import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelguide/theme/theme.dart';
import 'package:travelguide/viewmodels/auth_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:travelguide/views/authentication_screens/country_select_page.dart';
import 'package:travelguide/views/widgets/custom_button.dart';

class BirthDateSelectPage extends StatefulWidget {
  const BirthDateSelectPage({super.key});

  @override
  State<BirthDateSelectPage> createState() => _BirthDateSelectPageState();
}

class _BirthDateSelectPageState extends State<BirthDateSelectPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  int? _calculatedAge;

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime today = DateTime.now();
      final DateTime firstDate = DateTime(today.year - 100);
      final DateTime lastDate = DateTime(today.year - 15);

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: lastDate,
        firstDate: firstDate,
        lastDate: lastDate,
        //locale: Locale('tr', 'TR'), // Yerel ayarları yoruma alarak deneyin
      );

      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Doğum tarihi seçilirken bir hata oluştu. Lütfen tekrar deneyin.')),
      );
    }
  }

  int _calculateAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Kullanıcı Bilgileri"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (authViewModel.user != null)
                  Text(
                    "Hoşgeldin ${authViewModel.user?.name}!",
                    style: const TextStyle(fontSize: 24),
                  ),
                const SizedBox(height: 16),
                const Text(
                  "Şimdi senden birkaç bilgi alalım. Doğum gününü kutlamak için doğum tarihini bizimle paylaşır mısın? 🎉",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Doğum Tarihini Seç'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Kaydet",
                  color: AppColors.primaryColor,
                  onPressed: () async {
                    if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Lütfen doğum tarihinizi seçin.')),
                      );
                      return;
                    }

                    if (_formKey.currentState!.validate() &&
                        authViewModel.user != null) {
                      int age = _calculateAge(_selectedDate!);

                      Map<String, dynamic> data = {
                        'birth_date': _selectedDate!.toIso8601String(),
                        'age': age,
                      };

                      await authViewModel.updateUserField(
                          authViewModel.user!.userId, data);

                      setState(() {
                        _calculatedAge = age;
                      });

                      // CountrySelectPage sayfasına yönlendirme
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CountrySelectPage(),
                        ),
                      );
                    }
                  },
                ),
                if (_calculatedAge != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Yaşınız: $_calculatedAge',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
