class Player {
  final int _id;
  final String _name;
  final DateTime _createdAt;

  Player({required int id, required String name, DateTime? createdAt})
      : _id = id,
        _name = name,
        _createdAt = createdAt ?? DateTime.now();

  factory Player.fromJson(Map<String, String> json) {
    return switch (json) {
      {'id': String id, 'name': String name, 'created_at': String createdAt} =>
        Player(
            id: int.parse(id),
            name: name,
            createdAt: DateTime.parse(createdAt)),
      _ => throw FormatException('Invalid JSON format for Player')
    };
  }

  int get id => _id;
  String get name => _name;
  DateTime get createdAt => _createdAt;

  @override
  String toString() {
    return _name;
  }

  @override
  bool operator ==(Object other) {
    return other is Player && _id == other._id;
  }

  @override
  int get hashCode => _id;
}
