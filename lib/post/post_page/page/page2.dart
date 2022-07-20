import 'package:cooking_social_network/model/post.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Page2 extends StatefulWidget {
  const Page2({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _serversController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _serversController.text = widget.post.servers;
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.red),
              width: double.infinity,
              child: const Text(
                "Một công thức mới ư? Hãy bắt đầu nào",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  itemPage(
                      title: "Khẩu phần",
                      content: "vd: Khẩu phần ăn 1 người",
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
                  timePickerItem(
                      context: context,
                      title: "Thời gian chuẩn bị",
                      content: "Món ăn được làm trong bao lâu",
                      hint: "10 phút"),
                ],
              ),
            )
          ],
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
            initialRating: widget.post.level,
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
              widget.post.level = rating;
            },
          ),
        )
      ],
    );
  }

  Row itemPage(
      {required String title, required String content, required String hint}) {
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
            controller: _serversController,
            onChanged: (text) {
              widget.post.servers = text;
            },
            decoration: InputDecoration(hintText: hint),
          ),
        )
      ],
    );
  }

  Row timePickerItem(
      {required BuildContext context,
      required String title,
      required String content,
      required String hint}) {
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
            child: InkWell(
                onTap: () async {
                  var time = await showDurationPicker(
                    context: context,
                    initialTime: Duration(
                        minutes: int.parse(widget.post.cookingTime.toString())),
                  );
                  if (time != null) {
                    setState(() {
                      widget.post.cookingTime = time.inMinutes;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.red),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      "${widget.post.cookingTime} phút",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )))
      ],
    );
  }

  TextStyle textStyleTitle() {
    return const TextStyle(
        fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold);
  }
}
