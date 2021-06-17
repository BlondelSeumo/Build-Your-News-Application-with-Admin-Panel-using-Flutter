import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/pages/home.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  
  void afterIntroComplete (){
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    sb.setSignIn();
    nextScreenReplace(context, HomePage());
  }


  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        introPage(context, 'intro-title1', 'intro-description1', Config().introImage1),
        introPage(context, 'intro-title2', 'intro-description2', Config().introImage2),
        introPage(context, 'intro-title3', 'intro-description3', Config().introImage3)
      
      
      
      ],
      onDone: () {
        afterIntroComplete();
      },
      onSkip: () {
        afterIntroComplete();
      },
      showSkipButton: true,
      skip: const Text('skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)).tr(),
      next: const Icon(Icons.navigate_next),
      done: const Text("done", style: TextStyle(fontWeight: FontWeight.w600)).tr(),

      dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(20.0, 5.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0))),
    );
  }
}




PageViewModel introPage (context, String title, String subtitle, String image){
  return PageViewModel(

      titleWidget: Column(
        children: <Widget>[
          Text(title, style:  TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),).tr(),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      
      body: subtitle.tr(),
      image: Center(
        child: Image(
          image: AssetImage(image)
        )
      ),

      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 17, fontWeight: FontWeight.w500),
        descriptionPadding: EdgeInsets.only(left: 30, right: 30),
        imagePadding: EdgeInsets.all(30),

      ),
    );

}


