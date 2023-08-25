import 'package:flutter/material.dart';

class GenderSelectionDialouge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Text(
            'Which Gender do you Identify As?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          Text(
            '',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Row(
              children: [
                Text(
                  'Male',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '👱‍♂️',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Text(
                  'Female',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '👩‍🦰',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Text(
                  'Prefer Not to Say',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '❌',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
    );
  }
}
