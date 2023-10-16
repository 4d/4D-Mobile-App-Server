

Class constructor($path : Text)
	This:C1470.path:=$path
	
	This:C1470.query:=This:C1470._webGetVariables()  // alternative parse from $1
	
	
Function _webGetVariables()->$result : Object
	ARRAY TEXT:C222($anames; 0)
	ARRAY TEXT:C222($avalues; 0)
	WEB GET VARIABLES:C683($anames; $avalues)
	
	$result:=New object:C1471()
	C_LONGINT:C283($cpt)
	For ($cpt; 1; Size of array:C274($anames); 1)
		C_TEXT:C284($name)
		$name:=Lowercase:C14($anames{$cpt})
		If ($result[$name]#Null:C1517)
			If (Value type:C1509($result[$name])=Is collection:K8:32)
				$result[$name].push($avalues{$cpt})
			Else 
				$result[$name]:=New collection:C1472($result[$name]; $avalues{$cpt})
			End if 
		Else 
			$result[$name]:=$avalues{$cpt}
		End if 
	End for 
	
	
Function getDataClass()->$result : Object
	If (Length:C16(String:C10(This:C1470.query.dataclass))>0)
		
		$result:=ds:C1482[This:C1470.query.dataclass]
		
	End if 
	
Function getEntity()->$Obj_entity : Object
	var $Obj_dataClass : Object
	$Obj_dataClass:=This:C1470.getDataClass()
	If ($Obj_dataClass#Null:C1517)
		
		If (Length:C16(String:C10(This:C1470.query["entity.primarykey"]))>0)
			
			$Obj_entity:=QueryByPrimaryKey($Obj_dataClass; New object:C1471("primaryKey"; This:C1470.query["entity.primarykey"]))
			
		End if 
	End if 
	
Function _getAppIdFromPath()->$result : Text
	$result:=Replace string:C233(This:C1470.path; "/mobileapp/$/"; "")
	If (Position:C15("?"; $result)>0)
		$result:=Substring:C12($result; 1; Position:C15("?"; $result)-1)
	End if 
	
Function getApp() : Object
	
	var $apps : Collection
	$apps:=cs:C1710.App.new().withAssociatedDomain()
	
	var $appName : Text
	$appName:=This:C1470._getAppIdFromPath()
	
	If (Length:C16($appName)=0)  // short url if one app
		return $apps[0]  // ASSERT($apps.length=1)
	Else 
		$apps:=$apps.query("id=:1"; This:C1470._getAppIdFromPath())
		If ($apps.length>0)
			return $apps[0]
		End if 
		
	End if 
	
	