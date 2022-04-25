import 'package:flutter/material.dart';
import '../../../constants.dart';

///Header on Email Screen contains features like delete, reply, print, etc
class Header extends StatelessWidget {
  const Header({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          BackButton(color: kGrayColor),
          IconButton(
            icon: Icon(Icons.delete, size: 26, color: kGrayColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.reply, size: 26, color: kGrayColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.reply_all, size: 26, color: kGrayColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.forward, size: 26, color: kGrayColor),
            onPressed: () {},
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.bookmark, size: 26, color: kGrayColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert, size: 26, color: kGrayColor),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
