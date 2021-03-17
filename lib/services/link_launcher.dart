import 'package:mamaket/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher {
  static void launchInsta() async {
    if (await canLaunch(kInsta)) {
      await launch(kInsta);
    } else {
      throw 'Could not launch $kInsta';
    }
  }

  static void launchTwitter() async {
    if (await canLaunch(kTwitter)) {
      await launch(kTwitter);
    } else {
      throw 'Could not launch $kTwitter';
    }
  }
}
