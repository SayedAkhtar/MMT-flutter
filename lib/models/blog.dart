class Blog {
  int? id;
  String? date;
  String? link;
  String? title;
  String? content;
  String? excerpt;
  String? thumbnail;
  bool? status;

  Blog(
      {this.id,
        this.date,
        this.link,
        this.title,
        this.content,
        this.excerpt,
        this.thumbnail});

  Blog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']['rendered'];
    content = json['content']['rendered'];
    thumbnail = json['fimg_url'].runtimeType == String ? json['fimg_url'] : '';
    excerpt = json['excerpt']['rendered'];
    link = json['link']?? "";
    date = json['date'] ?? "";
    status = json['status'] == 'publish' ? true : false;
  }

  DateTime getFormattedDate(){
    return DateTime.parse(date!);
  }
}

