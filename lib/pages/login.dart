import 'package:econodrive/components/error-message.dart';
import 'package:econodrive/utils/errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool personal = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, String> formErrors = {};

  bool _haveErrors() {
    return formErrors["email"] != null || formErrors["password"] != null;
  }

  void _formatErrors(Object err) {
    formErrors = {};
    String error = err.toString();
    String customError = errors[error] ?? "Erro desconhecido";
    setState(() {
      if (customError.contains("Senha")) {
        formErrors["password"] = customError;
      } else if (customError.contains("E-mail")) {
        formErrors["email"] = customError;
      } else {
        formErrors["email"] = customError;
        formErrors["password"] = customError;
      }
    });
  }

  void _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacementNamed(context, "/home");
    } catch (err) {
      _formatErrors(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Image(
              image: AssetImage(
                "images/logo.png",
              ),
              width: 140,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: SizedBox(
            height: _haveErrors() ? 430 : 400,
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
                            setState(() {
                              personal = true;
                            });
                          },
                          style: ButtonStyle(
                            fixedSize: const MaterialStatePropertyAll(
                              Size.fromHeight(50),
                            ),
                            backgroundColor: MaterialStatePropertyAll(
                              personal == true ? Colors.red : Colors.black54,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.person,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Pessoal"),
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
                            setState(() {
                              personal = false;
                            });
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
                              Text("Locadora"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      personal == true ? Icons.person : Icons.car_rental,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
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
                  "Digite seus dados para entrar na plataforma.",
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          label: personal == true
                              ? const Text("E-mail")
                              : const Text("E-mail principal da locadora"),
                          border: const OutlineInputBorder(),
                          error: formErrors["email"] != null
                              ? ErrorMessage(
                                  message: formErrors["email"] as String,
                                )
                              : null,
                        ),
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          label: const Text("Senha"),
                          border: const OutlineInputBorder(),
                          error: formErrors["password"] != null
                              ? ErrorMessage(
                                  message: formErrors["password"] as String,
                                )
                              : null,
                        ),
                        obscureText: true,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/register");
                        },
                        child: const Text(
                          "Ainda não tem conta? Clique aqui para criar uma.",
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
      ),
    );
  }
}
