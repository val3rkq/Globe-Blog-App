import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:flutter/material.dart';

class NoUsers extends StatelessWidget {
  const NoUsers({
    super.key,
    required this.context,
    required this.users,
  });

  final BuildContext context;
  final String users;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text(
              '${S.of(context).no_users} ${users.toLowerCase()}',
              style: TextStyle(fontSize: 25, color: grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Icon(
              Icons.no_accounts_rounded,
              color: grey,
              size: 70,
            )
          ],
        ),
      ),
    );
  }
}