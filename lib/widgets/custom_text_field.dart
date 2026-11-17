import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxlines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxlines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Textfiel desenha um campo editaval na interface
    return TextField(
      controller: controller, // conectat com o campo controller
      maxLines: maxlines, // aplica a quantidade de lnha
      decoration: InputDecoration(
        labelText: label, // mostra o nome do campo
        border: const OutlineInputBorder(), // Bordas Visíveis
      ),
    );
  }
}