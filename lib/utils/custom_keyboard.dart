import 'package:flutter/material.dart';
import 'package:unify_secret/utils/text_util.dart';

class NumericKeyboardView extends StatelessWidget {
  const NumericKeyboardView({super.key, required this.onTap});

  final Function(dynamic) onTap;

  static const numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9, ".", 0, "x"];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 3,
      childAspectRatio: 2.5,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(numberList.length, (index) {
        return InkWell(
            onTap: () => onTap(numberList[index]),
            child: Container(alignment: Alignment.center, child: TextAutoMetropolis(numberList[index].toString())));
      }),
    );
  }
}
