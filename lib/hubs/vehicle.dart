import 'package:vehicles_prep/hubs/history.dart';
import 'package:vehicles_prep/hubs/vehicle_photo.dart';
import 'package:vehicles_prep/hubs/vehicle_type.dart';
import 'brand.dart';

class Vehicle {
  int id = 0;
  VehicleType vehicleType = VehicleType(description: '', id: 0);
  Brand brand = Brand(description: '', id: 0);
  int model = 0;
  String plaque = '';
  String line = '';
  String color = '';
  String remarks = '';
  List<VehiclePhoto> vehiclePhotos = [];
  int vehiclePhotosCount = 0;
  String imageFullPath = '';
  List<History> histories = [];
  int historiesCount = 0;

  Vehicle({
    required this.id,
    required this.vehicleType,
    required this.brand,
    required this.model,
    required this.plaque,
    required this.line,
    required this.color,
    required this.remarks,
    required this.vehiclePhotos,
    required this.vehiclePhotosCount,
    required this.imageFullPath,
    required this.histories,
    required this.historiesCount
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleType = VehicleType.fromJson(json['vehicleType']);
    brand = Brand.fromJson(json['brand']);
    model = json['model'];
    plaque = json['plaque'];
    line = json['line'];
    color = json['color'];
    remarks = json['remarks'];
    if (json['vehiclePhotos'] != null) {
      vehiclePhotos = [];
      json['vehiclePhotos'].forEach((v) {
        vehiclePhotos.add(VehiclePhoto.fromJson(v));
      });
    }
    vehiclePhotosCount = json['vehiclePhotosCount'];
    imageFullPath = json['imageFullPath'];
    if (json['histories'] != null) {
      histories = [];
      json['histories'].forEach((v) {
        histories.add(History.fromJson(v));
      });
    }
    historiesCount = json['historiesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicleType'] = this.vehicleType.toJson();
    data['brand'] = this.brand.toJson();
    data['model'] = this.model;
    data['plaque'] = this.plaque;
    data['line'] = this.line;
    data['color'] = this.color;
    data['remarks'] = this.remarks;
    data['vehiclePhotos'] = this.vehiclePhotos.map((v) => v.toJson()).toList();
    data['vehiclePhotosCount'] = this.vehiclePhotosCount;
    data['imageFullPath'] = this.imageFullPath;
    data['histories'] = this.histories.map((v) => v.toJson()).toList();
    data['historiesCount'] = this.historiesCount;
    return data;
  }
}