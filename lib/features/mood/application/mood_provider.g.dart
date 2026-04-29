// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseClientHash() => r'36e9cae00709545a85bfe4a5a2cb98d8686a01ea';

/// See also [supabaseClient].
@ProviderFor(supabaseClient)
final supabaseClientProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabaseClient,
  name: r'supabaseClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseClientRef = AutoDisposeProviderRef<SupabaseClient>;
String _$moodRepositoryHash() => r'0fc181c8c7bec12951b52bcc605a476cbe31f056';

/// See also [moodRepository].
@ProviderFor(moodRepository)
final moodRepositoryProvider = AutoDisposeProvider<MoodRepository>.internal(
  moodRepository,
  name: r'moodRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$moodRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MoodRepositoryRef = AutoDisposeProviderRef<MoodRepository>;
String _$moodsHash() => r'7d391058ce86e05585fd9855230830cdd3813a0b';

/// See also [moods].
@ProviderFor(moods)
final moodsProvider = AutoDisposeFutureProvider<List<MoodModel>>.internal(
  moods,
  name: r'moodsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$moodsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MoodsRef = AutoDisposeFutureProviderRef<List<MoodModel>>;
String _$activitiesHash() => r'5b24cb343049674c8cec0b3fa1fc8e9737e45508';

/// See also [activities].
@ProviderFor(activities)
final activitiesProvider =
    AutoDisposeFutureProvider<List<ActivityModel>>.internal(
      activities,
      name: r'activitiesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activitiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivitiesRef = AutoDisposeFutureProviderRef<List<ActivityModel>>;
String _$moodEntriesHash() => r'61289938b72cce34a305151617794b258f820d59';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [moodEntries].
@ProviderFor(moodEntries)
const moodEntriesProvider = MoodEntriesFamily();

/// See also [moodEntries].
class MoodEntriesFamily extends Family<AsyncValue<List<MoodEntryModel>>> {
  /// See also [moodEntries].
  const MoodEntriesFamily();

  /// See also [moodEntries].
  MoodEntriesProvider call(String userId) {
    return MoodEntriesProvider(userId);
  }

  @override
  MoodEntriesProvider getProviderOverride(
    covariant MoodEntriesProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'moodEntriesProvider';
}

/// See also [moodEntries].
class MoodEntriesProvider
    extends AutoDisposeFutureProvider<List<MoodEntryModel>> {
  /// See also [moodEntries].
  MoodEntriesProvider(String userId)
    : this._internal(
        (ref) => moodEntries(ref as MoodEntriesRef, userId),
        from: moodEntriesProvider,
        name: r'moodEntriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$moodEntriesHash,
        dependencies: MoodEntriesFamily._dependencies,
        allTransitiveDependencies: MoodEntriesFamily._allTransitiveDependencies,
        userId: userId,
      );

  MoodEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<MoodEntryModel>> Function(MoodEntriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MoodEntriesProvider._internal(
        (ref) => create(ref as MoodEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MoodEntryModel>> createElement() {
    return _MoodEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MoodEntriesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MoodEntriesRef on AutoDisposeFutureProviderRef<List<MoodEntryModel>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MoodEntriesProviderElement
    extends AutoDisposeFutureProviderElement<List<MoodEntryModel>>
    with MoodEntriesRef {
  _MoodEntriesProviderElement(super.provider);

  @override
  String get userId => (origin as MoodEntriesProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
