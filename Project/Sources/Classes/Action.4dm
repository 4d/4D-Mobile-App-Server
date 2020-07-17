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
	