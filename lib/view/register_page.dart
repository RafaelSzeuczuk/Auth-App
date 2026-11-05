import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> showAlert(String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty || confirmController.text.isEmpty) {
      await showAlert('Preencha todos os campos.');
      return;
    }
    if (password != confirmController.text) {
      await showAlert('As senhas não conferem.');
      return;
    }
    if (password.length < 6) {
      await showAlert('A senha deve ter pelo menos 6 caracteres.');
      return;
    }

    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // AuthPage acompanha authStateChanges e exibirá a Home após o pop.
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        'email-already-in-use' => 'Já existe uma conta com esse email.',
        'weak-password' => 'Escolha uma senha mais forte.',
        'invalid-email' => 'Digite um email válido.',
        'network-request-failed' => 'Falha de conexão. Verifique sua internet.',
        _ => 'Não foi possível cadastrar. Tente novamente.',
      };
      await showAlert(message);
    } catch (_) {
      await showAlert('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Crie sua conta'),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const Icon(Icons.person_add_alt_1_rounded,
                      size: 74, color: Color(0xFF8B83FF)),
                  const SizedBox(height: 20),
                  const Text('Comece agora',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Senha (mínimo 6 caracteres)',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: confirmController,
                    hintText: 'Confirmar senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: register,
                    text: 'Criar conta',
                    icon: Icons.person_add_alt,
                    isLoading: loading,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
