import 'dart:io';

import 'package:chat_app_flutter/models/mensajes_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_flutter/models/usuario.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/socket_service.dart';
import 'package:chat_app_flutter/services/chat_service.dart';
import 'package:chat_app_flutter/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;


  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket?.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(this.chatService.usuarioPara?.uid ?? '');
  }

  _cargarHistorial(String usuarioID) async{
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);
    
    final history = chat.map((m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0)
        )..forward()
    ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  _escucharMensaje(dynamic payload){
    ChatMessage message = ChatMessage(
        texto: payload['mensaje'],
        uid: payload['de'],
        animationController: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 600)
        )
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = this.chatService.usuarioPara;

    return Scaffold(
      appBar: _ChatAppBar(usuarioPara),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            Divider(height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  AppBar _ChatAppBar(Usuario? usuario) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            child: Text(usuario?.nombre.substring(0,2) ?? 'Nn', style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.blue[100],
            radius: 14,
          ),
          SizedBox(height: 3),
          Text(usuario?.nombre ?? 'No name',
              style: TextStyle(color: Colors.black87, fontSize: 13))
        ],
      ),
      centerTitle: true,
      elevation: 1,
    );
  }

  _inputChat() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _input(),
                _sendMessageButton()
              ],
            )));
  }

  Container _sendMessageButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: Platform.isIOS ? _iosButton() : _androidButton(),
    );
  }

  Container _androidButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: IconTheme(
        data: IconThemeData(color: Colors.blue[400]),
        child: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Icon(Icons.send),
          onPressed: _estaEscribiendo
              ? () => _handleSubmit(_textController.text.trim())
              : null,
        ),
      ),
    );
  }

  CupertinoButton _iosButton() {
    return CupertinoButton(
      child: Text('Enviar'),
      onPressed: _estaEscribiendo
          ? () => _handleSubmit(_textController.text.trim())
          : null,
    );
  }

  Flexible _input() {
    return Flexible(
      child: TextField(
        controller: _textController,
        onSubmitted: _handleSubmit,
        onChanged: (texto) {
          setState(() {
            texto.trim().length > 0
                ? _estaEscribiendo = true
                : _estaEscribiendo = false;
          });
        },
        decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
        focusNode: _focusNode,
      ),
    );
  }

  _handleSubmit(String text) {
    if(text.length == 0) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: text,
      uid: authService.usuario?.uid ?? '',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 600)));

    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    this.socketService.emit('mensaje-personal', {
      'de': this.authService.usuario?.uid ?? 'baddddd',
      'para': this.chatService.usuarioPara?.uid ?? 'badddd',
      'mensaje': text
    });
  }

  @override
  void dispose() {
    super.dispose();
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    this.socketService.socket?.off('mensaje-personal');
  }
}
