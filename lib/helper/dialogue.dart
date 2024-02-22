import 'package:flutter/material.dart';

class Dialogue {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String txt) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        txt,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.secondaryContainer
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
