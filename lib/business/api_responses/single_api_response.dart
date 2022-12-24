/// jsonrpc : "2.0"
/// id : "02edf1afe361e6a2fd00a085c642edae3a1d02c1"
/// result : 9311

class SingleApiResponse {
  SingleApiResponse({
    String? jsonrpc,
    String? id,
    dynamic? result,
  }) {
    _jsonrpc = jsonrpc;
    _id = id;
    _result = result;
  }

  SingleApiResponse.fromJson(dynamic json) {
    _jsonrpc = json['jsonrpc'];
    _id = json['id'];
    _result = json['result'];
  }

  String? _jsonrpc;
  String? _id;
  dynamic? _result;

  SingleApiResponse copyWith({
    String? jsonrpc,
    String? id,
    dynamic? result,
  }) =>
      SingleApiResponse(
        jsonrpc: jsonrpc ?? _jsonrpc,
        id: id ?? _id,
        result: result ?? _result,
      );

  String? get jsonrpc => _jsonrpc;

  String? get id => _id;

  dynamic? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jsonrpc'] = _jsonrpc;
    map['id'] = _id;
    map['result'] = _result;
    return map;
  }
}
