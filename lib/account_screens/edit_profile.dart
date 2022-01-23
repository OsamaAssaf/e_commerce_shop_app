import 'package:flutter/material.dart';
import 'package:osama_shop/account_screens/change_nickname.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/controllers/push_screens.dart';
import 'package:osama_shop/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.setCenterAppBar('Edit Profile', context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildListTile(
                'Nickname',
                Text(context.watch<Auth>().user!.email != null
                    ? context.watch<Auth>().user!.email!.split('@')[0]
                    : context.watch<Auth>().user!.phoneNumber!),
                (){PushScreens.pushScreens(context,const ChangeName());}
            ),
            const Divider(),
            buildListTile('My QR Code', const Icon(Icons.qr_code_2),(){}),
            const Divider(),
            buildListTile('Bio', const Text('About me...'),(){}),
            Container(
              height: 30,
              width: double.infinity,
              color: Theme.of(context).dividerColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'The following content will be kept confidential.',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
            buildListTile('My QR Code', const Text('Category and style, etc.'),(){}),
            const Divider(),
            buildListTile('Bio', const Text('Not set'),(){}),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(String title, Widget widget, Function() onTap) {
    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: 300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [widget, const Icon(Icons.arrow_forward_ios)],
        ),
      ),
      onTap: onTap,
    );
  }
}
