// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/dashboard/content.dart';
import 'package:cameroon_2/classes/get_started_now/get_started_now.dart';
import 'package:cameroon_2/classes/profile_details/profile_details.dart';
import 'package:flutter/foundation.dart';

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/dashboard/widgets/background_curve_widget.dart';
import 'package:cameroon_2/classes/dashboard/widgets/cards_stack_widget.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:swipe/swipe.dart';
import 'package:swipe_cards/draggable_card.dart';

import 'package:swipeable_card_stack/swipeable_card_stack.dart';

import 'package:geolocator/geolocator.dart';

import 'package:swipe_cards/swipe_cards.dart';

import 'package:swiping_card_deck/swiping_card_deck.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //
  var str_dashboard_loader = '0';
  var arr_swipe = [];
  //
  String _message = 'Swipe your screen';
  //
  SwipeableCardSectionController _cardController =
      SwipeableCardSectionController();
  //
  String? _currentAddress;
  Position? _currentPosition;
  //
  int counter = 4;

  @override
  void initState() {
    func_get_all_users_near_you();

    super.initState();
  }

  /*func_create_content(arr_server) {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          //content: Content(text: _names[i], color: _colors[i]),
          // content: Content(name: 'dishu', image: '', gender: '', dob: ''),
          likeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Liked  "),
          duration: Duration(milliseconds: 500),
        ));
      }, nopeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Nope"),
          duration: Duration(milliseconds: 500),
        ));
      }, superlikeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // content: Text("Superliked ${_names[i]}"),
          content: Text("Superliked  "),
          // arr_server
          duration: Duration(milliseconds: 500),
        ));
      }, onSlideUpdate: (SlideRegion? region) async {
        print("Region $region");
      }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }*/

  func_get_all_users_near_you() async {
    // print('object');

    setState(() {
      // str_save_and_continue_loader = '1';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getInt('userId').toString());
    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'finduser',
          'userId': prefs.getInt('userId').toString(),
          'latitude': '13.7563',
          'longitude': '100.5018',
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    print(get_data);

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        // draggableItems.clear();
        // print('RAJPUTANA');
        final data = Map<String, dynamic>.from(get_data);
        // print(data['data']);
        for (var i = 0; i < data['data'].length; i++) {
          //
          arr_swipe.add(data['data']);
        }
        //
        setState(() {});
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      print('something went wrong');
    }
  }

  func_position() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString());
    print(position.longitude.toString());
    print(position.altitude);
    // _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      print(place);
      print(placemarks);
      // setState(() {
      print(place.street);
      // _currentAddress =
      //    '\${place.street}, ${place.subLocality},
      //     ${place.subAdministrativeArea}, ${place.postalCode}';
      // });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  /*final SwipingCardDeck deck = SwipingCardDeck(
    cardDeck: getCardDeck(),
    onDeckEmpty: () => debugPrint("Card deck empty"),
    onLeftSwipe: (Card card) => debugPrint("Swiped left!"),
    onRightSwipe: (Card card) => debugPrint("Swiped right!"),
    cardWidth: 400,
    swipeThreshold: double.infinity,
    minimumVelocity: 1000,
    rotationFactor: 0.8 / 3.14,
    swipeAnimationDuration: const Duration(milliseconds: 500),
    disableDragging: false,
  );

  List<Widget> _samplePages = [
    Center(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        color: Colors.amber[600],
        width: 48.0,
        height: 48.0,
      ),
    ),
    Center(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        color: Colors.pink,
        width: 48.0,
        height: 48.0,
      ),
    ),
    /*Center(
      child: Text('Page 1'),
    ),
    Center(child: Text('Page 2'))*/
  ];*/
  final _controller = new PageController();
  int _activePage = 0;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontFamily: font_family_name,
            ),
          ),
          backgroundColor: bg_color,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(170, 0, 20, 1),
                  Color.fromRGBO(180, 30, 20, 1),
                  Color.fromRGBO(218, 115, 32, 1),
                  Color.fromRGBO(227, 142, 36, 1),
                  Color.fromRGBO(236, 170, 40, 1),
                  Color.fromRGBO(248, 198, 40, 1),
                  Color.fromRGBO(252, 209, 42, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        drawer: const navigationDrawer(),
        body:
            // Column(
            // children: <Widget>[
            PageView.builder(
          // scrollDirection: Axis.vertical,
          controller: _controller,
          itemCount: arr_swipe.length,
          onPageChanged: (int page) {
            setState(() {
              _activePage = page;
              print(_activePage);
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.amber[600],
                    // width: 48.0,
                    // height: 48.0,
                    child: Image.asset(
                      'assets/images/avatar_5.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // margin: const EdgeInsets.all(10.0),
                    // color: Colors.transparent,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.2,
                          0.4,
                          0.6,
                          0.8,
                        ],
                        colors: [
                          Color.fromARGB(255, 55, 55, 55),
                          Color.fromARGB(255, 80, 80, 80),
                          Color.fromARGB(233, 57, 56, 56),
                          Color.fromARGB(255, 31, 31, 31),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    // height: 300,
                    child: Column(
                      children: [
                        // for (int i = 0; i < arr_swipe.length; i++) ...[
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 20,
                          ),
                          child: Text(
                            // 'Dishant Rajput',
                            //
                            arr_swipe[index][_activePage]['fullName'],
                            //
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 10,
                          ),
                          child: Text(
                            //
                            arr_swipe[index][_activePage]['gender'].toString(),
                            //
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 22,
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _controller.nextPage(
                                duration: _kDuration, curve: _kCurve);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            color: Colors.transparent,
                            // width: 300,
                            // height: 100 - 20,
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    color: Colors.transparent,
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/images/left.png',
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10.0),
                                    color: Colors.transparent,
                                    width: 70,
                                    height: 70,
                                    child: IconButton(
                                      onPressed: () {
                                        /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileDetailsScreen(
                                              str_user_profile_id:
                                                  arr_swipe[index][_activePage]
                                                          ['userId']
                                                      .toString(),
                                            ),
                                          ),
                                        );*/
                                      },
                                      icon: const Icon(
                                        Icons.info,
                                        size: 50,
                                        color: Color.fromRGBO(
                                          230,
                                          230,
                                          230,
                                          1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _controller.nextPage(
                                          duration: _kDuration, curve: _kCurve);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10.0),
                                      color: Colors.transparent,
                                      width: 80,
                                      height: 80,
                                      child: Image.asset(
                                        'assets/images/right.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // ]
                      ],
                    ),
                  ),
                ),
              ],
            );

            /*Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.amber[600],
                    // width: 48.0,
                    // height: 48.0,
                    child: Image.asset(
                      'assets/images/avatar_5.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Spacer(),
                Container(
                  // margin: const EdgeInsets.all(10.0),
                  // color: Colors.transparent,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                        0.2,
                        0.4,
                        0.6,
                        0.8,
                      ],
                      colors: [
                        Color.fromARGB(255, 55, 55, 55),
                        Color.fromARGB(255, 80, 80, 80),
                        Color.fromARGB(233, 57, 56, 56),
                        Color.fromARGB(255, 31, 31, 31),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  // height: 300,
                  child: Column(
                    children: [
                      // for (int i = 0; i < arr_swipe.length; i++) ...[
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Text(
                          // 'Dishant Rajput',
                          //
                          arr_swipe[index][_activePage]['fullName'],
                          //
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                        ),
                        child: Text(
                          '25 - Male',
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 22,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.transparent,
                        // width: 300,
                        // height: 100 - 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.transparent,
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                  'assets/images/left.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.transparent,
                                width: 70,
                                height: 70,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Color.fromRGBO(
                                      230,
                                      230,
                                      230,
                                      1,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _controller.nextPage(
                                      duration: _kDuration, curve: _kCurve);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  color: Colors.transparent,
                                  width: 80,
                                  height: 80,
                                  child: Image.asset(
                                    'assets/images/right.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ]
                    ],
                  ),
                ),
              ],
            );*/
          },
        ),
        /*Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // margin: const EdgeInsets.all(10.0),
                // color: Colors.transparent,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.2,
                      0.5,
                      0.7,
                      0.6,
                    ],
                    colors: [
                      Color.fromARGB(218, 246, 54, 77),
                      Color.fromARGB(255, 238, 110, 110),
                      Color.fromARGB(233, 231, 126, 126),
                      Color.fromARGB(255, 244, 125, 125),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                // height: 160,
                child: Column(
                  children: [
                    // for (int i = 0; i < arr_swipe.length; i++) ...[
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: Text(
                          // 'Dishant Rajput',
                          arr_swipe[index]['fullName'],
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                        ),
                        child: Text(
                          '25 - Male',
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 22,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.transparent,
                        // width: 300,
                        // height: 100 - 20,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.transparent,
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                  'assets/images/left.png',
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.transparent,
                                width: 70,
                                height: 70,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.info,
                                    size: 50,
                                    color: Color.fromRGBO(
                                      230,
                                      230,
                                      230,
                                      1,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.transparent,
                                width: 80,
                                height: 80,
                                child: Image.asset(
                                  'assets/images/right.png',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // ]
                  ],
                ),
              ),
            ),*/
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        ///
        /*Container(
              color: Colors.lightBlueAccent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Prev'),
                    onPressed: () {
                      /*_controller.previousPage(
                          duration: _kDuration, curve: _kCurve);*/

                      _controller.nextPage(
                          duration: _kDuration, curve: _kCurve);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Next'),
                    onPressed: () {
                      _controller.nextPage(
                          duration: _kDuration, curve: _kCurve);
                    },
                  )
                ],
              ),
            ),*/
        // const SizedBox(
        //   height: 0,
        // ),
        // ],
        // ),
        /*body: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // deck,
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.amber[600],
                width: MediaQuery.of(context).size.width,
                // height: 48.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.clear),
                  iconSize: 30,
                  color: Colors.red,
                  onPressed:
                      deck.animationActive ? null : () => deck.swipeLeft(),
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: const Icon(Icons.check),
                  iconSize: 30,
                  color: Colors.green,
                  onPressed:
                      deck.animationActive ? null : () => deck.swipeRight(),
                ),
              ],
            ),
          ],
        ),*/
        /*Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                child: SwipeCards(
                  matchEngine: _matchEngine!,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: _swipeItems[index].content.color,
                      child: Text(
                        _swipeItems[index].content.text,
                        style: TextStyle(fontSize: 100),
                      ),
                    );
                  },
                  onStackFinished: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Stack Finished"),
                      duration: Duration(milliseconds: 500),
                    ));
                  },
                  itemChanged: (SwipeItem item, int index) {
                    print("item: ${item.content.text}, index: $index");
                  },
                  leftSwipeAllowed: true,
                  rightSwipeAllowed: true,
                  upSwipeAllowed: true,
                  fillSpace: true,
                  likeTag: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Text('Like'),
                  ),
                  nopeTag: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: Text('Nope'),
                  ),
                  superLikeTag: Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.orange)),
                    child: Text('Super Like'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _matchEngine!.currentItem?.nope();
                        },
                        child: Text("Nope")),
                    ElevatedButton(
                        onPressed: () {
                          _matchEngine!.currentItem?.superLike();
                        },
                        child: Text("Superlike")),
                    ElevatedButton(
                        onPressed: () {
                          _matchEngine!.currentItem?.like();
                        },
                        child: Text("Like"))
                  ],
                ),
              )
            ],
          ),
        ),*/
      ),
      /*Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
            'Dashboard',
            style: TextStyle(
              fontFamily: font_family_name,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(170, 0, 20, 1),
                  Color.fromRGBO(180, 30, 20, 1),
                  Color.fromRGBO(218, 115, 32, 1),
                  Color.fromRGBO(227, 142, 36, 1),
                  Color.fromRGBO(236, 170, 40, 1),
                  Color.fromRGBO(248, 198, 40, 1),
                  Color.fromRGBO(252, 209, 42, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        
        body: Stack(
          children: const [
            // BackgroudCurveWidget(),
            // CardsStackWidget(),
          ],
        ),
      ),*/
    );
  }

  //
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

//
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}

List<Card> getCardDeck() {
  List<Card> cardDeck = [];
  for (int i = 0; i < 500; ++i) {
    cardDeck.add(
      Card(
          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          child: const SizedBox(height: 300, width: 200)),
    );
  }
  return cardDeck;
}

// Content({required String text, required Color color}) {
//   text = '';
//   color = Colors.amber;
// }

enum Swipe { left, right, none }
