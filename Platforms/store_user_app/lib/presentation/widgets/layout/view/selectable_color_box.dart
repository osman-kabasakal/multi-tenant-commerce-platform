import 'package:flutter/material.dart';
import 'package:store_user_app/core/constants/colors.dart';

class SelectableColorBox extends StatelessWidget {
  const SelectableColorBox({
    super.key,
    required this.valueState,
    required this.onChanged,
    required this.colorSquaresRgb,
    this.selected = false,
    this.value,
    this.disabled = false,
    required this.selectedDesicion,
  });

  final ValueNotifier valueState;
  final void Function(bool selected) onChanged;
  final String colorSquaresRgb;
  final bool selected;
  final dynamic value;
  final bool disabled;
  final bool Function(dynamic value) selectedDesicion;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: valueState,
        builder: (context, state, child) {
          return Container(
              padding: selectedDesicion(value)
                  ? EdgeInsets.all(5)
                  : EdgeInsets.all(5),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(textFieldRadius),
                border: Border.all(
                  color: selectedDesicion(value)
                      ? colorPrimaryContainer
                      : Colors.grey,
                  width: 1,
                ),
                color: selectedDesicion(value)
                    ? colorPrimaryContainer.withValues(alpha: 0.5)
                    : Colors.white,
              ),
              child: InkWell(
                onTap: disabled
                    ? null
                    : () {
                        onChanged(!selectedDesicion(value));
                        // valueState.value = value;
                      },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                        '0xFF${colorSquaresRgb.replaceAll('#', '')}')),
                    border: Border.all(
                      color: Colors.grey,
                      width: selectedDesicion(value) ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ));
        });
  }
}
