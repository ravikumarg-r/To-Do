class Contact {
  String descripion;
  // String contact;
  Contact({required this.descripion});

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        descripion: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "description": descripion,
      };
}
