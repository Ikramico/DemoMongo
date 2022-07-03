import 'package:demomongo/DB/mongodb.dart';
import 'package:demomongo/data.dart';
import 'package:demomongo/model.dart';
import 'package:flutter/material.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: MongoDB.getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
               else {var totalData = snapshot.data.length;
                  if(totalData>0){
                     print('Total Data' + totalData.toString());
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return displayCard(
                          Model.fromJson(snapshot.data[index]),
                        );
                      },
                      
                    ),
                  );
                  
                //  else {
                //   return Center(
                //     child: Column(
                //       children: [
                //         Text('No Data AVailable'),
                //         ElevatedButton(
                //             onPressed: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (context) => InsertData(),
                //                   ));
                //             },
                //             child: Text('Insert data'))
                //       ],
                //     ),
                //   );
                // }

                } else {
                  return Center(
                    child: Column(
                      children: [
                        Text('No Data AVailable'),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InsertData(),
                                  ));
                            },
                            child: Text('Insert data'))
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget displayCard(Model data) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${data.id}'),
                SizedBox(
                  height: 5,
                ),
                Text('${data.name}'),
                SizedBox(
                  height: 5,
                ),
                Text('${data.email}'),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text('${data.about}'),
                  // width: 300,
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return InsertData();
                          },
                          settings: RouteSettings(arguments: data)))
                  .then((value) => {setState(() {})});
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              print(data.id);
              await MongoDB.delete(data);
              setState(() {});
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
