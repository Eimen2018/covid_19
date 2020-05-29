import 'package:covid_19/constant.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHeader extends StatefulWidget {
  final String image;
  final String textTop;
  final String textBottom;
  final double offset;
  final String page;
  const MyHeader({
    Key key,
    this.image,
    this.textTop,
    this.textBottom,
    this.offset,
    this.page,
  }) : super(key: key);

  @override
  _MyHeaderState createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeader> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(left: 40, top: 50, right: 20),
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: Theme.of(context).brightness == Brightness.dark
                  ? [
                      Color(0xff0B186E),
                      Color(0xFF11249F),
                    ]
                  : [
                      Color(0xFF3383CD),
                      Color(0xFF11249F),
                    ]),
          image: DecorationImage(
            image: AssetImage("assets/images/virus.png"),
          ),
        ),
        child: Column(
          crossAxisAlignment: widget.page == "Info"
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (widget.page == "Info")
                  Navigator.of(context).pop();
                else
                  Scaffold.of(context).openEndDrawer();
                // await _navigationService.navigateTo(Routes.infoViewRoute);
              },
              child: widget.page == "Info"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: FaIcon(
                              FontAwesomeIcons.cog,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? FaIcon(
                                        FontAwesomeIcons.moon,
                                        color: Colors.white,
                                        size: 22,
                                      )
                                    : FaIcon(
                                        FontAwesomeIcons.cloudSun,
                                        color: Color(0xfff9d71c),
                                        size: 22,
                                      ),
                                onPressed: () {
                                  DynamicTheme.of(context).setBrightness(
                                      Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Brightness.dark
                                          : Brightness.light);
                                }),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                // color: Colors.yellow,
                                padding: EdgeInsets.all(10),
                                child:
                                    SvgPicture.asset("assets/icons/menu.svg")),
                          ],
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset,
                    child: SvgPicture.asset(
                      widget.image,
                      width: 230,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    top: 20 - widget.offset / 2,
                    left: 150,
                    child: Text(
                      "${widget.textTop} \n${widget.textBottom}",
                      style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(), // I dont know why it can't work without container
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
