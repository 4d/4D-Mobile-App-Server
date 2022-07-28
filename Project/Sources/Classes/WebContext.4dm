Class constructor
	ARRAY TEXT:C222($names; 0)
	ARRAY TEXT:C222($values; 0)
	WEB GET HTTP HEADER:C697($names; $values)
	
	var $index : Integer
	$index:=Find in array:C230($names; "X-DataClass")
	If ($index>0)
		This:C1470.dataClassName:=$values{$index}
	End if 
	
	$index:=Find in array:C230($names; "X-Primary-Key-Value")
	If ($index>0)
		This:C1470.primaryKeyValue:=$values{$index}
	End if 
	
Function getDataClass()->$dataClass : 4D:C1709.DataClass
	If (This:C1470.dataClassName#0)
		$dataClass:=ds:C1482[This:C1470.dataClassName]
	End if 
	
Function getEntity()->$entity : 4D:C1709.Entity
	If (This:C1470.primaryKeyValue#0)
		var $dataClass : Object
		$dataClass:=This:C1470.dataClass
		If ($dataClass#Null:C1517)
			$entity:=$dataClass.get(This:C1470.primaryKeyValue)
		End if 
	End if 
	