import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final dynamic number;
  final Color color;
  final String title;
  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
  }) : super(key: key);

  addcoma(int number) {
    String num = number.toString();
    num = num.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return num;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          (number is int) ? addcoma(number) : number.toString(),
          style: TextStyle(
            fontSize: 20,
            color: color,
          ),
        ),
        Text(
          title,
          style: kSubTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
