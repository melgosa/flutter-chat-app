import 'package:chat_app_flutter/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_flutter/helpers/mostrar_alerta.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/widgets/custom_button_azul.dart';
import 'package:chat_app_flutter/widgets/custom_input.dart';
import 'package:chat_app_flutter/widgets/labels_login.dart';
import 'package:chat_app_flutter/widgets/logo.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: 'Registro'),
                _Form(),
                Labels( ruta: 'login', titulo: '¿Ya tienes una cuenta?', subtitulo: 'Ingresa ahora!'),
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text('Términos y condiciones de uso',
                        style: TextStyle(fontWeight: FontWeight.w200)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            textInputType: TextInputType.name,
            textController: nameCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            textInputType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          BotonAzul(text: 'Crear cuenta', onPressed: authService.autenticando
              ? () => {}
              : () async {
            FocusScope.of(context).unfocus();

            final registerOk = await authService.register(
                nameCtrl.text.trim() ,
                emailCtrl.text.trim(),
                passCtrl.text.trim()
            );

            if(registerOk == true){
              socketService.connect();
              Navigator.pushReplacementNamed(context, 'users');

            }else{
              mostrarAlerta(context, 'Registro incorrecto', registerOk);
            }
          }),
          //RaisedButton(onPressed: () {})
        ],
      ),
    );
  }
}


