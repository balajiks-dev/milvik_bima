///
/// Define for Doctors List
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
class DoctorsResponseModel {
  final int id;
  final String firstName;
  final String lastName;
  final String profilePic;
  final bool favorite;
  final String primaryContactNo;
  final String rating;
  final String emailAddress;
  final String qualification;
  final String description;
  final String specialization;
  final String languagesKnown;
  final String gender;
  final String height;
  final String weight;
  final String bloodGroupName;
  final int birthDay;
  final int birthMonth;
  final int birthYear;

  DoctorsResponseModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.profilePic,
      required this.favorite,
      required this.primaryContactNo,
      required this.rating,
      required this.emailAddress,
      required this.qualification,
      required this.description,
      required this.specialization,
      required this.languagesKnown,
      required this.gender,
      required this.height,
      required this.weight,
        required this.bloodGroupName,
        required this.birthDay,
        required this.birthMonth,
        required this.birthYear});

  factory DoctorsResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorsResponseModel(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        profilePic: json['profile_pic'],
        favorite: json['favorite'],
        primaryContactNo: json['primary_contact_no'],
        rating: json['rating'],
        emailAddress: json['email_address'],
        qualification: json['qualification'],
        description: json['description'],
        specialization: json['specialization'],
        languagesKnown: json['languagesKnown'],
        gender: json['gender'] ?? "",
        height: json['height'] ?? "",
        weight: json['weight'] ?? "",
        bloodGroupName: json['bloodGroupName'] ?? "",
        birthDay: json['birthDay'] ?? 1,
        birthMonth: json['birthMonth'] ?? 1,
        birthYear: json['birthYear'] ?? 1900);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_pic'] = profilePic;
    data['favorite'] = favorite;
    data['primary_contact_no'] = primaryContactNo;
    data['rating'] = rating;
    data['email_address'] = emailAddress;
    data['qualification'] = qualification;
    data['description'] = description;
    data['specialization'] = specialization;
    data['languagesKnown'] = languagesKnown;
    data['gender'] = gender;
    data['height'] = height;
    data['weight'] = weight;
    data['bloodGroupName'] = bloodGroupName;
    data['birthMonth'] = birthMonth;
    data['birthDay'] = birthDay;
    data['birthYear'] = birthYear;
    return data;
  }
}
