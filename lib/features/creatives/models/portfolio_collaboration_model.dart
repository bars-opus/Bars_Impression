import 'package:bars/features/events/event_management/models/collaborated_people_model.dart';

class PortfolioCollaborationModel {
  String id;
  String name; 
  String link; 
  List<CollaboratedPeople> people;

  PortfolioCollaborationModel({
    required this.id,
    required this.name,
    required this.link,
    required this.people,
  });

  factory PortfolioCollaborationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> peopleData = json['people'];
    List<CollaboratedPeople> collaboratedPeople =
        peopleData.map((personData) {
      return CollaboratedPeople.fromJson(personData);
    }).toList();

    return PortfolioCollaborationModel(
      id: json['id'],
      name: json['name'],
      link: json['link'],
      people: collaboratedPeople,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'people': people.map((person) => person.toJson()).toList(),
    };
  }
}

