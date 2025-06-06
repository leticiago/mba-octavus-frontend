class Instrument {
  final String id;
  final String name;

  Instrument({required this.id, required this.name});

  factory Instrument.fromJson(Map<String, dynamic> json) {
    return Instrument(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
