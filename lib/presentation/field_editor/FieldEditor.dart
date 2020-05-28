import 'package:flutter/material.dart';

class FieldEditor extends StatelessWidget {
  const FieldEditor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _AddFieldControl(),
        )),
        Expanded(
          child: Card(
            child: ListView(
              children: List<Widget>.generate(
                  15,
                  (index) => ListTile(
                        title: Text('Field ${index + 1}'),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Short Name'),
                            Text('DataType'),
                          ],
                        ),
                      trailing: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return <PopupMenuEntry>[
                            PopupMenuItem(
                              child: Text('View values'),
                            ),
                            PopupMenuItem(
                              child: Text('Edit'),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem(
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),)),
            ),
          ),
        )
      ],
    );
  }
}

class _AddFieldControl extends StatefulWidget {
  @override
  __AddFieldControlState createState() => __AddFieldControlState();
}

class __AddFieldControlState extends State<_AddFieldControl> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Field Name'),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: TextField(
              decoration: InputDecoration(
                hintText: 'Short name'
              ),
            )),
            Container(width: 16),
            DropdownButton(
              isDense: true,
              onChanged: (_) {},
              items: [
                DropdownMenuItem(
                  child: Text('Text'),
                ),
                DropdownMenuItem(
                  child: Text('Number'),
                ),
                DropdownMenuItem(
                  child: Text('DMX Address'),
                ),
                DropdownMenuItem(
                  child: Text('Color'),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                child: Text('Add'),
                onPressed: () {},
              )
            ],
          ),
        )
      ],
    );
  }
}
