import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lennyfacekeyboard/widgets/appbar.dart';
import 'package:lennyfacekeyboard/models/category.dart';
import 'package:lennyfacekeyboard/models/emoji.dart';
import 'package:lennyfacekeyboard/screens/home/widgets.dart';
import 'package:lennyfacekeyboard/utils/file.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Category> _categories = Categories.all();
  List<Emoji> _emojis = List<Emoji>();
  final List<String> _customCategories = ['recent', 'custom'];
  Category _selectedCategory;
  final fileHelper = FileHelper();

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories[0];
  }

  _floatingButtonPressed() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AddEmojiDialog()).then((value) {
      if (value != null) {
        fileHelper.saveToCustom(value);
        setState(() {});
      }
    });
  }

  SnackBar _snackbar(String text, MaterialColor color) {
    return SnackBar(
      content: Text(text),
      backgroundColor: color,
      duration: Duration(milliseconds: 300),
    );
  }

  _onCategoryChanged(dynamic category) {
    _selectedCategory = category;
    setState(() {});
  }

  Widget _list() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) return Text("Error Occurred");
        //show progress bar on loading
        if (snapshot.connectionState == ConnectionState.waiting)
          return CenterProgressIndicator();
        //show text if no data
        if (snapshot.connectionState == ConnectionState.none &&
            !snapshot.hasData) return Text('No emoji');

        return ListView.builder(
            key: ObjectKey(_selectedCategory.id),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  //save to clipboard
                  Clipboard.setData(
                      new ClipboardData(text: snapshot.data[index].text));
                  //save to recent file
                  fileHelper.saveToRecent(snapshot.data[index].text);

                  Scaffold.of(context).showSnackBar(_snackbar(
                      snapshot.data[index].text + ' copied!', Colors.green));
                },
                trailing: _customCategories.contains(_selectedCategory.id)
                    ? ButtonTheme(
                        minWidth: 8,
                        child: FlatButton(
                            onPressed: () {
                              //delete emoji
                              fileHelper.delete(_selectedCategory.id,
                                  snapshot.data[index].text).then((value) {
                                setState(() {});
                                Scaffold.of(context).showSnackBar(_snackbar(
                                    snapshot.data[index].text + ' deleted!',
                                    Colors.red));
                              });

                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            )))
                    : null,
                title: Card(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(snapshot.data[index].text,
                                  overflow: TextOverflow.fade, softWrap: true),
                            )
                          ],
                        ))),
              );
            });
      },
      future: fileHelper.loadEmojiAsList(_selectedCategory.id),
      initialData: List<Emoji>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingButtonPressed,
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CategoryDropdown(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onChanged: _onCategoryChanged,
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: _list(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }
}
