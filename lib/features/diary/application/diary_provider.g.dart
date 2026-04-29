// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_provider.dart';

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
String _$diaryRepositoryHash() => r'763458264e238ff8893e91da6002a8682a8eaae0';

/// See also [diaryRepository].
@ProviderFor(diaryRepository)
final diaryRepositoryProvider = AutoDisposeProvider<DiaryRepository>.internal(
  diaryRepository,
  name: r'diaryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$diaryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiaryRepositoryRef = AutoDisposeProviderRef<DiaryRepository>;
String _$gratitudeEntriesHash() => r'96000f839027f82b4709ea7d14c44d409faa835b';

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

/// See also [gratitudeEntries].
@ProviderFor(gratitudeEntries)
const gratitudeEntriesProvider = GratitudeEntriesFamily();

/// See also [gratitudeEntries].
class GratitudeEntriesFamily extends Family<AsyncValue<List<GratitudeEntry>>> {
  /// See also [gratitudeEntries].
  const GratitudeEntriesFamily();

  /// See also [gratitudeEntries].
  GratitudeEntriesProvider call(String userId) {
    return GratitudeEntriesProvider(userId);
  }

  @override
  GratitudeEntriesProvider getProviderOverride(
    covariant GratitudeEntriesProvider provider,
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
  String? get name => r'gratitudeEntriesProvider';
}

/// See also [gratitudeEntries].
class GratitudeEntriesProvider
    extends AutoDisposeFutureProvider<List<GratitudeEntry>> {
  /// See also [gratitudeEntries].
  GratitudeEntriesProvider(String userId)
    : this._internal(
        (ref) => gratitudeEntries(ref as GratitudeEntriesRef, userId),
        from: gratitudeEntriesProvider,
        name: r'gratitudeEntriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gratitudeEntriesHash,
        dependencies: GratitudeEntriesFamily._dependencies,
        allTransitiveDependencies:
            GratitudeEntriesFamily._allTransitiveDependencies,
        userId: userId,
      );

  GratitudeEntriesProvider._internal(
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
    FutureOr<List<GratitudeEntry>> Function(GratitudeEntriesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GratitudeEntriesProvider._internal(
        (ref) => create(ref as GratitudeEntriesRef),
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
  AutoDisposeFutureProviderElement<List<GratitudeEntry>> createElement() {
    return _GratitudeEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GratitudeEntriesProvider && other.userId == userId;
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
mixin GratitudeEntriesRef
    on AutoDisposeFutureProviderRef<List<GratitudeEntry>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _GratitudeEntriesProviderElement
    extends AutoDisposeFutureProviderElement<List<GratitudeEntry>>
    with GratitudeEntriesRef {
  _GratitudeEntriesProviderElement(super.provider);

  @override
  String get userId => (origin as GratitudeEntriesProvider).userId;
}

String _$todayEntryHash() => r'56f873e9b51909ccf60d4c212d38e4a1fa9a28be';

/// See also [todayEntry].
@ProviderFor(todayEntry)
const todayEntryProvider = TodayEntryFamily();

/// See also [todayEntry].
class TodayEntryFamily extends Family<AsyncValue<GratitudeEntry?>> {
  /// See also [todayEntry].
  const TodayEntryFamily();

  /// See also [todayEntry].
  TodayEntryProvider call(String userId) {
    return TodayEntryProvider(userId);
  }

  @override
  TodayEntryProvider getProviderOverride(
    covariant TodayEntryProvider provider,
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
  String? get name => r'todayEntryProvider';
}

/// See also [todayEntry].
class TodayEntryProvider extends AutoDisposeFutureProvider<GratitudeEntry?> {
  /// See also [todayEntry].
  TodayEntryProvider(String userId)
    : this._internal(
        (ref) => todayEntry(ref as TodayEntryRef, userId),
        from: todayEntryProvider,
        name: r'todayEntryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$todayEntryHash,
        dependencies: TodayEntryFamily._dependencies,
        allTransitiveDependencies: TodayEntryFamily._allTransitiveDependencies,
        userId: userId,
      );

  TodayEntryProvider._internal(
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
    FutureOr<GratitudeEntry?> Function(TodayEntryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TodayEntryProvider._internal(
        (ref) => create(ref as TodayEntryRef),
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
  AutoDisposeFutureProviderElement<GratitudeEntry?> createElement() {
    return _TodayEntryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TodayEntryProvider && other.userId == userId;
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
mixin TodayEntryRef on AutoDisposeFutureProviderRef<GratitudeEntry?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _TodayEntryProviderElement
    extends AutoDisposeFutureProviderElement<GratitudeEntry?>
    with TodayEntryRef {
  _TodayEntryProviderElement(super.provider);

  @override
  String get userId => (origin as TodayEntryProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
