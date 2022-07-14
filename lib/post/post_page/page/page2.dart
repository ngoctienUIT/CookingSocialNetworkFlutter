import 'package:cooking_social_network/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Page2 extends StatelessWidget {
  Page2({Key? key, required this.post}) : super(key: key);
  Post post;
  final TextEditingController _serversController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _serversController.addListener(() {
      post.servers = _serversController.text;
    });
    _timeController.addListener(() {
      // post.
    });
    return Form(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              itemPage(
                  title: "Khẩu phần",
                  content: "vd: Khẩu phần ăn 1 người",
                  controller: _serversController,
                  hint: "1 người"),
              const SizedBox(height: 30),
              const SizedBox(
                height: 10,
                width: double.infinity,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              rateItemPage(
                  title: "Độ khó",
                  content: "content",
                  controller: _serversController),
              const SizedBox(height: 30),
              const SizedBox(
                height: 20,
                width: double.infinity,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              itemPage(
                  title: "Thời gian chuẩn bị",
                  content: "Món ăn được làm trong bao lâu",
                  controller: _timeController,
                  hint: "10 phút"),
            ],
          ),
        ),
      ),
    );
  }

  Row rateItemPage(
      {required String title,
      required String content,
      required TextEditingController controller}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyleTitle(),
              ),
              const SizedBox(height: 5),
              Text(
                content,
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 200,
          child: RatingBar.builder(
            itemSize: 30,
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              post.level = rating;
            },
          ),
        )
      ],
    );
  }

  Row itemPage(
      {required String title,
      required String content,
      required String hint,
      required TextEditingController controller}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyleTitle(),
              ),
              const SizedBox(height: 5),
              Text(
                content,
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
        )
      ],
    );
  }

  TextStyle textStyleTitle() {
    return const TextStyle(
        fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);
  }
}
