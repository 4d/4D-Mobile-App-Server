//%attributes = {"invisible":true,"preemptive":"capable"}
  /// # Mobile App Action NewEntity
  //: Utility method to return a new entity to apply action from `$1` context in `On Mobile App Action` database method.
/*:
## Overview

in `On Mobile App Action`

```4d
Case of 

    : ($1.action="addMyNewEntity")

     $newEntity:=Mobile App Action NewEntity($1)
     $status:=$newEntity.save()
````

*/
C_OBJECT:C1216($1)  /// * $1: Object containing `context.dataClass` and `parameters` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  /// * $0: Return the bnew entity corresponding to the action.

C_OBJECT:C1216($Obj_request;$Obj_dataClass;$Obj_entity)
C_TEXT:C284($Txt_key)

$Obj_request:=$1

$Obj_dataClass:=Mobile App Action GetDataClass ($Obj_request)

If ($Obj_dataClass#Null:C1517)
	
	$Obj_entity:=$Obj_dataClass.new()
	
	If (Value type:C1509($Obj_request.parameters)=Is object:K8:27)
		
		For each ($Txt_key;$Obj_request.parameters)
			
			$Obj_entity[$Txt_key]:=$Obj_request.parameters[$Txt_key]
			
		End for each 
		
	End if 
End if 

$0:=$Obj_entity