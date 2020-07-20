import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_app/employee.dart';
import 'package:sqlite_app/db_helper.dart';

class DBPage extends StatefulWidget {
  @override
  _DBPageState createState() => _DBPageState();
}

class _DBPageState extends State<DBPage> {
  TextEditingController controller = new TextEditingController();
  String name;
  int curUserId;
  final formKey = new GlobalKey<FormState>();
  DBHelper dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    isUpdating = false;
  }

  clearName() {
    controller.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Employee e = new Employee(curUserId, name);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = new Employee(null, name);
        dbHelper.save(e);
      }
      clearName();
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('DELETE'),
          ),
        ],
        rows: employees
            .map(
              (e) => DataRow(
                cells: [
                  DataCell(
                    Text(e.name),
                    onTap: () {
                      setState(
                        () {
                          isUpdating = true;
                          curUserId = e.id;
                        },
                      );
                      controller.text = e.name;
                    },
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dbHelper.delete(e.id);
                      },
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: dbHelper.getEmployees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text('No Data Found');
          }
          return Text('Loading');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dbHelper = Provider.of<DBHelper>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('DB Example'),
      ),
      body: Column(
        children: [
          form(),
          list(),
        ],
      ),
    );
  }
}
