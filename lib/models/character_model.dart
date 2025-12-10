class Character {
  final String id;
  final String name;
  final String personality;
  final String tone;
  final String gender;
  final String relation;
  final String habits;
  final bool isLocal;

  Character({
    required this.id,
    required this.name,
    this.personality = '',
    this.tone = '',
    this.gender = '',
    this.relation = '',
    this.habits = '',
    this.isLocal = false,
  });

  factory Character.fromMap(Map<String, dynamic> map, String id) {
    return Character(
      id: id,
      name: map['name'] ?? 'Unknown',
      personality: map['personality'] ?? '',
      tone: map['tone'] ?? '',
      gender: map['gender'] ?? '',
      relation: map['relation'] ?? '',
      habits: map['habits'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'personality': personality,
      'tone': tone,
      'gender': gender,
      'relation': relation,
      'habits': habits,
    };
  }

  // This was missing — now added
  Character copyWith({
    String? id,
    String? name,
    String? personality,
    String? tone,
    String? gender,
    String? relation,
    String? habits,
    bool? isLocal,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      tone: tone ?? this.tone,
      gender: gender ?? this.gender,
      relation: relation ?? this.relation,
      habits: habits ?? this.habits,
      isLocal: isLocal ?? this.isLocal,
    );
  }
}