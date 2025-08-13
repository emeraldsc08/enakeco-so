import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../styles/app_styles.dart';

enum ButtonType { primary, secondary, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(AppConstants.white),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppConstants.paddingSmall),
              ],
              Text(text),
            ],
          );

    switch (type) {
      case ButtonType.primary:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: AppStyles.primaryButtonStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(
                isLoading
                    ? const Color(AppConstants.primaryRed).withOpacity(0.6)
                    : const Color(AppConstants.primaryRed),
              ),
            ),
            child: buttonChild,
          ),
        );

      case ButtonType.secondary:
        return SizedBox(
          width: width,
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: AppStyles.secondaryButtonStyle,
            child: buttonChild,
          ),
        );

      case ButtonType.text:
        return SizedBox(
          width: width,
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: AppStyles.textButtonStyle,
            child: buttonChild,
          ),
        );
    }
  }
}
