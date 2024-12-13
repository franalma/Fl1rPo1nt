import 'package:app/model/UserInterest.dart';
import 'package:app/ui/NavigatorApp.dart';
import 'package:app/ui/elements/FlexibleAppBar.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:flutter/material.dart';

class SelectSexOptionPage extends StatefulWidget {
  final List<SexAlternative> _listSex;

  SelectSexOptionPage(this._listSex);

  @override
  State<SelectSexOptionPage> createState() {
    return _SelectSexOptionPage();
  }
}

class _SelectSexOptionPage extends State<SelectSexOptionPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleAppBar(),
      ),
      body: ListView.builder(
          itemCount: widget._listSex.length,
          itemBuilder: (context, index) {
            int color = CommonUtils.colorToInt(widget._listSex[index].color);
            return Column(
              children: [
                ListTile(
                    leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Container(color: Color(color)),
                    ),
                    title: Text(widget._listSex[index].name),
                    onTap: () {
                      NavigatorApp.popWith(context, widget._listSex[index]);
                    }),
                const Divider()
              ],
            );
          }),
    );
  }
}
