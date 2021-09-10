import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:vehicles_prep/hubs/brand.dart';
import 'package:vehicles_prep/hubs/document_type.dart';
import 'package:vehicles_prep/hubs/procedure_hub.dart';
import 'package:vehicles_prep/hubs/response.dart';
import 'package:vehicles_prep/hubs/user.dart';
import 'package:vehicles_prep/hubs/vehicle_type.dart';
import 'constans.dart';

class ApiHelper {
  static Future<Response> getDocumentTypes(String token) async {
    var url = Uri.parse('${Constans.apiUrl}/api/DocumentTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer $token',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<DocumentType> list = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(DocumentType.fromJson(item));  
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getBrands(String token) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Brands');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer $token',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Brand> list = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Brand.fromJson(item));  
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getProcedures(String token) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer $token',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Procedure> list = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Procedure.fromJson(item));  
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getVehicleTypes(String token) async {
    var url = Uri.parse('${Constans.apiUrl}/api/VehicleTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer $token',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<VehicleType> list = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehicleType.fromJson(item));  
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> getUsers(String token) async {
    var url = Uri.parse('${Constans.apiUrl}/api/Users');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer $token',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<User> list = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(User.fromJson(item));  
      }
    }

    return Response(isSuccess: true, result: list);
  }
}