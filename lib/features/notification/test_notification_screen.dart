import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestNotificationScreen extends StatelessWidget {
  const TestNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Notifications Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await EasyNotify.showBasicNotification(
                  id: 1,
                  title: 'المحموود بيجرب',
                  body: "المحمرد بيجرب برده",
                );
              },
              child: const Text('Show Basic Notification'),
            ),
            ElevatedButton(
              onPressed: () async {
                await EasyNotify.showScheduledNotification(
                
                  id: 2,
                  title: 'Reminder',
                  body: 'This will appear after 10 seconds',
                  duration: Duration(seconds: 5),
                );
              },
              child: const Text('Show Repeated Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
