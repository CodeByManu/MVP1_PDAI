import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNotificationItem(
              context,
              title: 'New Message',
              subtitle: 'You have received a new message.',
              time: '2 min ago',
            ),
            Divider(),
            _buildNotificationItem(
              context,
              title: 'App Update',
              subtitle: 'A new update is available.',
              time: '1 hr ago',
            ),
            Divider(),
            _buildNotificationItem(
              context,
              title: 'Friend Request',
              subtitle: 'You have a new friend request.',
              time: '3 hrs ago',
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Notification Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/main/settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context,
      {required String title,
      required String subtitle,
      required String time}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Icon(Icons.notifications),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            // children: [
            //   IconButton(
            //     icon: Icon(Icons.done),
            //     iconSize: 20,
            //     onPressed: () {
            //       // Mark as read
            //     },
            //   ),
            //   IconButton(
            //     icon: Icon(Icons.delete),
            //     iconSize: 20,
            //     onPressed: () {
            //       // Delete notification
            //     },
            //   ),
            // ],
          ),
        ],
      ),
    );
  }
}
