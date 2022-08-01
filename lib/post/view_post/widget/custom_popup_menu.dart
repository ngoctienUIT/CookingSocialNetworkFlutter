import 'package:cooking_social_network/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customPopupMenu() {
  return PopupMenuButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    offset: const Offset(0, 40),
    itemBuilder: (context) => [
      PopupMenuItem(
        onTap: () {},
        child: Row(
          children: [
            Text(S.current.edit),
            const Spacer(),
            const Icon(FontAwesomeIcons.penToSquare, color: Colors.orange)
          ],
        ),
      ),
      PopupMenuItem(
        onTap: () {},
        child: Row(
          children: [
            Text(S.current.delete, style: const TextStyle(color: Colors.red)),
            const Spacer(),
            const Icon(Icons.delete_rounded, color: Colors.red)
          ],
        ),
      ),
    ],
    child: Container(
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: const Icon(
        FontAwesomeIcons.ellipsis,
        color: Colors.red,
      ),
    ),
  );
}
