import 'package:flutter/material.dart';
import 'package:itunesmoviessearch/components/search.dart'; 
import 'package:itunesmoviessearch/model/data.dart';
import 'package:itunesmoviessearch/view_detail/index.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'style.dart';
import 'dart:math';
import 'dart:convert';
import 'package:itunesmoviessearch/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';


class SearchView extends StatefulWidget {
  @override
  SearchViewState createState() => new SearchViewState(flag: true,list: new  List<MovieListData>());
}

class SearchViewState extends State<SearchView> {
  SearchViewState({this.flag,this.list});
  
  var list =  new  List<MovieListData>();
  bool search = false;
  double resizeContainer = 1.0;
  int count;
  int itemCount = 99;
  PageController controller;
  static int currentPage;
  bool flag = true;
  TextEditingController searchControl = new TextEditingController();


  //function to load JSON data from URL (Itunes) and update local json asset
  newData(String url) async{
    list.clear(); //clear the list first before populating new list
    var response = await http.get(url, headers: {"Accept": "application/json"});

    if(response.statusCode == 200){ //if returns successfully
      String responseBody = response.body;
      var jsonBody = json.decode(responseBody);

      //iterate data from results and put into our list
      for(var data in jsonBody['results']){
        list.add(new MovieListData.fromMap(data));
      }
      
      writeJsonFile(responseBody); //write json to file

    }else{
      print("error");
    }

    setState(() {}); //refresh to render the changes of data into the screen.
  }

  //loads local asset json file
  loadData() async {
    try {
      final file = await _localFile; //get file in app local directory

      
    if(await file.exists()){  //if file does not exist then request for new data instead

      file.readAsString().then((String jsonString) { //check if 
         final jsonBody = json.decode(jsonString);
          for(var data in jsonBody['results']){
           list.add(new MovieListData.fromMap(data));
          }
        setState(() {});
      });
      
    }else{
      newData("https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie");
    }
    

    } catch (e) { //backup request instead something goes wrong
      newData("https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie");
    }
  }

  //writes json data into file
  writeJsonFile(String json) async {
    try{
      
    final file = await _localFile;

    //delete the old file first
    File.fromUri(Uri.file(file.path)).delete().then((e){
      print("file succesfully deleted");
    }
    );

   // Write the file
   file.writeAsString(json)
    .then((File file) {
      print("file successfully created");
    }); 

    } catch (e) { 
      print("error");
    }
    
  }

  //get local path for files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  //get local file. in our case its always movies.json
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/'+globals.filename);
  }

 navigate(id, list) {
    if(id!=''){
      globals.movieInfo = list; //set the movie info to be viewed on detail page
    }
    Navigator.of(context).push(new PageRouteBuilder(
          pageBuilder: (_, __, ___) => new ViewDetail(id: id), //opens the detail page
        ));
  }

  @override
  initState() {
    super.initState();
   loadData(); //load data at the start
    flag = true;
    count = list.length;
    currentPage = 0;
    
    controller = new PageController(
      initialPage: currentPage,
      keepPage: true,
      viewportFraction: 0.8,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
     
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
        decoration: decoration,
        child: new Container(
          margin: const EdgeInsets.only(top: 25.0),
          width: screenSize.width,
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //creates a search button if search is not flag true. else it enables typing to search bar

                  search
                      ? new Expanded(
                          child: new Search(
                            changeSearch: (data) {
                              //do nothing while user is typing
                            }, 
                            submitSearch: (data) {
                              if (data == '') 
                              //if there is nothing typed then revert back to search icon
                                setState(() {
                                  search = false;
                                });
                              else {
                                //load new data based on what the user typed
                                newData("https://itunes.apple.com/search?term=$data&amp;country=au&amp;media=movie");

                                setState(() { }); //refresh the page to show changes
                              }
                            },
                          ),
                        )
                      :  new SearchButton(
                          pressed: () => setState(() {
                                search = true;
                              }),
                          ),

                ],
              ),
              new Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 25.0),
                child: new Text(
                  'iTunes Search',
                  style: title,
                ),
              ),
              new Container( // this is where the group list is populated
                height: (screenSize.height / 1.4),
                child: _buildPageView(context,list), //call a function to populate the list
              )
            ],
          ),
        ),
      ),
    );
    

  }

  
//build the page using the sent list
 Widget _buildPageView(BuildContext context, List<MovieListData> snapshot) {
   itemCount=snapshot.length;
   list = snapshot;
     return PageView.builder(
        controller: controller,
        itemCount: itemCount,
        onPageChanged: (i) => setState(() {
          currentPage = i;
        }),
       itemBuilder: (context, index) => builder(index,snapshot[index]) //build the page individually
        );
   }

  //create the individual list items 
  builder(int index, MovieListData data) {
    final _page = data;

    return new AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value;
        if (flag == false && controller != null)
          value = controller.page - index;
        if (index == currentPage - 1 && flag) value = 1.0;
        if (index == currentPage && flag) value = 0.0;
        if (index == currentPage + 1 && flag) {
          value = 1.0;
          flag = false;
        }
        
        value = (1 - (value.abs() * .2)).clamp(0.0, 1.0);
        
        return new InkWell(
          onTap: () { //triggers when list item is clicked and opens the detail page
            globals.movieInfo = _page; //saves the current item selected to open up in the detail view
            Navigator.pushNamed(context, "/detail");
          },
          child: new Opacity(
            opacity: pow(value, 4),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: new Container(
                    height: value * 250,
                    width: value * 900,
                    decoration: new BoxDecoration(shape: BoxShape.rectangle, color: Colors.white12),
                    alignment: Alignment.center,
                    //add our artwork image here
                    child: new CachedNetworkImage( //cachednetworkimage is used to save artwork into cache for persistence
                             //change artwork to bigger size because 100x100 is too small
                            imageUrl: _page.artworkUrl100.replaceAll(new RegExp(r'100x100'), '250x250'), 
                            //loading indicator as placeholder
                            placeholder: (context, url) => new CircularProgressIndicator(),
                            //error image when image fails to load
                            errorWidget: (context, url, error) => new Image(image: new AssetImage("err_image.jpg"))
                            ),
                  ),
                ),
                 new Center(
                        child: new Container(
                          height: value * 150.0,
                          width: value * 900,
                          color: Colors.white54,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              //shows the current list item/total list size
                              new Text(
                                '${(currentPage.toInt()%itemCount)+1}/$itemCount',
                                style: subTitle,
                              ),

  
                              //check values for null and print placeholder values if true

                              _page.trackName != null ?
                              new Text(
                                _page.trackName,
                                style: cardTitle,
                                textAlign: TextAlign.center,
                              )
                              : new Text(
                                "",
                                style: cardTitle
                              ),

                               _page.collectionName != null ?
                               new Text(
                                "Collection: "+_page.collectionName,
                                style: subTitle
                              ) 
                              : new Text("Collection: none",
                                  style: subTitle
                                  ),

                              _page.primaryGenreName != null ?
                              new Text(
                                "Genre: "+_page.primaryGenreName,
                                style: subTitle
                                  )
                              : new Text(
                                "Genre: None",
                                style: subTitle
                                  ),

                              _page.trackPrice != null ?
                              new Text(
                                "Price: \$"+_page.trackPrice.toString(),
                                style: subTitle
                                  )
                              : new Text(
                                "Price: None",
                                style: subTitle
                                  )

                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  
  }
  
}
