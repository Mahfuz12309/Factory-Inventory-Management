import 'package:flutter/material.dart';

class ViewBalanceSheet extends StatelessWidget {
  const ViewBalanceSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance Sheet'),
      ),
      body: Center(
        child: const Text('Day-wise Balance Sheet will be shown here'),
      ),
    );
  }
}
