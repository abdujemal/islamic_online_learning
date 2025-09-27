// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Curriculum {
  final String id;
  final String title;
  final String description;
  final bool active = true;
  final bool prerequisite;
  final int level;
  Curriculum({
    required this.id,
    required this.title,
    required this.description,
    required this.prerequisite,
    required this.level,
  });

  Curriculum copyWith({
    String? id,
    String? title,
    String? description,
    bool? prerequisite,
    int? level,
  }) {
    return Curriculum(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      prerequisite: prerequisite ?? this.prerequisite,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'prerequisite': prerequisite,
      'level': level,
    };
  }

  factory Curriculum.fromMap(Map<String, dynamic> map) {
    return Curriculum(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      prerequisite: map['prerequisite'] as bool,
      level: map['level'] as int,
    );
  }

  static List<Curriculum> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Curriculum.fromMap(json)).toList();
  }

  String toJson() => json.encode(toMap());

  factory Curriculum.fromJson(String source) => Curriculum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Curriculum(id: $id, title: $title, description: $description, prerequisite: $prerequisite, level: $level)';
  }

  @override
  bool operator ==(covariant Curriculum other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.prerequisite == prerequisite &&
      other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      prerequisite.hashCode ^
      level.hashCode;
  }
}
