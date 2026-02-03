class SessionST {
  final String status;
  final bool exists;

  const SessionST({
    required this.status,
    required this.exists,
  });

  factory SessionST.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'status': String status,
        'exists': bool exists,
      } =>
        SessionST(
          status: status,
          exists: exists,
        ),
      _ => throw const FormatException('Failed to load SessionST.'),
    };
  }
}
