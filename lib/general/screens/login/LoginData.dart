part of 'LoginImports.dart';

class LoginData {
  GlobalKey<ScaffoldState> scaffold = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<CustomButtonState> btnKey = new GlobalKey<CustomButtonState>();

  final TextEditingController password = new TextEditingController();
  final TextEditingController phone = new TextEditingController();


  void userLogin(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).push(CupertinoPageRoute(builder: (cxt)=> HomeScreen()));
    return;
    if (formKey.currentState!.validate()) {
      btnKey.currentState!.animateForward();
      String phoneEn = Utils.convertDigitsToLatin(phone.text);
      String passEn = Utils.convertDigitsToLatin(password.text);
      await GeneralRepository(context).setUserLogin(phoneEn, passEn);
      btnKey.currentState!.animateReverse();
    }
  }
}
