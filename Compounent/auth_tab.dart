import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class AuthTab extends StatelessWidget {
  final bool modeLogin;
  final ValueChanged<bool> onChanged;

  const AuthTab({super.key, required this.modeLogin, required this.onChanged});

  Widget _tab(String label, bool aktif, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: aktif ? ZestifyColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: aktif ? ZestifyColors.bg : const Color(0xFF777777),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ZestifyColors.bg,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF1E1E1E)),
      ),
      child: Row(
        children: [
          _tab('Masuk', modeLogin, () => onChanged(true)),
          _tab('Daftar', !modeLogin, () => onChanged(false)),
        ],
      ),
    );
  }
}
