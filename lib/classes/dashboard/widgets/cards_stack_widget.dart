// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/dashboard/widgets/action_button_widget.dart';
import 'package:cameroon_2/classes/dashboard/widgets/drag_widget.dart';
import 'package:cameroon_2/classes/dashboard/model/profile.dart';
import 'package:cameroon_2/classes/profile_details/profile_details.dart';
// import 'package:dating_app/main.dart';
// import 'package:dating_app/model/profile.dart';
// import 'package:dating_app/widgets/action_button_widget.dart';
// import 'package:dating_app/widgets/drag_widget.dart';
import 'package:flutter/material.dart';
// import 'package:swipe/swipe.dart';
// import 'package:swipe/swipe.dart';
import 'package:cameroon_2/classes/dashboard/dashboard.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  //
  var arr_users = [];
  //
  List<Profile> draggableItems = [];
  // var draggableItems = [];
  //
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    //
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        draggableItems.removeLast();
        _animationController.reset();

        swipeNotifier.value = Swipe.none;
      }
    });
    //
    func_get_all_users_near_you();
    //
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _) => Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: List.generate(draggableItems.length, (index) {
                // print('1212');
                if (index == draggableItems.length - 1) {
                  return GestureDetector(
                    onTap: () {
                      print('object');

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProfileDetailsScreen(
                      //       str_user_profile_id:
                      //           draggableItems[index].id.toString(),
                      //       str_profile_notification: 'no',
                      //     ),
                      //   ),
                      // );
                    },
                    child: PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(
                            const Rect.fromLTWH(0, 0, 580, 340),
                            const Size(580, 340)),
                        end: RelativeRect.fromSize(
                            Rect.fromLTWH(
                                swipe != Swipe.none
                                    ? swipe == Swipe.left
                                        ? -300
                                        : 300
                                    : 0,
                                0,
                                580,
                                340),
                            const Size(580, 340)),
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      )),
                      child: RotationTransition(
                        turns: Tween<double>(
                                begin: 0,
                                end: swipe != Swipe.none
                                    ? swipe == Swipe.left
                                        ? -0.1 * 0.3
                                        : 0.1 * 0.3
                                    : 0.0)
                            .animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve:
                                const Interval(0, 0.4, curve: Curves.easeInOut),
                          ),
                        ),
                        child: DragWidget(
                          profile: draggableItems[index],
                          index: index,
                          swipeNotifier: swipeNotifier,
                          isLastCard: true,
                        ),
                      ),
                    ),
                  );
                } else {
                  // print(draggableItems[index].id);
                  return DragWidget(
                    profile: draggableItems[index],
                    index: index,
                    swipeNotifier: swipeNotifier,
                  );
                }
              }),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 46.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButtonWidget(
                  onPressed: () {
                    swipeNotifier.value = Swipe.left;
                    _animationController.forward();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 20),
                ActionButtonWidget(
                  onPressed: () {
                    // print(_animationController.value);
                    // print(draggableItems);
                  },
                  icon: const Icon(
                    Icons.info,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                ActionButtonWidget(
                  onPressed: () {
                    swipeNotifier.value = Swipe.right;
                    _animationController.forward();
                    // print(_animationController.value);
                    // setState(() {});
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              print('ra');
              setState(() {
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
        Positioned(
          right: 0,
          child: DragTarget<int>(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return IgnorePointer(
                child: Container(
                  height: 700.0,
                  width: 80.0,
                  color: Colors.transparent,
                ),
              );
            },
            onAccept: (int index) {
              print('mobile');
              setState(() {
                draggableItems.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }
  //

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
    // print(get_data);

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        // draggableItems.clear();
        // print('RAJPUTANA');
        final data = Map<String, dynamic>.from(get_data);
        // print(data['data']);
        for (var i = 0; i < data['data'].length; i++) {
          //
          draggableItems.add(Profile(
              id: data['data'][i]['id'].toString(),
              name: data['data'][i]['fullName'].toString(),
              distance: '${data['data'][i]['gender']}  26 years old',
              imageAsset: 'assets/images/avatar_5.png'));
          //
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
}
