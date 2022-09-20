import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mystock/components/customSnackbar.dart';
import 'package:mystock/components/externalDir.dart';
import 'package:mystock/components/globalData.dart';
import 'package:mystock/components/network_connectivity.dart';
import 'package:mystock/model/branchModel.dart';
import 'package:mystock/model/itemcategroy.dart';
import 'package:mystock/model/productListModel.dart';
import 'package:mystock/model/registrationModel.dart';
import 'package:mystock/model/transactionModel.dart';
import 'package:mystock/screen/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends ChangeNotifier {
  String? fromDate;
  bool isVisible = false;
  bool isProdLoading = false;
  bool isSearch = false;
  String? todate;
  String urlgolabl = Globaldata.apiglobal;
  bool isLoading = false;
  bool isListLoading = false;

  bool qtyerror = false;
  bool stocktransferselected = false;
  String? branch_id;
  String? staff_name;
  String? branch_name;
  String? branch_prefix;
  String? user_id;

  String? menu_index;
  List<Map<String, dynamic>> menuList = [];
  List<Map<String, dynamic>> searchList = [];

  List<Map<String, dynamic>> infoList = [];
  List<Map<String, dynamic>> stockList = [];

  // String urlgolabl = Globaldata.apiglobal;
  bool filter = false;
  double? totalPrice;
  String? priceval;
  List<bool> errorClicked = [];
  List<TextEditingController> qty = [];

  String? cartCount;

  List<Map<String, dynamic>> productList = [];
  List<Map<String, dynamic>> bagList = [];

  List<BranchModel> branchist = [];
  List<TransactionTypeModel> transactionist = [];

  List<ItemCategoryModel> itemCategoryList = [];

  List<Map<String, dynamic>> filteredproductList = [];

  List<String> productbar = [];
  List<String> filteredproductbar = [];

  int? qtyinc;

  List<CD> c_d = [];

  List<String> uniquelist = [];
  List<String> filtereduniquelist = [];

  ///////////////////////////////////////////////////////////////////////

  getItemCategory(BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          Uri url = Uri.parse("$urlgolabl/category_list.php");

          // isDownloaded = true;
          isLoading = true;
          // notifyListeners();

          http.Response response = await http.post(
            url,
          );

          // print("body ${body}");
          ItemCategoryModel itemCategory;
          List map = jsonDecode(response.body);
          productList.clear();
          productbar.clear();
          itemCategoryList.clear();
          for (var item in map) {
            itemCategory = ItemCategoryModel.fromJson(item);
            itemCategoryList.add(itemCategory);
          }

          isLoading = false;
          notifyListeners();
          return itemCategoryList;
          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////////////
  getBranchList(BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          BranchModel brnachModel = BranchModel();
          Uri url = Uri.parse("$urlgolabl/branch_list.php");
          // Map body = {
          //   'cid': cid,
          // };
          // print("compny----${cid}");
          // isDownloaded = true;
          isLoading = true;
          // notifyListeners();

          http.Response response = await http.post(
            url,
            // body: body,
          );

          // print("body ${body}");
          var map = jsonDecode(response.body);
          print("branchlist-----$map");
          branchist.clear();
          // productbar.clear();
          for (var item in map) {
            brnachModel = BranchModel.fromJson(item);
            branchist.add(brnachModel);
          }

          isLoading = false;
          notifyListeners();
          return branchist;
          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////////////
  getTransactionList(BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          BranchModel brnachModel = BranchModel();
          Uri url = Uri.parse("$urlgolabl/transaction_type.php");
          // Map body = {
          //   'cid': cid,
          // };

          // isDownloaded = true;
          isLoading = true;
          // notifyListeners();

          http.Response response = await http.post(
            url,
            // body: body,
          );
          var map = jsonDecode(response.body);
          print("transaction map----$map");
          TransactionTypeModel transactionTypeModel;
          transactionist.clear();

          for (var item in map) {
            transactionTypeModel = TransactionTypeModel.fromJson(item);
            transactionist.add(transactionTypeModel);
          }

          isLoading = false;
          notifyListeners();

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  //////////////////////////////////////////////////////////////////////
  addDeletebagItem(String itemId, String srate1, String srate2, String qty,
      String event, String cart_id, BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          branch_id = prefs.getString("branch_id");
          user_id = prefs.getString("user_id");
          print("kjn---------------$branch_id----$user_id-");
          Uri url = Uri.parse("$urlgolabl/save_cart.php");
          Map body = {
            'staff_id': user_id,
            'branch_id': branch_id,
            'item_id': itemId,
            'qty': qty,
            'event': event,
            'cart_id': cart_id
          };
          print("body-----$body");
          isLoading = true;
          notifyListeners();

          http.Response response = await http.post(
            url,
            body: body,
          );

          var map = jsonDecode(response.body);
          print("delete response-----------------$map");

          isLoading = false;
          notifyListeners();

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  //////////////////////////////////////////////////////////////////////
  getbagData1(BuildContext context) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          branch_id = prefs.getString("branch_id");
          user_id = prefs.getString("user_id");
          print("kjn---------------$branch_id----$user_id-");
          Uri url = Uri.parse("$urlgolabl/cart_list.php");
          Map body = {
            'staff_id': user_id,
            'branch_id': branch_id,
          };
          print("cart body-----$body");

          isLoading = true;
          notifyListeners();

          http.Response response = await http.post(
            url,
            body: body,
          );

          var map = jsonDecode(response.body);
          print("cart response-----------------${map}");
          isLoading = false;
          notifyListeners();
          ProductListModel productListModel;
          bagList.clear();
          if (map != null) {
            for (var item in map) {
              productListModel = ProductListModel.fromJson(item);
              bagList.add(item);
            }
          }
          print("bag list data........${bagList.length}");
          // isLoading = false;
          notifyListeners();

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print("error...$e");
          // return null;
          return [];
        }
      }
    });
  }

// //////////////////////////////////////////////
  saveCartDetails(
    BuildContext context,
    String transid,
    String to_branch_id,
    String remark,
  ) async {
    List<Map<String, dynamic>> jsonResult = [];
    Map<String, dynamic> itemmap = {};
    Map<String, dynamic> resultmmap = {};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    branch_id = prefs.getString("branch_id");
    user_id = prefs.getString("user_id");

    print(
        "datas------$transid---$to_branch_id----$remark------$branch_id----$user_id");
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        print("bagList-----$bagList");
        Uri url = Uri.parse("$urlgolabl/cart_list.php");
        for (var item in bagList) {
          itemmap["item_id"] = item["item_id"];
          itemmap["qty"] = item["qty"];
          itemmap["s_rate_1"] = item["s_rate_1"];
          itemmap["s_rate_2"] = item["s_rate_2"];
          jsonResult.add(itemmap);
        }
        Map masterMap = {
          "trans_id": transid,
          "to_branch_id": to_branch_id,
          "remark": remark,
          "staff_id": user_id,
          "branch_id": branch_id
        };
        resultmmap["master"] = masterMap;
        resultmmap["details"] = jsonResult;

        var jsonBody = jsonEncode(resultmmap);
        print("resultmap----$jsonBody");

        http.Response response = await http.post(
          url,
          // body: {'om': jsonBody},
        );
      }
    });
  }

////////////////////////////////////////////////////////////////////////
  getinfoList(BuildContext context, String itemId) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          branch_id = prefs.getString("branch_id");

          Uri url = Uri.parse("$urlgolabl/item_search_stock.php");
          Map body = {
            'item_id': itemId,
            'branch_id': branch_id,
          };
          print("cart bag body-----$body");
          // isDownloaded = true;
          isListLoading = true;
          notifyListeners();

          http.Response response = await http.post(
            url,
            body: body,
          );
          var map = jsonDecode(response.body);
          print("item_search_stock bag response-----------------$map");

          isListLoading = false;
          notifyListeners();
          // ProductListModel productListModel;
          if (map != null) {
            infoList.clear();
            for (var item in map["item_info"]) {
              infoList.add(item);
            }
            stockList.clear();
            for (var item in map["Stock_info"]) {
              stockList.add(item);
            }
          }

          print("infoList---$infoList----$stockList");
          notifyListeners();

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

  //////////////////////////////////////////////////////////////////////
  searchItem(BuildContext context, String itemName) async {
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          print("value-----$itemName");

          Uri url = Uri.parse("$urlgolabl/search_products_list.php");
          Map body = {
            'item_name': itemName,
          };
          print("body-----$body");
          // isDownloaded = true;
          isLoading = true;
          // notifyListeners();

          http.Response response = await http.post(
            url,
            body: body,
          );
          var map = jsonDecode(response.body);
          print("item_search_s------$map");
          searchList.clear();
          for (var item in map) {
            searchList.add(item);
          }

          isLoading = false;
          notifyListeners();

          /////////////// insert into local db /////////////////////
        } catch (e) {
          print(e);
          // return null;
          return [];
        }
      }
    });
  }

/////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getProductDetails() async {
    // print("sid.......$branchid........${sid}");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      branch_id = prefs.getString("branch_id");
      staff_name = prefs.getString("staff_name");
      branch_name = prefs.getString("branch_name");
      branch_prefix = prefs.getString("branch_prefix");
      user_id = prefs.getString("user_id");
      print("kjn---------------$branch_id----$user_id-");
      Uri url = Uri.parse("$urlgolabl/products_list.php");

      Map body = {'staff_id': user_id, 'branch_id': branch_id};
      print("body----${body}");
      // isDownloaded = true;
      isProdLoading = true;
      notifyListeners();

      http.Response response = await http.post(
        url,
        body: body,
      );

      isProdLoading = false;
      notifyListeners();

      print("body ${body}");
      var map = jsonDecode(response.body);

      print("nmnmkzd-------${map["product_list"].length}");
      productList.clear();
      productbar.clear();

      cartCount = map["cart_count"].toString();

      notifyListeners();
      // print("map["product_list"]")
      for (var pro in map["product_list"]) {
        print("pro------$pro");
        productbar.add(pro["item_name"][0]);
        productList.add(pro);
      }
      qty =
          List.generate(productList.length, (index) => TextEditingController());
      errorClicked = List.generate(productList.length, (index) => false);

      print("qty------$qty");

      for (int i = 0; i < productList.length; i++) {
        print("qty------${productList[i]["qty"]}");
        qty[i].text = productList[i]["qty"].toString();
      }
      notifyListeners();
      var seen = Set<String>();
      uniquelist =
          productbar.where((productbar) => seen.add(productbar)).toList();
      uniquelist.sort();
      print("productDetailsTable--map ${productList.length}");
      print("productbar--map ${uniquelist}");

      return productList;
      /////////////// insert into local db /////////////////////
    } catch (e) {
      print(e);
      // return null;
      return [];
    }
  }

  ///////////////////////////////////////////////////////
  filterProduct(String selected) {
    print("productzszscList----$productList");
    isLoading = true;
    filteredproductList.clear();
    filteredproductbar.clear();
    for (var item in productList) {
      if (item["cat_id"] == selected) {
        filteredproductbar.add(item["item_name"][0]);
        filteredproductList.add(item);
      }
    }

    isLoading = false;
    print("filsfns----$filteredproductList");
    notifyListeners();
  }

////////////////////////////////////////////////////////////////////
  setbardata() {
    filter = true;
    isLoading = true;
    notifyListeners();
    print("filterdeproductbar---$filteredproductbar");
    var seen = Set<String>();
    filtereduniquelist.clear();
    filtereduniquelist =
        filteredproductbar.where((productbar) => seen.add(productbar)).toList();
    filtereduniquelist.sort();
    notifyListeners();

    print("filtereduniquelist-----$filtereduniquelist");
    isLoading = false;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////
  uploadImage(filepath, context) async {
    final String uploadUrl = 'https://api.imgur.com/3/upload';
    NetConnection.networkConnection(context).then((value) async {
      if (value == true) {
        try {
          var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
          request.files
              .add(await http.MultipartFile.fromPath('image', filepath));
          var res = await request.send();
          print("res.reasonPhrase------${res.reasonPhrase}");
          return res.reasonPhrase!;
        } catch (e) {
          print(e);
        }
      }
    });
  }

  setfilter(bool fff) {
    print("filter----$filter");
    filter = fff;
    notifyListeners();
  }

  setQty(int qty) {
    qtyinc = qty;
    print("qty.......$qty");
    // notifyListeners();
  }

  setAmt(
    String price,
  ) {
    totalPrice = double.parse(price);
    priceval = double.parse(price).toStringAsFixed(2);
    // notifyListeners();
  }

  qtyDecrement() {
    // returnqty = true;
    qtyinc = qtyinc! - 1;
    print("qty-----$qtyinc");
    notifyListeners();
  }

  qtyIncrement() {
    qtyinc = 1 + qtyinc!;
    print("qty increment-----$qtyinc");
    notifyListeners();
  }

  totalCalculation(double rate) {
    totalPrice = rate * qtyinc!;
    priceval = totalPrice!.toStringAsFixed(2);
    print("total pri-----$totalPrice");
    notifyListeners();
  }

  seterrorClicked(bool apply, int index) {
    errorClicked[index] = apply;
    notifyListeners();
  }
  /////////////////////////////////////////////////////////
  // uploadBagData(
  //     String cid, BuildContext context, int? index, String page) async {
  //   List<Map<String, dynamic>> resultQuery = [];
  //   List<Map<String, dynamic>> om = [];
  //   var result;

  //   // var result = await OrderAppDB.instance.selectMasterTable();
  //   print("output------$result");
  //   if (result.length > 0) {
  //     // isUpload = true;
  //     notifyListeners();
  //     String jsonE = jsonEncode(result);
  //     var jsonDe = jsonDecode(jsonE);
  //     print("jsonDe--${jsonDe}");
  //     for (var item in jsonDe) {
  //       resultQuery = await OrderAppDB.instance.selectDetailTable(item["oid"]);
  //       item["od"] = resultQuery;
  //       om.add(item);
  //     }
  //     if (om.length > 0) {
  //       print("entede");
  //       saveOrderDetails(cid, om, context);
  //     }
  //     isUpload = false;
  //     if (page == "upload page") {
  //       isUp[index!] = true;
  //     }

  //     notifyListeners();
  //     print("om----$om");
  //   } else {
  //     isUp[index!] = false;
  //     notifyListeners();
  //     snackbar.showSnackbar(context, "Nothing to upload!!!", "");
  //   }

  //   notifyListeners();
  // }

  setstockTranserselected(bool value) {
    stocktransferselected = value;
    notifyListeners();
  }

  userDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? staff_nam = prefs.getString("staff_name");
    String? branch_nam = prefs.getString("branch_name");

    staff_name = staff_nam;
    branch_name = branch_nam;
    notifyListeners();
  }

  setqtyErrormsg(bool qtyerrormsg) {
    qtyerror = qtyerrormsg;
    notifyListeners();
  }

  setDate(String date1, String date2) {
    fromDate = date1;
    todate = date2;
    print("gtyy----$fromDate----$todate");
    notifyListeners();
  }

  setIssearch(bool isSrach) {
    isSearch = isSrach;
    notifyListeners();
  }
}
