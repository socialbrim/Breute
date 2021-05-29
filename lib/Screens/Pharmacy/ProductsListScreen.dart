import 'package:parentpreneur/Providers/AllRewardProducts.dart';
import 'package:parentpreneur/models/ProductDetails.dart';

import 'productDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ProductsListScreen extends StatefulWidget {
  final bool isSort;
  final String categoryForSort;
  final List<ProductModel> list;
  ProductsListScreen({this.isSort, this.list, this.categoryForSort});
  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  ScrollController _controller;
  bool _isLoading = true;
  int reecheckCount = 0;

  List<ProductModel> _productList = [];
  List<ProductModel> _filtertList = [];
  void getData() async {
    _productList = [];
    await Provider.of<MarketProvider>(context, listen: false)
        .fetchProductData();
    _productList = Provider.of<MarketProvider>(context, listen: false).products;

    try {
      if (widget.isSort) {
        _productList.forEach((element) {
          if (!element.category.contains(widget.categoryForSort)) {
            _productList.remove(element);
          }
        });
        setState(() {
          _isLoading = false;
        });
        if (_productList.length < 10 && widget.isSort && reecheckCount < 2) {
          reecheckCount++;
          getData();
        }
      }
    } catch (e) {}
    setState(() {
      _isLoading = false;
      _filtertList = [..._productList];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  int indexSortType;
  int noOfPoints;
  void filterList(int indexsortType, int noOfPoints) {
    this.indexSortType = indexsortType;
    this.noOfPoints = noOfPoints;
    List<ProductModel> tempList = [..._productList];
    if (indexsortType == 1) {
      tempList.sort((a, b) => a.pointReq.compareTo(b.pointReq));
    } else if (indexsortType == 2) {
      tempList.sort((a, b) => a.pointReq.compareTo(b.pointReq));
      final temprary = tempList.reversed;
      tempList = [];
      temprary.forEach((element) {
        tempList.add(element);
      });
    }
    if (noOfPoints > 0) {
      tempList.removeWhere((element) => noOfPoints >= element.pointReq);
    }

    setState(() {
      _filtertList = [];
      tempList.forEach((element) {
        _filtertList.add(element);
      });
    });
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    if (widget.list != null) {
      _productList = widget.list;
      _filtertList = widget.list;
      _isLoading = false;
    } else {
      getData();
    }
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        if (widget.list != null) {
          _productList = widget.list;
          _filtertList = widget.list;
        } else {
          _isLoading = true;
          Provider.of<MarketProvider>(context, listen: false).setNewIndex();
          getData();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              MdiIcons.arrowLeft,
              color: HexColor("FA163F"),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: SearchYourProduct(
                            ls: _productList,
                          ),
                        );
                      },
                      child: Container(
                        color: HexColor('F1FAEE'),
                        width: 220,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: HexColor('FA163F'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                "Search items...",
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => FilterProductScreen(
                        //       indexSortType: indexSortType,
                        //       noOfPoints: noOfPoints,
                        //       submit: filterList,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        color: HexColor('F1FAEE'),
                        width: 100,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              MdiIcons.tuneVertical,
                              color: HexColor('FA163F'),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Filter',
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: 3.0 * 240,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 5,
                  ),
                  itemCount: _filtertList.length, //
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: _filtertList[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Center(
                                child: Container(
                                  height: 130,
                                  width: 150,
                                  child: Image.network(
                                    _filtertList[index].images == null
                                        ? "https://cdn1.vectorstock.com/i/thumb-large/46/50/missing-picture-page-for-website-design-or-mobile-vector-27814650.jpg"
                                        : "${_filtertList[index].images.first}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "${_filtertList[index].title}",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: HexColor('091540'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "${_filtertList[index].pointReq.toInt()} Points",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: HexColor('FA163F'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: SpinKitFadingCircle(
                      color: Colors.pink,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchYourProduct extends SearchDelegate<String> {
  List<ProductModel> ls;

  SearchYourProduct({
    this.ls,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext contexntext) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(contexntext).pop();
      },
    );
    // throw UnimplementedError();
  }

  ProductModel resultChoosen;
  @override
  Widget buildResults(BuildContext context) {
    return resultChoosen == null
        ? Center(
            child: Text("No Result Found"),
          )
        : GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                    product: resultChoosen,
                  ),
                ),
              );
            },
            child: Container(
              height: 130,
              width: double.infinity,
              child: Card(
                child: Row(
                  children: [
                    Center(
                      child: Container(
                        height: 130,
                        width: 150,
                        child: Image.network(
                          resultChoosen.images == null
                              ? "https://cdn1.vectorstock.com/i/thumb-large/46/50/missing-picture-page-for-website-design-or-mobile-vector-27814650.jpg"
                              : "${resultChoosen.images.first}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${resultChoosen.title}",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: HexColor('091540'),
                            ),
                          ),
                        ),
                        Text(
                          "${resultChoosen.pointReq.toInt()} Points",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: HexColor('FA163F'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? [ls.elementAt(0)]
        : ls.where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()));
    return suggestionList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 65,
                ),
                Center(
                  child: Text(
                    "No result found.\nCheck spelling and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                onTap: () {
                  resultChoosen = suggestionList.elementAt(index);
                  showResults(context);
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(suggestionList
                              .elementAt(index)
                              .images ==
                          null
                      ? "https://www.pinclipart.com/picdir/big/1-12934_shop-clip-art-local-business-clipart-png-download.png"
                      : suggestionList.elementAt(index).images.first),
                ),
                title: RichText(
                  text: TextSpan(
                      text: suggestionList
                          .elementAt(index)
                          .title
                          .substring(0, query.length),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: suggestionList.elementAt(index).title.substring(
                              query.length,
                              suggestionList.elementAt(index).title.length),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        )
                      ]),
                ),
              ),
            ),
          );
    // throw UnimplementedError();
  }
}
