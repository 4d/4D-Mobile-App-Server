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

### Page opening in mobile app

If the page is displayed from mobile app we want to know some context information about it

```4d
$context:=$handler.getContext()
```

On this context we could get for instance the entity that open the page

```4d
$entity:=$context.getEntity()
```

More in [WebContext](WebContext.md)

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


#### Manage link on desktop or phone without the app

When the client use a browser on a device without the app you must provide some web page instead or it will receive a 404 error with a url of type `/mobileapp/*`

You could register method using formula do so.

```4d
$handler:=cs.WebHandler.new()
$handler.handleUniversalLinks:=Formula(MyHandleUniversalLinks($1))
```

You could produce a page in `MyHandleUniversalLinks` or use `WEB SEND HTTP REDIRECT` to redirect to an existing one.

According to the link, environnement and your need you could provide a link to download the mobile app or show an existing web page about your dataclass and/or entity.

##### MyHandleUniversalLinks

Example of code to redirect

- If there is an entity redirect to a web page that display the entity (ie. the customer, the bug, etc...)
- Else if there is a dataclass only we redirect to a page that display all the entities of this dataclass

```4d
$universalLinks:=$1 // of type MobileAppServer.UniversalLink

$dataClass:=$universalLinks.getDataClass()
$entity:=$universalLinks.getEntity()

Case of
  : ($entity#Null)
		WEB SEND HTTP REDIRECT("https://mywebsite/"+Lowercase($dataClass.getInfo().name)+"/"+Lowercase($dataClass.getInfo().name))
	  $0:=True // Managed by this code, return false if you do not want
	: ($dataClass#Null)
		WEB SEND HTTP REDIRECT("https://mywebsite/"+Lowercase($dataClass.getInfo().name)+"-"+String($entity.ID)+".html")
		$0:=True // Managed by this code, return false if you do not want
  Else
    $0:=False // here redirect to download page
End case
```
