//%attributes = {}
C_COLLECTION:C1488($apps)
C_OBJECT:C1216($app)

$apps:=cs:C1710.App.new().all()

If ($apps.length=0)
	
	$app:=JSON Parse:C1218(Folder:C1567(fk resources folder:K87:11).folder("test").file("manifest.json"))
	$app:=cs:C1710.App.new($app)
	
	$app.create()
	
	$apps:=cs:C1710.App.new().all()
End if 

ASSERT:C1129($apps.length>0; "Not enought app to test")
$app:=$apps[0]

ASSERT:C1129($app.id#Null:C1517; "no app full id")
ASSERT:C1129($app.application.id#Null:C1517; "no application id")
//ASSERT($app.team.id#Null; "no team id") // iOS only

$app:=cs:C1710.App.new($app)  // recreate app from app or json

ASSERT:C1129($app.id#Null:C1517; "no app full id")
ASSERT:C1129($app.application.id#Null:C1517; "no application id")
ASSERT:C1129($app.team.id#Null:C1517; "no team id")  // iOS only

C_COLLECTION:C1488($sessions)
$sessions:=$app.getSessionManager().getSessionObjects()
C_OBJECT:C1216($session)
For each ($session; $sessions)
	ASSERT:C1129($app.id=$session.getApp().id)
End for each 