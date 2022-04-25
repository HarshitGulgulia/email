import 'package:flutter/material.dart';
import '../../Database/database_bin_emails_helper.dart';
import '../../Database/database_draft_emails_helper.dart';
import '../../Database/database_inbox_emails_helper.dart';
import '../../Database/database_sent_emails_helper.dart';
import '../../Database/database_user_helper.dart';
import '../../services/authapi.dart';
import '../login/login_screen.dart';

///Stateless widget for showing error while loading mail from server
class MailLoadingError extends StatelessWidget {
  const MailLoadingError({Key key, this.error}) : super(key: key);
  final AsyncSnapshot<String> error;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                'Error: ${error.error}',
                style: TextStyle(fontSize: 10),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await GoogleAuthApi.signOut();
                // await DatabaseEmailsHelper.instance.deleteDatabase();
                await DatabaseUserHelper.instance.delete();
                await DatabaseInboxEmailsHelper.instance.delete();
                await DatabaseSentEmailsHelper.instance.delete();
                await DatabaseDraftEmailsHelper.instance.delete();
                await DatabaseBinEmailsHelper.instance.delete();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
