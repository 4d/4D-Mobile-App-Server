Class constructor
	ARRAY TEXT:C222($names; 0)
	ARRAY TEXT:C222($values; 0)
	WEB GET HTTP HEADER:C697($names; $values)
	
	var $index : Integer
	$index:=Find in array:C230($names; "X-QMobile-Context")
	If ($index>0)
		var $tmpBlob : 4D:C1709.Blob
		var $contextJSON; $key; $errorMethod : Text
		var $contextObject : Object
		
		$errorMethod:=Method called on error:C704
		ON ERR CALL:C155("noError")
		
		BASE64 DECODE:C896($values{$index}; $tmpBlob)
		$contextJSON:=BLOB to text:C555($tmpBlob; UTF8 text without length:K22:17)
		If (Position:C15("{"; $contextJSON)=1)
			$contextObject:=JSON Parse:C1218($contextJSON)
			For each ($key; $contextObject)
				This:C1470[$key]:=$contextObject[$key]
			End for each 
		End if 
		
		ON ERR CALL:C155($errorMethod)
		
	End if 
	
Function getDataClass()->$dataClass : 4D:C1709.DataClass
	If (This:C1470.dataClass#Null:C1517)
		$dataClass:=ds:C1482[This:C1470.dataClass]
	End if 
	
Function getEntity()->$entity : 4D:C1709.Entity
	If ((This:C1470.entity#Null:C1517) && (This:C1470.entity.primaryKey#Null:C1517))
		var $dataClass : Object
		$dataClass:=This:C1470.getDataClass()
		If ($dataClass#Null:C1517)
			$entity:=$dataClass.get(This:C1470.entity.primaryKey)
		End if 
	End if 
	
