//create data object
class MovieListData {
  String trackName;
  String artworkUrl100;
  String longDescription;
  String kind;
  String collectionName;
  double trackPrice;
  double collectionPrice;
  String primaryGenreName;
  int trackId;

  //initialize values, this is the constructor
  MovieListData( 
      {this.trackName,
      this.artworkUrl100,
      this.longDescription,
      this.trackPrice,
      this.collectionName,
      this.primaryGenreName,
      this.collectionPrice,
      this.trackId,
      this.kind
      });

      //load data from map
 MovieListData.fromMap(Map<String, dynamic> map)
     : trackId = map['trackId'],
       trackName = map['trackName'],
       collectionName = map['collectionName'],
       artworkUrl100 = map['artworkUrl100'],
       longDescription = map['longDescription'],
       kind = map['kind'],
       trackPrice = map['trackPrice'],
       collectionPrice = map['collectionPrice'],
       primaryGenreName = map['primaryGenreName'];
     
 @override
 String toString() => "MovieListData<$trackId:$trackName:$trackPrice>";
}