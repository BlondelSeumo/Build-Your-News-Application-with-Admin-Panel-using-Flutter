import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../utils/next_screen.dart';

class VideoArticleDetails extends StatefulWidget {
  final Article data;
  final String tag;
  const VideoArticleDetails({Key key, @required this.data, @required this.tag})
      : super(key: key);

  @override
  _VideoArticleDetailsState createState() => _VideoArticleDetailsState();
}

class _VideoArticleDetailsState extends State<VideoArticleDetails> {
  double rightPaddingValue = 140;
  YoutubePlayerController _controller;
  bool adInitiated;

  initYoutube() async {
    _controller = YoutubePlayerController(
        initialVideoId: widget.data.videoID,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          loop: true,
          controlsVisibleAtStart: false,
          enableCaption: false,
        ));
  }

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
    //initiateAdmobInterstitial();  //admob
    //initFbInterstitialAd();    //fb

    initYoutube();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    //disposeAdmobInterstitial(); //admob
    //disposefbInterstitial();  //fb

    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final Article d = widget.data;

    return Scaffold(
        key: Key(widget.data.timestamp),
        body: SafeArea(
          bottom: false,
          top: true,
          child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                thumbnail:
                    CustomCacheImage(imageUrl: d.thumbnailImagelUrl, radius: 0),
                onReady: () {},
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: player,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.keyboard_backspace,
                                    size: 22, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.share,
                                    size: 22, color: Colors.white),
                                onPressed: () {
                                  _handleShare();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
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
                                      borderRadius: BorderRadius.circular(5),
                                      color: context
                                                  .watch<ThemeBloc>()
                                                  .darkTheme ==
                                              false
                                          ? CustomColor().loadingColorLight
                                          : CustomColor().loadingColorDark,
                                    ),
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 1000),
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
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                      margin:
                                          EdgeInsets.only(top: 8, bottom: 8),
                                      child: Chip(
                                        backgroundColor: context
                                                    .watch<ThemeBloc>()
                                                    .darkTheme ==
                                                false
                                            ? CustomColor().loadingColorLight
                                            : CustomColor().loadingColorDark,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
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
                                                  fontWeight: FontWeight.w500),
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
                                      shape: MaterialStateProperty.resolveWith(
                                          (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3)))),
                                  icon: Icon(Icons.comment,
                                      color: Colors.black87, size: 20),
                                  label: Text('comments',
                                          style:
                                              TextStyle(color: Colors.black87))
                                      .tr(),
                                  onPressed: () {
                                    _controller.pause();
                                    nextScreen(context,
                                        CommentsPage(timestamp: d.timestamp));
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
                                    fontSize: FontSize(17),
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).primaryColorDark)
                              },
                              data: '''${d.description}''',
                              onLinkTap: (url) async {
                                launchURL(context, url);
                              },
                              onImageTap: (imageUrl) => nextScreenPopup(
                                  context, FullScreeImage(imageUrl: imageUrl)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: RelatedArticles(
                              category: d.category,
                              timestamp: d.timestamp,
                              replace: true,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ));
  }

  //Admob ads -- START

  // InterstitialAd _admobInterstitialAd;

  // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   nonPersonalizedAds: true,
  // );

  // InterstitialAd createAdmobInterstitialAd() {
  //   return InterstitialAd(
  //     adUnitId: Platform.isAndroid ? Config().admobInterstitialAdIdAndroid : Config().admobInterstitialAdIdiOS,
  //     targetingInfo: targetingInfo,
  //     listener: (MobileAdEvent event) {
  //       print("InterstitialAd event $event");
  //     },
  //   );
  // }

  // initiateAdmobInterstitial (){
  //   if(mounted){
  //     if(context.read<AdsBloc>().interstitialAd == true){
  //       adInitiated = true;
  //       _admobInterstitialAd = createAdmobInterstitialAd()..load()..show();
  //     }
  //   }
  // }

  // disposeAdmobInterstitial (){
  //   if(adInitiated != null){
  //     _admobInterstitialAd?.dispose();
  //   }
  // }

  //admob ads -- END

  //fb ads -- START

  // initFbInterstitialAd() {
  //   if (mounted) {
  //     if (context.read<AdsBloc>().interstitialAd == true) {
  //       adInitiated = true;
  //       FacebookInterstitialAd.loadInterstitialAd(
  //         placementId: Platform.isAndroid ? Config().fbInterstitalAdIDAndroid : Config().fbInterstitalAdIDiOS,
  //         listener: (result, value) {
  //           print('fb=-------------------$result + $value');
  //           if (result == InterstitialAdResult.LOADED){
  //             FacebookInterstitialAd.showInterstitialAd();
  //           }
  //           if (result == InterstitialAdResult.ERROR && value["invalidated"] == true) {
  //             print('fb interstitial : $result');

  //           }
  //         },
  //       );

  //     }
  //   }
  // }

  // disposefbInterstitial()async {
  //   if(adInitiated != null){
  //     FacebookInterstitialAd.destroyInterstitialAd();
  //   }
  // }

  //fb ads -- END

}
