// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

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
String _$statsRepositoryHash() => r'89d24e758e6e1311126771e24e6dee70793d8b47';

/// See also [statsRepository].
@ProviderFor(statsRepository)
final statsRepositoryProvider = AutoDisposeProvider<StatsRepository>.internal(
  statsRepository,
  name: r'statsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$statsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StatsRepositoryRef = AutoDisposeProviderRef<StatsRepository>;
String _$weeklyStatsHash() => r'd7c31663394af9a9a56ca449ad1ac032dadf7551';

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

/// See also [weeklyStats].
@ProviderFor(weeklyStats)
const weeklyStatsProvider = WeeklyStatsFamily();

/// See also [weeklyStats].
class WeeklyStatsFamily extends Family<AsyncValue<MoodStats>> {
  /// See also [weeklyStats].
  const WeeklyStatsFamily();

  /// See also [weeklyStats].
  WeeklyStatsProvider call(String userId) {
    return WeeklyStatsProvider(userId);
  }

  @override
  WeeklyStatsProvider getProviderOverride(
    covariant WeeklyStatsProvider provider,
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
  String? get name => r'weeklyStatsProvider';
}

/// See also [weeklyStats].
class WeeklyStatsProvider extends AutoDisposeFutureProvider<MoodStats> {
  /// See also [weeklyStats].
  WeeklyStatsProvider(String userId)
    : this._internal(
        (ref) => weeklyStats(ref as WeeklyStatsRef, userId),
        from: weeklyStatsProvider,
        name: r'weeklyStatsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weeklyStatsHash,
        dependencies: WeeklyStatsFamily._dependencies,
        allTransitiveDependencies: WeeklyStatsFamily._allTransitiveDependencies,
        userId: userId,
      );

  WeeklyStatsProvider._internal(
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
    FutureOr<MoodStats> Function(WeeklyStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyStatsProvider._internal(
        (ref) => create(ref as WeeklyStatsRef),
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
  AutoDisposeFutureProviderElement<MoodStats> createElement() {
    return _WeeklyStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyStatsProvider && other.userId == userId;
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
mixin WeeklyStatsRef on AutoDisposeFutureProviderRef<MoodStats> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _WeeklyStatsProviderElement
    extends AutoDisposeFutureProviderElement<MoodStats>
    with WeeklyStatsRef {
  _WeeklyStatsProviderElement(super.provider);

  @override
  String get userId => (origin as WeeklyStatsProvider).userId;
}

String _$wellnessHash() => r'e2611e5c68ac00992ade5dd94894c0ebc9987ece';

/// See also [wellness].
@ProviderFor(wellness)
const wellnessProvider = WellnessFamily();

/// See also [wellness].
class WellnessFamily extends Family<AsyncValue<WellnessData>> {
  /// See also [wellness].
  const WellnessFamily();

  /// See also [wellness].
  WellnessProvider call(String userId) {
    return WellnessProvider(userId);
  }

  @override
  WellnessProvider getProviderOverride(covariant WellnessProvider provider) {
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
  String? get name => r'wellnessProvider';
}

/// See also [wellness].
class WellnessProvider extends AutoDisposeFutureProvider<WellnessData> {
  /// See also [wellness].
  WellnessProvider(String userId)
    : this._internal(
        (ref) => wellness(ref as WellnessRef, userId),
        from: wellnessProvider,
        name: r'wellnessProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wellnessHash,
        dependencies: WellnessFamily._dependencies,
        allTransitiveDependencies: WellnessFamily._allTransitiveDependencies,
        userId: userId,
      );

  WellnessProvider._internal(
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
    FutureOr<WellnessData> Function(WellnessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WellnessProvider._internal(
        (ref) => create(ref as WellnessRef),
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
  AutoDisposeFutureProviderElement<WellnessData> createElement() {
    return _WellnessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WellnessProvider && other.userId == userId;
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
mixin WellnessRef on AutoDisposeFutureProviderRef<WellnessData> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _WellnessProviderElement
    extends AutoDisposeFutureProviderElement<WellnessData>
    with WellnessRef {
  _WellnessProviderElement(super.provider);

  @override
  String get userId => (origin as WellnessProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
