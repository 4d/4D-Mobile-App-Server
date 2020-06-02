# PushNotification 🔔

Utility class to send a push notification to one or multiple recipients.

## Usage

First of all, you will need to instanciate the `PushNotification` class with an authentication object.

To use the `send()`  and `sendAll()` functions from `PushNotification` class, you need a notification object that defines the content to send, and recipients.

### Build authentication object 

---

In order to use the component to send push notification, it is required to have an authentication file `AuthKey_XXXX.p8` from Apple.
This file should be placed in user database for convenience.
It is important to note what are `$authKey`, `$authKeyId` and `$teamId` refering to.

<a href="../Generate_p8.md">Check how to generate .p8 key file</a>

```4d
$authKey:=File("/path_to_p8_file/AuthKey_XXXYYY.p8")  // AuthKey file
$authKeyId=XXXYYY  // is the second part of the AuthKey filename
$teamId=TEAM123456  // is the team related to the AuthKey file
```

```4d
$bundleId:="com.sample.myappname"
$authKey:=File("/path_to_p8_file/AuthKey_XXXYYY.p8")
$authKeyId:="AuthKey_XXXYYY"
$teamId:="TEAM123456"

$auth:=New object
$auth.bundleId:=$bundleId
$auth.authKey:=$authKey
$auth.authKeyId:=$authKeyId
$auth.teamId:=$teamId
$auth.isDevelopment:=False  // Optional value, defines whether you are in production or development mode. Default is False
```


### Instanciate PushNotification class to authenticate

---

```4d
$pushNotification:=MobileAppServer .PushNotification.new($auth)
```

### Use PushNotification class to send push notifications

---

- #### `send()`

This function will send `$notification` to all `$recipients`.

```4d
$response:=$pushNotification.send($notification;$recipients)
```

- #### `sendAll()`

This function will send `$notification` to any recipient that has a session file on the server for the app.

```4d
$response:=$pushNotification.sendAll($notification)
```

### Build notification object

---

```4d
$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
```

### Recipients

---

Recipients can be of various types : email addresses, device tokens, simulator ids. It can be given as a single `String` parameter, but also as `Collection`, or as an `Object` containing 3 `Collection` of different types.

- #### A single mail address

```4d
$mail:="abc@4dmail.com"
$response:=$pushNotification.send($notification;$mail)
```

- ##### A single device token

A device token can be found in a session file, it identifies a device for push notifications. Its length is 64 characters.

```4d
$deviceToken:="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$response:=$pushNotification.send($notification;$deviceToken)
```

- ##### A single simulator UDID

Testing your push notifications on a simulator can be very helpful. **However, in order to use this feature, you will need to have a XCode version of 11.4 or newer.**
You can simply give the value `booted` to target the launched simulator, or you can run the follow command to list booted devices and get their UDID : `xcrun simctl list devices | grep Booted`

```4d
$simulator:="ABCD-DEFG-HIJK-LMNO"
$response:=$pushNotification.send($notification;$simulator)
```

- ##### A mail address collection

```4d
$mails:=New collection("abc@4dmail.com";"def@4dmail.com";"ghi@4dmail.com")
$response:=$pushNotification.send($notification;$mails)
```

- ##### A device token collection

```4d
$deviceTokens:=New collection("xxxxxxxxxxxx";"yyyyyyyyyyyy";"zzzzzzzzzzzz")
$response:=$pushNotification.send($notification;$deviceTokens)
```

- ##### An object

This object can contain up to 3 collections : a mail address collection, a device token collection, and a simulator collection.

```4d
$recipients:=New object
$recipients.mails:=New collection("abc@4dmail.com";"def@4dmail.com";"ghi@4dmail.com")
$recipients.deviceTokens:=New collection("xxxxxxxxxxxx";"yyyyyyyyyyyy";"zzzzzzzzzzzz")
$recipients.simulators:=New collection("ABCDEFGHI";"9GER74FS8S";"PY1J4IT984")
$response:=$pushNotification.send($notification;$recipients)
```

- ##### Extra

You can use the <a href="./Session.md">`Session` class</a> to retrieve information in session files, such as deviceTokens, mail addresses or more session information.

### Exploring results

---

You may encounter different kind of issues while sending a push notification. Exploring results lets you know if anything went wrong.

```4d
$response:=$pushNotification.sendAll($notification)

$response.success  // True or False
$response.warnings  // Contains a collection of Text warnings
$response.errors  // Contains a collection of Text errors (implies $response.success is False)
```
