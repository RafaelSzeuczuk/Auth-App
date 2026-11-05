import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool signingOut = false;

  Future<void> signOut() async {
    setState(() => signingOut = true);
    try {
      await FirebaseAuth.instance.signOut();
      // AuthPage observa authStateChanges e volta para a tela de login.
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível sair. Tente novamente.')),
      );
    } finally {
      if (mounted) setState(() => signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'não informado';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: signingOut ? null : signOut,
            icon: signingOut
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Olá!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () {}, // Botão visual; funcionalidade será adicionada depois.
              icon: const Icon(Icons.person_outline),
              label: const Text('Meu perfil'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {}, // Botão visual; funcionalidade será adicionada depois.
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
