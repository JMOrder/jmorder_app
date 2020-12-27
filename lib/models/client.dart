import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:jmorder_app/models/item.dart';
import 'package:jmorder_app/services/jmo_api_service.dart';
import 'package:jmorder_app/utils/dependency_injector.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Client extends Equatable {
  final int id;
  final String name;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(defaultValue: [])
  final List<Item> items;

  Client({
    this.id,
    this.name,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);
  Map<String, dynamic> toJson() => _$ClientToJson(this);

  @override
  List<Object> get props => [id];

  Future<void> delete() async {
    await getIt<JmoApiService>().getClient().delete("/clients/$id");
  }

  Future<void> addItem(Item item) async {
    try {
      var response = await getIt<JmoApiService>().getClient().post(
            "/clients/$id/items",
            data: item.toJson(),
          );
      items.add(Item.fromJson(response.data));
    } on DioError {
      throw ItemAddFailedException();
    }
  }

  Future<void> editItem(Item item) async {
    try {
      var response = await getIt<JmoApiService>().getClient().put(
            "/clients/$id/items/${item.id}",
            data: item.toJson(),
          );
      final index = items.indexOf(item);
      items[index] = Item.fromJson(response.data);
    } on DioError {
      throw ItemEditFailedException();
    }
  }

  Future<void> deleteItem(Item item) async {
    try {
      await getIt<JmoApiService>()
          .getClient()
          .delete("/clients/$id/items/${item.id}");
      items.remove(item);
    } on DioError {
      throw ItemDeleteFailedException();
    }
  }
}

class ItemAddFailedException implements Exception {}

class ItemEditFailedException implements Exception {}

class ItemDeleteFailedException implements Exception {}
