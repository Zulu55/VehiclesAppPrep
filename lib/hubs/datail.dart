import 'package:vehicles_prep/hubs/procedure_hub.dart';

class Detail {
  int id = 0;
  Procedure procedure = Procedure(description: '', id: 0, price: 0);
  int laborPrice = 0;
  int sparePartsPrice = 0;
  int totalPrice = 0;
  String remarks = '';

  Detail({
    required this.id,
    required this.procedure,
    required this.laborPrice,
    required this.sparePartsPrice,
    required this.totalPrice,
    required this.remarks
  });

  Detail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    procedure = Procedure.fromJson(json['procedure']);
    laborPrice = json['laborPrice'];
    sparePartsPrice = json['sparePartsPrice'];
    totalPrice = json['totalPrice'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['procedure'] = this.procedure.toJson();
    data['laborPrice'] = this.laborPrice;
    data['sparePartsPrice'] = this.sparePartsPrice;
    data['totalPrice'] = this.totalPrice;
    data['remarks'] = this.remarks;
    return data;
  }
}