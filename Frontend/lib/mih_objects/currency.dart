class Currency {
  final String code;
  final String name;

  const Currency({
    required this.code,
    required this.name,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "code": String code,
        'name': String name,
      } =>
        Currency(
          code: code,
          name: name,
        ),
      _ => throw const FormatException('Failed to load Currency object.'),
    };
  }
}
