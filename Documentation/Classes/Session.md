# Session 📁

Utility class to retrieve information in session files.

## Usage

First of all, you will need to instanciate the `Session` class with a `teamId` and a `bundleId`.

### Instanciate Session class

---

```4d
$teamId:="TEAM123456"
$bundleId:="com.sample.myappname"
$sessions:=MobileAppServer .Session.new($teamId;$bundleId)
```

### Use Session class to retrieve information

---

- #### `getAllDeviceTokens()`

This function will retrieve all the deviceTokens found in session files.

```4d
$response:=$sessions.getAllDeviceTokens()
If ($response.success)
	$deviceTokens:=$response.deviceTokens
End if
```

- #### `getAllMailAddresses()`

This function will retrieve all the mail addresses found in session files.

```4d
$response:=$sessions.getAllMailAddresses()
If ($response.success)
	$mailAddresses:=$response.mailAddresses
End if
```

- #### `getSessionInfoFromMail()`

This function will retrieve a session whose mail address is given in parameter.

```4d
$response:=$sessions.getSessionInfoFromMail("abc@4dmail.com")
If ($response.success)
	$session:=$response.session
End if
```