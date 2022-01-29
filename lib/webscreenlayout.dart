import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int value) {
    pageController.jumpToPage(value);
    setState(() {
      _page = value;
    });
  }

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = "assests/insstalogo.svg";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          assetName,
          height: 32,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () =>navigationTapped(0),
            icon:  Icon(Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () =>navigationTapped(1),
            icon:  Icon(Icons.search,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () =>navigationTapped(2),
            icon:  Icon(Icons.add_a_photo,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () =>navigationTapped(3),
            icon:  Icon(Icons.notifications_none,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
          IconButton(
            onPressed: () =>navigationTapped(4),
            icon:  Icon(Icons.person,
                color: _page == 0 ? primaryColor : secondaryColor),
          ),
        ],
      ),
      body: PageView(
        children: homeScreenWidegets,
        controller: pageController,
      ),
    );
  }

}
