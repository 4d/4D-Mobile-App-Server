# Mobile App Active Session

To validate a session when a user click the validation link call the `Mobile App Active Session` method in the  `On Web Connection` database method with the Session ID parameter retrieved from the URL.

```4d
C_TEXT($1) // path/route, will be used to handle or not the request

Case of
: (Mobile App Active Session($1).success)
    //add log if you want
End case
```
