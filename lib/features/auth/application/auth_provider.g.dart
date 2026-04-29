// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

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
String _$authRepositoryHash() => r'89d6ccb645856c61d418c3edc743d3a5e7f0007c';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$authStateHash() => r'ff774f4370f1b35e97e4dcf85096fe197ed4ac79';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = AutoDisposeStreamProvider<AppUser?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = AutoDisposeStreamProviderRef<AppUser?>;
String _$signInHash() => r'7f502f0f8f4f8a2b71f9789a295b9f6adeda468b';

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

/// See also [signIn].
@ProviderFor(signIn)
const signInProvider = SignInFamily();

/// See also [signIn].
class SignInFamily extends Family<AsyncValue<AppUser>> {
  /// See also [signIn].
  const SignInFamily();

  /// See also [signIn].
  SignInProvider call(String email, String password) {
    return SignInProvider(email, password);
  }

  @override
  SignInProvider getProviderOverride(covariant SignInProvider provider) {
    return call(provider.email, provider.password);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signInProvider';
}

/// See also [signIn].
class SignInProvider extends AutoDisposeFutureProvider<AppUser> {
  /// See also [signIn].
  SignInProvider(String email, String password)
    : this._internal(
        (ref) => signIn(ref as SignInRef, email, password),
        from: signInProvider,
        name: r'signInProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$signInHash,
        dependencies: SignInFamily._dependencies,
        allTransitiveDependencies: SignInFamily._allTransitiveDependencies,
        email: email,
        password: password,
      );

  SignInProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
  }) : super.internal();

  final String email;
  final String password;

  @override
  Override overrideWith(FutureOr<AppUser> Function(SignInRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: SignInProvider._internal(
        (ref) => create(ref as SignInRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser> createElement() {
    return _SignInProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignInProvider &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SignInRef on AutoDisposeFutureProviderRef<AppUser> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;
}

class _SignInProviderElement extends AutoDisposeFutureProviderElement<AppUser>
    with SignInRef {
  _SignInProviderElement(super.provider);

  @override
  String get email => (origin as SignInProvider).email;
  @override
  String get password => (origin as SignInProvider).password;
}

String _$signUpHash() => r'9fb2e481d05bdbd034ca61d5e4b2e082263cda3e';

/// See also [signUp].
@ProviderFor(signUp)
const signUpProvider = SignUpFamily();

/// See also [signUp].
class SignUpFamily extends Family<AsyncValue<AppUser>> {
  /// See also [signUp].
  const SignUpFamily();

  /// See also [signUp].
  SignUpProvider call(String email, String password, String fullName) {
    return SignUpProvider(email, password, fullName);
  }

  @override
  SignUpProvider getProviderOverride(covariant SignUpProvider provider) {
    return call(provider.email, provider.password, provider.fullName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signUpProvider';
}

/// See also [signUp].
class SignUpProvider extends AutoDisposeFutureProvider<AppUser> {
  /// See also [signUp].
  SignUpProvider(String email, String password, String fullName)
    : this._internal(
        (ref) => signUp(ref as SignUpRef, email, password, fullName),
        from: signUpProvider,
        name: r'signUpProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$signUpHash,
        dependencies: SignUpFamily._dependencies,
        allTransitiveDependencies: SignUpFamily._allTransitiveDependencies,
        email: email,
        password: password,
        fullName: fullName,
      );

  SignUpProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.email,
    required this.password,
    required this.fullName,
  }) : super.internal();

  final String email;
  final String password;
  final String fullName;

  @override
  Override overrideWith(FutureOr<AppUser> Function(SignUpRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: SignUpProvider._internal(
        (ref) => create(ref as SignUpRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser> createElement() {
    return _SignUpProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignUpProvider &&
        other.email == email &&
        other.password == password &&
        other.fullName == fullName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);
    hash = _SystemHash.combine(hash, fullName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SignUpRef on AutoDisposeFutureProviderRef<AppUser> {
  /// The parameter `email` of this provider.
  String get email;

  /// The parameter `password` of this provider.
  String get password;

  /// The parameter `fullName` of this provider.
  String get fullName;
}

class _SignUpProviderElement extends AutoDisposeFutureProviderElement<AppUser>
    with SignUpRef {
  _SignUpProviderElement(super.provider);

  @override
  String get email => (origin as SignUpProvider).email;
  @override
  String get password => (origin as SignUpProvider).password;
  @override
  String get fullName => (origin as SignUpProvider).fullName;
}

String _$signOutHash() => r'478f3b34bd16d616ef7d6622e7102185c930787c';

/// See also [signOut].
@ProviderFor(signOut)
final signOutProvider = AutoDisposeFutureProvider<void>.internal(
  signOut,
  name: r'signOutProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signOutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignOutRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
