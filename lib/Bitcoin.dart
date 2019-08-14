import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Bitcoin {
  double price;
  String type;

  Bitcoin(this.price, this.type);

  factory Bitcoin.fromJson(Map<String, dynamic> json) =>
      _$BitcoinFromJson(json);
  Map<String, dynamic> toJson() => _$BitcoinToJson(this);
}
