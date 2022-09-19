import 'package:azlistview/azlistview.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mystock/components/commonColor.dart';
import 'package:mystock/components/infoBottomSheet.dart';
import 'package:mystock/components/modalBottomsheet.dart';
import 'package:mystock/controller/controller.dart';
import 'package:mystock/screen/alphabetScrollPage.dart';
import 'package:mystock/screen/bag/bag.dart';
import 'package:provider/provider.dart';

class ItemSelection extends StatefulWidget {
  List<Map<String, dynamic>> list;
  int transVal;

  ItemSelection({required this.list, required this.transVal});

  @override
  State<ItemSelection> createState() => _ItemSelectionState();
}

class _ItemSelectionState extends State<ItemSelection> {
  String? selected;
  List<_AZItem> items = [];
  List<String> uniqueList = [];
  Bottomsheet showsheet = Bottomsheet();
  InfoBottomsheet infoshowsheet = InfoBottomsheet();

  var itemstest = [
    'kg',
    'pcs',
  ];
  // List<String> items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("dgjxfkjgkg-----${widget.list}");
    initList(widget.list);
  }

/////////////////////////////////////
  void initList(List<Map<String, dynamic>> items) {
    print("cjncn----${items}");
    this.items = items
        .map(
          (item) => _AZItem(
            tag: item["item_name"][0].toUpperCase(),
            itemId: item["item_id"],
            catId: item["cat_id"],
            itemName: item["item_name"].toUpperCase(),
            batchCode: item["batch_code"],
            itemImg: item["item_img"],
            sRate1: item["s_rate_1"],
            sRate2: item["s_rate_2"],
            stock: item["stock"],
          ),
        )
        .toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  // void setBarData(List<Map<String, dynamic>> items) {
  //   print("cjncn----${items}");
  //   this.items = items
  //       .map(
  //         (item) => _AZItem(
  //           title: item["item"].toUpperCase(),
  //           tag: item["item"][0].toUpperCase(),
  //         ),
  //       )
  //       .toList();
  //   SuspensionUtil.sortListBySuspensionTag(this.items);
  //   SuspensionUtil.setShowSuspensionStatus(this.items);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: P_Settings.loginPagetheme,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Badge(
                animationType: BadgeAnimationType.scale,
                toAnimate: true,
                badgeColor: Colors.white,
                badgeContent: Consumer<Controller>(
                  builder: (context, value, child) {
                    if (value.cartCount == null) {
                      return SpinKitChasingDots(
                          color: P_Settings.buttonColor, size: 9);
                    } else {
                      return Text(
                        "${value.cartCount}",
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
                position: const BadgePosition(start: 33, bottom: 25),
                child: IconButton(
                  onPressed: () async {
                         Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BagPage()),
                  );
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 18.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       Provider.of<Controller>(context, listen: false)
            //           .getbagData(context);
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => BagPage()),
            //       );
            //     },
            //     child: Image.asset(
            //       "asset/shopping-cart.png",
            //       height: size.height * 0.05,
            //       width: size.width * 0.07,
            //     ),
            //   ),
            // ),

            // IconButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => BagPage()),
            //     );
            //   },
            //   icon: Icon(Icons.shopping_cart),
            // )
          ],
        ),
        // appBar: AppBar(
        //   leading: IconButton(
        //       onPressed: () {
        //         Provider.of<Controller>(context, listen: false)
        //             .setfilter(false);
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(Icons.arrow_back)),
        //   backgroundColor: P_Settings.loginPagetheme,
        // ),
        body: Consumer<Controller>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return SpinKitFadingCircle(
                color: P_Settings.loginPagetheme,
              );
            } else {
              return Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     "Select Item Category",
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                  // Divider(),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: P_Settings.loginPagetheme,
                          style: BorderStyle.solid,
                          width: 0.3),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selected,
                      // isDense: true,
                      hint: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Select Item Category"),
                      ),
                      // isExpanded: true,
                      autofocus: false,
                      underline: SizedBox(),
                      elevation: 0,
                      items: value.itemCategoryList
                          .map((item) => DropdownMenuItem<String>(
                              value: item.catId.toString(),
                              child: Container(
                                width: size.width * 0.9,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.catName.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              )))
                          .toList(),
                      onChanged: (item) {
                        print("clicked");
                        if (item != null) {
                          setState(() {
                            Provider.of<Controller>(context, listen: false)
                                .setfilter(true);
                            selected = item;
                          });

                          Provider.of<Controller>(context, listen: false)
                              .filterProduct(selected!);

                          initList(value.filteredproductList);

                          Provider.of<Controller>(context, listen: false)
                              .setbardata();
                          print("se;ected---$item");
                        }
                      },
                    ),
                  ),
                  Divider(),
                  Expanded(child: Consumer<Controller>(
                    builder: (context, value, child) {
                      print("value------${value.filter}");
                      return AzListView(
                        data: items,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          print("itemmmm------$item");
                          return buildListitem(item, size, index);
                        },
                        indexHintBuilder: (context, tag) {
                          return Container(
                            alignment: Alignment.center,
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.blue, shape: BoxShape.circle),
                            child: Text(
                              tag,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 50),
                            ),
                          );
                        },
                        indexBarMargin: EdgeInsets.all(10),
                        indexBarAlignment: Alignment.centerLeft,
                        indexBarItemHeight: 30,
                        indexBarData: value.filter
                            ? value.filtereduniquelist
                            : value.uniquelist,
                        indexBarOptions: IndexBarOptions(
                          needRebuild: true,
                          selectTextStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          selectItemDecoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          indexHintAlignment: Alignment.centerRight,
                          indexHintOffset: Offset(-20, 0),
                        ),
                      );
                    },
                  ))
                  // Expanded(
                  //   child: AlphabetScrollPage(
                  //       onClickedItem: (item) {
                  //         final snackbar = SnackBar(
                  //             content: Text(
                  //           "Clicked Item  $item",
                  //           style: TextStyle(fontSize: 20),
                  //         ));
                  //         ScaffoldMessenger.of(context)
                  //           ..removeCurrentSnackBar()
                  //           ..showSnackBar(snackbar);
                  //       },
                  //       items: value.filter
                  //           ? value.filteredproductList
                  //           : widget.list),
                  // ),
                ],
              );
            }
          },
        ));
  }

  Widget buildListitem(_AZItem item, Size size, int index) {
    // final tag = item.getSuspensionTag();
    final offStage = item.isShowSuspension;
    return Column(
      children: [
        // Offstage(offstage: offStage, child: buildHeader(tag)),
        Consumer<Controller>(
          builder: (context, value, child) {
            return Container(
              height: size.height * 0.07,
              margin: EdgeInsets.only(left: 40),
              child: ListTile(
                  trailing: value.applyClicked[index]
                      ? Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text(
                            value.qty[index].text,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            // Provider.of<Controller>(context, listen: false)
                            //     .addTobag(
                            //         item.itemId!,
                            //         double.parse(item.sRate1!),
                            //         double.parse(item.sRate2!),
                            //         double.parse(
                            //           value.qty[index].text,
                            //         ),
                            //         item.cartId!,
                            //         int.parse(item.event!),
                            //         context);
                            showsheet.showSheet(
                              context,
                              index,
                              item.itemId!,
                              item.catId!,
                              item.batchCode!,
                              item.itemName!,
                              item.itemImg!,
                              double.parse(item.sRate1!),
                              double.parse(item.sRate2!),
                              double.parse(item.stock!),
                              widget.transVal,
                            );
                          },
                          icon: Icon(
                            Icons.add,
                            size: 20,
                          )),
                  title: Text(item.itemName!,
                      style: GoogleFonts.aBeeZee(
                        textStyle: Theme.of(context).textTheme.bodyText2,
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: P_Settings.loginPagetheme,
                      )),
                  subtitle: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          width: size.width * 0.2,
                          child: Text("SR1:${item.sRate1}")),
                      Container(
                          width: size.width * 0.2,
                          child: Text("SR2:${item.sRate1}")),
                      Container(
                          width: size.width * 0.2,
                          child: Text("Stock:${item.stock}")),
                      GestureDetector(
                        onTap: () {
                          infoshowsheet.showInfoSheet(
                            context,
                            index,
                            item.itemId!,
                            item.catId!,
                            item.batchCode!,
                            item.itemName!,
                            item.itemImg!,
                            double.parse(item.sRate1!),
                            double.parse(item.sRate2!),
                            double.parse(item.stock!),
                            widget.transVal,
                          );
                        },
                        child: Icon(
                          Icons.info,
                          size: 19,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    // print("c--------------------${item.title.toString()}----${item.index.toString()}");
                    showsheet.showSheet(
                      context,
                      index,
                      item.itemId!,
                      item.catId!,
                      item.batchCode!,
                      item.itemName!,
                      item.itemImg!,
                      double.parse(item.sRate1!),
                      double.parse(item.sRate2!),
                      double.parse(item.stock!),
                      widget.transVal,
                    );
                  }
                  // widget.onClickedItem(item.title!),
                  ),
            );
          },
        ),
      ],
    );
  }

  Widget buildHeader(String tag) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(right: 18),
      padding: EdgeInsets.only(left: 18),
      color: Colors.grey,
      alignment: Alignment.centerLeft,
      child: Text(
        "$tag",
        // softWrap: false,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AZItem extends ISuspensionBean {
  String? tag;
  String? itemId;
  String? catId;
  String? itemName;
  String? batchCode;
  String? itemImg;
  String? sRate1;
  String? sRate2;
  String? stock;

  _AZItem({
    this.tag,
    this.itemId,
    this.catId,
    this.itemName,
    this.batchCode,
    this.itemImg,
    this.sRate1,
    this.sRate2,
    this.stock,
  });

  @override
  String getSuspensionTag() => tag!;
}
