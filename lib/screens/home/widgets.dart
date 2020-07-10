import 'package:flutter/material.dart';
import 'package:lennyfacekeyboard/models/category.dart';

class CategoryDropdown extends StatefulWidget {
  final List<Category> categories;
  final ValueChanged onChanged;
  final Category selectedCategory;

  const CategoryDropdown(
      {Key key, this.categories, this.onChanged, this.selectedCategory})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CategoryDropdownState();
  }
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Category>(
      value: widget.selectedCategory,
      isExpanded: true,
      items: widget.categories.map((e) {
        return DropdownMenuItem<Category>(
          value: e,
          child: Text(e.name),
        );
      }).toList(),
      onChanged: widget.onChanged,
      hint: Text(
        "Category",
      ),
    );
  }
}

class CenterProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
          ],
        ),
      ],
    );
  }
}

class AddEmojiDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add emoji'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Your emoji will be saved to User-Defined category"),
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Emoji'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, _controller.text);
                  },
                  color: Colors.blue,
                  child: Text("Save", style: TextStyle(color: Colors.white),)),
            ],
          )
        ],
      ),
    );
  }
}
