import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;  // Ajout d'un état pour le chargement

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;  // Affiche le loader
      });

      try {
        // Essayer de se connecter avec l'email et le mot de passe
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Si la connexion réussit, afficher un message et rediriger vers la page d'accueil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connexion réussie ! Bienvenue ${credential.user?.email}")),
        );

        // Naviguer vers l'écran d'accueil après la connexion
        Navigator.pushReplacementNamed(context, '/home');

      } on FirebaseAuthException catch (e) {
        String errorMessage = "Erreur inconnue";
        if (e.code == 'user-not-found') {
          errorMessage = "Aucun utilisateur trouvé pour cet email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Mot de passe incorrect.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;  // Cache le loader
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              _isLoading
                  ? CircularProgressIndicator() // Affiche un loader si en attente
                  : ElevatedButton(
                      onPressed: _signIn,
                      child: Text('Se connecter'),
                    ),
              SizedBox(height: 16),
              // Message avec un lien vers l'inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Vous n'avez pas de compte ? "),
                  GestureDetector(
                    onTap: () {
                      // Rediriger vers la page d'inscription
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
