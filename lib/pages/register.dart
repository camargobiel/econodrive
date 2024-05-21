import 'package:econodrive/components/error-message.dart';
import 'package:econodrive/utils/errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firestore = FirebaseFirestore.instance;
  bool personal = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Map<String, String> formErrors = {};

  void _formatErrors(Object err) {
    formErrors = {};
    String error = err.toString();
    String customError = errors[error] ?? "Erro desconhecido";
    setState(() {
      if (customError.toLowerCase().contains("senha")) {
        formErrors["password"] = customError;
      } else if (customError.toLowerCase().contains("e-mail")) {
        formErrors["email"] = customError;
      } else {
        formErrors["email"] = customError;
        formErrors["password"] = customError;
      }
    });
  }

  void _register(BuildContext context) async {
    if (nameController.value.text == "") {
      setState(() {
        formErrors["name"] = "Nome é obrigatório";
      });
      return;
    }
    try {
      CollectionReference usersCollectionRef = firestore.collection('users');
      var authResponse =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (authResponse.user?.uid != null) {
        await authResponse.user!.updateDisplayName(nameController.value.text);
        await usersCollectionRef.doc(authResponse.user!.uid).set({
          "type": personal == true ? "personal" : "rental",
        });
      }
      await Navigator.pushReplacementNamed(context, "/home");
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
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            Text("Cadastrar pessoa"),
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
                            Text("Cadastrar locadora"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
                    "Cadastrar",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Digite seus dados para cadastrar na plataforma.",
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        label: personal == true
                            ? const Text("Nome completo")
                            : const Text("Nome da locadora"),
                        border: const OutlineInputBorder(),
                        error: formErrors["name"] != null
                            ? ErrorMessage(
                                message: formErrors["name"] as String,
                              )
                            : null,
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _register(context);
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
                        "Cadastrar",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
