import 'dart:convert';

import 'package:chat_app_flutter/global/enviroment.dart';
import 'package:chat_app_flutter/models/login_response.dart';
import 'package:chat_app_flutter/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier{

  Usuario? usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor){
    this._autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estatica
  static Future<String?> getToken() async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');

    return token;
  }

  static Future deleteToken() async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final url = Uri.http(Enviroment.apiUrl, 'api/login');
    final resp = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json'
        }
    );

    this.autenticando = false;

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    }else{
      return false;
    }

  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final url = Uri.http(Enviroment.apiUrl, 'api/login/new');
    final resp = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'}
    );

    this.autenticando = false;

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future isLoggedIn() async{
    final token = await this._storage.read(key: 'token') ?? '';
    final url = Uri.http(Enviroment.apiUrl, 'api/login/renew');

    final resp = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token
        }
    );

    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);

      return true;
    }else{
      this._logout();
      return false;
    }
  }

  Future _guardarToken(String token) async{
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async{
    return await _storage.delete(key: 'token');
  }
}