import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motix_app/data/entity/post.dart';
import 'package:motix_app/data/entity/userImageEntity.dart';
import 'package:motix_app/pages/cubit/profileCubit.dart';
import '../../data/auth/Auth.dart';
import '../cubit/imageCubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    final User? user = Auth().currentUser;
    context.read<Imagecubit>().getUserImage(user?.email ?? "");
    context.read<ProfileCubit>().getAllPostByEmail(user?.email ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final User? user = Auth().currentUser;

    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<Imagecubit, List<UserImageEntity>>(
            builder: (context, userImageList) {
              if (userImageList.isNotEmpty) {
                return Column(
                  children: [
                    _buildHeader(screenHeight, userImageList.first.profileIcon),
                    SizedBox(height: screenHeight * 0.07),
                    UserName(name: userImageList.first.userName),
                    SizedBox(height: screenHeight * 0.01),
                    UserMail(email: userImageList.first.userEmail),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                );
              } else if (userImageList.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 8.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFed7d32)),
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
          BlocBuilder<ProfileCubit, List<Post>>(
            builder: (context, postList) {
              if (postList.isNotEmpty) {
                return Expanded(
                  child: Column(
                    children: [
                      PostLine(postCount: postList.length),
                      Expanded(child: _buildPostList(screenHeight, postList)),
                    ],
                  ),
                );
              } else if (postList.isEmpty) {
                return Container();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

Widget _buildHeader(double screenHeight, String imageUrl) {
  return Container(
    height: screenHeight * 0.3,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFFBCFAD),
          Color.fromARGB(0, 254, 138, 71),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Center(
      child: Transform.translate(
        offset: Offset(0, screenHeight * 0.1),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 15,
              ),
            ],
          ),
          child: Ellipse3(imageUrl:imageUrl),
        ),
      ),
    ),
  );
}




  Widget _buildPostList(double screenHeight, List<Post> postList) {
    return ListView.builder(
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return PostCard(post: postList[index]);
      },
    );
  }
}

class Ellipse3 extends StatelessWidget {
  final String imageUrl;
  const Ellipse3({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    final double imageSize = MediaQuery.of(context).size.width * 0.45;

    return Container(
      width: imageSize,
      height: imageSize,
      decoration: const ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(width: 6, color: Colors.white),
        ),
      ),
      child:  ClipOval(
        child: SvgPicture.asset(
          "assets/animalIcon/$imageUrl.svg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class UserName extends StatelessWidget {
  final String name;
  const UserName({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.05,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class UserMail extends StatelessWidget {
  final String email;
  const UserMail({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          email,
          style: TextStyle(
            color: const Color(0xFFE38343),
            fontSize: screenWidth * 0.033,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class PostLine extends StatelessWidget {
  final int postCount;
  const PostLine({required this.postCount, super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Text(
          'Gönderilerim',
          style: TextStyle(
            color: const Color(0xFFE38343),
            fontSize: screenWidth * 0.035,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          width: screenWidth * 0.9,
          height: 1,
          color: const Color(0xFFCAC4C4),
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({required this.post , super.key});



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                onPressed: (){
                  context.read<ProfileCubit>().delete(post.postId);
                },
                icon: Icon(Icons.delete),
                color: Color (0xFFed7d32),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.postTitle,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    post.postDescription,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
