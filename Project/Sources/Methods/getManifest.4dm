//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)  //sessionDir

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_result)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Obj_result:=New object:C1471
	$Obj_result.success:=False:C215
	
Else 
	
	ABORT:C156
	
End if 

C_OBJECT:C1216($sessionDir;$manifestFile)

$sessionDir:=$1

If (($sessionDir.exists) & ($sessionDir.isFolder))
	
	$manifestFile:=$sessionDir.file("manifest.json")
	
	If ($manifestFile.exists)
		
		$Obj_result.manifest:=JSON Parse:C1218($manifestFile.getText())
		
		If ($Obj_result.manifest#Null:C1517)
			
			$Obj_result.success:=True:C214
			
		Else 
			
			ASSERT:C1129(False:C215;"The manifest.json file could not be parsed")
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215;"The manifest.json file could not be found")
		
	End if 
	
Else 
	
	ASSERT:C1129(False:C215;"The session direction could not be found")
	
End if 

$0:=$Obj_result