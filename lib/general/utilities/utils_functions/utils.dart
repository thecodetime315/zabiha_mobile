part of 'UtilsImports.dart';

class Utils {


  static Future<void> manipulateSplashData( BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await GeneralRepository(context).getHomeConstData();

    var strUser = prefs.get("user");
    if (strUser != null) {
      UserModel data = UserModel.fromJson(json.decode("$strUser"));
      GlobalState.instance.set("token", data.token);
      changeLanguage(data.lang,context);
      setCurrentUserData(data,context);
    } else {
      changeLanguage("ar",context);
      AutoRouter.of(context).push(SelectUserRoute());
    }

  }


  static Future<bool> manipulateLoginData(BuildContext context,dynamic data,String token)async{
    if (data != null) {
      int status = data["status"];
      if (status == 1) {
        await Utils.setDeviceId("$token");
        UserModel user = UserModel.fromJson(data["data"]);
        int type = data["data"]["type"];
        user.type = type == 1 ? "user" : "company";
        user.token = data["token"];
        user.lang = context.read<LangCubit>().state.locale.languageCode;
        GlobalState.instance.set("token", user.token);
        await Utils.saveUserData(user);
        Utils.setCurrentUserData(user, context);
      } else if (status == 2) {
        AutoRouter.of(context).push(ActiveAccountRoute(userId: data["data"]["id"]));
      }
      return true;
    }
    return false;
  }

  static void  setCurrentUserData(UserModel model,BuildContext context)async{
    // context.read<UserCubit>().onUpdateUserData(model);
    // ExtendedNavigator.of(context).push(Routes.home,arguments: HomeArguments(parentCount: parentCount));
  }

  static Future<void> saveUserData(UserModel model)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", json.encode(model.toJson()));
  }

  static void changeLanguage(String lang,BuildContext context){
    context.read<LangCubit>().onUpdateLanguage(lang);
  }

  static UserModel getSavedUser({required BuildContext context}){
    return context.read<UserCubit>().state.model;
  }

  static Future<String?> getDeviceId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("deviceId");
  }

  static Future<void> setDeviceId(String token)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("deviceId",token);
  }

  static void clearSavedData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static String getCurrentUserId({required BuildContext context}){
    var provider = context.watch<UserCubit>().state.model;
    return provider.id;
  }

  static void launchURL({required String url}) async {
    if (!url.toString().startsWith("https")) {
      url = "https://" + url;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      LoadingDialog.showToastNotification("من فضلك تآكد من الرابط");
    }
  }

  static void launchWhatsApp(phone) async {
    String message = 'مرحبا بك';
    if (phone.startsWith("00966")) {
      phone = phone.substring(5);
    }
    var _whatsAppUrl = "whatsapp://send?phone=+966$phone&text=$message";
    print(_whatsAppUrl);
    if (await canLaunch(_whatsAppUrl)) {
      await launch(_whatsAppUrl);
    } else {
      throw 'حدث خطأ ما';
    }
  }

  static void launchYoutube({required String url}) async {
    if (Platform.isIOS) {
      if (await canLaunch('$url')) {
        await launch('$url', forceSafariVC: false);
      } else {
        if (await canLaunch('$url')) {
          await launch('$url');
        } else {
          throw 'Could not launch $url';
        }
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static void callPhone({phone}) async {
    await launch("tel:$phone");
  }

  static void sendMail(mail) async {
    await launch("mailto:$mail");
  }

  static void shareApp(url) {
    LoadingDialog.showLoadingDialog();
    Share.share(url).whenComplete((){
      EasyLoading.dismiss();
    });
  }

  static Future<File?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image!=null) {
      File imageFile = File(image.path);
      return imageFile;
    }
    return null;
  }

  static Future<List<File>> getImages()async{
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? result = await _picker.pickMultiImage();
    if(result != null) {
      List<File> files = result.map((e) => File(e.path)).toList();
      return files;
    } else {
      return [];
    }
  }

  static Future<File?> getVideo() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video!=null) {
      File imageFile = File(video.path);
      return imageFile;
    }
    return null;
  }

  static void copToClipboard({required String text,required GlobalKey<ScaffoldState> scaffold}){
    if(text.trim().isEmpty){
      LoadingDialog.showToastNotification("لا يوجد بيانات للنسخ");
      return;
    }else{
      Clipboard.setData(ClipboardData(text: "$text")).then((value) {
        LoadingDialog.showToastNotification("تم النسخ بنجاح");
      });
    }
  }

  static Future<bool> askForPermission(Location location)async{
    var permission = await location.hasPermission();
    if (permission == PermissionStatus.deniedForever) {
      return false;
    } else if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.denied ||
          permission == PermissionStatus.deniedForever) {
        return false;
      }
    }
    return true;
  }

  static Future<LocationData> getCurrentLocation()async{
    final location = new Location();
    bool permission =await askForPermission(location);
    LocationData? current;
    if(permission){
      current = await location.getLocation();
    }
     return current??LocationData.fromMap({"latitude":0,"longitude":0});

  }

  static void navigateToMapWithDirection({required String lat,required String lng,required String title})async{
    final availableMaps = await MapLauncher.installedMaps;
    LocationData loc = await getCurrentLocation();
    if (availableMaps.length>0) {
      await availableMaps.first.showDirections(
        destinationTitle: title,
        origin: Coords(loc.latitude!, loc.longitude!),
        destination: Coords(double.parse(lat), double.parse(lng)),
      );
    }
    else{
      LoadingDialog.showSimpleToast("قم بتحميل خريطة جوجل");
    }
  }

  static String convertDigitsToLatin(String s) {
    var sb = new StringBuffer();
    for (int i = 0; i < s.length; i++) {
      switch (s[i]) {
      //Arabic digits
        case '\u0660':
          sb.write('0');
          break;
        case '\u0661':
          sb.write('1');
          break;
        case '\u0662':
          sb.write('2');
          break;
        case '\u0663':
          sb.write('3');
          break;
        case '\u0664':
          sb.write('4');
          break;
        case '\u0665':
          sb.write('5');
          break;
        case '\u0666':
          sb.write('6');
          break;
        case '\u0667':
          sb.write('7');
          break;
        case '\u0668':
          sb.write('8');
          break;
        case '\u0669':
          sb.write('9');
          break;
        default:
          sb.write(s[i]);
          break;
      }
    }
    return sb.toString();
  }

}
