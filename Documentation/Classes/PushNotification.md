# PushNotification 🔔

Utility class to send a push notification to one or multiple recipients.

## Configuration

### iOS configuration

⚠️ You need to have an authentication key file `AuthKey_XXXYYY.p8` from Apple.

[Check how to generate your authentication key .p8 file](../Generate_p8.md)

This file should be placed in your application sessions folder (`MobileApps/TEAM123456.com.sample.myappname`).

### Android configuration

⚠️ You need to configure a Firebase project in order to use push notifications.

[Check how to configure Firebase in few quick steps](../Conf_firebase.md)

You need to :

- create a project if it doesn't exist yet.
- get **google-services.json** file.
- enable **Cloud Message API (Legacy)** to retrieve your server key.

The **google-services.json** file should be placed in your application sessions folder (`MobileApps/com.sample.myappname`).

## Usage

```4d
$pushNotification:=MobileAppServer .PushNotification.new()

$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"

$response:=$pushNotification.send($notification;"abc@4dmail.com")
```

### NOTE

> For **iOS**, if you only use simulators (no real device), you can bypass the process of .p8 key file verification by pressing **Shift down** on PushNotification class instantiation.

## Development or Production mode (**iOS only**)

You need to specify whether the target application is in `development` or `production` mode.

If your application is in `development` mode and you try to send push notification in `production` mode, the target won't receive the push notifications. By default, the `PushNotification` class is in `production` mode, but you can change it as follows :

```4d
$pushNotification.auth.isDevelopment:=True
```

## Server key (**Android only**)

You need to provide your server key in order to send push notifications.

```4d
$pushNotification.auth.serverKey:="your_server_key"
```

## Instanciate the PushNotification class

If you have **only one application** in your Session files (`MobileApps/`), you can call the constructor with no parameter. However, if you have **more than one**, you will need to provide parameters to identify which application you want to send push notifications to.

---

As it uses the [Session](./Session.md) class in its constructor, you can provide the same parameters :

```4d
// none (if you have only one application folder in `MobileApps/` folder)
$pushNotification:=MobileAppServer .PushNotification.new()

// Application ID (teamId.bundleId)
$pushNotification:=MobileAppServer .PushNotification.new("TEAM123456.com.sample.myappname")

// Bundle ID
$pushNotification:=MobileAppServer .PushNotification.new("com.sample.myappname")

// Application name
$pushNotification:=MobileAppServer .PushNotification.new("myappname")

// An object
$pushNotification:=MobileAppServer .PushNotification.new(New object("bundleId";"com.sample.myappname";"teamId";"TEAM123456"))
```

Alternatively, you can instanciate the `PushNotification` class with an authentication object.

```4d
$auth:=New object
$auth.bundleId:="com.sample.myappname"
$auth.authKey:=File("/path_to_p8_file/AuthKey_XXXYYY.p8")  // authentication key .p8 file or file path
$auth.teamId:="TEAM123456"  // is the team related to the authentication key file
$auth.isDevelopment:=False  // Optional value, defines whether you are in production or development mode. Default is False

$pushNotification:=MobileAppServer .PushNotification.new($auth)
```

### Define OS targets

Additionally, you can specify OS targets for your push notifications. Targets will be provided as an additional parameter to the PushNotification constructor. It can be a collection as follows, or a simple text.

```4d
// first example
$targets:=New Collection("android"; "ios")
$pushNotification:=MobileAppServer .PushNotification.new($targets)

// another example
$pushNotification:=MobileAppServer .PushNotification.new("com.sample.myappname"; "android")
```

## Use PushNotification class to send push notifications

To use the `send()`  and `sendAll()` functions from `PushNotification` class, you need a notification object that defines the content to send, and recipients.

### `send()`

This function will send `$notification` to all `$recipients`.

```4d
$response:=$pushNotification.send($notification;$recipients)
```

You can also set the recipients into your class, and call `send()` with no recipients parameter.

```4d
$pushNotification.recipients:=$recipients
$response:=$pushNotification.send($notification)
```

### `sendAll()`

This function will send `$notification` to any recipient that has a session file on the server for the app. **Be careful to who you send it, as it may be considered as spamming.**

```4d
$response:=$pushNotification.sendAll($notification)
```

## Build notification object

```4d
$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"

// Additional properties

```

### Additional properties

#### iOS properties

- [subtitle](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649873-subtitle) containing a secondary description of the reason for the alert.
- [badge](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649875-badge) the number to apply to the app’s icon.
- [sound](https://developer.apple.com/documentation/usernotifications/unmutablenotificationcontent/1649868-sound) the sound to play when the system delivers the notification. If custom one, must be embedded manually in the app.
- `category`: A category information for your notification
- `url`: Open a URL when clicking the notification, could help for custom deep linking etc...
- `imageUrl`: Add an image using a URL for rich notification display

#### Android properties

- `sound`: The filename of a sound resource bundled in the app. Sound files must reside in /res/raw/
- `color`: The notification's icon color, expressed in #rrggbb format.
- `imageUrl`: Add an image using a URL for rich notification display

## Recipients

Recipients can be of various types : email addresses, device tokens, simulator IDs. It can be given as a single `String` parameter, but also as `Collection`, or as an `Object` containing 3 `Collection` of different types.

### A single mail address

```4d
$mail:="abc@4dmail.com"
$response:=$pushNotification.send($notification;$mail)
```

### A single device token

A device token can be found in a session file, it identifies a device for push notifications. Its length is 64 characters.

```4d
$deviceToken:="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$response:=$pushNotification.send($notification;$deviceToken)
```

### A single simulator UDID (**iOS only**)

Testing your push notifications on a simulator can be very helpful. **However, in order to use this feature, you will need to have a XCode version of 11.4 or newer.**
You can simply give the value `booted` to target the launched simulator, or you can run the follow command to list booted devices and get their UDID : `xcrun simctl list devices | grep Booted`

```4d
$simulator:="ABCD-DEFG-HIJK-LMNO"
$response:=$pushNotification.send($notification;$simulator)
```

### A mail address collection

```4d
$mails:=New collection("abc@4dmail.com";"def@4dmail.com";"ghi@4dmail.com")
$response:=$pushNotification.send($notification;$mails)
```

### A device token collection

```4d
$deviceTokens:=New collection("xxxxxxxxxxxx";"yyyyyyyyyyyy";"zzzzzzzzzzzz")
$response:=$pushNotification.send($notification;$deviceTokens)
```

### An object with all together: mails, devices and/or simulators

This object can contain up to 3 collections : a mail address collection, a device token collection, and a simulator collection.

```4d
$recipients:=New object
$recipients.mails:=New collection("abc@4dmail.com";"def@4dmail.com";"ghi@4dmail.com")
$recipients.deviceTokens:=New collection("xxxxxxxxxxxx";"yyyyyyyyyyyy";"zzzzzzzzzzzz")
$recipients.simulators:=New collection("ABCDEFGHI";"9GER74FS8S";"PY1J4IT984") // iOS only
$response:=$pushNotification.send($notification;$recipients)
```

### Extra

You can use the [Session](./Session.md) class to retrieve information in session files, such as device tokens, mail addresses or more session information.

## Exploring results

You may encounter different kind of issues while sending a push notification. Exploring results lets you know if anything went wrong.

```4d
$response:=$pushNotification.sendAll($notification)

$response.success  // True or False
$response.warnings  // Contains a collection of Text warnings
$response.errors  // Contains a collection of Text errors (implies $response.success is False)
```

## Custom actions

### `open()`

Open the app to a specific dataclass list form or entity detail form.

#### Open a dataclass list form

This function will send `$notification` to all `$recipients` and open the target application on `$dataClass` list form.
`$dataClass`can either be a text as a dataclass name, or a `4D DataClass` object.

```4d
$dataClass:="Employees"
$response:=$pushNotification.open($dataClass;$notification;$recipients)
```

Or alternatively with a dataclass object :

```4d
$dataClass:=ds.Employees
$response:=$pushNotification.open($dataClass;$notification;$recipients)
```

##### Open an entity detail form

This function will send `$notification` to all `$recipients` and open the target application on a specific `$entity` detail form.
You can retrieve the specific `4D Entity` object with the `4D DataClass` `get()` method.

```4d
$entity:=ds.Employees.get("456456")
$response:=$pushNotification.open($entity;$notification;$recipients)
```

In order to force a data synchronization, you can specify it with the `dataSynchro` boolean entry as follows.

```4d
$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.userInfo:=New object("dataSynchro"; True)

$entity:=ds.Employees.get("456456")
$response:=$pushNotification.open($entity; $notification; $recipients)
```
