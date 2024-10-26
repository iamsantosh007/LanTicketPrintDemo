import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoaderDissmiss {
  LoaderDissmiss() {
    loaderDismiss();
  }
  void loaderDismiss() async {
    await EasyLoading.dismiss();
  }
}
