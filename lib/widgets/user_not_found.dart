import 'package:globe/generated/l10n.dart';
import 'package:flutter/material.dart';

class UserNotFound extends StatelessWidget {
  const UserNotFound({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text(
              S.of(context).user_is_not_found,
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Icon(
              Icons.no_accounts_rounded,
              color: Colors.grey,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}