class StdModel {
  StdModel({
    required this.fullName,
    required this.address,
    required this.mobile,
    required this.parentMobile,
    required this.email,
    required this.dob,
    required this.eduction,
    required this.course,
  });
  late final String fullName;
  late final String address;
  late final String mobile;
  late final String parentMobile;
  late final String email;
  late final String dob;
  late final List<Eduction> eduction;
  late final Course course;

  StdModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    address = json['address'];
    mobile = json['mobile'];
    parentMobile = json['parent_mobile'];
    email = json['email'];
    dob = json['dob'];
    eduction =
        List.from(json['eduction']).map((e) => Eduction.fromJson(e)).toList();
    course = Course.fromJson(json['course']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['full_name'] = fullName;
    _data['address'] = address;
    _data['mobile'] = mobile;
    _data['parent_mobile'] = parentMobile;
    _data['email'] = email;
    _data['dob'] = dob;
    _data['eduction'] = eduction.map((e) => e.toJson()).toList();
    _data['course'] = course.toJson();
    return _data;
  }
}

class Eduction {
  Eduction({
    required this.qualification,
    required this.university,
    required this.passingYear,
    required this.per,
  });
  late final String qualification;
  late final String university;
  late final int passingYear;
  late final double per;

  Eduction.fromJson(Map<String, dynamic> json) {
    qualification = json['qualification'];
    university = json['university'];
    passingYear = json['passing_year'];
    per = json['per'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['qualification'] = qualification;
    _data['university'] = university;
    _data['passing_year'] = passingYear;
    _data['per'] = per;
    return _data;
  }
}

class Course {
  Course({
    required this.name,
    required this.duration,
    required this.totalFees,
  });
  late final String name;
  late final String duration;
  late final int totalFees;

  Course.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    duration = json['duration'];
    totalFees = json['total_fees'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['duration'] = duration;
    _data['total_fees'] = totalFees;
    return _data;
  }
}
