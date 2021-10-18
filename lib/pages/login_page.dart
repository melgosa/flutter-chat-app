import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app_flutter/helpers/mostrar_alerta.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/widgets/custom_button_azul.dart';
import 'package:chat_app_flutter/widgets/custom_input.dart';
import 'package:chat_app_flutter/widgets/labels_login.dart';
import 'package:chat_app_flutter/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                Logo(titulo: 'Messenger'),
                _Form(),
                Labels( ruta: 'register', titulo: '¿No tienes cuenta?',subtitulo: 'Crea una ahora!',),
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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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

          BotonAzul(
              text: 'Ingresar',
              onPressed: authService.autenticando
                  ? () => {}
                  : () async {
                FocusScope.of(context).unfocus();
                final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());

                if(loginOk){
                  Navigator.pushReplacementNamed(context, 'users');

                }else{
                  mostrarAlerta(context, 'Login Incorrecto', 'Revise sus credenciales nuevamente');
                }
              }
          ),
          //RaisedButton(onPressed: () {})
        ],
      ),
    );
  }

}


