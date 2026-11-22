import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/auth_tab.dart';
import 'package:flutter_aplication_cafe/Compounent/gold_button.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_logo.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_textfield.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_toast.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ZestifyColors.bg,
          gradient: RadialGradient(
            center: Alignment(-0.6, -0.2),
            radius: 1.2,
            colors: [Color(0x14D4AF37), ZestifyColors.bg],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                  decoration: BoxDecoration(
                    color: ZestifyColors.surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: const Color(0xFF222222)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xCC000000),
                        blurRadius: 60,
                        offset: Offset(0, 30),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const ZestifyLogo(),
                      const SizedBox(height: 8),
                      const Text(
                        'Premium Coffee & Fine Dining · Member VIP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Obx(
                        () => AuthTab(
                          modeLogin: controller.modeLogin.value,
                          onChanged: controller.gantiMode,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: controller.modeLogin.value
                              ? _FormLogin(controller: controller)
                              : _FormDaftar(controller: controller),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String teks;
  final String link;
  final VoidCallback onTap;

  const _FooterLink({
    required this.teks,
    required this.link,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          teks,
          style: const TextStyle(color: Color(0xFF777777), fontSize: 13),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: ZestifyColors.gold,
            padding: const EdgeInsets.symmetric(horizontal: 6),
          ),
          child: Text(link, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _FormLogin extends StatelessWidget {
  final AuthController controller;

  const _FormLogin({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(
          () => ZestifyTextField(
            label: 'Alamat Email',
            hintText: 'contoh@email.com',
            controller: controller.loginEmailController,
            keyboardType: TextInputType.emailAddress,
            errorText: controller.errLoginEmail.value,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ZestifyTextField(
            label: 'Kata Sandi',
            hintText: 'Minimal 6 karakter',
            controller: controller.loginPassController,
            obscureText: controller.sembunyikanLoginPass.value,
            onToggleObscure: controller.sembunyikanLoginPass.toggle,
            errorText: controller.errLoginPass.value,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => controller.login(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => showZestifyToast(
              'Hubungi Customer Service untuk reset kata sandi.',
              icon: Icons.support_agent,
            ),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF888888)),
            child: const Text('Lupa kata sandi?', style: TextStyle(fontSize: 13)),
          ),
        ),
        const SizedBox(height: 4),
        GoldButton(
          label: 'Masuk Sekarang',
          icon: Icons.login,
          onPressed: controller.login,
        ),
        const SizedBox(height: 12),
        _FooterLink(
          teks: 'Belum punya akun?',
          link: 'Daftar di sini',
          onTap: () => controller.gantiMode(false),
        ),
      ],
    );
  }
}

class _FormDaftar extends StatelessWidget {
  final AuthController controller;

  const _FormDaftar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('daftar'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(
          () => ZestifyTextField(
            label: 'Nama Lengkap',
            hintText: 'Nama Anda',
            controller: controller.daftarNamaController,
            errorText: controller.errDaftarNama.value,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ZestifyTextField(
            label: 'Alamat Email',
            hintText: 'contoh@email.com',
            controller: controller.daftarEmailController,
            keyboardType: TextInputType.emailAddress,
            errorText: controller.errDaftarEmail.value,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ZestifyTextField(
            label: 'Kata Sandi',
            hintText: 'Minimal 6 karakter',
            controller: controller.daftarPassController,
            obscureText: controller.sembunyikanDaftarPass.value,
            onToggleObscure: controller.sembunyikanDaftarPass.toggle,
            errorText: controller.errDaftarPass.value,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => ZestifyTextField(
            label: 'Konfirmasi Kata Sandi',
            hintText: 'Ulangi kata sandi',
            controller: controller.daftarKonfirmasiController,
            obscureText: controller.sembunyikanKonfirmasi.value,
            onToggleObscure: controller.sembunyikanKonfirmasi.toggle,
            errorText: controller.errDaftarKonfirmasi.value,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => controller.daftar(),
          ),
        ),
        const SizedBox(height: 22),
        GoldButton(
          label: 'Buat Akun',
          icon: Icons.person_add_alt_1,
          onPressed: controller.daftar,
        ),
        const SizedBox(height: 12),
        _FooterLink(
          teks: 'Sudah punya akun?',
          link: 'Masuk di sini',
          onTap: () => controller.gantiMode(true),
        ),
      ],
    );
  }
}
