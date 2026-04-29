// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

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
String _$profileRepositoryHash() => r'5fa71e0d6bc7a83b7fec7edd4ddc9624cedf097f';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider =
    AutoDisposeProvider<ProfileRepository>.internal(
      profileRepository,
      name: r'profileRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRepositoryRef = AutoDisposeProviderRef<ProfileRepository>;
String _$currentProfileHash() => r'7a6706f1d52ffbd16962744b6586843bc998d137';

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

/// See also [currentProfile].
@ProviderFor(currentProfile)
const currentProfileProvider = CurrentProfileFamily();

/// See also [currentProfile].
class CurrentProfileFamily extends Family<AsyncValue<Profile>> {
  /// See also [currentProfile].
  const CurrentProfileFamily();

  /// See also [currentProfile].
  CurrentProfileProvider call(String userId) {
    return CurrentProfileProvider(userId);
  }

  @override
  CurrentProfileProvider getProviderOverride(
    covariant CurrentProfileProvider provider,
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
  String? get name => r'currentProfileProvider';
}

/// See also [currentProfile].
class CurrentProfileProvider extends AutoDisposeFutureProvider<Profile> {
  /// See also [currentProfile].
  CurrentProfileProvider(String userId)
    : this._internal(
        (ref) => currentProfile(ref as CurrentProfileRef, userId),
        from: currentProfileProvider,
        name: r'currentProfileProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$currentProfileHash,
        dependencies: CurrentProfileFamily._dependencies,
        allTransitiveDependencies:
            CurrentProfileFamily._allTransitiveDependencies,
        userId: userId,
      );

  CurrentProfileProvider._internal(
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
    FutureOr<Profile> Function(CurrentProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CurrentProfileProvider._internal(
        (ref) => create(ref as CurrentProfileRef),
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
  AutoDisposeFutureProviderElement<Profile> createElement() {
    return _CurrentProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentProfileProvider && other.userId == userId;
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
mixin CurrentProfileRef on AutoDisposeFutureProviderRef<Profile> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _CurrentProfileProviderElement
    extends AutoDisposeFutureProviderElement<Profile>
    with CurrentProfileRef {
  _CurrentProfileProviderElement(super.provider);

  @override
  String get userId => (origin as CurrentProfileProvider).userId;
}

String _$updateProfileHash() => r'53ecbf8f606bcf7c541253254764ece2ee2b24d7';

/// See also [updateProfile].
@ProviderFor(updateProfile)
const updateProfileProvider = UpdateProfileFamily();

/// See also [updateProfile].
class UpdateProfileFamily extends Family<AsyncValue<void>> {
  /// See also [updateProfile].
  const UpdateProfileFamily();

  /// See also [updateProfile].
  UpdateProfileProvider call(Profile profile) {
    return UpdateProfileProvider(profile);
  }

  @override
  UpdateProfileProvider getProviderOverride(
    covariant UpdateProfileProvider provider,
  ) {
    return call(provider.profile);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateProfileProvider';
}

/// See also [updateProfile].
class UpdateProfileProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateProfile].
  UpdateProfileProvider(Profile profile)
    : this._internal(
        (ref) => updateProfile(ref as UpdateProfileRef, profile),
        from: updateProfileProvider,
        name: r'updateProfileProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$updateProfileHash,
        dependencies: UpdateProfileFamily._dependencies,
        allTransitiveDependencies:
            UpdateProfileFamily._allTransitiveDependencies,
        profile: profile,
      );

  UpdateProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final Profile profile;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateProfileProvider._internal(
        (ref) => create(ref as UpdateProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProfileProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateProfileRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `profile` of this provider.
  Profile get profile;
}

class _UpdateProfileProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateProfileRef {
  _UpdateProfileProviderElement(super.provider);

  @override
  Profile get profile => (origin as UpdateProfileProvider).profile;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
