import 'package:globe/constants.dart';
import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({
    Key? key,
    required this.title,
    required this.photo,
    required this.subtitle,
    required this.onTap,
    required this.isFollower,
    required this.isFollowing,
  }) : super(key: key);

  final String title;
  final String photo;
  final String subtitle;
  final bool isFollower;
  final bool isFollowing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Row(
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
                    color: grey.withOpacity(0.65),
                  ),
                )
              : const SizedBox(),
          isFollowing
              ? Text(
                  S.of(context).following,
                  style: TextStyle(
                    fontSize: 15,
                    color: grey.withOpacity(0.65),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      subtitle: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: BoxDecoration(
                color: subtitle == 'online'
                    ? onlineColor
                    : grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: subtitle == 'online'
                    ? onlineColor
                    : grey,
              ),
            ),
          ],
        ),
      ),
      trailing: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mainColor,
        ),
        child: photo.isEmpty
            ? Center(
                child: Text(
                  title.toString().toUpperCase()[0],
                  style: TextStyle(fontSize: 30, color: white5),
                ),
              )
            : CircleAvatar(
                backgroundImage: Image.network(photo).image,
              ),
      ),
    );
  }
}
