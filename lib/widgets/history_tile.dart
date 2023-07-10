import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    Key? key,
    required this.title,
    required this.onTap,
    required this.onDelete,
    required this.isFollower,
    required this.isFollowing,
  }) : super(key: key);

  final String title;
  final void Function()? onTap;

  final bool isFollower;
  final bool isFollowing;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 10),
      onTap: onTap,
      title: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Colors.lime,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Text(title),
                const SizedBox(
                  width: 10,
                ),
                isFollower
                    ? Text(
                        S.of(context).follower,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.withOpacity(0.65),
                        ),
                      )
                    : const SizedBox(),
                isFollowing
                    ? Text(
                        S.of(context).following,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.withOpacity(0.65),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(Icons.close_rounded),
      ),
    );
  }
}
