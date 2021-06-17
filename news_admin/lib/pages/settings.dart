import 'package:news_admin/blocs/admin_bloc.dart';
import 'package:news_admin/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminBloc ab = Provider.of<AdminBloc>(context, listen: false);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 5, bottom: 50),
        height: 3,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.indigoAccent,
            borderRadius: BorderRadius.circular(15)),
      ),
      ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.ad_units),
          ),
          title: Text('Banner Ads'),
          trailing: Switch(
            value: context.watch<AdminBloc>().bannerAd,
            onChanged: (bool value) async {
              if (ab.userType == 'tester') {
                openDialog(
                    context, 'You are a Tester', 'Only admin can control ads!');
              } else {
                await context
                    .read<AdminBloc>()
                    .controlBannerAd(value, context)
                    .then((value) => context.read<AdminBloc>().getAdsData());
              }
            },
          )),
      SizedBox(
        height: 10,
      ),


      ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.ad_units),
          ),
          title: Text('Interstitial Ads'),
          trailing: Switch(
            value: context.watch<AdminBloc>().interstitialAd,
            onChanged: (bool value) async {
              if (ab.userType == 'tester') {
                openDialog(context, 'You are a Tester', 'Only admin can control ads!');
              } else {
                await context
                    .read<AdminBloc>()
                    .controlInterstitialAd(value, context)
                    .then((value) => context.read<AdminBloc>().getAdsData());
              }
            },
          )),
    ]);
  }
}
