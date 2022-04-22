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
    return Row(
      children: [
        CircleAvatar(
          maxRadius: 24,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage(widget.email.image),
        ),
        SizedBox(width:kDefaultPadding/2),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: widget.email.name,
                  style: Theme.of(context)
                      .textTheme
                      .button,
                  children: [
                    TextSpan(
                        text:
                        widget.email.from_email,
                        style: Theme.of(context)
                            .textTheme
                            .caption),
                  ],
                ),
              ),
              Text(
                widget.email.subject,
                style: Theme.of(context)
                    .textTheme
                    .headline6,
              )
            ],
          ),
        ),
        SizedBox(width: kDefaultPadding / 2),
        Text(
          widget.email.time,
          style:
          Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
