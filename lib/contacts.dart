class Contacts {
  String name;
  String contact;
  Contacts({required this.name, required this.contact});

  factory Contacts.fromJson(Map<String, dynamic> json) => Contacts(
        name: json["name"],
        contact: json["contact"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "contact": contact,
      };
}
