class HomeModel {
  bool? success;
  Data? data;

  HomeModel({this.success, this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<VacantBeds>? vacantBeds;
  List<BookedBeds>? bookedBeds;

  Data({this.vacantBeds, this.bookedBeds});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vacantBeds'] != null) {
      vacantBeds = <VacantBeds>[];
      json['vacantBeds'].forEach((v) {
        vacantBeds!.add(new VacantBeds.fromJson(v));
      });
    }
    if (json['bookedBeds'] != null) {
      bookedBeds = <BookedBeds>[];
      json['bookedBeds'].forEach((v) {
        bookedBeds!.add(new BookedBeds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vacantBeds != null) {
      data['vacantBeds'] = this.vacantBeds!.map((v) => v.toJson()).toList();
    }
    if (this.bookedBeds != null) {
      data['bookedBeds'] = this.bookedBeds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VacantBeds {
  int? roomNumber;
  int? bedNumber;

  VacantBeds({this.roomNumber, this.bedNumber});

  VacantBeds.fromJson(Map<String, dynamic> json) {
    roomNumber = json['roomNumber'];
    bedNumber = json['bedNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomNumber'] = this.roomNumber;
    data['bedNumber'] = this.bedNumber;
    return data;
  }
}

class BookedBeds {
  String? employee;
  int? roomNumber;
  int? bedNumber;
  String? loggedInDate;
  String? loggedOutDate;

  BookedBeds(
      {this.employee,
        this.roomNumber,
        this.bedNumber,
        this.loggedInDate,
        this.loggedOutDate});

  BookedBeds.fromJson(Map<String, dynamic> json) {
    employee = json['employee'];
    roomNumber = json['roomNumber'];
    bedNumber = json['bedNumber'];
    loggedInDate = json['loggedInDate'];
    loggedOutDate = json['loggedOutDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee'] = this.employee;
    data['roomNumber'] = this.roomNumber;
    data['bedNumber'] = this.bedNumber;
    data['loggedInDate'] = this.loggedInDate;
    data['loggedOutDate'] = this.loggedOutDate;
    return data;
  }
}