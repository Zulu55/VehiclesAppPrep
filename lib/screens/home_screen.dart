import 'package:flutter/material.dart';

import 'package:vehicles_prep/helpers/constans.dart';
import 'package:vehicles_prep/hubs/token_hub.dart';
import 'package:vehicles_prep/screens/login_screen.dart';
import 'package:vehicles_prep/screens/procedures_screen.dart';
import 'package:vehicles_prep/screens/users_screen.dart';
import 'package:vehicles_prep/screens/vehicle_types_screen.dart';
import 'brands_screen.dart';
import 'document_types_screen.dart';

class HomeScreen extends StatefulWidget {
  final TokenHub tokenHub;
  
  HomeScreen({required this.tokenHub});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      body: _getBody(),
      drawer: widget.tokenHub.user.userType == 0 ? _getMechanicMenu() : _getCustomerMenu(),
    );
  }

  Widget _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: FadeInImage(
              placeholder: NetworkImage(Constans.noImageUrl), 
              image: NetworkImage(widget.tokenHub.user.imageFullPath),
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 30,),
        Text(
          'Bienvenid@ ${widget.tokenHub.user.fullName}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _getMechanicMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Image(
              image: AssetImage('assets/vehicles_logo.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.two_wheeler),
            title: const Text('Marcas'),
            onTap: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => BrandsScreen(tokenHub: widget.tokenHub)
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.precision_manufacturing),
            title: const Text('Procedimientos'),
            onTap: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => ProceduresScreen(tokenHub: widget.tokenHub)
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.badge),
            title: const Text('Tipos de Documento'),
            onTap: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => DocumentTypesScreen(tokenHub: widget.tokenHub,)
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.toys),
            title: const Text('Tipos de Veh??culos'),
            onTap: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => VehicleTypesScreen(tokenHub: widget.tokenHub,)
                )
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: const Text('Usuarios'),
            onTap: () { 
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => UsersScreen(tokenHub: widget.tokenHub)
                )
              );
            },
          ),
          Divider(
            color: Colors.black, 
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: const Text('Editar Perfil'),
            onTap: () { },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Cerras Sesi??n'),
            onTap: () { 
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginScreen()
                )
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getCustomerMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Image(
              image: AssetImage('assets/vehicles_logo.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.two_wheeler),
            title: const Text('Mis veh??culos'),
            onTap: () { },
          ),
          Divider(
            color: Colors.black, 
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: const Text('Editar Perfil'),
            onTap: () { },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Cerras Sesi??n'),
            onTap: () { 
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginScreen()
                )
              );
            },
          ),
        ],
      ),
    );
  }
}