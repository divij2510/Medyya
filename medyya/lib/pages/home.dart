import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medyya/constants.dart';
import 'package:medyya/controllers/post_controller.dart';
import 'package:medyya/controllers/profile_controller.dart';
import 'package:medyya/models/post_model.dart';
import 'package:medyya/models/profile_model.dart';
import 'package:medyya/components/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> posts = [];
  UserProfile? profile;
  SharedPreferences? p;
  String? tkn;
  GetPosts? gp;
  GetProfile? gpr;

  Future<List<PostModel>> fetch_posts(
      {required String? token,
      required SharedPreferences? prefs,
      required GetPosts? gp}) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken');
    gp = GetPosts(token: token);
    posts = await gp.get_posts();
    if (posts.isEmpty) {
      // If so, navigate to the login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    }
    setState(() {
      //toggle rebuild
    });
    return posts;
  }

  Future<UserProfile?> fetch_profile(
      {required String? token,
      required SharedPreferences? prefs,
      required GetProfile? gpr}) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('authToken');
    gpr = GetProfile(token: token);
    profile = await gpr.get_profile();
    print('heyyyyyyyyyyyyy:' + '${profile?.profilePicture}');
    setState(() {
      //toggle rebuild
    });
    return profile;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pr) {
      p = pr;
      tkn = p?.getString('authToken');
      gp = GetPosts(token: tkn);
      gpr = GetProfile(token: tkn);
      fetch_posts(token: tkn, prefs: p, gp: gp);
      fetch_profile(token: tkn, prefs: p, gpr: gpr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkpink,
        centerTitle: true,
        foregroundColor: lightpink,
        title: const Text(
          'MEDYYA',
          style: TextStyle(letterSpacing: 12, fontWeight: FontWeight.w300),
        ),
        actions: [
          Tooltip(
            message: MaterialLocalizations.of(context).openAppDrawerTooltip,
            child: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.supervised_user_circle_outlined),
              ),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        surfaceTintColor: Colors.pink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 35,
            ),
            Card(
              color: darkpink,
              child: Padding(
                padding: const EdgeInsets.only(top: 13, bottom: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, bottom: 10),
                      child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                              hosting_url + (profile?.profilePicture ?? ''),
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        profile?.fullName ?? '',
                        style: TextStyle(
                          color: lightpink,
                          fontWeight: FontWeight.w500,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            '@${profile?.username ?? ''}',
                            style: TextStyle(
                              fontSize: 17,
                              color: lightpink,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(
                          Icons.supervised_user_circle_outlined,
                          color: Colors.grey,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${profile?.connectionsCount} Connections',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 17),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: darkpink,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 210, top: 6),
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: lightpink,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 0, bottom: 8, right: 20),
                    child: Text(
                      profile?.bio ?? '',
                      style: TextStyle(
                        fontSize: 17,
                        color: lightpink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              focusColor: Colors.pink[50],
              // style: ListTileStyle(
              //
              // ),
              title: const Text(
                'Logout',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {
                p?.clear();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return Post(post: posts[index], gp: gp, p: p, tkn: tkn);
          }),
    );
  }
}
