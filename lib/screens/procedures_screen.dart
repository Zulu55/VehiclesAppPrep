import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:vehicles_prep/helpers/constans.dart';
import 'package:vehicles_prep/hubs/procedure_hub.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';

class ProceduresScreen extends StatefulWidget {
  final TokenHub tokenHub;

  ProceduresScreen({required this.tokenHub});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Procedure> _procedures = [];

  @override
  void initState() {
    super.initState();
    _getProcedures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Procedimientos'),
      ),
      body: Center(child: Text('Procedures')),
    );
  }

  void _getProcedures() async {
    var url = Uri.parse('${Constans.apiUrl}/api/Procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer ${widget.tokenHub.token}',
      }, 
    );

    String body = response.body;
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        _procedures.add(Procedure.fromJson(item));  
      }
    }
  }
}