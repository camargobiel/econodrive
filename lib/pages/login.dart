import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    bool personal = true;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SizedBox(
          height: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          personal = true;
                        },
                        style: ButtonStyle(
                            fixedSize: const MaterialStatePropertyAll(
                              Size.fromHeight(50),
                            ),
                            backgroundColor: MaterialStatePropertyAll(
                              personal == true ? Colors.red : Colors.black54,
                            )),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.person,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Entrar pessoal"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          personal = false;
                        },
                        style: ButtonStyle(
                          fixedSize: const MaterialStatePropertyAll(
                            Size.fromHeight(50),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            personal == true ? Colors.black54 : Colors.red,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.car_rental,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("Entrar locadora"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Text(
                "Ainda não tem conta na plataforma? Cadastre-se agora.",
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        label: Text("E-mail"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        label: Text("Senha"),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                          Size(
                            double.maxFinite,
                            50,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Entrar",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/register");
                      },
                      child: const Text(
                        "Já tem conta? Clique para entrar.",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
