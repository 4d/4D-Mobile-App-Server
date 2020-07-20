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

		// your code

End case
```

### Apple UniversalLinks

To support Universal Links create your self a `apple-app-site-association` file inside the database folder `WebFolder/.well-known/`

or let the handler do the job by browsing the app list inside `/MobileApps` and produce a default file.

#### Example

```json
{
  applinks: {
    apps: [ ],
    details: [
      {
        appID: "37UG5W39Z2.com.myCompany.My-App-1",
        paths: [
        "/mobilelink/37UG5W39Z2.com.myCompany.My-App-1/*"
        ]
      },
      {
        appID: "37UG5W39Z2.com.myCompany.My-App",
        paths: [
        "/mobilelink/37UG5W39Z2.com.myCompany.My-App/*"
        ]
      }
    ]
  }
}
```
