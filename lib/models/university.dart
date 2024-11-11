class University {
  final String name;
  final String country;

  University({
    required this.name,
    required this.country,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] as String,
      country: json['country'] as String,
    );
  }
}