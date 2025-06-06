import 'dart:io';

import 'package:crm_ekuasoft_app/ui/ui.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  
  const ProfileScreen(Key? key, this.username,{ required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  final String githubURL =
      "https://github.com/MCarlomagno/FaceRecognitionAuth/tree/master";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(File(imagePath)),
                      ),
                    ),
                    margin: const EdgeInsets.all(20),
                    width: 50,
                    height: 50,
                  ),
                  Text(
                    'Hi $username !',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEFFC1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '''If you think this project seems interesting and you want to contribute or need some help implementing it, dont hesitate and lets get in touch!''',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    const Divider(
                      height: 30,
                    ),
                    InkWell(
                      //onTap: _launchURL,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CONTRIBUTE',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                null,
                text: "LOG OUT",
                onPressed: () {
                  
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                color: const Color(0xFFFF6161),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
