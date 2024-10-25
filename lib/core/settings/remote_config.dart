import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class VersionCheckService {
  final FirebaseRemoteConfig remoteConfig;
  VersionCheckService({required this.remoteConfig});

  Future<void> init() async {
    // Fetch and activate the remote config values
    await remoteConfig.fetchAndActivate();
  }

  // Compare the current app version with the latest version on Firebase
  Future<bool> isAppVersionOutdated(String currentVersion) async {
    String latestVersion = remoteConfig.getString('latest_app_version');
    return _isVersionOutdated(currentVersion, latestVersion);
  }

  bool _isVersionOutdated(String currentVersion, String latestVersion) {
    List<String> currentVersionParts = currentVersion.split('.');
    List<String> latestVersionParts = latestVersion.split('.');

    for (int i = 0; i < latestVersionParts.length; i++) {
      if (int.parse(currentVersionParts[i]) < int.parse(latestVersionParts[i])) {
        return true;  // App is outdated
      }
    }
    return false;  // App is up to date
  }
}
