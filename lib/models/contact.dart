class Contact {
  int? id;
  String name;
  String phone;
  String? email;
  bool isFavorite;

  Contact({this.id, required this.name, required this.phone, this.email, this.isFavorite = false});

  Contact copyWith({int? id, String? name, String? phone, String? email, bool? isFavorite}) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> m) {
    return Contact(
      id: m['id'] as int?,
      name: m['name'] as String? ?? '',
      phone: m['phone'] as String? ?? '',
      email: m['email'] as String?,
      isFavorite: (m['isFavorite'] as int? ?? 0) == 1,
    );
  }
}
