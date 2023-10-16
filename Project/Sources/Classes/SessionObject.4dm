
Class constructor($data : Object)
	
	If (OB Instance of:C1731($data; 4D:C1709.File))
		
		This:C1470.file:=$data
		This:C1470.refresh()
		
	Else 
		C_TEXT:C284($key)
		
		For each ($key; $data)
			This:C1470[$key]:=$data[$key]
		End for each 
	End if 
	
Function refresh
	If (This:C1470.file#Null:C1517)
		If (This:C1470.file.exists)
			
			C_TEXT:C284($key; $text; $errorMethod)
			C_OBJECT:C1216($object)
			
			$text:=This:C1470.file.getText()
			$errorMethod:=Method called on error:C704
			ON ERR CALL:C155("noError")
			If (Position:C15("{"; $text)=1)
				
				$object:=JSON Parse:C1218($text)
				For each ($key; $object)
					This:C1470[$key]:=$object[$key]
				End for each 
				
			End if 
			
			ON ERR CALL:C155($errorMethod)
			
		End if 
		
	End if 
	
Function save
	If (This:C1470.file#Null:C1517)
		C_OBJECT:C1216($object)
		C_TEXT:C284($key)
		$object:=New object:C1471()
		
		For each ($key; This:C1470)
			If ($key#"file")
				$object[$key]:=This:C1470[$key]
			End if 
		End for each 
		
		This:C1470.file.setText(JSON Stringify:C1217($object))
		
	End if 
	
Function getApp() : Object
	return cs:C1710.App.new(New object:C1471("application"; This:C1470.application; "team"; This:C1470.team))
	