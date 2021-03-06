import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:luan_van/main.dart';
import 'package:luan_van/testChat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// The [SharedPreferences] key to access the alarm fire count.
const String countKey = 'count';

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

/// Global [SharedPreferences] object.
SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );
  prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(countKey)) {
    await prefs.setInt(countKey, 0);
  }
  await AndroidAlarmManager.initialize();
  runApp(AlarmManagerExampleApp());
  await AndroidAlarmManager.periodic(
    const Duration(minutes: 5), //Do the same every 24 hours
    Random().nextInt(pow(2, 31).toInt()), //Different ID for each alarm
    testAlarm,
    wakeup: true, //the device will be woken up when the alarm fires
    startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 19, 10), //Start whit the specific time 5:00 am
    rescheduleOnReboot: true, //Work after reboot
  );
}

Future<void> testAlarm() async {
  print("In nè + ");
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',//Cái này hiện tên trong cài đặt
    channelDescription: "your channel description",
    sound: RawResourceAndroidNotificationSound("noti"),
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    icon: "eaten",
  );

  var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    5,
    'New Post',
    'Alarm: '+DateTime.now().minute.toString(),
    platformChannelSpecifics,
    payload: 'Custom_Sound',
  );
}

/// Example app for Espresso plugin.
class AlarmManagerExampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: _AlarmHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class _AlarmHomePage extends StatefulWidget {
  _AlarmHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<_AlarmHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();

    // Register for events from the background isolate. These messages will
    // always coincide with an alarm firing.
    port.listen((_) async => await _incrementCounter());

  }

  Future<void> _incrementCounter() async {
    print('Increment counter!');

    // Ensure we've loaded the updated count from the background isolate.
    await prefs.reload();

    setState(() {
      _counter++;
    });
  }

  // The background
  static SendPort uiSendPort;

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');

    // Get the previous cached count and increment it.
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt(countKey) ?? 0;
    await prefs.setInt(countKey, currentCount + 1);

    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alarm fired $_counter times',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Total alarms fired: ',
                  style: textStyle,
                ),
                Text(
                  prefs.getInt(countKey).toString(),
                  key: ValueKey('BackgroundCountText'),
                  style: textStyle,
                ),
              ],
            ),
            ElevatedButton(
              child: Text(
                'Schedule OneShot Alarm',
              ),
              key: ValueKey('RegisterOneShotAlarm'),
              onPressed: () async {
                await AndroidAlarmManager.oneShot(
                  const Duration(seconds: 5),
                  // Ensure we have a unique alarm ID.
                  Random().nextInt(pow(2, 31).toInt()),
                  callback,
                  exact: true,
                  wakeup: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}