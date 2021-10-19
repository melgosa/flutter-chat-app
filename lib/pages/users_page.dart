import 'package:chat_app_flutter/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app_flutter/services/usuarios_service.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/socket_service.dart';
import 'package:chat_app_flutter/models/usuario.dart';

class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final usuariosService = UsuariosService();

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  List<Usuario> _usuarios = [];

  @override
  void initState() {
    super.initState();
    this._cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario?.nombre ?? 'Usuario', style: TextStyle(color: Colors.black54)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {
          socketService.disconnect();
          Navigator.pushReplacementNamed(context, 'login');
          AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Connecting
                ? Icon(Icons.watch_later, color: Colors.yellow)
                : socketService.serverStatus == ServerStatus.Offline
                  ? Icon(Icons.offline_bolt, color: Colors.red)
                  : Icon(Icons.check_circle, color: Colors.blue[300])
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
        itemBuilder: (_, i) => _userListTile(_usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: _usuarios.length
    );
  }

  ListTile _userListTile(Usuario user) {
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara =  user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async{
    this._usuarios = await usuariosService.getUsuarios();
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
