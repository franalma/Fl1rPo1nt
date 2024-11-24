import 'package:app/model/UserInterest.dart';
import 'package:app/ui/utils/CommonUtils.dart';
import 'package:flutter/material.dart';

class SelectSexOptionPage extends StatefulWidget {
  List<SexAlternative> _listSex;

  SelectSexOptionPage(this._listSex);

  @override
  State<SelectSexOptionPage> createState() {
    return _SelectSexOptionPage();
  }
}

class _SelectSexOptionPage extends State<SelectSexOptionPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("building lisg ${widget._listSex.length}");
    return Container(
      child: ListView.builder(
          itemCount: widget._listSex.length,
          itemBuilder: (context, index) {
            int color = CommonUtils.colorToInt(widget._listSex[index].color);
            ListTile(
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Container(color: Color(color)),
                ),
                title: Text(widget._listSex[index].name));
          }),
    );
  }
}
