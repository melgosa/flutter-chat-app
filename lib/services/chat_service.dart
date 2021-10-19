import 'package:chat_app_flutter/global/enviroment.dart';
import 'package:chat_app_flutter/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app_flutter/models/usuario.dart';

import 'auth_service.dart';

class ChatService with ChangeNotifier{
  Usuario? usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async{
    try{

      final url = Uri.http(Enviroment.apiUrl, 'api/mensajes/$usuarioID');

      final resp = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken() ?? ''
          }
      );

      if(resp.statusCode == 200){
        final mensajesResponse = mensajesResponseFromJson(resp.body);

        return mensajesResponse.mensajes;
      }else{

        return [];
      }

    }catch(e){
      return [];
    }
  }
}