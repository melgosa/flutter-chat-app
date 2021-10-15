import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app_flutter/models/user.dart';

class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  final users = [
    User(uid: '1', nombre: 'Marcos', email: 'melgosa_kent@hotmail.com', online: true),
    User(uid: '2', nombre: 'Mario', email: 'mario_kent@hotmail.com', online: true),
    User(uid: '3', nombre: 'Marcela', email: 'maercel_kent@hotmail.com', online: false),
    User(uid: '4', nombre: 'Mauricio', email: 'maurcio_kent@hotmail.com', online: true),
    User(uid: '5', nombre: 'Magdalena', email: 'magda_kent@hotmail.com', online: false),
    User(uid: '6', nombre: 'Marcia', email: 'marcia_kent@hotmail.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi nombre', style: TextStyle(color: Colors.black54)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            //Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),
      body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue[400]!,
          ),
          child: _ListViewUsers()
      ),
    );
  }

  ListView _ListViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(users[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
          title: Text(user.nombre!),
          subtitle: Text(user.email!),
          leading: CircleAvatar(
            child: Text(user.nombre!.substring(0,2)),
            backgroundColor: Colors.blue[100],
          ),
          trailing: Container(
            width: 10,
              height: 10,
            decoration: BoxDecoration(
              color: user.online! ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        );
  }

  _cargarUsuarios() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
