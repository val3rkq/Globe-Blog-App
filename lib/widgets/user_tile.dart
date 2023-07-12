import 'package:flutter/material.dart';
import 'package:globe/constants.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {Key? key, required this.title, required this.subtitle, required this.onTap, required this.photo,})
      : super(key: key);

  final String title;
  final String subtitle;
  final String photo;
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
                color: subtitle == 'online' ? onlineColor : grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5,),
            Text(
              subtitle,
              style: TextStyle(
                color: subtitle == 'online' ? onlineColor : grey,
              ),
            ),
          ],
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mainColor,
        ),
        width: 45,
        height: 45,
        child: photo.isEmpty ?
        Center(
          child: Text(
            title
                .toString()
                .toUpperCase()[0],
            style: TextStyle(
                fontSize: 25, color: white5),
          ),
        ) : CircleAvatar(
          backgroundImage:
          Image.network(photo).image,
        ),
      ),
    );
  }
}
