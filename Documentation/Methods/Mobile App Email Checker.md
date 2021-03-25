# Mobile App Email Checker

Call `Mobile App Email Checker` method in the `On Mobile App Authentification` database  method with the information provided by the mobile application.

```4d
C_OBJECT($0; $1)
$0:= Mobile App Email Checker ($1)
```

An email will be send and the session is deactivated automatically

> In case of failure, the `Mobile App Email Checker` method returns a list of errors and `.success` is `False`.

## Setup the SMTP and template parameters

The `Mobile App Server/settings.json` file must contain the following parameters to send emails:

```json
{
    "smtp" : {
        "user":"mail@example.com",
        "password":"******",
        "from":"mail@example.com",
        "host":"smtp.example.com",
        "port":465
    },
    "template": {
        "emailToSend": "ConfirmMailTemplate.html",
        "emailConfirmActivation":"ActiveSessionTemplate.html"
    },
    "emailSubject":"Application Name: Sign in confirmation",
    "activation": {
        "scheme":"http",
        "hostname":"192.168.1.2",
        "port": "80",
        "path":"activation",
        "otherParameters":""
    },
    "timeout":300000,
    "message":{
        "successConfirmationMailMessage":"Verify your email address",
        "waitSendMailConfirmationMessage":"The mail is already sent thank you to wait before sending again",
        "successActiveSessionsMessage":"You are successfully authenticated",
        "expireActiveSessionsMessage":"This email confirmation link has expired!"
    }
}
```

- *activation.scheme*: **http or https** \
- *activation.hostname*: **192.168.1.2** // server address \
- *activation.port*: **80** // server port \
- *activation.path*: **activation** // used to catch the value of the token connection \
- *activation.otherParameters*: **param1=Value1&param2=value2** // custom user settings

- *message.successConfirmationMailMessage*: message displayed in the mobile application if the email is sent successfully \
- *message.waitSendMailConfirmationMessage*: message displayed in the mobile application if the user tries to login without activating his account from his email address and without respecting the expiration value of a connection \
- *message.successActiveSessionsMessage*: message displayed in the activation web page if the session is activated \
- *message.expireActiveSessionsMessage*: message displayed in the activation web page if the session has expired

> **Note**: if the settings file does not exist in the `Resources` folder of your 4D base, a `Resources/Mobile App Server/settings.sample.json` file will be created, there you will find the mandatory configuration that you must fill out.

### Mail template

The HTML template that will be sent by default to the user.

```html
<html>
    <header>
    </header>
    <body>
        Hello,
        <br><br>
        To start using the App, you must first confirm your subscription by clicking on the following link:
        <a href="{{url}}">Click Here.</a>"<br>
        The link will expire in {{expirationminutes}} minutes.
        <br><br>
        Sincerely,
    </body>
</html>
```

- `{{url}}` : url to validate the session
  - could be modifyed by the `activation` keys in `settings.json`
  - when clicking this link the 4D Server must receive the request and validate the session using the provided method [`Mobile App Active Session`](Mobile%20%App%Active%20Sessiion.md)
- `{{expirationminutes}}` : **300000 -> 5min**
  - could be modified by the `timeout` value which exists in the `settings.json` file

You can customize the mail
- by providing one specific template file using the setting json key `template.emailToSend`
- or by creating/editing the file in default path `Resources/Mobile App Server/ConfirmMailTemplate.html`
