class Contact {

  static const String idContactColumn = "id_contact";
  static const String nameColumn = "name";
  static const String emailColumn = "email";
  static const String phoneColumn = "phone";
  static const String imgUrlColumn = "img_url";

  int? idContact;
  String? name;
  String? email;
  String? phone;
  String? imgUrl;

  Contact();

  Contact.fromMap(Map map) {

    idContact = map[idContactColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    imgUrl = map[imgUrlColumn];

  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgUrlColumn: imgUrl
    };
    if (idContact != null) {

      map[idContactColumn] = idContact;

    }

    return map;

  }

  @override
  String toString() {

    return "Contact(idContact: $idContact, name: $name, email: $email, phone: $phone, imgUrl: $imgUrl)";

  }
}