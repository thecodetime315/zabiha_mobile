
import 'package:base_flutter/core/base_widgets/my_text.dart';
import 'package:base_flutter/features/auth/screens/login/widgets/login_buttons.dart';
import 'package:flutter/material.dart';

import '../../../../../core/resource/color_manager.dart';
import '../../../widgets/logo_widget.dart';
import 'forget_password_button.dart';
import 'login_form.dart';


class LoginBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        // todo Focus request to close keyboard on click
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              LogoWidget(),
              MyText(title: "مرحبا بك",size: 18,fontWeight: FontWeight.bold,color: ColorManager.black,),
              LoginForm(),
              ForgetPasswordButton(),
              LoginButtons(),
            ],
          ),
        ),
      ),
    );
  }
}