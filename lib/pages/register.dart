import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    bool personal = true;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SizedBox(
          child: Wrap(
            runSpacing: 15,
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
                            Text("Cadastro pessoal"),
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
                            Text("Cadastro locadora"),
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
                    "Cadastrar",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Text(
                "Digite seus dados para cadastrar na plataforma",
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Wrap(
                runSpacing: 15,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      label: Text("Nome da locadora"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      label: Text("E-mail da organização"),
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
                  const TextField(
                    decoration: InputDecoration(
                      label: Text("Confirmar senha"),
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
                      Navigator.pushReplacementNamed(context, "/login");
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
            ],
          ),
        ),
      ),
    );
  }
}
