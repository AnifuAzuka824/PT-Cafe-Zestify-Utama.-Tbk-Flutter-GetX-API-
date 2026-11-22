import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class GoldButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: ZestifyColors.gold,
        foregroundColor: ZestifyColors.bg,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class GoldOutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool compact;

  const GoldOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: compact ? 15 : 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        minimumSize: Size.fromHeight(compact ? 36 : 48),
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 16),
        foregroundColor: ZestifyColors.gold,
        side: const BorderSide(color: ZestifyColors.gold, width: 1.5),
        shape: const StadiumBorder(),
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: compact ? 12 : 14,
        ),
      ),
    );
  }
}
