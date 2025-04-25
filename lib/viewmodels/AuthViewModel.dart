import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _user != null;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    // Escuchar cambios de autenticación
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> checkAuthState() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  // Iniciar sesión con email y contraseña
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getMessageFromErrorCode(e.code);
      notifyListeners();
      return false;
    }
  }

  // Registrar nuevo usuario
  Future<bool> registerWithEmailAndPassword(String email, String password, String name, String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Crear el perfil de usuario en Firestore
        await _firestore.collection("usuarios").doc(userCredential.user!.uid).set({
          "uid": userCredential.user!.uid,
          "email": email,
          "nombre": name,
          "telefono": phone,
          "provider": "EMAIL",
          "createdAt": Timestamp.now().millisecondsSinceEpoch
        });

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = "No se pudo crear el usuario";
        notifyListeners();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getMessageFromErrorCode(e.code);
      notifyListeners();
      return false;
    }
  }

// Método autenticación con Google
  Future<bool> signInWithGoogle() async {
    try {
      // Paso 1: Forzar cierre de sesión previo
      await _googleSignIn.signOut();

      // Paso 2: Autenticar con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      // Paso 3: Obtener tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Paso 4: Crear credencial de Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Paso 5: Autenticar en Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) throw Exception("Usuario de Firebase nulo");

      // Paso 6: Crear/Actualizar usuario en Firestore
      await _firestore.collection("usuarios").doc(user.uid).set({
        "uid": user.uid,
        "email": user.email,
        "provider": "GOOGLE",
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return true;
    } catch (e, stack) {
      print("‼️ Error crítico: $e\nStacktrace: $stack");
      await _auth.signOut();
      await _googleSignIn.signOut();
      return false;
    }
  }

  // Actualizar el teléfono del usuario
  Future<bool> updateUserPhone(String phone) async {
    if (_user == null) {
      _errorMessage = "No hay usuario autenticado";
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection("usuarios").doc(_user!.uid).update({
        "telefono": phone
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error al actualizar el teléfono: ${e.toString()}";
      notifyListeners();
      return false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _googleSignIn.signOut();
      await _auth.signOut();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error al cerrar sesión: ${e.toString()}";
      notifyListeners();
    }
  }

  // Restablecer contraseña
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getMessageFromErrorCode(e.code);
      notifyListeners();
      return false;
    }
  }

  // Obtener mensaje de error en español
  String _getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "invalid-email":
        return "El correo electrónico no es válido";
      case "user-disabled":
        return "Esta cuenta de usuario ha sido deshabilitada";
      case "user-not-found":
        return "No existe un usuario con este correo electrónico";
      case "wrong-password":
        return "La contraseña es incorrecta";
      case "email-already-in-use":
        return "Ya existe una cuenta con este correo electrónico";
      case "operation-not-allowed":
        return "Operación no permitida";
      case "weak-password":
        return "La contraseña es demasiado débil";
      case "too-many-requests":
        return "Demasiados intentos fallidos. Inténtalo más tarde";
      default:
        return "Ha ocurrido un error. Inténtalo de nuevo";
    }
  }
}