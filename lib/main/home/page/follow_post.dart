import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FollowPost extends StatelessWidget {
  const FollowPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: null,
        builder: (context, snapshot) {
          return GridView.builder(
              itemCount: 30,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                  child: Image.network(
                                    index % 2 == 0
                                        ? "https://i.9mobi.vn/cf/Images/tt/2021/8/20/anh-avatar-dep-39.jpg"
                                        : "https://inkythuatso.com/uploads/thumbnails/800/2022/03/anh-dai-dien-anime-nam-2-30-15-33-56.jpg",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tên món",
                            style: TextStyle(
                                color: Color.fromRGBO(64, 70, 78, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Spacer(),
                              Text(
                                "120 phút",
                                style: TextStyle(
                                  color: Color.fromRGBO(160, 164, 167, 1),
                                ),
                              ),
                              Spacer(),
                              Text(
                                "3/5",
                                style: TextStyle(
                                  color: Color.fromRGBO(160, 164, 167, 1),
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellowAccent,
                                size: 18,
                              ),
                              Spacer(),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              reactWidget(
                                  icon: Icons.favorite_border_rounded,
                                  color: Colors.red,
                                  size: 24,
                                  text: "123"),
                              const Spacer(),
                              reactWidget(
                                  icon: FontAwesomeIcons.comment,
                                  color: Colors.green,
                                  text: "123"),
                              const Spacer(),
                              reactWidget(
                                  icon: FontAwesomeIcons.share,
                                  color: Colors.green,
                                  text: "123"),
                              const Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Column reactWidget(
      {required IconData icon,
      required Color color,
      double size = 20,
      required String text}) {
    return Column(
      children: [
        Icon(
          icon,
          size: size,
          color: color,
        ),
        const SizedBox(height: 2),
        Text(text, style: const TextStyle(fontSize: 12))
      ],
    );
  }
}
