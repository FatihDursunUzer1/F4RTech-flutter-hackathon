import 'dart:ui';

import 'package:education/app/colors/colors.dart';
import 'package:education/app/constants.dart';
import 'package:education/app/helper.dart';
import 'package:education/services/authentication.dart';
import 'package:education/services/firestoredbservice.dart';
import 'package:education/ui/donate_page/donate_page.dart';
import 'package:education/ui/login_page/login_page.dart';
import 'package:education/ui/post_detail_page/post_detail_page.dart';
import 'package:education/ui/post_page/post_page_model.dart';
import 'package:education/ui/post_page/posts_page_services.dart';
import 'package:education/widget/UserWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';

import '../background.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostPageServices _postPageServices = PostPageServices();
  final PostPageModel model = PostPageModel();
  final FirestoreDBService _firestoreDBService = FirestoreDBService();
  var photoNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundContainer(context),
        Scaffold(
          appBar: AppBar(
              title: Text('Forum', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          body: Container(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: _firestoreDBService.getCurrentUser(),
                builder: (context, auth) {
                  if (auth.hasData) {
                    return FutureBuilder(
                      future: _postPageServices.getAllStudent(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailPage(snapshot.data[index])));
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorTable.textColor.withOpacity(0.05),
                                                blurRadius: 8,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              FutureBuilder(
                                                  future: _postPageServices.initUser(snapshot.data[index].publisher),
                                                  builder: (BuildContext context, AsyncSnapshot sp) {
                                                    if (sp.hasData) {
                                                      return UserWidget(
                                                          rozet: '${Helper.UserIconLevel(sp.data)[1]}',
                                                          username: sp.data.username,
                                                          seviye: '${Helper.UserIconLevel(sp.data)[0]}');
                                                    } else {
                                                      return Center(
                                                        child: LoadingBouncingGrid.square(
                                                          size: 30,
                                                          backgroundColor: Colors.white,
                                                        ),
                                                      );
                                                    }
                                                  }),
                                              Container(
                                                height: Constants.getHeight(context) / 4,
                                                width: Constants.getWidth(context),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      child: Image.asset(
                                                        'assets/student/${int.parse(snapshot.data[index].uid) % 17 + 1}.png',
                                                        fit: BoxFit.contain,
                                                        height: Constants.getHeight(context) / 5,
                                                        width: Constants.getWidth(context) / 2.5,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        StudentInfo('Öğrenci Adı-Soyadı', snapshot.data[index].fullname),
                                                        StudentInfo('Öğrenci Yaşı', snapshot.data[index].age.toString()),
                                                        StudentInfo('Sınıfı', snapshot.data[index].classOfStudent.toString()),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 20.0),
                                                child: Container(
                                                    height: Constants.getHeight(context) / 14.22,
                                                    width: Constants.getWidth(context),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            _postPageServices.likeorDislike(snapshot.data[index], auth.data);
                                                            setState(() {
                                                              snapshot.data[index].likeCount;
                                                            });
                                                          },
                                                          child: Column(
                                                            children: [
                                                              snapshot.data[index].listOfLikes.contains(auth.data.uid)
                                                                  ? Icon(Icons.star)
                                                                  : Icon(Icons.star_border),
                                                              Text(
                                                                '${snapshot.data[index].likeCount} yıldız',
                                                                style: GoogleFonts.crimsonText(fontSize: 9),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (context) => PostDetailPage(snapshot.data[index])));
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Icon(Icons.messenger_outline),
                                                              Text(
                                                                '${snapshot.data[index].listOfComments.length} yorum',
                                                                style: GoogleFonts.crimsonText(fontSize: 9),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => DonatePage(
                                                                      auth.data,
                                                                      snapshot.data[index],
                                                                    )));
                                                            setState(() {
                                                              snapshot.data[index].donationCount;
                                                            });
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Icon(Icons.money_sharp),
                                                              Text(
                                                                '${snapshot.data[index].donationCount} Bağış',
                                                                style: GoogleFonts.crimsonText(fontSize: 9),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: Constants.getWidth(context) / 20.55,
                                        top: Constants.getHeight(context) / 71.1,
                                        child: Container(
                                            width: Constants.getWidth(context) / 3.1,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  snapshot.data[index].approvalStatus ? Icons.verified : Icons.adjust_outlined,
                                                  color: snapshot.data[index].approvalStatus ? Colors.green : Colors.yellow.shade700,
                                                  size: 35,
                                                ),
                                                Text(
                                                  '${snapshot.data[index].approvalStatus ? 'Onaylandı' : 'Onay Bekliyor'}',
                                                  style: GoogleFonts.lemonada(fontSize: Constants.getHeight(context) / 71.1),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: LoadingBouncingGrid.square(
                              size: 30,
                              backgroundColor: Colors.white,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: LoadingBouncingGrid.square(
                        size: 30,
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget StudentInfo(String s, String data) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s,
              style: GoogleFonts.poppins(fontSize: Constants.getHeight(context) / 59.25, fontWeight: FontWeight.w700),
            ),
            Container(
                alignment: Alignment.center,
                height: Constants.getHeight(context) / 23.7,
                width: Constants.getWidth(context) / 2.74,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white.withOpacity(0.7),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                child: Text(
                  data,
                  style: GoogleFonts.poppins(fontSize: Constants.getHeight(context) / 59.25),
                )),
          ],
        ),
      ),
    );
  }
}
