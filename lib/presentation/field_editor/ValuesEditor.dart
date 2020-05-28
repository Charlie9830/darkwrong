import 'package:flutter/material.dart';

class ValuesEditor extends StatelessWidget {
  const ValuesEditor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: DropdownButton(
            onChanged: (_) {},
            items: [
              DropdownMenuItem(
                child: Text('Instrument Type'),
              )
            ],
          ),
        ),
        Card(child: Text('Value Editor')),
        Expanded(
            child: Card(
          child: ListView(
              children: List<Widget>.generate(
                  20, (index) => ListTile(title: Text('Value ${index + 1}')))),
        ))
      ],
    );
  }
}
