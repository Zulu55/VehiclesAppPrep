import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';

import 'package:vehicles_prep/components/loader_component.dart';
import 'package:vehicles_prep/helpers/api_Helper.dart';
import 'package:vehicles_prep/hubs/document_type.dart';
import 'package:vehicles_prep/hubs/response.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/hubs/user.dart';
import 'package:vehicles_prep/screens/user_screen.dart';

class UsersScreen extends StatefulWidget {
  final TokenHub tokenHub;

  UsersScreen({required this.tokenHub});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  bool _isLoading = true;
  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
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
                  builder: (context) => UserScreen(
                    tokenHub: widget.tokenHub, 
                    user: User(
                      firstName: '', 
                      lastName: '', 
                      documentType: DocumentType(id: 0, description: ''), 
                      document: '', 
                      address: '', 
                      imageId: '', 
                      imageFullPath: '', 
                      userType: 1, 
                      fullName: '', 
                      vehicles: [], 
                      vehiclesCount: 0, 
                      id: '', 
                      userName: '', 
                      email: '', 
                      phoneNumber: ''
                    ),
                  )
                )
              );
        },
      ),
    );
  }

  Future<Null> _getUsers() async {
    setState(() {
      _isLoading = true;
    });

    Response response = await ApiHelper.getUsers(widget.tokenHub.token);

    setState(() {
      _isLoading = false;
    });
    
    if (!response.isSuccess) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    _users = response.result;
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getUsers,
      child: ListView(
        children: _users.map((e) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => UserScreen(
                      tokenHub: widget.tokenHub, 
                      user: e,
                    )
                  )
                );
              },
              child: Hero(
                tag: e.id,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage(
                          placeholder: AssetImage('assets/vehicles_logo.png'), 
                          image: NetworkImage(e.imageFullPath),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${e.fullName}', 
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            '${e.email}', 
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 5,),
                          Text(
                            'Tel??fono: ${e.phoneNumber}', 
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, size: 30,),
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
          ? 'No hay usuarios con ese criterio de b??squeda' 
          : 'No hay usuarios registrados.', 
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _getContent() {
    return _users.length == 0 
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
          title: Text('Filtar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Escriba las primeras letras del nombre del usuario que desea filtar'),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Criterio de b??squeda...',
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

    List<User> filteredUsers = [];
    for (var user in _users) {
      if (user.fullName.toLowerCase().contains(_search.toLowerCase())) {
        filteredUsers.add(user);
      }
    }

    setState(() {
      _users = filteredUsers;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  void _removeFilter() {
    _isFiltered = false;
    _getUsers();
  }
}