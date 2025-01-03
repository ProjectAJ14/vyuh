import 'package:feature_conference/api/conference_api.dart';
import 'package:feature_conference/layouts/conference_card_layout.dart';
import 'package:feature_conference/widgets/conference_route_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vyuh_core/vyuh_core.dart';

import '../content/conference.dart';

final class ConferenceRootPage extends StatelessWidget {
  const ConferenceRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConferenceRouteScaffold<List<Conference>>(
      errorTitle: 'Failed to load Conferences',
      future: () => vyuh.di.get<ConferenceApi>().conferences(),
      builder: (context, conferences) {
        final layout = ConferenceCardLayout();

        return ConferenceRouteCustomScrollView(
          title: 'Conferences',
          subtitle: '(${conferences.length})',
          appBarActions: [
            IconButton(
                onPressed: () {
                  context.push('/conferences/settings');
                },
                icon: const Icon(Icons.settings))
          ],
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final conference = conferences[index];
                return vyuh.content.buildContent(
                  context,
                  conference,
                  layout: layout,
                );
              },
              childCount: conferences.length,
            ),
          ),
        );
      },
    );
  }
}
