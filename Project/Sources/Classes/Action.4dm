// Wrapper `On Mobile App Action` input
Class constructor($request : Object)
	
	This:C1470.name:=$request.action
	This:C1470.request:=$request
	
	If ($request=Null:C1517)
		
		ASSERT:C1129(False:C215; "Failed to "+Current method name:C684)
		
	End if 
	
	/// Handle with dataclass or entity class by calling action name function on target
Function handleWithClasses() : Object
	var $object : Object
	$object:=This:C1470.getTarget()
	
	Case of 
		: ($object=Null:C1517)
			return New object:C1471("success"; False:C215; "statusText"; "Cannot get action target")
		: ($object[This:C1470.name]=Null:C1517)
			return New object:C1471("success"; False:C215; "statusText"; "Unknown action.")
		Else 
			return $object[This:C1470.name].call($object; This:C1470.request)
	End case 
	
	// Get target of the action ie. dataClass or entity
Function getTarget() : Object
	If (Value type:C1509(This:C1470.request.context.entity)=Is object:K8:27)
		return This:C1470.getEntity()
	Else 
		return This:C1470.getDataClass()
	End if 
	
Function getDataClass() : Object
	return Mobile App Action GetDataClass(This:C1470.request)
	
Function getEntity() : Object
	return Mobile App Action GetEntity(This:C1470.request)
	
Function getParent() : Object
	return MA Action GetParentEntity(This:C1470.request)
	
Function newEntity() : Object
	return Mobile App Action NewEntity(This:C1470.request)
	
Function dropEntity() : Object
	return Mobile App Action DropEntity(This:C1470.request)
	
Function link() : Object
	return Mobile App Action Link(This:C1470.request)
	
Function unlink() : Object
	return Mobile App Action Unlink(This:C1470.request)
	
Function getApp() : Object
	return MobileAppServer.App.new(New object:C1471("application"; This:C1470.request.application; "team"; This:C1470.request.team))
	
Function shareContext()->$response : Object
	$response:=New object:C1471("success"; False:C215)
	
	If (Value type:C1509(This:C1470.request.context)=Is object:K8:27)
		
		C_OBJECT:C1216($app; $context)
		$context:=This:C1470.request.context
		$app:=This:C1470.getApp()
		
		C_TEXT:C284($url)
		
		Case of 
			: (Bool:C1537($app.hasAssociatedDomain()))
				
				$response.success:=True:C214
				$url:=$app.universalLink($context)
				$response.share:=New collection:C1472(New object:C1471("value"; $url; "type"; "url"))
				
			: (Bool:C1537($app.hasURLScheme()))
				
				$response.success:=True:C214
				$url:=$app.urlSchemeURL($context)
				$response.share:=New collection:C1472(New object:C1471("value"; $url; "type"; "url"))
				
			Else 
				$response.statusText:="Sharing is not available yet"
				$response.errors:=New collection:C1472("No url scheme to defined url to share")
		End case 
		
	Else 
		// No context to share
	End if 
	
	$0:=$response
	