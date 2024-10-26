import 'dart:async';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:lanprintdemo/loader/loader.dart';
import 'package:lanprintdemo/loader/loaderDismiss.dart';
import 'package:network_discovery/network_discovery.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanPrintService{
  @pragma('vm:entry-point')
  Future<List<String>> discoverNetworkDeviceIpAddress() async {
    Loader();
    // final String deviceIP = await NetworkDiscovery.discoverDeviceIpAddress();
    List<String> networkDevices=[];
     final Completer<List<String>> completer = Completer();
    final stream = NetworkDiscovery.discoverAllPingableDevices('192.168.1');
    stream.listen((HostActive host) {
      print('Found device: ${host.ip}, isActive: ${host.isActive}');
      if (host.isActive) {
       networkDevices.add(host.ip);
      }
    
    }).onDone((){
      LoaderDissmiss();
       completer.complete(networkDevices);
    });

    return completer.future;
  }

   Future<List<Object>> connectLAN(
      String ipAddress, BuildContext context) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    var res = await printer.connect(ipAddress, port: 9100);

    return [res, printer];
  }
}