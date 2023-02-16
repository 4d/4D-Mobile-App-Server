//%attributes = {}
// Delete test session
C_OBJECT:C1216($0)
C_TEXT:C284($1)  // bundle id

var $bundleId : Text

$bundleId:=$1

var $Dir_mobileApps : 4D:C1709.Folder

$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18; *)

var $sessionDir : 4D:C1709.Folder

$sessionDir:=$Dir_mobileApps.folder($bundleId)

If ($sessionDir.exists)
	
	$sessionDir.delete(Delete with contents:K24:24)
	
End if 