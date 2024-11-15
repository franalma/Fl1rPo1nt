import 'package:flutter/material.dart';

class ListContactsPage extends StatefulWidget {
  @override
  State<ListContactsPage> createState() {
    return _ListContactsPage();
  }
}

class _ListContactsPage extends State<ListContactsPage> {
  bool _isLoading = true; 

  @override
  void initState() {  
    super.initState();
    _fetchFromHost(); 
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void>_fetchFromHost() async{

  }
}
