<!-- $auth:=Mobile App Authentication($1) // $1 Informations provided by  `On Mobile App Authentication` -->
# Mobile App Authentication

Utility class to get manipulate session when inside `On Mobile App Authentication` database method.

## Usage

in `On Mobile App Authentication` wrap the first input parameters

```4d
$auth:=Mobile App Authentication($1) // $1 Informations provided by mobile application
```

Then you can have some information about mobile applications and session.

### Get application id

```4d
$myAppId:=$auth.getAppId()
```

### Get session information

#### Get the `File` associated to the session

```4d
$currentSessionFile:=$auth.getSessionFile()
```

#### Get the session information as object

```4d
$currentSessionObject:=$auth.getSessionObject()
```

### Modify current session

Setting the status to "pending" ie. not validated yet.

```4d
$currentSessionObject.status:="pending"
$currentSessionObject.save() // save to File on disk
```

### Checking authentication using a confirmation email

```4d
$0:=$auth.confirmEmail()
```

You must configure first your SMTP server to send emails - more detail available [here](Mobile%20App%20Email%20Checker.md)