import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
class GoogleLoginService extends GetxController {
  var _googleSignIn = GoogleSignIn();
  var googleAccont = Rx<GoogleSignInAccount?>(null);

  login() async {
    googleAccont.value = await _googleSignIn.signIn();
  }
}
