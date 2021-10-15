import 'dart:io';

import 'package:chat_app_flutter/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatAppBar(),
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

  AppBar _ChatAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          CircleAvatar(
            child: Text('Ma', style: TextStyle(fontSize: 12)),
            backgroundColor: Colors.blue[100],
            radius: 14,
          ),
          SizedBox(height: 3),
          Text('Marcos Melgosa',
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
    print('$text');
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: text,
      uid: '123',
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 600)));

    _messages.insert(0, newMessage);

    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
  }
}
