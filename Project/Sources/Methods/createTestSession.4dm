//%attributes = {}
// Create test session
C_OBJECT:C1216($0)
C_TEXT:C284($1)  // bundle id

var $bundleId : Text

$bundleId:=$1

var $Dir_mobileApps : 4D:C1709.Folder

$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)

var $sessionDir : 4D:C1709.Folder

$sessionDir:=$Dir_mobileApps.folder($bundleId)

var $testSession : 4D:C1709.File

$testSession:=$sessionDir.file("test_session")

If (Not:C34($testSession.exists))
	
	$testSession.create()
	
	var $sessionContent : Object
	$sessionContent:=New object:C1471
	$sessionContent.email:=""
	$sessionContent.application:=New object:C1471
	$sessionContent.application.id:=$bundleId
	$sessionContent.device:=New object:C1471
	$sessionContent.device.token:="123456789"
	$testSession.setText(JSON Stringify:C1217($sessionContent))
	
End if 

var $manifest : 4D:C1709.File

$manifest:=$sessionDir.file("manifest.json")

If (Not:C34($manifest.exists))
	
	$manifest.create()
	
	var $manifestContent : Object
	$manifestContent:=New object:C1471
	$manifestContent.application:=New object:C1471
	$manifestContent.application.id:=$bundleId
	$manifestContent.team:=New object:C1471
	$manifestContent.team.id:=""
	$manifestContent.info:=New object:C1471
	$manifestContent.info.target:=New collection:C1472("android"; "iOS")
	$manifest.setText(JSON Stringify:C1217($manifestContent))
	
End if 