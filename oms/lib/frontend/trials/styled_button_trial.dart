import 'package:flutter/material.dart';

import 'package:oms/frontend/components/styled_button.dart';

class StyledButtonTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Tüm butonları saran padding
        child: Column(
          children: [
            // sadece buton
            Row(
              children: [
                StyledButton(
                  flex: 0,
                  title: 'Button 1',
                  onPressed: () => print('Button 1 pressed'),
                ),
              ],
            ),
            // ekranı enine kaplayan butonlar
            Row(
              children: [
                StyledButton(
                  flex: 1,
                  title: 'Button 2',
                  onPressed: () => print('Button 2 pressed'),
                ),
                StyledButton(
                  flex: 2,
                  title: 'Button 3',
                  onPressed: () => print('Button 3 pressed'),
                ),
              ],
            ),
            // sağa dayalı buton
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StyledButton(
                  flex: 0,
                  title: 'Button 4',
                  onPressed: () => print('Button 4 pressed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// aşağıdaki kodu kopyalayıp kullanabilirsiniz
// void main() {
//   runApp(MaterialApp(home: StyledButtonTest()));
// }