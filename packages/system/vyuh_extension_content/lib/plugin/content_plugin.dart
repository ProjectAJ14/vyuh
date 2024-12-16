import 'package:flutter/widgets.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

/// The default ContentPlugin implementation for the Vyuh framework.
/// This plugin is responsible for fetching content from a CMS and rendering content items.
/// It uses a [ContentExtensionBuilder] to keep track of the various [ContentItem] types.
final class DefaultContentPlugin extends ContentPlugin {
  ContentExtensionBuilder? _extensionBuilder;

  DefaultContentPlugin({required super.provider})
      : super(
          name: 'vyuh.plugin.content',
          title: 'Content Plugin',
        );

  @override
  Map<Type, Map<String, TypeDescriptor>> get typeRegistry =>
      _extensionBuilder!.getTypeRegistry();

  @override
  Widget buildContent(BuildContext context, ContentItem content) {
    final builder = _extensionBuilder!.getContentBuilder(content.schemaType);

    assert(builder != null,
        'Failed to retrieve builder for schemaType: ${content.schemaType}');

    final contentWidget = builder?.build(context, content);

    assert(contentWidget != null,
        'Failed to build content for schemaType: ${content.schemaType}');

    if (contentWidget != null) {
      final modifiers = content.getModifiers();

      if (modifiers != null && modifiers.isNotEmpty) {
        try {
          return modifiers.fold<Widget>(
            contentWidget,
            (child, modifier) => modifier.build(context, child, content),
          );
        } catch (e) {
          return vyuh.widgetBuilder.errorView(context,
              error: e,
              title: 'Failed to apply modifiers',
              subtitle:
                  'Modifier Chain: "${modifiers.map((m) => m.schemaType).join(' -> ')}" for Content: "${content.schemaType}"');
        }
      }

      return contentWidget;
    }

    return const SizedBox.shrink();
  }

  @override
  Widget buildRoute(BuildContext context, {Uri? url, String? routeId}) {
    final label = [
      url == null ? null : 'Url: $url',
      routeId == null ? null : 'RouteId: $routeId',
      'Route',
    ].firstWhere((x) => x != null);

    return ScopedDIWidget(
      debugLabel: 'Scoped DI for $label',
      child: RouteFutureBuilder(
        url: url,
        routeId: routeId,
        fetchRoute: (context, {path, routeId}) => provider
            .fetchRoute(path: path, routeId: routeId)
            .then((value) async {
          if (!context.mounted) {
            return null;
          }

          // Reset DI scope when a new route is fetched
          await context.di.reset();

          if (!context.mounted) {
            return null;
          }

          final finalRoute = await value?.init(context);
          return finalRoute;
        }),
        buildContent: buildContent,
      ),
    );
  }

  @override
  T? fromJson<T>(Map<String, dynamic> json) {
    final type = provider.schemaType(json);
    return _extensionBuilder!.fromJson<T>(type, json);
  }

  @override
  register<T>(TypeDescriptor<T> descriptor) =>
      _extensionBuilder!.register<T>(descriptor);

  @override
  isRegistered<T>(TypeDescriptor<T> descriptor) =>
      _extensionBuilder!.isRegistered<T>(descriptor);

  @override
  Future<void> dispose() async {
    await provider.dispose();
    _extensionBuilder?.dispose();
  }

  @override
  Future<void> init() {
    return provider.init();
  }

  @override
  void attach(ExtensionBuilder extBuilder) {
    assert(extBuilder is ContentExtensionBuilder,
        '''For the $runtimeType to work, there must be one $ContentExtensionBuilder in your extension builders.
        However, you have provided a ${extBuilder.runtimeType}''');

    _extensionBuilder = extBuilder as ContentExtensionBuilder;
  }
}
