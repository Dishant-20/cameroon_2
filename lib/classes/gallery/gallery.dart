// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cameroon_2/classes/gallery/enlarge_image/enlarge_image.dart';
// import 'package:cameroon_2/classes/get_started_now/get_started_now.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_absolute_path/flutter_absolute_path.dart';
// import 'package:http/http.dart';
// import 'package:reference/reference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'stora';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  //
  // var arr_image_array
  //
  List<String> arr_scroll_multiple_images = [];
  //
  var str_user_profile_loader = '0';
  var arr_image_count = [];
  //
  var selected_photos_ids = [];
  var selected_photo_count = [];
  //
  // Type s = FirebaseFirestore;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  //
  var arr_custom_listing = [];
  //
  void selectImages() async {
    //
    imageFileList!.clear();
    //
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    // imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }

    setState(() {
      str_user_profile_loader = '0';
    });
    print("Image List Length: =====> ${imageFileList!.last}");
    print("Image List Length: =====> ${imageFileList!.length}");
    upload_image_to_server();
  }

  @override
  void initState() {
    super.initState();
    var list = ['1', '2', '3'];
    var stringList = list.join(",");
    print(stringList); //Pri

    profile_details_WB();
  }

  profile_details_WB() async {
    print('=====> POST : MY PROFILE LIST');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // str_login_user_id = prefs.getInt('userId').toString();

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'profile',
          'userId': prefs.getInt('userId').toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(get_data);
    }

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        // arr_guild_list.clear();
        // for (var i = 0; i < get_data['data'].length; i++) {
        //   arr_image_count.add(get_data['data']['totalImage'][i]);
        // }
        //
        arr_image_count.clear();
        arr_custom_listing.clear();
        //
        for (Map i in get_data['data']['totalImage']) {
          arr_image_count.add(i);
        }

        print('dishu');

        for (int j = 0; j < arr_image_count.length; j++) {
          var custom_array = {
            'userImageId': arr_image_count[j]['userImageId'].toString(),
            'image': arr_image_count[j]['image'].toString(),
            'status': 'no',
          };

          arr_custom_listing.add(custom_array);
        }

        //
        for (int i = 0; i < arr_image_count.length; i++) {
          arr_scroll_multiple_images.add(arr_image_count[i]['image']);
        }
        //

        // print(arr_custom_listing.length);

        if (arr_image_count.isEmpty) {
          setState(() {
            str_user_profile_loader = '2';
          });
        } else {
          setState(() {
            str_user_profile_loader = '1';
          });
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          text_gallery,
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
      drawer: const navigationDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          selectImages();
        },
        // backgroundColor: navigation_color,
        child: const Icon(Icons.add),
      ),
      body: (str_user_profile_loader == '0')
          ? const Align(
              child: CircularProgressIndicator(),
            )
          : (str_user_profile_loader == '2')
              ? const Align(
                  child: Text(
                    'No images found.',
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
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
                  child: Stack(
                    children: [
                      GridView.builder(
                        // physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          // mainAxisExtent: 200,
                          // childAspectRatio: 500,
                        ),
                        itemCount:
                            arr_custom_listing.length, //arr_image_count.length,
                        itemBuilder: (context, index) {
                          return GridTile(
                            header: GridTileBar(
                              leading: InkWell(
                                onTap: () {
                                  // print(index);
                                  func_select_deselect_image(index);
                                },
                                child: (arr_custom_listing[index]['status']
                                            .toString() ==
                                        'yes')
                                    ? const Icon(
                                        Icons.check_box,
                                        color: Colors.blue,
                                      )
                                    : const Icon(
                                        Icons.check_box_outline_blank,
                                      ),
                              ),
                            ),
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 46, 69, 86),
                                    width: 2.0,
                                  ),
                                ),
                                child: Image.network(
                                  //
                                  arr_custom_listing[index]['image'].toString(),
                                  //
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onLongPress: () {
                                if (kDebugMode) {
                                  print('long press');
                                }
                                func_select_deselect_image(index);
                              },
                              onTap: () {
                                // print('one tap');
                                CustomImageProvider customImageProvider =
                                    CustomImageProvider(
                                        imageUrls:
                                            arr_scroll_multiple_images.toList(),
                                        initialIndex: index);
                                showImageViewerPager(
                                    context, customImageProvider,
                                    doubleTapZoomable: true,
                                    onPageChanged: (page) {
                                  // print("Page changed to $page");
                                }, onViewerDismissed: (page) {
                                  // print("Dismissed while on page $page");
                                });
                              },
                            ),
                          );
                          /*InkWell(
                        onTap: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EnlargeImageScreen(),
                            ),
                          );*/
                          
                          // print(index);
                          CustomImageProvider customImageProvider =
                              CustomImageProvider(
                                  imageUrls: [
                                    arr_image_count[index]['image'].toString(),
                                    // "https://picsum.photos/id/1001/4912/3264",
                                    // "https://picsum.photos/id/1003/1181/1772",
                                    // "https://picsum.photos/id/1004/4912/3264",
                                    // "https://picsum.photos/id/1005/4912/3264"
                                  ].toList(),
                                  initialIndex: index);
                          showImageViewerPager(context, customImageProvider,
                              doubleTapZoomable: true, onPageChanged: (page) {
                            // print("Page changed to $page");
                          }, onViewerDismissed: (page) {
                            // print("Dismissed while on page $page");
                          });
                          
                          /*ElevatedButton(
                              child: const Text("Show Multiple Images (Custom)"),
                              onPressed: () {
                                print('open');
                                
                              });*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Image.network(
                            arr_image_count[index]['image'].toString(),
                            fit: BoxFit.cover,
                          ),
                          // Image.file(
                          //   File(
                          //     imageFileList![index].path,
                          //   ),
                          // ),
                        ),
                      );*/
                        },
                      ),
                      // Spacer(),
                      (selected_photo_count.isEmpty)
                          ? const SizedBox(
                              height: 0,
                            )
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  func_alert_custom(
                                      selected_photo_count.length.toString());
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),

                                  // width: 48.0,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: (selected_photo_count.length
                                                .toString() ==
                                            '1')
                                        ? Text(
                                            //
                                            '$text_delete ${selected_photo_count.length} $text_photos',
                                            style: TextStyle(
                                              fontFamily: font_family_name,
                                              fontSize: 16.0,
                                              color: Colors.white,
                                            ),
                                            //
                                          )
                                        : Text(
                                            //
                                            '$text_delete ${selected_photo_count.length} photos',
                                            style: TextStyle(
                                              fontFamily: font_family_name,
                                              fontSize: 16.0,
                                              color: Colors.white,
                                            ),
                                            //
                                          ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }

  //
  upload_image_to_server() async {
    // setState(() {});

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request =
        await http.MultipartRequest('POST', Uri.parse(application_base_url));

    request.fields['action'] = 'addmultiimage';
    request.fields['userId'] = prefs.getInt('userId').toString();

    print('dishant rajput');
    print(imageFileList!);

    // List<http.MultipartFile> newList = [];

    // final List<http.MultipartFile> photos = <http.MultipartFile>[];

    // var arr = [];
    for (int i = 0; i < imageFileList!.length; i++) {
      // print(i);
      request.files.add(
        http.MultipartFile(
            // 'multiImage$i',
            '$i',
            // '012345',
            File(imageFileList![i].path).readAsBytes().asStream(),
            File(imageFileList![i].path).lengthSync(),
            filename: (imageFileList![i].path.split("/").last)),
      );
      // newList.add(multipartFile);
    }

    // var dict = [
    //   {'': ''}
    // ];
    // request.files.add(dict);
    // request.files

    print('DISHANT RAJPUT');
    // print(uploadList);
    // print(uploadList.length);
    // request.files.addAll(newList);

    // print(request);
    // print(request.fields);
    print(request.files);

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    if (kDebugMode) {
      print(responsedData);
    }

    if (responsedData['status'].toString() == 'Success'.toLowerCase()) {
      //
      setState(() {
        str_user_profile_loader = '0';
      });
      profile_details_WB();
    }
  }

  Future handleUploadImage() async {
    /*final Reference storageReference = 
       FirebaseStorage.instance.ref().child("Items");
  
    TaskSnapshot taskSnapshot = await 
      storageReference.child("product_$productId.jpg")
        .putFile(mFileImage);
    
    var downloadUrl = await taskSnapshot.ref.getDownloadURL();
    
// final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/path/to/mountains.jpg";
    final file = File(filePath);

// Create the file metadata
    final metadata = SettableMetadata(contentType: "image/jpeg");

// Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child("images/path/to/mountains.jpg")
        .putFile(file, metadata);

// Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          // Handle successful uploads on complete
          // ...
          break;
      }
    });*/
  }
  func_select_deselect_image(indexx) {
    // print(arr_custom_listing.removeAt(3));
    // print(arr_custom_listing.removeAt(indexx));

    if (arr_custom_listing[indexx]['status'].toString() == 'yes') {
      // insert
      var custom_insert = {
        'userImageId': arr_custom_listing[indexx]['userImageId'].toString(),
        'image': arr_custom_listing[indexx]['image'].toString(),
        'status': 'no',
      };
      // remove index
      arr_custom_listing.removeAt(indexx);
      arr_custom_listing.insert(indexx, custom_insert);
    } else {
      // insert
      var custom_insert = {
        'userImageId': arr_custom_listing[indexx]['userImageId'].toString(),
        'image': arr_custom_listing[indexx]['image'].toString(),
        'status': 'yes',
      };
      // remove index
      arr_custom_listing.removeAt(indexx);
      arr_custom_listing.insert(indexx, custom_insert);
    }
    //
    selected_photo_count.clear();
    selected_photos_ids.clear();
    //
    for (int i = 0; i < arr_custom_listing.length; i++) {
      if (arr_custom_listing[i]['status'].toString() == 'yes') {
        selected_photo_count.add(i);
        selected_photos_ids
            .add(arr_custom_listing[i]['userImageId'].toString());
      }
    }
    setState(() {
      print(selected_photos_ids);
      // print(selected_photo_count.length);
    });
  }

  //
  func_alert_custom(String str_image_count) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ), //this right here
            child: SizedBox(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    (str_image_count == '1')
                        ? Text(
                            '$text_delete_message $str_image_count photo?',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            '$text_delete_message $str_image_count photos?',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 16,
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            //
                            Navigator.pop(context);
                            delete_multiple_image_WB();
                            //
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 120.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Align(
                              child: text_with_bold_style(
                                text_delete,
                              ),
                            ),
                            /*IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //
                                delete_multiple_image_WB();
                                //
                              },
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),*/
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(230, 230, 230, 1),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   width: 320.0,
                    //   child: ElevatedButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       "Save",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     // color: const Color(0xFF1BC0C5),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        });
  }

  //
  /*
  action: deleteimage
  userId:
  userImageId: 5,7,8  
 */
  delete_multiple_image_WB() async {
    print('=====> POST : MY PROFILE LIST');

    setState(() {
      selected_photo_count.clear();
      str_user_profile_loader = '0';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // str_login_user_id = prefs.getInt('userId').toString();

    //
    var stringList = selected_photos_ids.join(",");
    //

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'deleteimage',
          'userId': prefs.getInt('userId').toString(),
          'userImageId': stringList.toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(get_data);
    }

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        profile_details_WB();
        //
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
