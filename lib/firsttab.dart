import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:mobile_scanner/mobile_scanner.dart';

class Firsttab extends StatefulWidget {
  const Firsttab({super.key});

  @override
  State<Firsttab> createState() => _FirsttabState();
}

class _FirsttabState extends State<Firsttab> {
  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scanned text copied to clipboard.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Scan Your QR Code",
          style: TextStyle(fontSize: 24),
        ),
      ),
      SizedBox(
        height: 300,
        width: 300,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 6, color: Colors.blue),
            borderRadius: BorderRadius.circular(15),
          ),
          child: MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
            ),
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                final String? rawValue = barcode.rawValue;
                if (rawValue != null) {
                  _copyToClipboard(rawValue);
                  if (mounted && image != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            rawValue,
                          ),
                          content: Image(
                            image: MemoryImage(image),
                          ),
                        );
                      },
                    );
                  }
                  break;
                }
              }
            },
          ),
        ),
      ),
    ]);
  }
}
