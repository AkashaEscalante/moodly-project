import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodly/features/mood/domain/mood_model.dart';
import 'package:moodly/features/mood/domain/activity_model.dart';

class MoodEntryState {
  final MoodModel? selectedMood;
  final List<ActivityModel> selectedActivities;
  final String? thought;
  final int intensity;

  const MoodEntryState({
    this.selectedMood,
    this.selectedActivities = const [],
    this.thought,
    this.intensity = 3,
  });

  MoodEntryState copyWith({
    MoodModel? selectedMood,
    List<ActivityModel>? selectedActivities,
    String? thought,
    int? intensity,
  }) {
    return MoodEntryState(
      selectedMood: selectedMood ?? this.selectedMood,
      selectedActivities: selectedActivities ?? this.selectedActivities,
      thought: thought ?? this.thought,
      intensity: intensity ?? this.intensity,
    );
  }
}

class MoodEntryNotifier extends StateNotifier<MoodEntryState> {
  MoodEntryNotifier() : super(const MoodEntryState());

  void selectMood(MoodModel mood) {
    state = state.copyWith(selectedMood: mood);
  }

  void toggleActivity(ActivityModel activity) {
    final activities = List<ActivityModel>.from(state.selectedActivities);
    if (activities.contains(activity)) {
      activities.remove(activity);
    } else {
      activities.add(activity);
    }
    state = state.copyWith(selectedActivities: activities);
  }

  void setThought(String thought) {
    state = state.copyWith(thought: thought);
  }

  void setIntensity(int intensity) {
    state = state.copyWith(intensity: intensity);
  }

  void reset() {
    state = const MoodEntryState();
  }
}

final moodEntryNotifierProvider =
    StateNotifierProvider<MoodEntryNotifier, MoodEntryState>(
      (ref) => MoodEntryNotifier(),
    );
