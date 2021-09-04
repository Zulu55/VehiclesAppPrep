class TokenHub {
  String token = '';
  String expiration = '';
  User user = User(
    address: '', 
    document: '', 
    email: '', 
    firstName: '', 
    fullName: '', 
    id: '', 
    imageFullPath: '', 
    imageId: '', 
    lastName: '', 
    phoneNumber: '', 
    userName: '', 
    userType: 0
  );

  TokenHub({required this.token, required this.expiration, required this.user});

  TokenHub.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiration'] = this.expiration;
    data['user'] = this.user.toJson();
    return data;
  }
}

class User {
  String firstName = '';
  String lastName = '';
  String document = '';
  String address = '';
  String imageId = '';
  String imageFullPath = '';
  int userType = 0;
  String fullName = '';
  String id = '';
  String userName = '';
  String email = '';
  String phoneNumber = '';

  User({
    required this.firstName,
    required this.lastName,
    required this.document,
    required this.address,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.fullName,
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    document = json['document'];
    address = json['address'];
    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    fullName = json['fullName'];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['document'] = this.document;
    data['address'] = this.address;
    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}