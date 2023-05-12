import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:read_me_a_story/book_model.dart';
import 'package:read_me_a_story/book_read_controller.dart';

import 'home_controller.dart';

class BooksRead extends StatefulWidget {
  final Book book;

  BooksRead({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<BooksRead> createState() => _BooksReadState();
}

class _BooksReadState extends State<BooksRead> {
  late BookReadController controller;

  final HomeController _homeController = Get.find();

  @override
  void initState() {
    controller = Get.put(
      BookReadController(
        book: widget.book,
      ),
      tag: widget.book.title,
    );

    2.delay().then((value) {
      controller.indexOfBookPage.value = widget.book.bookMarkedPage ?? 0;
      controller.pageController.jumpToPage(widget.book.bookMarkedPage ?? 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BookReadController>(tag: widget.book.title);
    // tts.cancelHandler;

    controller.tts.stop();

    super.dispose();
  }

  var story = [];
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        if (controller.isPlaying.value) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please Pause audio first')));
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfffff8ee), //background for read story
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              //BookMark button
              icon: Obx(() {
                bool isBookMarked = _homeController.checkMarked(widget.book.id);
                return Icon(
                  isBookMarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: isBookMarked
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  size: 30,
                );
              }),
              onPressed: () =>
                  controller.bookMarkPage(_homeController, widget.book.id),
            ),
            IconButton(
              //fav button
              icon: Obx(
                () => Icon(
                  controller.isFavourite.value
                      ? Icons.favorite_outlined
                      : Icons.favorite_border,
                  color:
                      controller.isFavourite.value ? Colors.red : Colors.black,
                  size: 30,
                ),
              ),
              onPressed: () => controller.toggleFavourite(),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  (controller.size.width > 400 ? 0.2 : 0.15),
              child: AspectRatio(
                aspectRatio: 13 / 9,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(2, 2),
                        spreadRadius: 1,
                      ),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        widget.book.picture,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 8,
              width: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFBDD5C8),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Expanded(
              child: PageView.builder(
                //is this to navigate in story?
                onPageChanged: (value) {
                  controller.indexOfBookPage.value = value;
                },

                controller: controller.pageController,

                itemCount: controller.bookPages.length, //ws contentlist
                itemBuilder: (context, index) {
                  final bookPage = controller.bookPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        bookPage,
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        style: TextStyle(fontSize: 18
                            // index == (controller.bookPages.length - 1)
                            //     ? 17
                            //     : 28,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: controller.size.height * 0.1,
              width: double.infinity,
              child: LayoutBuilder(builder: (
                context,
                constraints,
              ) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.02,
                    ),
                    InkWell(
                      onTap: () => controller.playVoice(context),
                      child: Obx(
                        () => Icon(
                          controller.isPlaying.value
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          size: constraints.maxHeight,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.02,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              CircleAvatar(
                                // backgroundColor: isFemaleVoiceSelected
                                //     ? Colors.pink
                                //     : Colors.transparent,
                                child: InkWell(
                                  onTap: () =>
                                      controller.selectFemaleVoice(context),
                                  child: Image.asset(
                                    'assets/images/female.png',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              FlutterSwitch(
                                value: controller.isFemaleVoiceSelected.value,
                                activeColor: Colors.pink,
                                showOnOff: true,
                                onToggle: (value) {
                                  if (value) {
                                    controller.selectFemaleVoice(context);
                                  } else {
                                    controller.selectMaleVoice(context);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                        Obx(
                          () => Row(
                            children: [
                              CircleAvatar(
                                child: InkWell(
                                  child: Image.asset(
                                    'assets/images/male.png',
                                  ),
                                  onTap: () =>
                                      controller.selectMaleVoice(context),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              FlutterSwitch(
                                value: controller.isMaleVoiceSelected.value,
                                showOnOff: true,
                                onToggle: (value) {
                                  if (value) {
                                    controller.selectMaleVoice(context);
                                  } else {
                                    controller.selectFemaleVoice(context);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: controller.size.height * 0.04,
                          child: Obx(
                            () => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  child: LinearProgressIndicator(
                                    minHeight: 50,
                                    value: controller.prgressValue.value,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    // '${(controller.prgressValue.value * 100).toInt()}%',
                                    '',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: controller.size.height * 0.04,
              child: Center(
                child: Obx(
                  () => PageViewDotIndicator(
                    currentItem: controller.indexOfBookPage.value,
                    count: controller.bookPages.length,
                    unselectedColor: Colors.black26,
                    selectedColor: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
