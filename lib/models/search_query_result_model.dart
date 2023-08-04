class SearchQueryResult {
  List<Result>? list;
  SearchQueryResult({this.list});

  SearchQueryResult.fromJson(List<dynamic> json) {
    if(json.isNotEmpty){
      list = <Result>[];
      json.forEach((element) {
        list?.add(Result.fromJson(element));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['list'] = list;
  //   return data;
  // }
}

class Result {
  int? id;
  String name = "";

  Result({this.id, required this.name});

  Result.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
  }

  @override
  String toString() => name;
}
