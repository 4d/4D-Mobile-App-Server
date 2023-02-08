//%attributes = {"invisible":true,"shared":true,"preemptive":"capable"}
$0:=New object:C1471("request"; $1; \
"_is"; "mobileAppAuthentication"; \
"getAppID"; Formula:C1597(appID(This:C1470.request)); \
"getSessionFile"; Formula:C1597(Folder:C1567(fk mobileApps folder:K87:18; *).folder(This:C1470.getAppID()).file(This:C1470.request.session.id)); \
"getSessionObject"; Formula:C1597(Mobile App Session Object(This:C1470.getSessionFile())); \
"confirmEmail"; Formula:C1597(Mobile App Email Checker(This:C1470.request))\
)