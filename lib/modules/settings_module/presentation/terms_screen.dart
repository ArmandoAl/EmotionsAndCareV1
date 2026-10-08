// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_spacing.dart';

class TermsScreen extends StatefulWidget {
  final String terms;
  const TermsScreen({super.key, required this.terms});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y condiciones'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ListView(
          children: [
            Text(
              widget.terms != null ? widget.terms.replaceAll('|', '\n') : '',
              textAlign: TextAlign.justify,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.shadowWarm),
            ),
          ],
        ),
      ),
    );
  }
}
