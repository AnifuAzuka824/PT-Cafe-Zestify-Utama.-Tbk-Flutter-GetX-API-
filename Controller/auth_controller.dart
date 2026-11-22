import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_toast.dart';
import 'package:flutter_aplication_cafe/Models/user_model.dart';
import 'package:flutter_aplication_cafe/admin_config.dart';
import 'package:flutter_aplication_cafe/routes.dart';

class AuthController extends GetxController {
  static const String _usersKey = 'zestifyUsers';
  static const String _sessionKey = 'zestifyUser';
  static final RegExp _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final GetStorage _box = GetStorage();

  final RxBool modeLogin = true.obs;
  final Rxn<UserModel> userAktif = Rxn<UserModel>();

  final loginEmailController = TextEditingController();
  final loginPassController = TextEditingController();
  final RxBool sembunyikanLoginPass = true.obs;
  final RxnString errLoginEmail = RxnString();
  final RxnString errLoginPass = RxnString();

  final daftarNamaController = TextEditingController();
  final daftarEmailController = TextEditingController();
  final daftarPassController = TextEditingController();
  final daftarKonfirmasiController = TextEditingController();
  final RxBool sembunyikanDaftarPass = true.obs;
  final RxBool sembunyikanKonfirmasi = true.obs;
  final RxnString errDaftarNama = RxnString();
  final RxnString errDaftarEmail = RxnString();
  final RxnString errDaftarPass = RxnString();
  final RxnString errDaftarKonfirmasi = RxnString();

  bool get isLoggedIn => userAktif.value != null;

  bool get isAdmin {
    final user = userAktif.value;
    return user != null &&
        user.email == AdminConfig.email &&
        user.passwordHash == AdminConfig.passwordHash;
  }

  @override
  void onInit() {
    super.onInit();
    final String? emailSesi = _box.read<String>(_sessionKey);
    if (emailSesi != null) {
      userAktif.value = _cariUser(emailSesi);
    }
  }

  List<UserModel> _loadUsers() {
    final List? raw = _box.read<List>(_usersKey);
    if (raw == null) return [];
    return raw
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void _saveUsers(List<UserModel> users) {
    _box.write(_usersKey, users.map((u) => u.toJson()).toList());
  }

  UserModel? _cariUser(String email) =>
      _loadUsers().firstWhereOrNull((u) => u.email == email);

  String _hash(String email, String password) =>
      sha256.convert(utf8.encode('$email:$password')).toString();

  void gantiMode(bool login) {
    modeLogin.value = login;
    _resetErrors();
  }

  void _resetErrors() {
    errLoginEmail.value = null;
    errLoginPass.value = null;
    errDaftarNama.value = null;
    errDaftarEmail.value = null;
    errDaftarPass.value = null;
    errDaftarKonfirmasi.value = null;
  }

  void login() {
    _resetErrors();
    final email = loginEmailController.text.trim().toLowerCase();
    final pass = loginPassController.text;

    if (!_emailRe.hasMatch(email)) {
      errLoginEmail.value = 'Format email tidak valid.';
    }
    if (pass.length < 6) {
      errLoginPass.value = 'Password minimal 6 karakter.';
    }
    if (errLoginEmail.value != null || errLoginPass.value != null) return;

    final kredensialAdmin =
        email == AdminConfig.email &&
        _hash(email, pass) == AdminConfig.passwordHash;
    if (email == AdminConfig.email && !kredensialAdmin) {
      showZestifyToast('Kata sandi salah.', icon: Icons.lock_outline);
      return;
    }
    var user = _cariUser(email);
    if (kredensialAdmin &&
        (user == null || user.passwordHash != _hash(email, pass))) {
      user = _sinkronAkunAdmin(user);
    }
    if (user == null) {
      showZestifyToast(
        'Email belum terdaftar. Silakan daftar terlebih dahulu.',
        icon: Icons.error_outline,
      );
      daftarEmailController.text = email;
      gantiMode(false);
      return;
    }
    if (user.passwordHash != _hash(email, pass)) {
      showZestifyToast('Kata sandi salah.', icon: Icons.lock_outline);
      return;
    }

    _masuk(user);
    showZestifyToast(
      'Selamat datang kembali, ${user.namaPanggilan}!',
      icon: Icons.verified_user,
    );
  }

  void daftar() {
    _resetErrors();
    final nama = daftarNamaController.text.trim();
    final email = daftarEmailController.text.trim().toLowerCase();
    final pass = daftarPassController.text;
    final konfirmasi = daftarKonfirmasiController.text;

    if (nama.isEmpty) errDaftarNama.value = 'Nama tidak boleh kosong.';
    if (!_emailRe.hasMatch(email)) {
      errDaftarEmail.value = 'Format email tidak valid.';
    }
    if (pass.length < 6) errDaftarPass.value = 'Password minimal 6 karakter.';
    if (pass != konfirmasi) {
      errDaftarKonfirmasi.value = 'Kata sandi tidak cocok.';
    }
    if (email == AdminConfig.email &&
        _hash(email, pass) != AdminConfig.passwordHash) {
      errDaftarEmail.value = 'Email ini khusus akun admin.';
    }
    if (errDaftarNama.value != null ||
        errDaftarEmail.value != null ||
        errDaftarPass.value != null ||
        errDaftarKonfirmasi.value != null) {
      return;
    }

    final users = _loadUsers();
    if (users.any((u) => u.email == email)) {
      showZestifyToast(
        'Email sudah terdaftar. Silakan masuk.',
        icon: Icons.error_outline,
      );
      loginEmailController.text = email;
      gantiMode(true);
      return;
    }

    final user = UserModel(
      nama: nama,
      email: email,
      passwordHash: _hash(email, pass),
    );
    users.add(user);
    _saveUsers(users);

    _masuk(user);
    showZestifyToast(
      'Akun berhasil dibuat! Selamat datang, ${user.namaPanggilan}',
      icon: Icons.celebration,
    );
  }

  // Menyamakan hash akun admin dengan AdminConfig, termasuk saat password diganti.
  UserModel _sinkronAkunAdmin(UserModel? lama) {
    final admin = UserModel(
      nama: lama?.nama ?? AdminConfig.namaDefault,
      email: AdminConfig.email,
      passwordHash: AdminConfig.passwordHash,
    );
    final users = _loadUsers()..removeWhere((u) => u.email == admin.email);
    _saveUsers(users..add(admin));
    return admin;
  }

  void _masuk(UserModel user) {
    userAktif.value = user;
    _box.write(_sessionKey, user.email);
    _kosongkanForm();
    Get.offAllNamed(Routes.mainmenu);
  }

  void logout() {
    userAktif.value = null;
    _box.remove(_sessionKey);
    modeLogin.value = true;
    Get.offAllNamed(Routes.login);
  }

  void _kosongkanForm() {
    for (final c in [
      loginEmailController,
      loginPassController,
      daftarNamaController,
      daftarEmailController,
      daftarPassController,
      daftarKonfirmasiController,
    ]) {
      c.clear();
    }
    _resetErrors();
  }
}
