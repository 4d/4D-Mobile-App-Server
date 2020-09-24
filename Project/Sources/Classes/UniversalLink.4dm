

Class constructor
	C_TEXT:C284($1)
	This:C1470.path:=$1
	
	This:C1470.query:=This:C1470._webGetVariables()  // alternative parse from $1
	
	
Function _webGetVariables
	C_OBJECT:C1216($0)
	ARRAY TEXT:C222($anames; 0)
	ARRAY TEXT:C222($avalues; 0)
	WEB GET VARIABLES:C683($anames; $avalues)
	
	$0:=New object:C1471()
	C_LONGINT:C283($cpt)
	For ($cpt; 1; Size of array:C274($anames); 1)
		C_TEXT:C284($name)
		$name:=Lowercase:C14($anames{$cpt})
		If ($0[$name]#Null:C1517)
			If (Value type:C1509($0[$name])=Is collection:K8:32)
				$0[$name].push($avalues{$cpt})
			Else 
				$0[$name]:=New collection:C1472($0[$name]; $avalues{$cpt})
			End if 
		Else 
			$0[$name]:=$avalues{$cpt}
		End if 
	End for 
	
	
Function getDataClass
	C_OBJECT:C1216($0)
	If (Length:C16(String:C10(This:C1470.query.dataclass))>0)
		
		$0:=ds:C1482[This:C1470.query.dataclass]
		
	End if 
	
Function getEntity
	C_OBJECT:C1216($0; $Obj_dataClass; $Obj_entity)
	$Obj_dataClass:=This:C1470.getDataClass()
	If ($Obj_dataClass#Null:C1517)
		
		If (Length:C16(String:C10(This:C1470.query["entity.primarykey"]))>0)
			
			$Obj_entity:=QueryByPrimaryKey($Obj_dataClass; New object:C1471("primaryKey"; This:C1470.query["entity.primarykey"]))
			
		End if 
	End if 
	
	$0:=$Obj_entity
	
Function _getAppIdFromPath
	C_TEXT:C284($0)
	$0:=Replace string:C233(This:C1470.path; "/mobileapp/$/"; "")
	If (Position:C15("?"; $0)>0)
		$0:=Substring:C12($0; 1; Position:C15("?"; $0)-1)
	End if 
	
Function getApp
	C_OBJECT:C1216($0)
	
	C_COLLECTION:C1488($apps)
	$apps:=cs:C1710.App.new().withAssociatedDomain()
	
	C_TEXT:C284($appName)
	$appName:=This:C1470._getAppIdFromPath()
	
	If (Length:C16($appName)=0)  // short url if one app
		$0:=$apps[0]  // ASSERT($apps.length=1)
	Else 
		$apps:=$apps.query("id=:1"; This:C1470._getAppIdFromPath())
		If ($apps.length>0)
			$0:=$apps[0]
		End if 
		
	End if 
	
	