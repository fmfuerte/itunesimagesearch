import 'package:flutter/material.dart';
import 'package:itunesmoviessearch/components/custom_header.dart';
import 'package:itunesmoviessearch/components/add-edit/add_edit_card.dart';
import 'dart:async';
import 'package:itunesmoviessearch/globals.dart' as globals;
import 'package:cached_network_image/cached_network_image.dart';

class ViewDetail extends StatefulWidget {
  final String id;
  const ViewDetail({Key key, this.id}) : super(key: key);
  @override
  ViewDetailState createState() => new ViewDetailState(id: this.id);
}

class ViewDetailState extends State<ViewDetail> {
  ViewDetailState({this.id});

  FocusNode focus = new FocusNode();
  String id;
  String title;
  bool edit = false;
  bool hasimg = false;
  dynamic color = new Color.fromRGBO(0, 0, 0, 0.3);
  var _page =  globals.movieInfo;


  closeKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }


  @override
  initState() {
    super.initState();
      title = "Details";
      if(_page.artworkUrl100!=null) hasimg = true; //if artwork is not that then set hasimg to true
  }

 _exitApp(BuildContext context) {
     Navigator.of(context).pop(true);         
}

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () => _exitApp(context),
          child:

     new Stack(
      children: <Widget>[
        new Scaffold(
          primary: true,
          body: new Column(
            children: <Widget>[
              
              new CustomHeader(
                iconTL: new IconButton(
                  icon: new Icon(
                    Icons.clear,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    closeKeyboard();
                    new Timer(Duration(milliseconds: 100), () {
                  
                      Navigator.pop(context);
                    });
                  },
                ),
                iconTR: new Container(
                    padding: new EdgeInsets.only(right: 15.0),
                    child: new Container()
                    ), 

                title: title,
                subTitle: _page.kind !=null ? _page.kind : "",
                bg: 'assets/NewTaskBg1.png',
              ),
              
              new Expanded(
                child: new ListView(
                  key: ValueKey("listview"),
                  children: <Widget>[
                    new Column(
                      children: <Widget>[

                      //check if hasimg is set to true, if not is shows a placeholder asset image
                      hasimg ? 
                      new Center(
                        child: new Container(
                        height: 250,
                        width: 200,
                        decoration: new BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
                        child: new CachedNetworkImage(
                             //change artwork to bigger size because 100x100 is too small
                            imageUrl: _page.artworkUrl100.replaceAll(new RegExp(r'100x100'), '250x250'), 
                            //loading indicator as placeholder
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            //error icon when image fails to load
                            errorWidget: (context, url, error) => new Image(image: new AssetImage("err_image.jpg"))
                            )
                        ) 
                        
                      )
                      : Container( child: Image( image: AssetImage("err_image.jpg"))),

                      //creates a dummy purchase button 
                       new Center(
                        child: new Container(
                        alignment: Alignment.center,
                        child: new RaisedButton.icon(
                          label: Text("PURCHASE"),
                          color: Colors.lime,
                          icon: new Icon(Icons.local_offer),
                          onPressed: (){
                            print("purchased");
                          }
                          )
                        )
                        
                      ),

                        //add the details, editable has been set to false
                        //check for nulls then change to placeholder value if it is

                        new AddEditCard(
                            focus: focus,
                            enable: edit,
                            title: 'Title', 
                            val: new TextEditingController(text: _page.trackName  != null ? _page.trackName : "None"),
                            lines: _page.trackName  == null ? 1 : _page.trackName.length>42 ? 2 : 1, //if title is long make the field 2 lines
                            ),

                          new AddEditCard(
                          focus: focus,
                          enable: edit,
                          initialValue: _page.primaryGenreName != null ? _page.primaryGenreName : "None",
                          title: "Genre",
                          val: new TextEditingController(text: _page.primaryGenreName != null ? _page.primaryGenreName : "None"),
                          lines: 1
                        ),
                        
                         new AddEditCard(
                          focus: focus,
                          enable: edit,
                          initialValue: _page.collectionName != null ? _page.collectionName : "None",
                          title: "Collection",
                          val: new TextEditingController(text: _page.collectionName != null ? _page.collectionName : "None"),
                          lines:  _page.collectionName == null ? 1 : _page.collectionName.length>42 ? 2 : 1 //if collection is long make the field 2 lines
                        ),

                        
                         new AddEditCard(
                          focus: focus,
                          enable: edit,
                          initialValue: _page.trackPrice != null ?  "\$"+_page.trackPrice.toString() : "None",
                          title: "Price",
                          val: new TextEditingController(text: _page.trackPrice != null ?  "\$"+_page.trackPrice.toString() : "None"),
                          lines: 1
                        ),

                        new AddEditCard(
                          focus: focus,
                          enable: edit,
                          initialValue: _page.collectionPrice != null ?  "\$"+_page.collectionPrice.toString() : "None",
                          title: "Collection Price",
                          val: new TextEditingController(text: _page.collectionPrice != null ?  "\$"+_page.collectionPrice.toString() : "None"),
                          lines: 1
                        ),

                        new AddEditCard(
                          focus: focus,
                          enable: edit,
                          initialValue: _page.longDescription != null ? _page.longDescription : "No description",
                          title: "Description",
                          val: new TextEditingController(text: _page.longDescription != null ? _page.longDescription : "No description"),
                          lines: _page.longDescription == null ? 1 : //check length of description and adjust the lines accordingly
                                 _page.longDescription.length > 700 ? 24 :
                                 _page.longDescription.length > 600 ? 21 :
                                 _page.longDescription.length > 500 ? 18 : 
                                 _page.longDescription.length > 400 ? 14 :
                                 _page.longDescription.length > 300 ? 10 : 5,
                        ),

                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ), 
      ],
    )
    );


  }
}