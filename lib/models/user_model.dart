import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  User(
      {this.id = '',
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.date,
      required this.phoneNo,
      required this.location,
      required this.userRole});

  @HiveField(0)
  String id;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String date;
  @HiveField(5)
  final String phoneNo;
  @HiveField(6)
  final String location;
  @HiveField(7)
  final String userRole;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'date': date,
        'phoneNo': phoneNo,
        'location': location,
        'userRole': userRole
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        date: json['date'],
        phoneNo: json['phoneNo'],
        location: json['location'],
        userRole: json['userRole'],
      );
}
