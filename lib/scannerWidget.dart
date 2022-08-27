// import 'package:flutter/material.dart';
// import 'package:reviz/scannerUtils.dart';
//
// class ScannerWidget extends StatelessWidget {
//
//   const ScannerWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         alignment: Alignment.center,
//         child: Flex(
//             direction: Axis.vertical,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                       onPressed: () {
//                         Scanner.scanBarcodeNormal().then(
//                                 (value) => controllerQrText.text = value);
//                       },
//                       child: Text('Start barcode scan')),
//                   ElevatedButton(
//                       onPressed: () {
//                         Scanner.scanQR().then(
//                                 (value) => controllerQrText.text = value);
//                       },
//                       child: Text('Start QR scan')),
//                 ],
//               ),
//             ])
//     ),
//   }
// }
