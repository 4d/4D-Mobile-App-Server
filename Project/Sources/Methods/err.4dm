//%attributes = {"invisible":true}
  // ----------------------------------------------------
  // Project method : err
  // ID[113B9039655C4E06B194A25A54380846]
  // Created 7-10-2019 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  //
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)
C_TEXT:C284($1)
C_OBJECT:C1216($2)

C_TEXT:C284($t)
C_OBJECT:C1216($o)

If (False:C215)
	C_OBJECT:C1216(err ;$0)
	C_TEXT:C284(err ;$1)
	C_OBJECT:C1216(err ;$2)
End if 

  // ----------------------------------------------------
If (This:C1470[""]=Null:C1517)  // Constructor
	
	C_OBJECT:C1216(\
		errors;\
		errStack;\
		lastError\
		)
	
	$o:=New object:C1471(\
		"";"errors";\
		"stack";New collection:C1472;\
		"current";"";\
		"lastError";Formula:C1597(lastError);\
		"hide";Formula:C1597(err ("hide"));\
		"show";Formula:C1597(This:C1470.deinstall());\
		"capture";Formula:C1597(err ("capture"));\
		"Continue";Formula:C1597(ERROR=0);\
		"reset";Formula:C1597(lastError:=Null:C1517);\
		"release";Formula:C1597(This:C1470.deinstall());\
		"install";Formula:C1597(err ("install";New object:C1471("method";String:C10($1))));\
		"deinstall";Formula:C1597(err ("deinstall"));\
		"remove";Formula:C1597(err ("remove"))\
		)
	
	If (Count parameters:C259>=1)
		
		$o.install($1)
		
	End if 
	
Else 
	
	$o:=This:C1470
	
	Case of 
			
			  //______________________________________________________
		: ($o=Null:C1517)
			
			ASSERT:C1129(False:C215;"OOPS, this method must be called from a member method")
			
			  //______________________________________________________
		: ($1="install")  // Installs an error-handling method
			
			  // Record the current method called on error
			$o.stack.unshift(Method called on error:C704)
			
			$t:=String:C10($2.method)
			
			If ($t#$o.current)
				
				  // Install the method
				ON ERR CALL:C155($t)
				
			End if 
			
			$o.current:=$t
			
			CLEAR VARIABLE:C89(ERROR)
			CLEAR VARIABLE:C89(ERROR METHOD)
			CLEAR VARIABLE:C89(ERROR LINE)
			CLEAR VARIABLE:C89(ERROR FORMULA)
			
			  //______________________________________________________
		: ($1="capture")  // Install a local capture of the errors
			
			lastError:=Null:C1517
			
			  // Record the current method called on error
			$o.stack.unshift(Method called on error:C704)
			
			  // Install the method
			ON ERR CALL:C155("errors_CAPTURE")
			
			$o.current:="errors_CAPTURE"
			
			  //______________________________________________________
		: ($1="hide")
			
			  // Record the current method called on error
			$o.stack.unshift(Method called on error:C704)
			
			  // Install the method
			ON ERR CALL:C155("errors_HIDE")
			
			$o.current:="errors_HIDE"
			
			  //______________________________________________________
		: ($1="deinstall")  // Deinstalls the last error-handling method and restore the previous one
			
			If ($o.stack.length>0)
				
				  // Get the previous method if any
				$t:=String:C10($o.stack.shift())
				$o.current:=$t
				
			Else 
				
				  // NO MORE ERROR CAPTURE
				
			End if 
			
			ON ERR CALL:C155($t)
			
			  //______________________________________________________
		: ($1="remove")  // Stop the trapping of errors
			
			$o.stack:=New collection:C1472
			$o.current:=""
			
			ON ERR CALL:C155("")
			
			  //______________________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"Unknown entry point: \""+$1+"\"")
			
			  //______________________________________________________
	End case 
End if 

  // ----------------------------------------------------
  // Return
$0:=$o

  // ----------------------------------------------------
  // End