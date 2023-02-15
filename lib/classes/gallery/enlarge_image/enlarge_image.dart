import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class EnlargeImageScreen extends StatefulWidget {
  const EnlargeImageScreen({super.key});

  @override
  State<EnlargeImageScreen> createState() => _EnlargeImageScreenState();
}

class _EnlargeImageScreenState extends State<EnlargeImageScreen> {
  //
  final _pageController = PageController();
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final List<ImageProvider> _imageProviders = [
    Image.network("https://picsum.photos/id/1001/4912/3264").image,
    Image.network("https://picsum.photos/id/1003/1181/1772").image,
    Image.network("https://picsum.photos/id/1004/4912/3264").image,
    Image.network("https://picsum.photos/id/1005/4912/3264").image
    // Image.asset('name');
  ];

  late final _easyEmbeddedImageProvider = MultiImageProvider(_imageProviders);
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          'Gallery',
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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              child: const Text("Show Single Image"),
              onPressed: () {
                showImageViewer(
                    context,
                    Image.network("https://picsum.photos/id/1001/4912/3264")
                        .image,
                    swipeDismissible: true,
                    doubleTapZoomable: true);
              }),
          ElevatedButton(
              child: const Text("Show Multiple Images (Simple)"),
              onPressed: () {
                MultiImageProvider multiImageProvider =
                    MultiImageProvider(_imageProviders);
                showImageViewerPager(context, multiImageProvider,
                    swipeDismissible: true, doubleTapZoomable: true);
              }),
          ElevatedButton(
              child: const Text("Show Multiple Images (Custom)"),
              onPressed: () {
                CustomImageProvider customImageProvider = CustomImageProvider(
                    imageUrls: [
                      "https://picsum.photos/id/1001/4912/3264",
                      "https://picsum.photos/id/1003/1181/1772",
                      "https://picsum.photos/id/1004/4912/3264",
                      "https://picsum.photos/id/1005/4912/3264"
                    ].toList(),
                    initialIndex: 2);
                showImageViewerPager(context, customImageProvider,
                    doubleTapZoomable: true, onPageChanged: (page) {
                  // print("Page changed to $page");
                }, onViewerDismissed: (page) {
                  // print("Dismissed while on page $page");
                });
              }),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.0,
            child: EasyImageViewPager(
                easyImageProvider: _easyEmbeddedImageProvider,
                pageController: _pageController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: const Text("<< Prev"),
                  onPressed: () {
                    final currentPage = _pageController.page?.toInt() ?? 0;
                    _pageController.animateToPage(
                        currentPage > 0 ? currentPage - 1 : 0,
                        duration: _kDuration,
                        curve: _kCurve);
                  }),
              ElevatedButton(
                  child: const Text("Next >>"),
                  onPressed: () {
                    final currentPage = _pageController.page?.toInt() ?? 0;
                    final lastPage = _easyEmbeddedImageProvider.imageCount - 1;
                    _pageController.animateToPage(
                        currentPage < lastPage ? currentPage + 1 : lastPage,
                        duration: _kDuration,
                        curve: _kCurve);
                  }),
            ],
          )
        ],
      )),
    );
  }
}

class CustomImageProvider extends EasyImageProvider {
  @override
  final int initialIndex;
  final List<String> imageUrls;

  CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
      : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return NetworkImage(imageUrls[index]);
  }

  @override
  int get imageCount => imageUrls.length;
}
