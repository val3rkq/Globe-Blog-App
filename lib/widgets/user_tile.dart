import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {Key? key, required this.title, required this.subtitle, required this.onTap,})
      : super(key: key);

  final String title;
  final String subtitle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      subtitle: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 3.5),
              decoration: BoxDecoration(
                color: subtitle == 'online' ? Colors.lightGreenAccent : Colors.grey[500],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5,),
            Text(
              subtitle,
              style: TextStyle(
                color: subtitle == 'online' ? Colors.lightGreenAccent : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.circle,
        ),
        width: 45,
        height: 45,
      ),
    );
  }
}
