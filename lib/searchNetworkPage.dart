import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:lanprintdemo/lan_print_service.dart';
import 'package:lanprintdemo/utils.dart';

class SearchNetworkPage extends StatefulWidget {
  const SearchNetworkPage({super.key});

  @override
  State<SearchNetworkPage> createState() => _SearchNetworkPageState();
}

class _SearchNetworkPageState extends State<SearchNetworkPage> {
  String selectedIpAddress="";
  List<String> networkDevices = [];


  LanPrintService lanPrintService=LanPrintService();
  
  bool isPrint=false;

  Future<void> printTicket(String selectedIpAddress) async {
    var res = await lanPrintService.connectLAN(selectedIpAddress,context);

    if (res.first == PosPrintResult.success) {
      await testReceipt(res.last as NetworkPrinter);
    }
  }

   Future testReceipt(NetworkPrinter printer) async{
    printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: const PosStyles(bold: true));
    printer.text('Reverse text', styles: const PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }

  Future<String> _showDialogueForNetworkSelection(BuildContext context) async {
    String ipAddress = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Network'),
                  IconButton(
                    onPressed: () async {
                      await lanPrintService
                          .discoverNetworkDeviceIpAddress()
                          .then((value) {
                        networkDevices = value;
                      });
                      //  d to update the list after refresh
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite, // Ensures full width
                height: 400, // Define the height to fit more items
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: networkDevices.isEmpty
                        ? [const Text('No Devices Found')]
                        : networkDevices.map((deviceIp) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                height: 50,
                                color: Colors.grey[300],
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Colors.black,
                                //   ),
                                // ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        deviceIp,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return ipAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Network Page"),),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(onPressed: ()async{
               ElevatedButton(onPressed: ()async{
                             selectedIpAddress =
                                await _showDialogueForNetworkSelection(context);
                            if(selectedIpAddress.isNotEmpty){
                              setState(() {
                                isPrint=true;
                              });
                            }
                          }, child: const Text("Select Network"));
            }, child: const Text("Search Network")),
          ),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(isPrint?Colors.green:Colors.grey)
              ),
              onPressed: ()async{
                  if(isPrint){
                     await printTicket(selectedIpAddress);
                  }else{
                     Utils.showFlasbar("Ip Address Not Selected", context);
                  }
            }, child: const Text("Print Ticket")),
          )
        ],
      ),

    );
  }
}