// Wrapper `On Mobile App Action` input
Class constructor
	C_OBJECT:C1216($1)
	This:C1470.name:=$1.action
	This:C1470.request:=$1
	
	If ($1=Null:C1517)
		
		ASSERT:C1129(False:C215; "Failed to "+Current method name:C684)
		
	End if 
	
Function getDataClass
	C_OBJECT:C1216($0)
	$0:=Mobile App Action GetDataClass(This:C1470.request)
	
Function getEntity
	C_OBJECT:C1216($0)
	$0:=Mobile App Action GetEntity(This:C1470.request)
	
Function getParent
	C_OBJECT:C1216($0)
	$0:=MA Action GetParentEntity(This:C1470.request)
	
Function newEntity
	C_OBJECT:C1216($0)
	$0:=Mobile App Action NewEntity(This:C1470.request)
	
Function dropEntity
	C_OBJECT:C1216($0)
	$0:=Mobile App Action DropEntity(This:C1470.request)
	
Function link
	C_OBJECT:C1216($0)
	$0:=Mobile App Action Link(This:C1470.request)
	
Function unlink
	C_OBJECT:C1216($0)
	$0:=Mobile App Action Unlink(This:C1470.request)
	
Function getApp
	C_OBJECT:C1216($0)
	$0:=cs:C1710.App.new(New object:C1471("application"; This:C1470.request.application; "team"; This:C1470.request.team))
	
Function shareContext
	C_OBJECT:C1216($0; $response)
	$response:=New object:C1471("success"; False:C215)
	
	If (Value type:C1509(This:C1470.request.context)=Is object:K8:27)
		
		C_TEXT:C284($url)
		$url:=String:C10(This:C1470.getApp().urlScheme)
		If (Length:C16($url)>0)  // & $1.context.dataClass#Null (String(Null) is "null")
			
			$url:=$url+"://mobileapp/"
			$response.success:=True:C214
			
			If (Length:C16(String:C10(This:C1470.request.context.dataClass))>0)  // & $1.context.dataClass#Null (String(Null) is "null")
				
				$url:=$url+"show/?dataClass="+String:C10(This:C1470.request.context.dataClass)  // TODO query url encode
				
				If (Value type:C1509(This:C1470.request.context.entity)=Is object:K8:27)  // n.b. $Obj_request.context object already checked by previous method
					
					If (Length:C16(String:C10(This:C1470.request.context.entity.primaryKey))>0)
						
						$url:=$url+"&entity.primaryKey="+String:C10(This:C1470.request.context.entity.primaryKey)  // TODO query url encode
						
					End if 
				End if 
				
				$response.share:=New collection:C1472(New object:C1471("value"; $url; "type"; "url"))
				
			End if 
			// Else simple app open, no context
		End if 
	Else 
		$response.statusText:="Sharing is not available yet"
		$response.errors:=New collection:C1472("No url scheme to defined url to share")
	End if 
	
	$0:=$response
	