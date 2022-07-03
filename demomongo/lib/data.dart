import 'package:demomongo/display.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import './DB/mongodb.dart';
import 'model.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  var NameController = new TextEditingController();
  var EmailController = new TextEditingController();
  var AboutController = new TextEditingController();
  var checkUpdate = 'Insert';
  late M.ObjectId id;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings!.arguments != null) {
      Model data = ModalRoute.of(context)!.settings!.arguments as Model;
      setState(() {
        id = data.id;
      });

      NameController.text = data.name;
      EmailController.text = data.email;
      AboutController.text = data.about;
      checkUpdate = 'update';
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                'Enter Data',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: NameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: EmailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: AboutController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(labelText: "About"),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        fakeData();
                      },
                      child: Text('Generate Data')),
                  ElevatedButton(
                      onPressed: () {
                        if (checkUpdate == 'update') {
                          _updateData(id, NameController.text,
                              EmailController.text, AboutController.text);
                        } else {
                          insertData(NameController.text, EmailController.text,
                              AboutController.text);
                          OutlinedButton(
                              onPressed: () {
                                fakeData();
                              },
                              child: Text('Generate Data'));
                        }
                      },
                      child: Text(checkUpdate)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayData(),
                            ));
                      },
                      child: Text('See all data'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateData(
      var id, String Name, String Email, String About) async {
    final updateData = Model(id: id, name: Name, email: Email, about: About);
    await MongoDB.update(updateData).whenComplete(() => Navigator.pop(context));
  }

  Future<void> insertData(String Name, String Email, String About) async {
    var _id = M.ObjectId();
    final data = Model(id: _id, name: Name, email: Email, about: About);
    var result = await MongoDB.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Inserted _id ' + _id.$oid)));
    clearAll();
  }

  void clearAll() {
    NameController.text = '';
    EmailController.text = '';
    AboutController.text = '';
  }

  void fakeData() {
    setState(() {
      NameController.text = faker.person.name();
      EmailController.text = faker.internet.email();
      AboutController.text = faker.lorem.sentence();
    });
  }
}
