import 'package:flutter/material.dart';
class TodoItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function(bool?)? onChanged;
  
  const TodoItem({
    required this.text,
    required this.isSelected,
    required this.onChanged,
    super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 90/100,
        child: Card(

          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  Checkbox(value: isSelected, onChanged: onChanged),
                 SizedBox(width: 10,),
                 Text(text)
                ],
              ),
          ),
        ),
      ),
    );
  }
}