import 'package:chat_app_flutter/global/enviroment.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//enum para definir los estados del server

enum ServerStatus { Online, Offline, Connecting }


//ChangeNotifier notifica a los que este usando mi clase (hace que se redibujen)
class SocketService with ChangeNotifier {
  //se define la variable como privada para controlar que nadie mas cambie el valor
  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket? _socket;

  //retornamos el valor de nuestra variable privada
  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket? get socket => this._socket;
  Function get emit => _socket!.emit;
  Function get on => _socket!.on;
  Function get off => _socket!.off;

  connect() async{
    final token = await AuthService.getToken();

    this._socket = IO.io(Enviroment.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token
      }
    });

    this._socket?.on("connect", (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket?.on("disconnect", (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  disconnect(){
    this._socket?.disconnect();
  }
}