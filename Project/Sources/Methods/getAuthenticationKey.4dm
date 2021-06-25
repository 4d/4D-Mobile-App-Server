//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)
C_VARIANT:C1683($1)  //sessionDir

C_LONGINT:C283($Lon_parameters)
C_OBJECT:C1216($Obj_result;$authKeyFile;$Obj_authKeyId)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$Obj_result:=New object:C1471("success";False:C215)
	
End if 


If (Value type:C1509($1)=Is text:K8:3)
	
	$authKeyFile:=File:C1566($1)
	
	  // If authKey is not a file
	If (Not:C34(Bool:C1537($authKeyFile.isFile)))
		
		ASSERT:C1129(False:C215;"Unknown authentication key type : "+String:C10(Value type:C1509($authKeyFile)))
		
	End if 
	
End if 

C_BOOLEAN:C305($isFolder)

If (Value type:C1509($1)=Is object:K8:27)
	
	If ($1.isFile)
		
		$authKeyFile:=$1
		
	End if 
	
	If ($1.isFolder)
		
		$isFolder:=True:C214
		
	End if 
	
End if 

If ($authKeyFile#Null:C1517)
	
	  // If authKey file does not exist
	If (Not:C34(Bool:C1537($authKeyFile.exists)))
		
		ASSERT:C1129(False:C215;"Could not find authentication key file")
		
	End if 
	
	  // Check if authKey file is an alias, and get original
	If ($authKeyFile.isAlias)
		
		$authKeyFile:=$authKeyFile.original
		
	End if 
	
	If ($authKeyFile.extension=".p8")
		
		$Obj_authKeyId:=getAuthKeyId ($authKeyFile.name)
		
		If ($Obj_authKeyId.success)
			
			$Obj_result.authKeyId:=$Obj_authKeyId.authKeyId
			
			$Obj_result.authKey:=$authKeyFile
			
			$Obj_result.success:=True:C214
			
		Else 
			
			ASSERT:C1129(False:C215;"Authentication key ID could not be parsed from Auth key file")
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215;"Provided auth key is not a .p8 file")
		
	End if 
	
Else 
	
	If (Bool:C1537($isFolder))
		
		C_OBJECT:C1216($sessionDir)
		$sessionDir:=$1
		
		If (($sessionDir.exists) & ($sessionDir.isFolder))
			
			C_COLLECTION:C1488($files)
			C_OBJECT:C1216($file)
			$files:=$sessionDir.files()
			
			For each ($file;$files)
				
				If ($file.extension=".p8")
					
					$Obj_authKeyId:=getAuthKeyId ($file.name)
					
					If ($Obj_authKeyId.success)
						
						$Obj_result.authKeyId:=$Obj_authKeyId.authKeyId
						
						$Obj_result.authKey:=$file
						
						$Obj_result.success:=True:C214
						
					Else 
						
						ASSERT:C1129(False:C215;"Authentication key ID could not be parsed from Auth key file")
						
					End if 
					
				End if 
				
			End for each 
			
		Else 
			
			ASSERT:C1129(False:C215;"The session direction could not be found")
			
		End if 
		
	Else 
		
		ASSERT:C1129(False:C215;"Incompatible entry parameter")
		
	End if 
	
End if 


If (Not:C34($Obj_result.success))
	
	ASSERT:C1129(False:C215;"No authentication key with .p8 extension could be found")
	
End if 

$0:=$Obj_result