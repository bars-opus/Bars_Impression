class PortfolioContactModel {
  String id;
  final String email;
  final String number;

  PortfolioContactModel({
    required this.id,
    required this.email,
    required this.number,
  });

  factory PortfolioContactModel.fromJson(Map<String, dynamic> json) {
    return PortfolioContactModel(
      id: json['id'],
      email: json['email'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'number': number,
    };
  }
}


