import '../../domain/entities/hn_item.dart';

class HnItemModel extends HnItem {
  HnItemModel({
    required super.id,
    super.title,
    super.text,
    super.by,
    super.score,
    super.time,
    super.type,
    super.url,
    super.kids = const [],
  });

  factory HnItemModel.fromJson(Map<String, dynamic> json) {
    return HnItemModel(
      id: json['id'] ?? 0,
      title: json['title'],
      text: json['text'],
      by: json['by'],
      score: json['score'],
      time: json['time'],
      type: json['type'],
      url: json['url'],
      kids: json['kids'] != null
          ? List<int>.from(json['kids'])
          : [],
    );
  }
}