# Session 📁

Utility class to retrieve information in session files.

## Usage

```4d
$sessions:=MobileAppServer .Session.new()

If ($sessions.sessionDir#Null)
	// success
	$deviceTokens:=$sessions.getAllDeviceTokens()
	$mailAddresses:=$sessions.getAllMailAddresses()
	$john_session:=$sessions.getSessionInfoFromMail("john@mail.com")
End if
```

### Instanciate Session class

---

First of all, you will need to instanciate the `Session` class. Different parameters can be given.

- none (only if you have exactly one application folder in `MobileApps` folder)
```4d
$sessions:=MobileAppServer .Session.new()
```

- `teamId`.`bundleId`
```4d
$sessions:=MobileAppServer .Session.new("TEAM123456.com.sample.myappname")
```

- `bundleId`
```4d
$sessions:=MobileAppServer .Session.new("com.sample.myappname")
```

- `appName`
```4d
$sessions:=MobileAppServer .Session.new("myappname")
```

### Use Session class to retrieve information

---

- #### `getAllDeviceTokens()`

This function will retrieve all the deviceTokens found in application sessions files.

```4d
$response:=$sessions.getAllDeviceTokens()
If ($response.success)
	$deviceTokens:=$response.deviceTokens
End if
```

- #### `getAllMailAddresses()`

This function will retrieve all the mail addresses found in application sessions files.

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