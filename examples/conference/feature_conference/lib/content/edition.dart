import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';

import 'conference.dart';

part 'edition.g.dart';

@JsonSerializable()
class Edition extends ContentItem {
  static const schemaName = 'conf.edition';

  @JsonKey(name: '_id')
  final String id;

  final String identifier;
  final String title;
  final String tagline;
  final DateTime startDate;
  final DateTime endDate;
  final String? url;
  final String location;
  final Conference conference;

  Edition({
    required this.id,
    required this.identifier,
    required this.title,
    required this.tagline,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.conference,
    this.url,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory Edition.fromJson(Map<String, dynamic> json) =>
      _$EditionFromJson(json);
}
