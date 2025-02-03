import 'package:feature_conference/feature_conference.dart' as conf;
import 'package:flutter/material.dart';
import 'package:sanity_client/sanity_client.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_core/vyuh_core.dart' hide runApp;
import 'package:vyuh_extension_content/vyuh_extension_content.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;
import 'package:vyuh_plugin_content_provider_sanity/vyuh_plugin_content_provider_sanity.dart';
import 'package:vyuh_plugin_telemetry_provider_console/vyuh_plugin_telemetry_provider_console.dart';

final sanityProvider = SanityContentProvider.withConfig(
  config: SanityConfig(
    projectId: '8b76lu9s',
    dataset: 'production',
    perspective: Perspective.previewDrafts,
    useCdn: false,
    token:
        'skt2tSTitRob9TonNNubWg09bg0dACmwE0zHxSePlJisRuF1mWJOvgg3ZF68CAWrqtSIOzewbc56dGavACyznDTsjm30ws874WoSH3E5wPMFrqVW8C0Hc0pJGzpYQiehfL9GTRrIyoO3y2aBQIxHpegGspzxAevZcchleelaH5uM6LAnOJT1',
  ),
  cacheDuration: const Duration(seconds: 5),
);

void main() async {
  VyuhContentBinding.init(
    plugins: PluginDescriptor(
      content: DefaultContentPlugin(provider: sanityProvider),
      telemetry: TelemetryPlugin(providers: [ConsoleLoggerTelemetryProvider()]),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Content-driven UI')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Expanded(
                //   child: VyuhContentWidget.fromDocument(
                //     identifier: 'hello-world',
                //   ),
                // ),
                Expanded(
                  child: VyuhContentWidget(
                    query: Queries.conferences.query,
                    fromJson: Queries.conferences.fromJson,
                    listBuilder: (context, conferences) => ListView.builder(
                      itemCount: conferences.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: system.ContentImage(
                          ref: conferences[index].logo,
                          width: 48,
                          height: 48,
                        ),
                        title: Text(conferences[index].title),
                        subtitle: Text(conferences[index].slug),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Queries<T extends ContentItem> {
  route(
    query: '''
*[_type == "vyuh.route" && path == "/devrel"][0]{
  ...,
  category->,
  regions[] {
    "identifier": region->identifier,
    "title": region->title,
    items
  },
}''',
    fromJson: system.Route.fromJson,
  ),

  conferences(
    query: '''
*[_type == "conf.conference"]{
  ...,
  "slug": slug.current,
}
  ''',
    fromJson: conf.Conference.fromJson,
  );

  final String query;
  final FromJsonConverter<T> fromJson;

  const Queries({
    required this.query,
    required this.fromJson,
  });
}

/*

- single content item as document (vyuh.document schema)
- add factory method for simple usage (VyuhContentWidget.document(identifier: ""))
- refresh button during debug mode
- Typed argument T for the VyuhContentWidget
 */
