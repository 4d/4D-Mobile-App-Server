<!-- Type your summary here -->
# WebHandler

Manage some default behaviours for the web server to manage HTTP request.

- Apple UniversalLinks: /.well-known/apple-app-site-association path
- Session activation

## On Web Connection

```4d
$handler:=MobileAppServer.WebHandler.new()

Case of
	: ($handler.handle($1; $2; $3; $4; $5; $6))
		// Managed by default mobile code
	Else

		// your web code

End case
```

### Apple UniversalLinks

To support Universal Links you could create a `apple-app-site-association` file inside the database folder `WebFolder/.well-known/` 
but to be compliant with iOS SDK for the moment you must let the web handler do the job by browsing the app inside `/MobileApps` and produce a default response.

#### Example

Example of auto generated response to `.well-known/apple-app-site-association` request.

```json
{
  "applinks": {
    "apps": [ ],
    "details": [
      {
        "appID": "37UG5W39Z2.com.myCompany.My-App-1",
        "paths": [
        "/mobileapp/$/37UG5W39Z2.com.myCompany.My-App-1/*"
        ]
      },
      {
        "appID": "37UG5W39Z2.com.myCompany.My-App",
        "paths": [
        "/mobileapp/$/37UG5W39Z2.com.myCompany.My-App/*"
        ]
      }
    ]
  }
}
```

If only one app

```json
{
  "applinks": {
    "apps": [ ],
    "details": [
      {
        "appID": "37UG5W39Z2.com.myCompany.My-App",
        "paths": [
        "/mobileapp/$/*"
        ]
      }
    ]
  }
}
```

#### How it work?

`manifest.json` of each apps are read to find any `associatedDomain` key (the url of server).

And for each app with this key, we add an entry in the response.