import 'package:chat_app_flutter/models/usuarios_response.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app_flutter/global/enviroment.dart';
import 'package:chat_app_flutter/models/usuario.dart';
import 'package:chat_app_flutter/services/auth_service.dart';

class UsuariosService{

  Future<List<Usuario>> getUsuarios() async{
    try{

      final url = Uri.http(Enviroment.apiUrl, 'api/usuarios/');

      final resp = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-token': await AuthService.getToken() ?? ''
          }
      );

      if(resp.statusCode == 200){
        final usuariosResponse = usuariosResponseFromJson(resp.body);

        return usuariosResponse.usuarios;
      }else{

        return [];
      }

    }catch(e){
      return [];
    }
  }

}