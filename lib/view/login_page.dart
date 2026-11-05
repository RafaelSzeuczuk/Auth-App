import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/social_button.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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

  String authMessage(String code) => switch (code) {
        'invalid-credential' || 'user-not-found' || 'wrong-password' =>
          'Email ou senha incorretos.',
        'invalid-email' => 'Digite um email válido.',
        'too-many-requests' => 'Muitas tentativas. Aguarde e tente novamente.',
        'network-request-failed' => 'Falha de conexão. Verifique sua internet.',
        _ => 'Não foi possível concluir. Tente novamente.',
      };

  Future<void> signIn() async {
    final email = emailController.text.trim();
    if (email.isEmpty || passwordController.text.isEmpty) {
      await showAlert('Preencha o email e a senha.');
      return;
    }
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      await showAlert(authMessage(e.code));
    } catch (_) {
      await showAlert('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      await showAlert('Digite seu email primeiro.');
      return;
    }
    setState(() => loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      await showAlert('Se houver uma conta para este email, enviaremos um link de redefinição.');
    } on FirebaseAuthException catch (e) {
      await showAlert(authMessage(e.code));
    } catch (_) {
      await showAlert('Não foi possível enviar o email. Tente novamente.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.75, end: 1),
                    duration: const Duration(milliseconds: 650),
                    builder: (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                    child: Lottie.asset(
                      'assets/animations/Animacao_Login.json',
                      width: 170,
                      height: 140,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Entre para continuar',
                      style: TextStyle(color: Colors.white.withOpacity(.65))),
                  const SizedBox(height: 28),
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
                    hintText: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: TextButton(
                        onPressed: loading ? null : forgotPassword,
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ),
                  ),
                  MyButton(
                    onTap: signIn,
                    text: 'Entrar',
                    icon: Icons.login,
                    isLoading: loading,
                  ),
                  const SizedBox(height: 24),
                  Text('ou continue com',
                      style: TextStyle(color: Colors.white.withOpacity(.65))),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        SocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onTap: () => showAlert('Login social não está integrado nesta versão.'),
                        ),
                        const SizedBox(width: 12),
                        SocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onTap: () => showAlert('Login social não está integrado nesta versão.'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () => Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const RegisterPage(),
                              ),
                            ),
                    child: const Text('Não tem uma conta? Registre-se agora'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
