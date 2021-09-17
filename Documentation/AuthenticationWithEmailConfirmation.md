# Authentication with email confirmation

Sending an email is a well-known process to check user identity.

You can implement its easily following this two steps
- Use [Mobile App Email Checker](Methods/Mobile%20App%20Email%20Checker.md) in [`On Mobile App Authentication`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Authentication-database-method.301-4505016.en.html) to disable the user session and send an email with a validation link.
- and [Mobile App Active Session](Methods/Mobile%20App%20Active%20Session.md) in [`On Web Connection`](https://doc.4d.com/4Dv18/4D/18/On-Web-Connection-database-method.301-4505013.en.html) to validate the session when the user click the link.