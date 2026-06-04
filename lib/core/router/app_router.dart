import 'package:go_router/go_router.dart';
import 'package:moodly/features/auth/presentation/login_screen.dart';
import 'package:moodly/features/auth/presentation/register_screen.dart';
import 'package:moodly/features/auth/presentation/onboarding/onboarding_screen.dart';
import 'package:moodly/features/chat/presentation/ai_chat_screen.dart';
import 'package:moodly/features/home/presentation/home_screen.dart';
import 'package:moodly/features/mood/presentation/mood_checkin_screen.dart';
import 'package:moodly/features/mood/presentation/mood_history_screen.dart';
import 'package:moodly/features/stats/presentation/stats_screen.dart';
import 'package:moodly/features/diary/presentation/diary_screen.dart';
import 'package:moodly/features/resources/presentation/resources_screen.dart';
import 'package:moodly/features/resources/presentation/consejos_screen.dart';
import 'package:moodly/features/profile/presentation/profile_screen.dart';
import 'package:moodly/features/profile/presentation/edit_profile_screen.dart';
import 'package:moodly/features/profile/presentation/help_center_screen.dart';
import 'package:moodly/features/profile/presentation/privacy_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/mood-checkin',
      builder: (context, state) => const MoodCheckinScreen(),
    ),
    GoRoute(
      path: '/mood-history',
      builder: (context, state) => const MoodHistoryScreen(),
    ),
    GoRoute(path: '/stats', builder: (context, state) => const StatsScreen()),
    GoRoute(path: '/diary', builder: (context, state) => const DiaryScreen()),
    GoRoute(
      path: '/resources',
      builder: (context, state) => const ResourcesScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/consejos',
      builder: (context, state) => const ConsejosScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (context, state) => const PrivacyScreen(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) => const AiChatScreen(),
    ),
  ],
);
