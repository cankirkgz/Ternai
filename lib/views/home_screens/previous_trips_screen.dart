// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreviousTripsScreen extends StatelessWidget {
  const PreviousTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Önceki Tatil Planlarım'),
      ),
      body: SizedBox(
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/pplans_page.jpg"),
                  fit: BoxFit.cover,
                  ),),),
                ListView(
                  children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20.0,right: 30, left: 30.0),
                        height: 200,
                        decoration: const BoxDecoration(boxShadow: [BoxShadow(blurRadius:10,color: Colors.grey,offset: Offset.zero)]),
                        child: Card(
                          color: const Color.fromARGB(255, 170, 210, 230),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                              Image.asset('assets/images/Hollanda.jpg',
                              height: 120,
                              fit: BoxFit.fill,),
                              Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: Text(
                                  textAlign:TextAlign.center,
                                'Hollanda\'da 2 kişilik 15 günlük bütçe planı',
                                style: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 15.0 ,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ],
                        )//child: Text('Hollanda''da 2 kişilik 15 günlük bütçe planı')
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0,right: 30, left: 30.0),
                      height: 200,
                      decoration: const BoxDecoration(boxShadow: [BoxShadow(blurRadius:10,color: Colors.grey,offset: Offset.zero)]),
                      child : Card(
                        color: const Color.fromARGB(255, 170, 210, 230),
                        child:  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children : <Widget>[
                          Image.asset('assets/images/Italy.jpg',
                          height: 120,
                          fit: BoxFit.fill,),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15,right: 15),
                            child: Text(
                              textAlign:TextAlign.center,
                              'İtalya\'da 9000\$ bütçe ile 4 kişilik 7 günlük tatil planı',
                              style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 15.0 ,
                              fontWeight: FontWeight.bold,
                              ),),),
                          ]
                        ),
                      ),
                    ),
                    Container(
                    margin: const EdgeInsets.only(top: 10.0,right: 30, left: 30.0),
                      height: 200,
                      decoration: const BoxDecoration(boxShadow: [BoxShadow(blurRadius:10,color: Colors.grey,offset: Offset.zero)]),
                      child : Card(
                        color:  const Color.fromARGB(255, 170, 210, 230),
                        child:  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children : <Widget>[
                          Image.asset('assets/images/fransa.jpg',
                          height: 120,
                          fit: BoxFit.fill,),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15,right: 15),
                            child: Text(
                              textAlign:TextAlign.center,
                              'Fransa\'da 350\$ bütçe ile 1 kişilik tatil için kalacak gün sayısı',
                              style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 15.0 ,
                              fontWeight: FontWeight.bold,
                              )),),
                      ]
                    ),
                  ),//textAlign : TextAlign.center,),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
