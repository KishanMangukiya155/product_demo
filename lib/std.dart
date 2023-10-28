import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_demo/std_model.dart';

class Std extends StatelessWidget {
  Std({super.key});
  var std_collection = FirebaseFirestore.instance.collection('students');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("CrossX"),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          centerTitle: true,
          backgroundColor: Colors.pink),
      body: StreamBuilder(
        stream: std_collection.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) {
              var data = snapshot.data?.docs[index].data();
              return ListTile(
                leading: CircleAvatar(),
                title: Text("${data!['full_name']}"),
                subtitle: Text(
                  "${data!['email']}",
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text("${data!['course']['name']}"),
              );
            },
            itemCount: snapshot.data?.docs.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => addNewStudent(context), child: Icon(Icons.add)),
    );
  }

  void addNewStudent(BuildContext context) {
    var data = StdModel(
            fullName: "Beladiya Kenil Ashokbhai",
            address: "107,sarita sagar soc.,chikuwadi,varachha,Surat",
            mobile: "+91 7990478573",
            parentMobile: "+91 9998888531",
            email: "beladiyakeni70@gmail.com",
            dob: "06/05/2003",
            eduction: [
              Eduction(
                  qualification: "12",
                  university: "H.S.C board",
                  passingYear: 2020,
                  per: 60)
            ],
            course:
                Course(name: "Flutter", duration: "8-month", totalFees: 65000))
        .toJson();

    std_collection.doc('cx23022').set(data).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("added...!")));
    });
  }
}
