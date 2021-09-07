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
  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;  
  TextEditingController _descriptionController = TextEditingController();

  String _price = '';
  String _priceError = '';
  bool _priceShowError = false;  
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _description = widget.procedure.description;
    _descriptionController.text = _description;
    _price = widget.procedure.price.toString();
    _priceController.text = _price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.procedure.id == 0 ? "Nuevo Procedimiento" : widget.procedure.description),
      ),
      body: Column(
        children: <Widget>[
          _showDescription(),
          _showPrice(),
          _showButtons(),
        ],
      ),
    );
  }

  Widget _showPrice() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
        controller: _priceController,
        decoration: InputDecoration(
          errorText: _priceShowError ? _priceError : null,
          hintText: 'Ingresa un precio...',
          labelText: 'Precio',
          suffixIcon: Icon(Icons.attach_money),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _price = value;
          });
        },
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _descriptionController,
        decoration: InputDecoration(
          errorText: _descriptionShowError ? _descriptionError : null,
          hintText: 'Ingresa una descripción...',
          labelText: 'Descripción',
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
        ),
        onChanged: (value) {
          setState(() {
            _description = value;
          });
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                      return Color(0xFF4DD637);
                  },
                ),
              ),
              child: Text('Guardar'),
              onPressed: () { }, 
            ),
          ),
          widget.procedure.id == 0 ? Container() : SizedBox(width: 10,),
          widget.procedure.id == 0 ? Container() : Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                      return Color(0xFFE21717);
                  },
                ),
              ),
              child: Text('Eliminar'),
              onPressed: () {}, 
            ),
          ),
        ],
      ),
    );
  }
}