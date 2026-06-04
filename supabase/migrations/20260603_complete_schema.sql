-- =============================================================================
-- Moodly — Migration completa
-- Ejecutar una sola vez en: Supabase Dashboard → SQL Editor → New query
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CORREGIR mood_entries: eliminar columna conflictiva
--    La columna activities text[] choca con la relación activities:mood_entry_activities
-- -----------------------------------------------------------------------------
ALTER TABLE public.mood_entries DROP COLUMN IF EXISTS activities;


-- -----------------------------------------------------------------------------
-- 2. TABLAS FALTANTES
-- -----------------------------------------------------------------------------

-- 2a. activities — catálogo de actividades del día
CREATE TABLE IF NOT EXISTS public.activities (
  id           serial      PRIMARY KEY,
  name         text        NOT NULL UNIQUE,
  icon_url     text,
  color_code   text        NOT NULL DEFAULT '#9C27B0',
  category     text,
  display_order integer    DEFAULT 0
);

-- 2b. mood_entry_activities — relación muchos-a-muchos entre entradas y actividades
CREATE TABLE IF NOT EXISTS public.mood_entry_activities (
  mood_entry_id uuid    NOT NULL REFERENCES public.mood_entries(id) ON DELETE CASCADE,
  activity_id   integer NOT NULL REFERENCES public.activities(id),
  PRIMARY KEY (mood_entry_id, activity_id)
);

-- 2c. wellness_data — métricas de bienestar manual del usuario
CREATE TABLE IF NOT EXISTS public.wellness_data (
  user_id        uuid              PRIMARY KEY REFERENCES auth.users(id),
  sleep_hours    double precision  DEFAULT 0,
  energy_pct     double precision  DEFAULT 0,
  meditation_min double precision  DEFAULT 0,
  hydration_l    double precision  DEFAULT 0,
  updated_at     timestamptz       DEFAULT now()
);


-- -----------------------------------------------------------------------------
-- 3. FUNCIÓN RPC: get_weekly_mood_stats
--    Retorna JSON con: most_frequent_mood, streak, week_data
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_weekly_mood_stats(user_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_most_frequent text;
  v_streak        int;
  v_week_data     json;
  result          json;
BEGIN
  -- Emoción más frecuente en los últimos 7 días
  SELECT e.name INTO v_most_frequent
  FROM public.mood_entries me
  JOIN public.emotions e ON me.emotion_id = e.id
  WHERE me.user_id = $1
    AND me.created_at >= now() - interval '7 days'
  GROUP BY e.name
  ORDER BY count(*) DESC
  LIMIT 1;

  -- Streak actual desde la tabla streaks
  SELECT COALESCE(s.current_streak, 0) INTO v_streak
  FROM public.streaks s
  WHERE s.user_id = $1;

  -- Datos por día de la semana (últimos 7 días)
  SELECT json_agg(
    json_build_object(
      'day',           to_char(day_series::date, 'Dy'),
      'date',          day_series::date,
      'count',         COALESCE(daily.cnt, 0),
      'avg_intensity', COALESCE(daily.avg_int, 0)
    )
    ORDER BY day_series
  ) INTO v_week_data
  FROM generate_series(
    (now() - interval '6 days')::date,
    now()::date,
    '1 day'::interval
  ) AS day_series
  LEFT JOIN (
    SELECT
      date_trunc('day', created_at)::date AS entry_date,
      count(*)                            AS cnt,
      avg(intensity)                      AS avg_int
    FROM public.mood_entries
    WHERE mood_entries.user_id = $1
      AND created_at >= now() - interval '7 days'
    GROUP BY date_trunc('day', created_at)::date
  ) daily ON day_series::date = daily.entry_date;

  result := json_build_object(
    'most_frequent_mood', COALESCE(v_most_frequent, ''),
    'streak',             COALESCE(v_streak, 0),
    'week_data',          COALESCE(v_week_data, '[]'::json)
  );

  RETURN result;
END;
$$;


-- -----------------------------------------------------------------------------
-- 4. TRIGGER: auto-crear perfil al registrar usuario
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    NEW.email
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();


-- -----------------------------------------------------------------------------
-- 5. ROW LEVEL SECURITY — habilitar y crear políticas
-- -----------------------------------------------------------------------------

-- profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_select_own" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- mood_entries
ALTER TABLE public.mood_entries ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "mood_entries_select_own" ON public.mood_entries;
DROP POLICY IF EXISTS "mood_entries_insert_own" ON public.mood_entries;
DROP POLICY IF EXISTS "mood_entries_update_own" ON public.mood_entries;
DROP POLICY IF EXISTS "mood_entries_delete_own" ON public.mood_entries;
CREATE POLICY "mood_entries_select_own" ON public.mood_entries FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "mood_entries_insert_own" ON public.mood_entries FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "mood_entries_update_own" ON public.mood_entries FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "mood_entries_delete_own" ON public.mood_entries FOR DELETE USING (auth.uid() = user_id);

-- gratitude_entries
ALTER TABLE public.gratitude_entries ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "gratitude_entries_select_own" ON public.gratitude_entries;
DROP POLICY IF EXISTS "gratitude_entries_insert_own" ON public.gratitude_entries;
DROP POLICY IF EXISTS "gratitude_entries_update_own" ON public.gratitude_entries;
DROP POLICY IF EXISTS "gratitude_entries_delete_own" ON public.gratitude_entries;
CREATE POLICY "gratitude_entries_select_own" ON public.gratitude_entries FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "gratitude_entries_insert_own" ON public.gratitude_entries FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "gratitude_entries_update_own" ON public.gratitude_entries FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "gratitude_entries_delete_own" ON public.gratitude_entries FOR DELETE USING (auth.uid() = user_id);

-- streaks
ALTER TABLE public.streaks ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "streaks_select_own" ON public.streaks;
DROP POLICY IF EXISTS "streaks_insert_own" ON public.streaks;
DROP POLICY IF EXISTS "streaks_update_own" ON public.streaks;
CREATE POLICY "streaks_select_own" ON public.streaks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "streaks_insert_own" ON public.streaks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "streaks_update_own" ON public.streaks FOR UPDATE USING (auth.uid() = user_id);

-- mood_entry_activities (acceso indirecto a través del mood_entry del usuario)
ALTER TABLE public.mood_entry_activities ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "mea_all_own" ON public.mood_entry_activities;
CREATE POLICY "mea_all_own" ON public.mood_entry_activities FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.mood_entries me
      WHERE me.id = mood_entry_id AND me.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.mood_entries me
      WHERE me.id = mood_entry_id AND me.user_id = auth.uid()
    )
  );

-- wellness_data
ALTER TABLE public.wellness_data ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "wellness_select_own" ON public.wellness_data;
DROP POLICY IF EXISTS "wellness_insert_own" ON public.wellness_data;
DROP POLICY IF EXISTS "wellness_update_own" ON public.wellness_data;
CREATE POLICY "wellness_select_own" ON public.wellness_data FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "wellness_insert_own" ON public.wellness_data FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "wellness_update_own" ON public.wellness_data FOR UPDATE USING (auth.uid() = user_id);

-- Tablas de catálogo: lectura pública (no contienen datos personales)
ALTER TABLE public.emotions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "emotions_public_read" ON public.emotions;
CREATE POLICY "emotions_public_read" ON public.emotions FOR SELECT USING (true);

ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "activities_public_read" ON public.activities;
CREATE POLICY "activities_public_read" ON public.activities FOR SELECT USING (true);

ALTER TABLE public.tips ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "tips_public_read" ON public.tips;
CREATE POLICY "tips_public_read" ON public.tips FOR SELECT USING (true);

ALTER TABLE public.motivational_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "messages_public_read" ON public.motivational_messages;
CREATE POLICY "messages_public_read" ON public.motivational_messages FOR SELECT USING (true);


-- -----------------------------------------------------------------------------
-- 6. DATOS SEMILLA
-- -----------------------------------------------------------------------------

-- 6a. Emociones (insertar solo si la tabla está vacía)
INSERT INTO public.emotions (name, emoji, color_hex, category, display_order)
SELECT name, emoji, color_hex, category, display_order FROM (VALUES
  ('Feliz',     '😊', '#FFD700', 'positive', 1),
  ('Enamorado', '🥰', '#FF69B4', 'positive', 2),
  ('Relajado',  '😌', '#90EE90', 'positive', 3),
  ('Neutral',   '😐', '#D3D3D3', 'neutral',  4),
  ('Cansado',   '😴', '#B0C4DE', 'neutral',  5),
  ('Ansioso',   '😰', '#FFA500', 'negative', 6),
  ('Triste',    '😢', '#4169E1', 'negative', 7),
  ('Enojado',   '😠', '#FF4500', 'negative', 8)
) AS v(name, emoji, color_hex, category, display_order)
WHERE NOT EXISTS (SELECT 1 FROM public.emotions LIMIT 1);

-- 6b. Actividades
INSERT INTO public.activities (name, icon_url, color_code, category, display_order)
SELECT name, icon_url, color_code, category, display_order FROM (VALUES
  ('Ejercicio',    NULL, '#E91E63', 'bienestar',      1),
  ('Meditación',   NULL, '#9C27B0', 'bienestar',      2),
  ('Lectura',      NULL, '#3F51B5', 'mente',           3),
  ('Música',       NULL, '#009688', 'arte',            4),
  ('Amigos',       NULL, '#FF9800', 'social',          5),
  ('Familia',      NULL, '#F44336', 'social',          6),
  ('Trabajo',      NULL, '#607D8B', 'productividad',   7),
  ('Descanso',     NULL, '#8BC34A', 'bienestar',       8),
  ('Comida sana',  NULL, '#4CAF50', 'salud',           9),
  ('Naturaleza',   NULL, '#00BCD4', 'bienestar',       10)
) AS v(name, icon_url, color_code, category, display_order)
WHERE NOT EXISTS (SELECT 1 FROM public.activities LIMIT 1);

-- 6c. Mensajes motivacionales de ejemplo
INSERT INTO public.motivational_messages (message, category, mood_target, is_active)
SELECT message, category, mood_target, is_active FROM (VALUES
  ('Cada día es una nueva oportunidad para ser la mejor versión de ti. 🌟', 'general',  NULL,      true),
  ('Tu bienestar es tu mayor tesoro. Cuídalo con amor. 💜',                 'general',  NULL,      true),
  ('Los pequeños pasos también te llevan lejos. Sigue adelante. 🐾',        'general',  NULL,      true),
  ('Respira. Este momento también pasará. 🌿',                               'calma',    'Ansioso', true),
  ('Está bien no estar bien. Date permiso de sentir. 💙',                   'tristeza', 'Triste',  true),
  ('Tu alegría inspira al mundo. ¡Compártela! ☀️',                          'alegria',  'Feliz',   true)
) AS v(message, category, mood_target, is_active)
WHERE NOT EXISTS (SELECT 1 FROM public.motivational_messages LIMIT 1);

-- 6d. Tips de bienestar de ejemplo
INSERT INTO public.tips (category, title, content, icon_name, display_order)
SELECT category, title, content, icon_name, display_order FROM (VALUES
  ('mindfulness', 'Respiración 4-7-8',
   'Inhala 4 segundos, retén 7 y exhala 8. Repite 4 veces para calmar el sistema nervioso.',
   'self_improvement', 1),
  ('movimiento', 'Estiramiento de 5 minutos',
   'Levántate y estira cuello, hombros y espalda. Tu cuerpo te lo agradecerá.',
   'fitness_center', 2),
  ('nutricion', 'Hidratación consciente',
   'Beber 2 litros de agua al día mejora el estado de ánimo y la concentración.',
   'water_drop', 3),
  ('sueño', 'Rutina nocturna',
   'Apaga pantallas 30 minutos antes de dormir. La melatonina fluirá con más facilidad.',
   'bedtime', 4),
  ('conexion', 'Gratitud diaria',
   'Escribe 3 cosas por las que estés agradecido hoy. Entrena tu cerebro hacia lo positivo.',
   'favorite', 5)
) AS v(category, title, content, icon_name, display_order)
WHERE NOT EXISTS (SELECT 1 FROM public.tips LIMIT 1);
