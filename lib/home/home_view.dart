import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_typeadapter/home/home_viewmodel.dart';
import 'package:hive_typeadapter/model/data_model.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title: Text("Flutter Hive Demo"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) => model.filtered(value),
              itemBuilder: (BuildContext context) {
                return ["All", "Compeleted", "Progress"].map((option) {
                  return PopupMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: model.dataBox.listenable(),
                builder: (context, Box<DataModel> items, _) {
                  List<int> keys = model.getKeys(items);
                  return ListView.separated(
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: keys.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final DataModel data = items.get(key)!;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.blueGrey[200],
                        child: ListTile(
                          title: Text(
                            data.title,
                            style: TextStyle(fontSize: 22, color: Colors.black),
                          ),
                          subtitle: Text(data.description,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black38)),
                          leading: Text(
                            "$key",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          trailing: Icon(
                            Icons.check,
                            color: data.complete
                                ? Colors.deepPurpleAccent
                                : Colors.red,
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                    backgroundColor: Colors.white,
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            color: Colors.blueAccent[100],
                                            child: Text(
                                              "Mark as complete",
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                            onPressed: () {
                                              model.updateDataModel(
                                                  key: key,
                                                  title: data.title,
                                                  description: data.description,
                                                  complete: true);
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                    )));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                      backgroundColor: Colors.blueGrey[100],
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(hintText: "Title"),
                              controller: titleController,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextField(
                              decoration:
                                  InputDecoration(hintText: "Description"),
                              controller: descriptionController,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.red,
                              child: Text(
                                "Add Data",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                model.addToDataModel(
                                    title: titleController.text,
                                    description: descriptionController.text);
                                titleController.clear();
                                descriptionController.clear();
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ));
                });
          },
          child: Icon(Icons.add),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
