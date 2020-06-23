//%attributes = {"invisible":true,"preemptive":"capable"}
  // Utility method to get object using primary key value.
  // /!\ This method do not check parameters. primaryKey must be defined in input.
C_OBJECT:C1216($0;$1;$2)
C_OBJECT:C1216($Obj_dataClass;$Obj_input;$Obj_entity)

$Obj_dataClass:=$1
$Obj_input:=$2

  // 1/ Using get (to test if work with string)
  // $Obj_entity:=$Obj_dataClass.get($Obj_input.primaryKey)

  // 2/ Using query 
$Obj_entity:=$Obj_dataClass.query($Obj_dataClass.getInfo().primaryKey+" = :1";$Obj_input.primaryKey)

If ($Obj_entity.length=1)
	
	$Obj_entity:=$Obj_entity[0]
	
Else   // expect only one
	
	$Obj_entity:=Null:C1517
	
End if 

$0:=$Obj_entity