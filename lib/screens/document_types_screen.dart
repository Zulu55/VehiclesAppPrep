import 'dart:convert';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/constans.dart';
import 'package:vehicles_prep/hubs/document_type.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/screens/document_type_screen.dart';

class DocumentTypesScreen extends StatefulWidget {
  final TokenHub tokenHub;

  DocumentTypesScreen({required this.tokenHub});

  @override
  _DocumentTypesScreenState createState() => _DocumentTypesScreenState();
}

class _DocumentTypesScreenState extends State<DocumentTypesScreen> {
  List<DocumentType> _documentTypes = [];
  bool _isLoading = true;
  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getDocumentTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Documento'),
        actions: <Widget>[
          _isFiltered 
          ? IconButton(
              icon: Icon(Icons.filter_none),
              onPressed: _removeFilter,
            )
          : IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: _showFilter,
            ), 
        ],
      ),
      body: _isLoading ? LoaderComponent(text: 'Por favor espere...') : _getContent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {  
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => DocumentTypeScreen(
                    tokenHub: widget.tokenHub, 
                    documentType: DocumentType(description: '', id: 0),
                  )
                )
              );
        },
      ),
    );
  }

  Future<Null> _getDocumentTypes() async {
    var url = Uri.parse('${Constans.apiUrl}/api/DocumentTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept'       : 'application/json',
        'authorization': 'bearer ${widget.tokenHub.token}',
      }, 
    );

    String body = response.body;
    if (response.statusCode >= 400) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: body,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    _documentTypes = [];
    dynamic decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        _documentTypes.add(DocumentType.fromJson(item));  
      }
    }
    _isLoading = false;
    setState(() { });
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getDocumentTypes,
      child: ListView(
        children: _documentTypes.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => DocumentTypeScreen(
                      tokenHub: widget.tokenHub, 
                      documentType: e,
                    )
                  )
                );
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _noContent() {
    return Center(
      child: Text(
        _isFiltered 
          ? 'No hay tipos de documento con ese criterio de búsqueda' 
          : 'No hay tipos de documento registrados.', 
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _getContent() {
    return _documentTypes.length == 0 
      ? _noContent() 
      : _getListView();
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Text('Filtar Tipo de Documento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Escriba las primeras letras del tipo de documento que desea filtar'),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Criterio de búsqueda...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),            
            TextButton(
              onPressed: () => _filter(),
              child: Text('Ok'),
            ),            
          ],
        );
      }
    );
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<DocumentType> filteredDocumentTypes = [];
    for (var documentType in _documentTypes) {
      if (documentType.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredDocumentTypes.add(documentType);
      }
    }
    setState(() {
      _documentTypes = filteredDocumentTypes;
      _isFiltered = true;
    });
    Navigator.of(context).pop();
  }

  void _removeFilter() {
    _isFiltered = false;
    _getDocumentTypes();
  }
}