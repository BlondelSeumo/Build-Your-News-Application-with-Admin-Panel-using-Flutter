import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:launch_review/launch_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/blocs/notification_bloc.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/pages/bookmarks.dart';
import 'package:news_app/pages/edit_profile.dart';
import 'package:news_app/pages/welcome.dart';
import 'package:news_app/widgets/language.dart';
import 'package:news_app/widgets/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/sign_in_bloc.dart';
import '../config/config.dart';
import '../utils/next_screen.dart';
import 'package:easy_localization/easy_localization.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{



  


  openAboutDialog (){
    final sb = context.read<SignInBloc>();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AboutDialog(
          applicationName: Config().appName,
          applicationIcon: Image(image: AssetImage(Config().splashIcon), height: 30, width: 30,),
          applicationVersion: sb.appVersion,
        );
      }
    );
  }





  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text('profile').tr(),
        centerTitle: false,
        
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 20, 20, 50),
        children: [
          sb.guestUser == true ? GuestUserUI() : UserUI(),

          Text("general settings", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),).tr(),

          
          
          SizedBox(height: 15,),
          ListTile(
            title: Text('bookmarks').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.bookmark, size: 20, color: Colors.white),
            ),
            trailing:  Icon(Feather.chevron_right, size: 20,),
            onTap: () => nextScreen(context, BookmarkPage()),
          ),


          Divider(height: 3,),
          ListTile(
            title: Text('dark mode').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(LineIcons.sun_o, size: 22, color: Colors.white),
            ),
            trailing:  Switch(
                activeColor: Theme.of(context).primaryColor,
                value: context.watch<ThemeBloc>().darkTheme,
                onChanged: (bool) {
                  context.read<ThemeBloc>().toggleTheme();
                }),
          ),


          Divider(height: 3,),
          ListTile(
            title: Text('get notifications').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(LineIcons.bell, size: 22, color: Colors.white),
            ),
            trailing:  Switch(
                activeColor: Theme.of(context).primaryColor,
                value: context.watch<NotificationBloc>().subscribed,
                onChanged: (bool) {
                  context.read<NotificationBloc>().fcmSubscribe(bool);
                }),
          ),
          Divider(height: 3,),
          ListTile(
            title: Text('contact us').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.mail, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()async=> await launch('mailto:${Config().supportEmail}?subject=About ${Config().appName} App&body='),
          ),
          Divider(height: 3,),

          ListTile(
            title: Text('language').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.globe, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> nextScreenPopup(context, LanguagePopup()),
          ),
          Divider(height: 3,),

          ListTile(
            title: Text('rate this app').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.star, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()async=> LaunchReview.launch(androidAppId: sb.packageName, iOSAppId: Config().iOSAppId),
          ),
          Divider(height: 3,),

          ListTile(
            title: Text('licence').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.paperclip, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> openAboutDialog(),
          ),
          Divider(height: 3,),

          ListTile(
            title: Text('privacy policy').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.lock, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()async{
              launchURL(context, Config().privacyPolicyUrl);
            },
          ),
          Divider(height: 3,),

          ListTile(
            title: Text('about us').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.info, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()async{
              launchURL(context, Config().ourWebsiteUrl);
            },
          ),

          
        ],
      )
      
      
    );
  }

  

  @override
  bool get wantKeepAlive => true;
}





class GuestUserUI extends StatelessWidget {
  const GuestUserUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: Text('login').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.user, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> nextScreenPopup(context, WelcomePage(tag: 'popup',)),
          ),
        SizedBox(height: 20,),
      ],
    );
  }
}


class UserUI extends StatelessWidget {
  const UserUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return Column(
      children: [
        Container(
          height: 200,
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: CachedNetworkImageProvider(sb.imageUrl)
              ),
              SizedBox(height: 15,),
              Text(sb.name, style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
        ),

        ListTile(
            title: Text(sb.email),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.mail, size: 20, color: Colors.white),
            ),
          ),
          Divider(height: 3,),

          

          ListTile(
            title: Text('edit profile').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.edit_3, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> nextScreen(context, EditProfile(name: sb.name, imageUrl: sb.imageUrl))
          ),

          Divider(height: 3,),

          ListTile(
            title: Text('logout').tr(),
            leading: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(Feather.log_out, size: 20, color: Colors.white),
            ),
            trailing: Icon(Feather.chevron_right, size: 20,),
            onTap: ()=> openLogoutDialog(context),
          ),



          SizedBox(height: 15,)
        

      ],
    );
  }


  void openLogoutDialog (context) {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('logout title').tr(),
          actions: [
            TextButton(
              child: Text('no').tr(),
              onPressed: ()=> Navigator.pop(context),
            ),
            TextButton(
              child: Text('yes').tr(),
              onPressed: ()async{
                Navigator.pop(context);
                await context.read<SignInBloc>().userSignout()
                .then((value) => context.read<SignInBloc>().afterUserSignOut())
                .then((value){
                  if(context.read<ThemeBloc>().darkTheme == true){
                    context.read<ThemeBloc>().toggleTheme();
                  }
                  nextScreenCloseOthers(context, WelcomePage());
                }
                );
                
                
              },
            )
          ],
        );
      }
    );
  }
}