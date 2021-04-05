class Chart {
  List<String> labels;
  List<Data> data;

  Chart fromJson(Map<String, dynamic> json) {
    labels = (json['labels'] as List)?.map((e) => e as String)?.toList();
    data = (json['data'] as List)?.map((e) {
      return Data().fromJson(e);
    })?.toList();
    return this;
  }
}

class Data {
  List<num> values;

  Data fromJson(List<dynamic> json) {
    values = json.map((e) => e as num)?.toList();
    return this;
  }
}
