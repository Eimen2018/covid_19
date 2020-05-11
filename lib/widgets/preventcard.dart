import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final double imagewidth;
  final double position;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
    this.imagewidth, this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: SizedBox(
        height: 206,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 206,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueGrey[900]
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Positioned(
              left: position??0,
              child: Image.asset(
                image,
                width: imagewidth ?? 190,
              ),
            ),
            Positioned(
              left: 140,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                height: 206,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).brightness == Brightness.dark
                          ? kTitleTextstyle.copyWith(color: Colors.white)
                          : kTitleTextstyle,
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 10,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black87
                                    : Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
