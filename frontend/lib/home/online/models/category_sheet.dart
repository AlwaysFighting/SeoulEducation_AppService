import 'package:flutter/material.dart';

class CategorySheet extends StatefulWidget {
  const CategorySheet({Key? key}) : super(key: key);

  @override
  _CategorySheetState createState() => _CategorySheetState();
}

class _CategorySheetState extends State<CategorySheet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Select Category'),
          onPressed: () async {
            final result = await showModalBottomSheet<String>(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('All'),
                        onTap: () => Navigator.of(context).pop('All'),
                      ),
                      ListTile(
                        title: const Text('Category 1'),
                        onTap: () => Navigator.of(context).pop('Category 1'),
                      ),
                      ListTile(
                        title: const Text('Category 2'),
                        onTap: () => Navigator.of(context).pop('Category 2'),
                      ),
                    ],
                  ),
                );
              },
            );
            if (result != null) {
              setState(() {
              });
            }
          },
        ),
      ),
    );
  }
}
