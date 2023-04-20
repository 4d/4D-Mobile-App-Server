# 4D Mobile App Server

[![language][code-shield]][code-url]
[![language-top][code-top]][code-url]
![code-size][code-size]
[![release][release-shield]][release-url]

Utility methods to speed up the 4D Mobile App backend coding.

## Usage

### Utility method to implement `On Mobile App...` database methods

Wrap input from `On Mobile App...` database methods into these classes to get utility functions.

- [MobileAppServer.Action](Documentation/Classes/Action.md) provide utility methods for [`On Mobile App Action`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Action-database-method.301-4505017.en.html) coding.
- [MobileAppServer.Authentication](Documentation/Classes/Authentication.md) provide utility methods for [`On Mobile App Authentication`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Authentication-database-method.301-4505016.en.html) coding.

#### Without classes (Previous 4D Version)

Without classes some functionnalities are still available.

- [Mobile App Action](Documentation/Methods/Mobile%20App%20Action.md) provide utility methods for [`On Mobile App Action`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Action-database-method.301-4505017.en.html) coding.
- [Mobile App Authentication](Documentation/Methods/Mobile%20App%20Authentication.md) provide utility methods for [`On Mobile App Authentication`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Authentication-database-method.301-4505016.en.html) coding.

### Others features

- [MobileAppServer.PushNotification](Documentation/Classes/PushNotification.md) provide utility methods to send push notifications to mobile devices.
- [Authentication with email confirmation](Documentation/AuthenticationWithEmailConfirmation.md) describe the process to check user identity by sending emails.
- [MobileAppServer.WebHandler](Documentation/Classes/WebHandler.md) provide utility methods for [`On Web Connection`](https://doc.4d.com/4Dv16/4D/16.6/On-Web-Connection-Database-Method.300-4445786.en.html) coding.

## Installation

Download this component and add it to your base `Components` folder. Be sure to name it `.4dbase`

What follows contains more detailled instructions

### Download artefact or sources

1️⃣ Download sources using github `Download` button, or by going to a specific release and getting sources
- for instance for main version `Download` button will download https://github.com/4d/4D-Mobile-App-Server/archive/refs/heads/main.zip

2️⃣ Then unzip into your `Components` folder, and rename it folder to `4D-Mobile-App.4dbase` if needed

> 💡  if your are in git a repository
> Adding `Components` or `Components/4D-Mobile-App-Server.4dbase` in your `.gitignore` file is recommended


> 🍎 On macOS the following command line will do the job for you.
> Open a terminal, go to your component root folder (`cd /your/base/path/`) and type:

```bash
curl -sL https://raw.githubusercontent.com/4d/4D-Mobile-App-Server/main/download.sh | sh
```

### Using git

Go to your component root folder (`cd /your/base/path/`)

and clone it

```bash
git clone git@github.com:4d/4D-Mobile-App-Server.git Components/4D-Mobile-App-Server.4dbase
```

or using submodule if you use already git as vcs

```bash
git submodule add git@github.com:4d/4D-Mobile-App-Server.git Components/4D-Mobile-App-Server.4dbase
```

## License

See the [LICENSE][license-url] file for details

## Contributing

See [CONTRIBUTING][contributing-url] guide.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[code-shield]: https://img.shields.io/static/v1?label=language&message=4d&color=blue
[code-top]: https://img.shields.io/github/languages/top/4d-for-ios/4D-Mobile-App-Server.svg
[code-size]: https://img.shields.io/github/languages/code-size/4d-for-ios/4D-Mobile-App-Server.svg
[code-url]: https://developer.4d.com/
[release-shield]: https://img.shields.io/github/v/release/4d-for-ios/4D-Mobile-App-Server
[release-url]: https://github.com/4d-for-ios/4D-Mobile-App-Server/releases/latest
[contributing-url]: .github/CONTRIBUTING.md
[license-url]: LICENSE.md
