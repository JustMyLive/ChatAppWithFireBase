import 'package:ChatAppWithFireBase/helper/util.dart';
import 'package:ChatAppWithFireBase/views/shareForUserList.dart';
import 'package:flutter/material.dart';

class Program extends StatefulWidget {
  @override
  _ProgramState createState() => _ProgramState();
}

class _ProgramState extends State<Program> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Program"),
      ),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              push(context, ShareForUserList(
                programId: "PR000026",
                programImage: "https://firebasestorage.googleapis.com/v0/b/russellmeapp-12181.appspot.com/o/images%2Fprogram%2Fsaketh-garuda-d1MFYeD01Lo-unsplash.jpg?alt=media&token=f88cb7cb-d92c-4a6d-831f-3150abbbba5a",
                programTitle: "プレゼン前の不安や緊張を和らげる",
              ));
              //CachedNetworkImageProvider(headerImageUrl)
            },
            child: Container(
              margin: EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Card(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text("This is $index Program, tap to share others"),
                  ),
                ),
              ),
            ),
          );
        }),
    );
  }
}
