import 'package:flutter/material.dart';

class GeneratePDFInvoice extends StatelessWidget {
  const GeneratePDFInvoice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Invoice'),
      ),
      body: Center(
        child: const Text('PDF Invoice generation will be implemented here'),
      ),
    );
  }
}
