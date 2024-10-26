import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loader {
  String? message;
  Loader({this.message}) {
    loader();
  }

  void loader() async {
    await EasyLoading.show(
      status: message ?? 'loading...',
    );
  }

  Widget loaderForPagination() {
    return Container();
  }
}
