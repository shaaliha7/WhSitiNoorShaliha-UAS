class Dosen {
  final int id;
  final String name;
  final String img;
  final List<ChatDetail> details; 

  Dosen({
    required this.id,
    required this.name,
    required this.img,
    required this.details,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      details: (json['details'] as List)
          .map((c) => ChatDetail.fromJson(c))
          .toList(),
    );
  }
}

class ChatDetail {
  final String role;
  final String message;

  ChatDetail({required this.role, required this.message});

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      role: json['role'],
      message: json['message'],
    );
  }
}