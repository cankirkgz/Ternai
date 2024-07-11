import 'package:flutter/material.dart';

class TatilPlaniPage extends StatelessWidget {
  // Bu değerler normalde önceki sayfalardan alınacak
  final String ulke = 'Hollanda';
  final int kalacakGun = 15;
  final int kisiSayisi = 2;
  final List<String> gezilecekYerler = ['Müzeler'];

  TatilPlaniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/sea_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mükemmel bir tatil planı oluşturalım!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ülke'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(ulke),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Kalacak gün'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(kalacakGun.toString()),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Kişi sayısı'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(kisiSayisi.toString()),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Gezilecek yerler'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(gezilecekYerler.join(', ')),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Çocuk var mı'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Hayır'),
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Düzenle'),
                    onPressed: () {
                      // Navigate back to edit
                    },
                  ),
                  ElevatedButton(
                    child: Text('Oluştur'),
                    onPressed: () {
                      // Navigate to budget page
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}