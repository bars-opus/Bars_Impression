import 'package:bars/utilities/exports.dart';

class Schedule {
  String id;
  String title;
  Timestamp scheduleDate; // Added scheduleDate field
  Timestamp startTime;
  Timestamp endTime;
  List<SchedulePeopleModel> people;

  Schedule({
    required this.id,
    required this.title,
    required this.scheduleDate, // Initialize scheduleDate in the constructor
    required this.startTime,
    required this.endTime,
    required this.people,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    List<dynamic> peopleData = json['people'];
    List<SchedulePeopleModel> collaboratedPeople = peopleData.map((personData) {
      return SchedulePeopleModel.fromJson(personData);
    }).toList();

    return Schedule(
      id: json['id'],
      title: json['title'],
      scheduleDate: Timestamp.fromMillisecondsSinceEpoch(json['scheduleDate']),
      startTime: Timestamp.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: Timestamp.fromMillisecondsSinceEpoch(json['endTime']),
      people: collaboratedPeople,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scheduleDate': scheduleDate.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'people': people.map((person) => person.toJson()).toList(),
    };
  }
}


