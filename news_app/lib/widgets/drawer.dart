import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:news_app/pages/bookmarks.dart';
import 'package:news_app/utils/app_name.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/language.dart';
import 'package:news_app/widgets/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final sb = context.watch<SignInBloc>();
    final List titles = ['bookmarks', 'language', 'about us', 'privacy policy', 'contact us'];
    final List icons = [
      Feather.bookmark,
      Feather.globe,
      Feather.info,
      Feather.lock,
      Feather.mail

    ];



    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
                color: context.watch<ThemeBloc>().darkTheme == false ? CustomColor().drawerHeaderColorLight : CustomColor().drawerHeaderColorDark,
                padding: EdgeInsets.all(15),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppName(fontSize: 25.0),
                    Text('Version: ${sb.appVersion}', style: TextStyle(
                      fontSize: 13, color: Colors.grey[600]
                    ),)
                  ],
                ),),
            Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: titles.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      titles[index],
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,),
                    ).tr(),
                    leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: context.watch<ThemeBloc>().darkTheme == false ? CustomColor().drawerHeaderColorLight : CustomColor().drawerHeaderColorDark,
                        child: Icon(
                          icons[index],
                          color: Colors.grey[600],
                        )),
                    onTap: () async{
                      Navigator.pop(context);
                      if(index == 0){
                        nextScreen(context, BookmarkPage());
                      }else if(index == 1){
                        nextScreenPopup(context, LanguagePopup());
                      }else if(index == 2){
                        launchURL(context, Config().ourWebsiteUrl);
                      }else if(index == 3){
                        launchURL(context, Config().privacyPolicyUrl);
                      }else if(index == 4){
                        await launch('mailto:${Config().supportEmail}?subject=About ${Config().appName} App&body=');
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
