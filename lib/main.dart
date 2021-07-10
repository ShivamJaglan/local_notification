import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// import 'package:timezone/timezone.dart' as tz;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterLocalNotificationsPlugin fltrNotification =
      FlutterLocalNotificationsPlugin();
  String? timeZoneName;
  @override
  void initState() {
    FlutterNativeTimezone.getLocalTimezone().then((value) {
      print(value);
      timeZoneName = value;
      tz.initializeTimeZones();

      tz.setLocalLocation(tz.getLocation(timeZoneName!));
    }).catchError((error) {
      print(error);
    });
    super.initState();
    //  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS, android: initializationSettingsAndroid);
    fltrNotification.initialize(
      initializationSettings,
    );
  }

  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await fltrNotification.show(
        0, "Task", "You created a Task", generalNotificationDetails,
        payload: "Task");
  }

  @override
  Widget build(BuildContext context) {
    // tz.initializeTimeZones();

    // tz.setLocalLocation(tz.getLocation(timeZoneName!));
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    // Find the 'current location'
    // final location = await timeZone.getLocation(timeZoneName);

    // final scheduledDate = tz.TZDateTime.from(dateTime, location);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                var scheduledTime = DateTime.now().add(Duration(seconds: 5));
                // fltrNotification.zonedSchedule(1, "Times Uppp", "scheduled task",
                //     scheduledTime, generalNotificationDetails,
                //     uiLocalNotificationDateInterpretation:
                //         uiLocalNotificationDateInterpretation,
                //     androidAllowWhileIdle: true);
                fltrNotification.zonedSchedule(
                    0,
                    'scheduled title',
                    'scheduled body',
                    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15)),
                    const NotificationDetails(
                        android: AndroidNotificationDetails(
                            'fettl', 'iyatttt', 'no tears')),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);
                // .schedule(1, "Times Uppp", task,
                // scheduledTime, generalNotificationDetails);
              },
              child: Text("scheduled one"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotification,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
