import 'package:vehicles_prep/hubs/document_type.dart';
import 'package:vehicles_prep/hubs/user.dart';

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
    userType: 0, 
    documentType: DocumentType(description: '', id: 0), 
    vehicles: [], 
    vehiclesCount: 0
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