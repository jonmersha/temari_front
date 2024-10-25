import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:temari/core/settings/remote_config.dart';

class VersionCheckScreen extends StatefulWidget {
  @override
  _VersionCheckScreenState createState() => _VersionCheckScreenState();
}

class _VersionCheckScreenState extends State<VersionCheckScreen> {
  bool isUpdateRequired = false;
  final String currentAppVersion = "1.0.0";  // Update with your app version

  @override
  void initState() {
    super.initState();
    checkAppVersion();
  }

  Future<void> checkAppVersion() async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    VersionCheckService versionCheckService = VersionCheckService(remoteConfig: remoteConfig);

    await versionCheckService.init();

    bool updateRequired = await versionCheckService.isAppVersionOutdated(currentAppVersion);
    setState(() {
      isUpdateRequired = updateRequired;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isUpdateRequired
            ? AlertDialog(
          title: Text('Update Required'),
          content: Text('A new version of the app is available. Please update to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                // Redirect to app store
              },
              child: Text('Update Now'),
            ),
          ],
        )
            : Text('App is up-to-date'),
      ),
    );
  }
}
