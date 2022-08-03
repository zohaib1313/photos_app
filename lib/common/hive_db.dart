/*
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;

class HiveDb {
  static Box<dynamic>? _box;

  static Future<void> init() async {
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    _box ??= await Hive.openBox('MyBoxWeather');
  }

  static Future<int?> clearDb() async {
    await _box?.flush();
    return await _box?.clear();
  }

  static Future<void> addWeatherToBox(CustomWeatherInfoModel infoModel) async {
    String s = jsonEncode(infoModel.toMap());
    return _box?.put(infoModel.id, s);
  }

  static Future<CustomWeatherInfoModel?> getWeatherFromBox(
      {required String id}) async {
    String? s = await _box?.get(id);
    if (s != null) {
      Map<String, dynamic> map = jsonDecode(s);
      return CustomWeatherInfoModel.fromMap(map);
    }
    return null;
  }

  static Future<List<CustomWeatherInfoModel>?> getListOfBoxWeather() async {
    List<CustomWeatherInfoModel>? list = [];
    print(_box?.values.length.toString());
    for (var s in _box?.values ?? []) {
      if (s != null) {
        Map<String, dynamic> map = jsonDecode(s);
        list.add(CustomWeatherInfoModel.fromMap(map));
      }
    }

    return list;
  }
}
*/
