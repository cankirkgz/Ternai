import 'package:flutter/material.dart';
import 'package:travelguide/theme/theme.dart';

class PriceSearchScreen extends StatelessWidget {
  const PriceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                "Bilgi almak istediğin ürün ya da hizmet ile ilgili:",
                style: TextStyle(fontSize: 24, color: AppColors.primaryColor),
              ),
            )
          ],
        ));
  }
}
