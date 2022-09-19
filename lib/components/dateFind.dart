import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mystock/components/commonColor.dart';
import 'package:mystock/controller/controller.dart';

import 'package:provider/provider.dart';

class DateFind {
  DateTime currentDate = DateTime.now();
  // String? formattedDate;
  String? fromDate;
  String? toDate;
  String? crntDateFormat;
  String? specialField;
  String? gen_condition;

  Future selectDateFind(BuildContext context, String dateType) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(currentDate.year + 1),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light()
                    .copyWith(primary: P_Settings.loginPagetheme),
              ),
              child: child!);
        });
    if (pickedDate != null) {
      // setState(() {
      currentDate = pickedDate;
      // });
    } else {
      print("please select date");
    }

    if (dateType == "from date") {
      print("curnt date----$currentDate");
      fromDate = DateFormat('yyyy-MM-dd').format(currentDate);
    }

    if (dateType == "to date") {
      toDate = DateFormat('yyyy-MM-dd').format(currentDate);
    }


    print("fromdate-----$fromDate---$toDate");
    // Provider.of<Controller>(context, listen: false).fromDate=fromDate;
    if (fromDate != null && toDate!=null) {
      Provider.of<Controller>(context, listen: false).setDate(fromDate!, toDate!);
    }
    toDate = toDate == null
        ? Provider.of<Controller>(context, listen: false).todate.toString()
        : toDate.toString();
  }
}