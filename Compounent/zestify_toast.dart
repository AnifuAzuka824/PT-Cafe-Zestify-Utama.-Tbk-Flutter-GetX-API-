import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/theme.dart';

void showZestifyToast(String message, {IconData icon = Icons.check_circle}) {
  Get.closeAllSnackbars();
  Get.rawSnackbar(
    messageText: Text(
      message,
      style: const TextStyle(color: ZestifyColors.text, fontSize: 14),
    ),
    icon: Icon(icon, color: ZestifyColors.gold),
    backgroundColor: ZestifyColors.card,
    borderColor: ZestifyColors.gold.withValues(alpha: 0.4),
    borderWidth: 1,
    borderRadius: 16,
    margin: const EdgeInsets.all(16),
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(milliseconds: 3200),
  );
}
