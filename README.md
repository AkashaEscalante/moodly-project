# Moodly

A wellness mobile app for mood tracking and self-care.

## Setup Instructions

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Copy the environment file:
   ```bash
   cp .env.example .env
   ```
   Then fill in your Supabase URL and anon key.

3. Run the Supabase migration:
   ```bash
   supabase db reset
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Tech Stack

- Flutter + Dart (null safety)
- Riverpod for state management
- Supabase for backend
- Go Router for navigation
- And more...

## Architecture

Clean Architecture with 4 layers: Domain, Data, Application, Presentation.
