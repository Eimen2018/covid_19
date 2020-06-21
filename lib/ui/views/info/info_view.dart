import 'package:covid_19/constant.dart';
import 'package:covid_19/ui/views/info/info_viewmodel.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:covid_19/widgets/preventcard.dart';
import 'package:covid_19/widgets/symptomcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoView extends StatefulWidget {
  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  final controller = ScrollController();

  double offset = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoViewModel>.reactive(
        viewModelBuilder: () => InfoViewModel(),
        builder: (context, model, child) => Scaffold(
              body: SingleChildScrollView(
                controller: controller,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MyHeader(
                      image: "assets/icons/coronadr.svg",
                      textTop: "Get to know",
                      textBottom: "About Covid-19.",
                      offset: offset,
                      page: "Info",
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Symptoms",
                            style: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? kTitleTextstyle.copyWith(color: Colors.white)
                                : kTitleTextstyle,
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SymptomCard(
                                  image: "assets/images/headache.png",
                                  title: "Headache",
                                  isActive: true,
                                ),
                                SymptomCard(
                                  image: "assets/images/caugh.png",
                                  title: "Cough",
                                ),
                                SymptomCard(
                                  image: "assets/images/fever.png",
                                  title: "Fever",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Prevention",
                            style: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? kTitleTextstyle.copyWith(color: Colors.white)
                                : kTitleTextstyle,
                          ),
                          SizedBox(height: 20),
                          Column(
                            children: <Widget>[
                              PreventCard(
                                text:
                                    "When someone coughs, sneezes, or speaks they spray small liquid droplets from their nose or mouth which may contain virus. If you are too close, you can breathe in the droplets, including the COVID-19 virus if the person has the disease.",
                                image: "assets/images/wear_mask.png",
                                title: "Wear face mask",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              PreventCard(
                                text:
                                    "Regularly and thoroughly clean your hands with an alcohol-based hand rub or wash them with soap and water. Why? Washing your hands with soap and water or using alcohol-based hand rub kills viruses that may be on your hands. ",
                                image: "assets/images/wash_hands.png",
                                title: "Wash your hands",
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              PreventCard(
                                text:
                                    "Hands touch many surfaces and can pick up viruses. Once contaminated, hands can transfer the virus to your eyes, nose or mouth. From there, the virus can enter your body and infect you.",
                                image: "assets/images/avoid_touch_eyes.png",
                                title: "Avoid Touching eyes and Nose",
                                imagewidth: 130,
                                position: 10,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launch(
                            "https://www.who.int/csr/disease/coronavirus_infections/faq_dec12/en/");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFF3383CD),
                              Color(0xFF11249F),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "FAQs",
                              style: kTitleTextstyle.copyWith(
                                  fontSize: 22, color: Colors.white),
                            ),
                            SvgPicture.asset(
                              "assets/icons/forward.svg",
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        launch("https://covid19responsefund.org");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFFffb88c),
                              Color(0xFFde6262),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Donate",
                              style: kTitleTextstyle.copyWith(
                                  fontSize: 22, color: Colors.white),
                            ),
                            SvgPicture.asset(
                              "assets/icons/forward.svg",
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Developed By Tech Bridge",
                          style:
                              TextStyle(color: kTextLightColor, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ));
  }
}
