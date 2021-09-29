import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social/componentes/post.dart';
import 'package:social/models/post_model.dart';
import 'package:social/providers/auth_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<PostModel>>(
        future: Provider.of<AuthProvider>(context).getPosts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
          if (snapshot.hasData) {

            return SmartRefresher(

              controller: _refreshController,
             onRefresh: (){
               setState(() {});
               _refreshController.refreshCompleted();
             },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
 /*                   Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 3),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * .25,
                        child: Image(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://image.freepik.com/free-photo/beautiful-asian-woman-talking-magaphone_8087-3737.jpg"),
                        ),
                      ),
                    ),*/
                    ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Post(post:snapshot.data![index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 8,
                          );
                        },
                        itemCount: Provider.of<AuthProvider>(context).posts.length
                        ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
