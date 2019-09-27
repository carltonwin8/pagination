class Photo {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({this.id, this.title, this.url, this.thumbnailUrl, this.albumId});

  Photo.fromJson(Map json)
      : id = json["id"],
        albumId = json["albumId"],
        title = json["title"],
        url = json["url"],
        thumbnailUrl = json["thumbnailUrl"];
}
