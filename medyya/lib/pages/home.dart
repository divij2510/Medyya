import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medyya/constants.dart';
import 'package:medyya/controllers/notification_controller.dart';
import 'package:medyya/controllers/post_controller.dart';
import 'package:medyya/controllers/profile_controller.dart';
import 'package:medyya/models/post_model.dart';
import 'package:medyya/models/profile_model.dart';
import 'package:medyya/components/post.dart';
import 'package:medyya/pages/connectionpage.dart';
import 'package:medyya/pages/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'make_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PostModel> posts = [];
  UserProfile? profile;
  SharedPreferences? p;
  String tkn = '';
  GetPosts? gp;
  GetNotifications? gn;
  GetProfile? gpr;
  int selected_index = 1;

  Future<List<PostModel>> fetch_posts({required GetPosts? gp}) async {
    posts = (await gp?.get_posts()) ?? [];
    if (posts.isEmpty) {
      // If so, navigate to the login page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return const LoginPage();
        }),
      );
    }
    setState(() {
      //toggle rebuild
    });
    return posts;
  }

  Future<UserProfile?> fetch_profile({required GetProfile? gpr}) async {
    profile = await gpr?.get_profile();
    setState(() {
      //toggle rebuild
    });
    if (profile?.firstName == '' || profile?.lastName == '') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return UpdateProfilePage(profile: profile!, tkn:tkn);
      }));
    }
    return profile;
  }

  void _bottomnavtap(int index) {
    setState(() {
      selected_index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pr) {
      p = pr;
      tkn = p!.getString('authToken') ?? '';
      gp = GetPosts(token: tkn);
      gn = GetNotifications(token: tkn);
      gpr = GetProfile(token: tkn);
      fetch_posts(gp: gp);
      fetch_profile(gpr: gpr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          indicatorColor: darkpink,
          overlayColor: const MaterialStatePropertyAll(Colors.pinkAccent),
          surfaceTintColor: darkpink,
          selectedIndex: selected_index,
          onDestinationSelected: _bottomnavtap,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.add_a_photo_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              label: 'post',
            ),
            NavigationDestination(
                icon: Icon(
                  Icons.house_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.house,
                  color: Colors.white,
                ),
                label: 'home'),
            NavigationDestination(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                label: 'notifications'),
          ],
          backgroundColor: darkpink,
          elevation: 100,
        ),
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
                  icon: ClipOval(
                      child: Image.network(
                    media_url +
                        ((profile != null)
                            ? profile!.profilePicture
                            : 'image/upload/v1713565892/bpwwih53rqle48wt7bsw.png'),
                    height: 27,
                    width: 28,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          surfaceTintColor: Colors.pink,
          child: Container(
            decoration: BoxDecoration(color: darkpink),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, bottom: 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, left: 17, bottom: 10),
                        child: ClipOval(
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              media_url + (profile?.profilePicture ?? ''),
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: CircularProgressIndicator(
                                    color: lightpink,
                                    strokeWidth: 120,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17.0),
                        child: Text(
                          '${profile?.firstName ?? ''} ${profile?.lastName ?? ''}',
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
                            padding: const EdgeInsets.only(left: 17.0),
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
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 17),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Divider(
                    height: 1,
                    color: lightpink,
                    indent: 17,
                    endIndent: 17,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 17.0, right: 210, top: 6),
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
                          left: 17.0, top: 0, bottom: 8, right: 20),
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
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Divider(
                    height: 1,
                    color: lightpink,
                    indent: 17,
                    endIndent: 17,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListTile(
                    focusColor: Colors.pink[50],
                    trailing: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Edit Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return UpdateProfilePage(
                            profile: profile ??
                                UserProfile(
                                    bio: 'default',
                                    connectionsCount: 0,
                                    firstName: 'default',
                                    lastName: 'default',
                                    profilePicture: '',
                                    username: 'default'),
                            tkn: tkn);
                      }));
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListTile(
                    tileColor: Colors.black,
                    selectedTileColor: lightpink,
                    focusColor: Colors.pink[50],
                    trailing: const Icon(
                      Icons.door_back_door_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      p?.clear();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const LoginPage();
                      }));
                    },
                  ),
                ),
                const SizedBox(
                  height: 27,
                ),
              ],
            ),
          ),
        ),
        body: (selected_index == 1)
            ? RefreshIndicator(
                onRefresh: () {
                  return fetch_posts(gp: gp);
                },
                color: darkpink,

                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Post(
                      post: posts[index],
                      gp: gp,
                      tkn: tkn,
                      gn: gn,
                      myprofile: profile,
                    );
                  },
                  addAutomaticKeepAlives: true,
                  cacheExtent: 1600,
                ),
              )
            : (selected_index == 0)
                ? CreatePost(gp: gp)
                : ConnectionPage(tkn: tkn));
  }
}
