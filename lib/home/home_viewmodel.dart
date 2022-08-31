import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_typeadapter/model/data_model.dart';
import 'package:stacked/stacked.dart';

enum DataFilter { ALL, COMPLETED, PROGRESS }

const String dataBoxName = "data";

class HomeViewModel extends BaseViewModel {
  late Box<DataModel> dataBox;
  DataFilter filter = DataFilter.ALL;

  void initialize() {
    dataBox = Hive.box<DataModel>(dataBoxName);
    notifyListeners();
  }

  void filtered(value) {
    if (value.compareTo("All") == 0) {
      filter = DataFilter.ALL;
    } else if (value.compareTo("Compeleted") == 0) {
      filter = DataFilter.COMPLETED;
    } else {
      filter = DataFilter.PROGRESS;
    }
    notifyListeners();
  }

  List<int> getKeys(items) {
    if (filter == DataFilter.ALL) {
      return items.keys.cast<int>().toList();
    } else if (filter == DataFilter.COMPLETED) {
      return items.keys
          .cast<int>()
          .where((key) => items.get(key)!.complete)
          .toList();
    } else {
      return items.keys
          .cast<int>()
          .where((key) => !items.get(key)!.complete)
          .toList();
    }
  }

  void addToDataModel({required String title, required String description}) {
    DataModel data =
        DataModel(title: title, description: description, complete: false);
    dataBox.add(data);
  }

  void updateDataModel(
      {required int key, String? title, String? description, bool? complete}) {
    DataModel data = DataModel(
        title: title!, description: description!, complete: complete!);
    dataBox.put(key, data);
  }
}
