import 'package:flutter/material.dart';
import 'package:vehicles_prep/hubs/procedure_hub.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';

class ProcedureScreen extends StatefulWidget {
  final TokenHub tokenHub;
  final Procedure procedure;

  ProcedureScreen({required this.tokenHub, required this.procedure});

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.id == 0 ? "Nuevo Procedimiento" : widget.procedure.description),
      ),
      body: Center(
        child: Text(widget.procedure.id == 0 ? "Nuevo Procedimiento" : widget.procedure.description),
      ),
    );
  }
}