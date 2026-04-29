// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resources_provider.dart';

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
String _$resourcesRepositoryHash() =>
    r'c6f577594b98aede2eb4404e87722ea938ed7175';

/// See also [resourcesRepository].
@ProviderFor(resourcesRepository)
final resourcesRepositoryProvider =
    AutoDisposeProvider<ResourcesRepository>.internal(
      resourcesRepository,
      name: r'resourcesRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$resourcesRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResourcesRepositoryRef = AutoDisposeProviderRef<ResourcesRepository>;
String _$featuredResourceHash() => r'158859efd62c088c89e43b534866b6ba636c7da3';

/// See also [featuredResource].
@ProviderFor(featuredResource)
final featuredResourceProvider = AutoDisposeFutureProvider<Resource?>.internal(
  featuredResource,
  name: r'featuredResourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featuredResourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeaturedResourceRef = AutoDisposeFutureProviderRef<Resource?>;
String _$resourcesByCategoryHash() =>
    r'8950cc553ce1084cfed299776e6aff3410a796a5';

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

/// See also [resourcesByCategory].
@ProviderFor(resourcesByCategory)
const resourcesByCategoryProvider = ResourcesByCategoryFamily();

/// See also [resourcesByCategory].
class ResourcesByCategoryFamily extends Family<AsyncValue<List<Resource>>> {
  /// See also [resourcesByCategory].
  const ResourcesByCategoryFamily();

  /// See also [resourcesByCategory].
  ResourcesByCategoryProvider call(String category) {
    return ResourcesByCategoryProvider(category);
  }

  @override
  ResourcesByCategoryProvider getProviderOverride(
    covariant ResourcesByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'resourcesByCategoryProvider';
}

/// See also [resourcesByCategory].
class ResourcesByCategoryProvider
    extends AutoDisposeFutureProvider<List<Resource>> {
  /// See also [resourcesByCategory].
  ResourcesByCategoryProvider(String category)
    : this._internal(
        (ref) => resourcesByCategory(ref as ResourcesByCategoryRef, category),
        from: resourcesByCategoryProvider,
        name: r'resourcesByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$resourcesByCategoryHash,
        dependencies: ResourcesByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ResourcesByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  ResourcesByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<Resource>> Function(ResourcesByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResourcesByCategoryProvider._internal(
        (ref) => create(ref as ResourcesByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Resource>> createElement() {
    return _ResourcesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ResourcesByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ResourcesByCategoryRef on AutoDisposeFutureProviderRef<List<Resource>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _ResourcesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Resource>>
    with ResourcesByCategoryRef {
  _ResourcesByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as ResourcesByCategoryProvider).category;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
