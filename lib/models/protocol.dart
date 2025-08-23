import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'protocol.g.dart';

@HiveType(typeId: 0)
class Protocol extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final List<ProtocolItem> items;

  @HiveField(4)
  final String template;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  Protocol({
    String? id,
    required this.name,
    this.description,
    this.items = const [],
    required this.template,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Protocol copyWith({
    String? name,
    String? description,
    List<ProtocolItem>? items,
    String? template,
  }) {
    return Protocol(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      items: items ?? this.items,
      template: template ?? this.template,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'items': items.map((item) => item.toJson()).toList(),
      'template': template,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Protocol.fromJson(Map<String, dynamic> json) {
    return Protocol(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      items:
          (json['items'] as List?)
              ?.map((item) => ProtocolItem.fromJson(item))
              .toList() ??
          [],
      template: json['template'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

@HiveType(typeId: 1)
class ProtocolItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? instruction;

  @HiveField(3)
  final ResponseType responseType;

  @HiveField(4)
  final List<String> options;

  ProtocolItem({
    required this.id,
    required this.title,
    this.instruction,
    required this.responseType,
    this.options = const [],
  });

  ProtocolItem copyWith({
    String? title,
    String? instruction,
    ResponseType? responseType,
    List<String>? options,
  }) {
    return ProtocolItem(
      id: id,
      title: title ?? this.title,
      instruction: instruction ?? this.instruction,
      responseType: responseType ?? this.responseType,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instruction': instruction,
      'responseType': responseType.index,
      'options': options,
    };
  }

  factory ProtocolItem.fromJson(Map<String, dynamic> json) {
    return ProtocolItem(
      id: json['id'],
      title: json['title'],
      instruction: json['instruction'],
      responseType: ResponseType.values[json['responseType']],
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

@HiveType(typeId: 7)
enum ResponseType {
  @HiveField(0)
  checklist,

  @HiveField(1)
  scale,

  @HiveField(2)
  text,

  @HiveField(3)
  multipleChoice,
}
