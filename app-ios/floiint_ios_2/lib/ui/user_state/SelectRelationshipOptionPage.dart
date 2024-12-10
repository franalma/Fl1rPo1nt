import 'package:app/model/UserInterest.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:flutter/material.dart';

class SelectRelationshipOptionPage extends StatefulWidget {
  final List<RelationShip> _listRelationship;

  SelectRelationshipOptionPage(this._listRelationship);

  @override
  State<SelectRelationshipOptionPage> createState() {
    return _SelectRelationshipOptionPage();
  }
}

class _SelectRelationshipOptionPage extends State<SelectRelationshipOptionPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleAppBar(),
      ),
      body: ListView.builder(
          itemCount: widget._listRelationship.length,
          itemBuilder: (context, index) {
            int color = CommonUtils.colorToInt(widget._listRelationship[index].color);
            return Column(
              children: [
                ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Container(color: Color(color)),
                    ),
                    title: Text(widget._listRelationship[index].value),
                    onTap: () {
                      NavigatorApp.popWith(context, widget._listRelationship[index]);
                    }),
                const Divider()
              ],
            );
          }),
    );
  }
}
