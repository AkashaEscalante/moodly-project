-- =============================================================================
-- Moodly — Esquema completo de la base de datos (documentación)
-- Para aplicar cambios usa: supabase/migrations/20260603_complete_schema.sql
-- =============================================================================

CREATE TABLE public.emotions (
  id            integer     NOT NULL DEFAULT nextval('emotions_id_seq'::regclass),
  name          text        NOT NULL UNIQUE,
  emoji         text        NOT NULL,
  color_hex     text        NOT NULL,
  category      text        NOT NULL CHECK (category = ANY (ARRAY['positive','negative','neutral'])),
  display_order integer     NOT NULL DEFAULT 0,
  CONSTRAINT emotions_pkey PRIMARY KEY (id)
);

CREATE TABLE public.activities (
  id            serial      PRIMARY KEY,
  name          text        NOT NULL UNIQUE,
  icon_url      text,
  color_code    text        NOT NULL DEFAULT '#9C27B0',
  category      text,
  display_order integer     DEFAULT 0
);

CREATE TABLE public.mood_entries (
  id            uuid        NOT NULL DEFAULT gen_random_uuid(),
  user_id       uuid        NOT NULL,
  emotion_id    integer     NOT NULL,
  intensity     integer     NOT NULL CHECK (intensity >= 1 AND intensity <= 5),
  note          text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT mood_entries_pkey PRIMARY KEY (id),
  CONSTRAINT mood_entries_user_id_fkey    FOREIGN KEY (user_id)    REFERENCES auth.users(id),
  CONSTRAINT mood_entries_emotion_id_fkey FOREIGN KEY (emotion_id) REFERENCES public.emotions(id)
);

CREATE TABLE public.mood_entry_activities (
  mood_entry_id uuid    NOT NULL,
  activity_id   integer NOT NULL,
  CONSTRAINT mood_entry_activities_pkey              PRIMARY KEY (mood_entry_id, activity_id),
  CONSTRAINT mood_entry_activities_entry_fkey        FOREIGN KEY (mood_entry_id) REFERENCES public.mood_entries(id) ON DELETE CASCADE,
  CONSTRAINT mood_entry_activities_activity_fkey     FOREIGN KEY (activity_id)   REFERENCES public.activities(id)
);

CREATE TABLE public.streaks (
  user_id        uuid    NOT NULL,
  current_streak integer NOT NULL DEFAULT 0,
  longest_streak integer NOT NULL DEFAULT 0,
  last_entry_date date,
  total_entries  integer NOT NULL DEFAULT 0,
  updated_at     timestamptz      DEFAULT now(),
  CONSTRAINT streaks_pkey         PRIMARY KEY (user_id),
  CONSTRAINT streaks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.motivational_messages (
  id         integer     NOT NULL DEFAULT nextval('motivational_messages_id_seq'::regclass),
  message    text        NOT NULL,
  category   text        NOT NULL,
  mood_target text,
  is_active  boolean     NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT motivational_messages_pkey PRIMARY KEY (id)
);

CREATE TABLE public.tips (
  id            integer NOT NULL DEFAULT nextval('tips_id_seq'::regclass),
  category      text    NOT NULL,
  title         text    NOT NULL,
  content       text    NOT NULL,
  icon_name     text,
  display_order integer DEFAULT 0,
  CONSTRAINT tips_pkey PRIMARY KEY (id)
);

CREATE TABLE public.profiles (
  id               uuid        NOT NULL,
  full_name        text        NOT NULL,
  email            text,
  avatar_url       text,
  bio              text,
  sexo             text,
  fecha_nacimiento date,
  ciudad           text,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT profiles_pkey   PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);

CREATE TABLE public.gratitude_entries (
  id         uuid        NOT NULL DEFAULT gen_random_uuid(),
  user_id    uuid        NOT NULL,
  content    text        NOT NULL,
  mood_icon  text,
  entry_date date        NOT NULL DEFAULT CURRENT_DATE,
  created_at timestamptz          DEFAULT now(),
  CONSTRAINT gratitude_entries_pkey         PRIMARY KEY (id),
  CONSTRAINT gratitude_entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.wellness_data (
  user_id        uuid             PRIMARY KEY REFERENCES auth.users(id),
  sleep_hours    double precision DEFAULT 0,
  energy_pct     double precision DEFAULT 0,
  meditation_min double precision DEFAULT 0,
  hydration_l    double precision DEFAULT 0,
  updated_at     timestamptz      DEFAULT now()
);

-- Función RPC para estadísticas semanales
-- Retorna: { most_frequent_mood: string, streak: int, week_data: [{day, date, count, avg_intensity}] }
-- Ver implementación completa en migrations/20260603_complete_schema.sql
