import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';

class MostAffected extends StatelessWidget {
  final List countryData;
  final Function setCountry;
  final Function updateData;
  final String date;
  final String name;
  final Color color;
  final String type;

  const MostAffected({
    Key key,
    this.countryData,
    this.setCountry,
    this.updateData,
    this.date,
    this.name,
    this.color,
    this.type,
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
          width: MediaQuery.of(context).size.width - 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                type ?? "Most Affected\n Countries",
                style: Theme.of(context).brightness == Brightness.dark
                    ? kTitleTextstyle.copyWith(color: Colors.white)
                    : kTitleTextstyle,
                textAlign: TextAlign.center,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                          color: color, borderRadius: BorderRadius.circular(5)),
                      child: Text(date,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 270,
          width: MediaQuery.of(context).size.width - 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.blueGrey[900]
                : Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 30,
                color: kShadowColor,
              ),
            ],
          ),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setCountry(countryData[index]['country']);
                  updateData();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Image.network(
                            countryData[index]['countryInfo']['flag'],
                            height: 30,
                            width: 50,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(countryData[index]['country']),
                        ],
                      ),
                      Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                  "+ " +
                                      countryData[index]['today' + name]
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Text(
                              addcoma(countryData[index][name.toLowerCase()]),
                              style: TextStyle(color: color),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
