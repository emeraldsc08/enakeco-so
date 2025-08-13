import 'package:intl/intl.dart';

class NumberHelper {
  static String formatCurrency(double amount, {String currency = 'IDR'}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: currency == 'IDR' ? 'Rp ' : currency,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatNumber(double number, {int decimalDigits = 0}) {
    final formatter = NumberFormat('#,##0${decimalDigits > 0 ? '.${'0' * decimalDigits}' : ''}');
    return formatter.format(number);
  }

  static String formatPercentage(double value, {int decimalDigits = 1}) {
    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}');
    return '${formatter.format(value)}%';
  }

  static String formatCompactNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length == 11 && digits.startsWith('08')) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7, 9)} ${digits.substring(9)}';
    } else if (digits.length == 12 && digits.startsWith('628')) {
      return '+62 ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8, 10)} ${digits.substring(10)}';
    } else if (digits.length == 13 && digits.startsWith('628')) {
      return '+62 ${digits.substring(2, 5)} ${digits.substring(5, 8)} ${digits.substring(8, 11)} ${digits.substring(11)}';
    }

    return phoneNumber;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 10 && digits.length <= 13;
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static String maskCreditCard(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '${'*' * (cardNumber.length - 4)}${cardNumber.substring(cardNumber.length - 4)}';
  }

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    final maskedUsername = '${username.substring(0, 2)}${'*' * (username.length - 2)}';
    return '$maskedUsername@$domain';
  }
}