class FeedbackReport {
    final String id;
    final User user;
    final String content;
    final DateTime date;
    FeedbackReport({
        required this.id,
        required this.user,
        required this.content,
        required this.date,
    });
}

class User {
    final String id;
    final String name;
    final String email;
    final String picture;

    User({
        required this.id,
        required this.name,
        required this.email,
        required this.picture,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        picture: json["picture"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "picture": picture,
    };
}