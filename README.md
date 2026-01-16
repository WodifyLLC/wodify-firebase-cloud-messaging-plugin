# OutSystems Firebase Cloud Messaging Plugin for Wodify

An OutSystems Cordova plugin that integrates Firebase Cloud Messaging (FCM) for push notifications and phone badge management. This plugin enables Wodify mobile applications to receive push notifications and manage notification badges on iOS and Android devices.

## ⚠️ Important: Plugin Override Configuration

**This plugin overrides the default Firebase Cloud Messaging plugin via OutSystems Lifetime.**

To configure this custom plugin in your environment:

1. Log into Lifetime: [https://lifetime.wodify.com/lifetime/Application_Settings.aspx](https://lifetime.wodify.com/lifetime/Application_Settings.aspx)
2. Navigate to the **Application List**
3. Find and select **Plugin Cloud Messaging (Firebase)**
4. Open the **Application Settings**
5. Choose the **environment to override**
6. **Clone the base plugin** to the custom plugin
7. Add the Git URL with the release tag that should be built with:
   ```
   https://github.com/WodifyLLC/wodify-firebase-cloud-messaging-plugin.git#vX.Y.Z-wodify.N
   ```
   _(Replace the placeholder tag with the appropriate release version for your deployment, e.g. by checking the GitHub Releases page)_

## Description

This plugin provides native integration with Firebase Cloud Messaging, allowing OutSystems applications to:
- Receive and handle push notifications
- Manage phone notification badges
- Support both iOS and Android platforms
- Handle notification permissions and events

## Features

- ✅ Firebase Cloud Messaging integration
- ✅ Push notification handling for iOS and Android
- ✅ Phone badge management
- ✅ Notification permission handling
- ✅ Background notification support
- ✅ Custom notification channels (Android)
- ✅ APNs integration (iOS)

## Platform Support

- iOS
- Android

## Requirements

- OutSystems Platform
- Firebase project configured
- iOS: APNs certificates configured
- Android: Firebase configuration files

## Installation

This plugin is designed to be used within OutSystems mobile applications. Refer to your OutSystems documentation for plugin installation procedures.

## License

See LICENSE file for details.