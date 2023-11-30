class Chat {
  String message;
  String id;

  Chat({
    required this.message,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'id': id,
    };
  }
}
