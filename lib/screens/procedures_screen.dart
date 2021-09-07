import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:vehicles_prep/components/loader_component.dart';

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
  bool _isLoading = true;

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
      body: _isLoading ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {  },
      ),
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
    _isLoading = false;
    setState(() { });
  }

  Widget _getListView() {
    return ListView(
      children: _procedures.map((e) {
        return Card(
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(
              //     builder: (context) => ExerciseScreen(
              //       exercise: e,
              //     )
              //   )
              // );
            },
            child: Hero(
              tag: e.id,
              child: Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.description, 
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${NumberFormat.currency(symbol: '\$').format(e.price)}', 
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _noContent() {
    return Center(
      child: Text(
        'No hay procedimientos registrados.', 
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      ),
    );  
  }

  Widget _getContent() {
    return _procedures.length == 0 
      ? _noContent() 
      : _getListView();
  }
}