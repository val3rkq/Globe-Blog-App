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
              style: const TextStyle(fontSize: 25, color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Icon(
              Icons.no_accounts_rounded,
              color: Colors.grey,
              size: 70,
            )
          ],
        ),
      ),
    );
  }
}