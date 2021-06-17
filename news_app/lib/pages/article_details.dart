import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/ads_bloc.dart';
import 'package:news_app/blocs/bookmark_bloc.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:news_app/pages/comments.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/sign_in_dialog.dart';
import 'package:news_app/widgets/bookmark_icon.dart';
import 'package:news_app/widgets/full_image.dart';
import 'package:news_app/widgets/launch_url.dart';
import 'package:news_app/widgets/love_count.dart';
import 'package:news_app/widgets/love_icon.dart';
import 'package:news_app/widgets/related_articles.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../utils/next_screen.dart';

class ArticleDetails extends StatefulWidget {
  final Article data;
  final String tag;
  const ArticleDetails({Key key, @required this.data, @required this.tag})
      : super(key: key);

  @override
  _ArticleDetailsState createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {
  double rightPaddingValue = 140;
  bool adInitiated;

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    if (Platform.isAndroid) {
      Share.share(
          '${widget.data.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}');
    } else if (Platform.isIOS) {
      Share.share(
          '${widget.data.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}');
    }
  }

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onLoveIconClick(widget.data.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(widget.data.timestamp);
    }
  }

  @override
  void initState() {
    super.initState();
    //initiateAdmobBanner();  //admob
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  @override
  void dispose() {
    //disposeAdmobbanner(); //admob
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final ab = context.watch<AdsBloc>();
    final Article d = widget.data;

    return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
            bottom: true,
      top: false,
      maintainBottomViewPadding: true,
      minimum: EdgeInsets.only(
          bottom: ab.bannerAd == true
              ? Platform.isAndroid
                  ? 60
                  : 90
              : 0),
              child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        expandedHeight: 270,
                        flexibleSpace: FlexibleSpaceBar(
                            background: widget.tag == null
                                ? CustomCacheImage(
                                    imageUrl: d.thumbnailImagelUrl, radius: 0.0)
                                : Hero(
                                    tag: widget.tag,
                                    child: CustomCacheImage(
                                        imageUrl: d.thumbnailImagelUrl,
                                        radius: 0.0),
                                  )),
                        leading: IconButton(
                          icon: Icon(Icons.keyboard_backspace,
                              size: 22, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        actions: <Widget>[
                          IconButton(
                            icon:
                                Icon(Icons.share, size: 22, color: Colors.white),
                            onPressed: () {
                              _handleShare();
                            },
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.center,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: context
                                                        .watch<ThemeBloc>()
                                                        .darkTheme ==
                                                    false
                                                ? CustomColor().loadingColorLight
                                                : CustomColor().loadingColorDark,
                                          ),
                                          child: AnimatedPadding(
                                            duration:
                                                Duration(milliseconds: 1000),
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: rightPaddingValue,
                                                top: 5,
                                                bottom: 5),
                                            child: Text(
                                              d.category,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )),
                                      Spacer(),
                                      IconButton(
                                          icon: BuildLoveIcon(
                                              collectionName: 'contents',
                                              uid: sb.uid,
                                              timestamp: d.timestamp),
                                          onPressed: () {
                                            handleLoveClick();
                                          }),
                                      IconButton(
                                          icon: BuildBookmarkIcon(
                                              collectionName: 'contents',
                                              uid: sb.uid,
                                              timestamp: d.timestamp),
                                          onPressed: () {
                                            handleBookmarkClick();
                                          }),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(CupertinoIcons.time_solid,
                                          size: 18, color: Colors.grey),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        d.date,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    d.title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(
                                    color: Theme.of(context).primaryColor,
                                    endIndent: 280,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  d.sourceUrl == null
                                      ? Container()
                                      : InkWell(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            child: Chip(
                                              backgroundColor: context
                                                          .watch<ThemeBloc>()
                                                          .darkTheme ==
                                                      false
                                                  ? CustomColor()
                                                      .loadingColorLight
                                                  : CustomColor()
                                                      .loadingColorDark,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              label: Wrap(
                                                alignment: WrapAlignment.center,
                                                children: [
                                                  Icon(
                                                    Feather.external_link,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'source',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            launchURL(context, d.sourceUrl);
                                          },
                                        ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      LoveCount(
                                          collectionName: 'contents',
                                          timestamp: d.timestamp),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      TextButton.icon(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => Colors.green[300]),
                                          shape:
                                              MaterialStateProperty.resolveWith(
                                                  (states) =>
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3))),
                                        ),
                                        icon: Icon(Icons.comment,
                                            color: Colors.black87, size: 20),
                                        label: Text('comments',
                                                style: TextStyle(
                                                    color: Colors.black87))
                                            .tr(),
                                        onPressed: () {
                                          //disposeAdmobbanner(); //admob
                                          nextScreen(
                                              context,
                                              CommentsPage(
                                                  timestamp: d.timestamp));
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Html(
                                    style: {
                                      "body": Style(
                                          margin: EdgeInsets.all(0),
                                          padding: EdgeInsets.all(0),
                                          fontSize: FontSize(18),
                                          fontWeight: FontWeight.normal,
                                          color: Theme.of(context).primaryColorDark)
                                    },
                                    data: '''${d.description}''',
                                    onLinkTap: (url) async {
                                      launchURL(context, url);
                                    },
                                    onImageTap: (imageUrl) => nextScreenPopup(
                                        context,
                                        FullScreeImage(imageUrl: imageUrl)),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.all(20),
                                child: RelatedArticles(
                                  category: d.category,
                                  timestamp: d.timestamp,
                                  replace: true,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //banner ad fb

                //context.watch<AdsBloc>().bannerAd != true
                //:BannerAdsFb().fbBanner
              ],
            ),
          )
    );
  }

  //admob --START
  // BannerAd _admobBannerAd;

  //  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   nonPersonalizedAds: true,
  // );

  // BannerAd createAdmobBannerAd() {
  //   return BannerAd(
  //     adUnitId: Platform.isAndroid ? Config().admobBannerAdIdAndroid : Config().admobBannerAdIdiOS,
  //     size: AdSize.banner,
  //     targetingInfo: targetingInfo,
  //     listener: (MobileAdEvent event) {
  //       print("BannerAd event $event");
  //     },
  //   );
  // }

  // initiateAdmobBanner (){
  //   if(mounted){
  //     if(context.read<AdsBloc>().bannerAd == true){
  //       adInitiated = true;
  //       _admobBannerAd = createAdmobBannerAd()..load()..show(
  //       anchorOffset: 0.0,
  //       anchorType: AnchorType.bottom
  //   );
  //     }
  //   }
  // }

  // disposeAdmobbanner (){
  //   if(adInitiated != null){
  //     _admobBannerAd?.dispose();
  //   }
  // }

  //Admob -- END

}
