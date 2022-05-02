import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/Email.dart';

class EmailScreenDetails extends StatefulWidget {
  const EmailScreenDetails({
    Key key,
    this.email,
  }) : super(key: key);

  final Email email;
  @override
  State<EmailScreenDetails> createState() => _EmailScreenDetailsState();
}

class _EmailScreenDetailsState extends State<EmailScreenDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: ColorList['${widget.email.name[0].toUpperCase()}'],
              child: Text(
                widget.email.name[0].toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26
                ),
              ),
              radius: 26,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.email.name,
                    style: TextStyle(fontSize: 18),
                    //style: Theme.of(context).textTheme.button,
                  ),
                  Text(
                    widget.email.from_email,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              widget.email.time,
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(width: kDefaultPadding / 2),
          ],
        ),
        SizedBox(height: kDefaultPadding),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.email.subject,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ],
    );
  }
}
