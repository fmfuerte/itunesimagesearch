import 'package:flutter/material.dart';
import 'style.dart';
/*
Constructor of the text fields used in the detail page
*/

class AddEditCard extends StatelessWidget {
  final bool enable;
  final String initialValue;
  final String title;
  final FocusNode focus;
  final TextEditingController val;
  final int lines;

  AddEditCard(
    {this.enable, this.initialValue, this.title, this.focus, this.val,this.lines}
    );

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new InkWell(
      onTap: () {
        if (focus != null) {
          if (enable) FocusScope.of(context).requestFocus(focus);
        } else {
          print('focus true');
        }
      },
      child: new Container(
          decoration: (title != 'Repeat' ? border : null),
          padding: new EdgeInsets.only(
              left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: new Text(title, style: titleStyle),
              ),
              new Container(
                width: screenSize.width / 1.55,
                child: new TextFormField(
                  enabled: enable,
                  controller: val,
                  decoration: inputDecoration,
                  focusNode: focus,
                  maxLines: lines,
                ),
              ),
            ],
          )),
    );
  }
}

class PicCard extends StatelessWidget {
  final List<dynamic> list;
  final bool enable;
  final String title;

  PicCard({this.enable, this.title, this.list});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Container(
        decoration: border,
        padding:
            new EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: new Text(title, style: titleStyle),
            ),
            new Container(
              width: screenSize.width / 2.4,
              height: 40.0,
              child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                    top: 0.0,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, int index) {
                    return new Container(
                        width: 40.0,
                        height: 40.0,
                        margin: const EdgeInsets.only(left: 10.0),
                        decoration: decoratePic(list[index]));
                  }),
            )
          ],
        ));
  }
}
