//%attributes = {"invisible":true,"shared":true,"executedOnServer":true}
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)
C_VARIANT:C1683($2)

C_TEXT:C284($t;$t_document)
C_OBJECT:C1216($error;$o;$o_result;$o_this)
C_COLLECTION:C1488($c_tables)

If (False:C215)
	C_OBJECT:C1216(dev UpdateStructure ;$0)
	C_OBJECT:C1216(dev UpdateStructure ;$1)
	C_VARIANT:C1683(dev UpdateStructure ;$2)
End if 

$o_this:=$1

$o_result:=New object:C1471(\
"success";True:C214;\
"errors";New collection:C1472;\
"log";New collection:C1472)

Case of 
		
		  //______________________________________________________
	: (Value type:C1509($2)=Is collection:K8:32)
		
		$c_tables:=$2
		
		  //______________________________________________________
	: (Value type:C1509($2)=Is text:K8:3)
		
		$c_tables:=New collection:C1472($2)
		
		  //______________________________________________________
	Else 
		
		$o_result.success:=False:C215
		$o_result.errors.push("The parameter must be a text or a collection")
		
		  //______________________________________________________
End case 

If ($o_result.success)
	
	  // Backup DOCUMENT value
	$t_document:=DOCUMENT
	
/* -----------------------------  START TRAPPING ERRORS ----------------------------- */
	$error:=err .capture()
	
	  // Create table if any
	DOCUMENT:="CREATE TABLE IF NOT EXISTS "+String:C10($o_this.deletedRecordsTable.name)+" ("
	
	For each ($o;$o_this.deletedRecordsTable.fields)
		
		DOCUMENT:=DOCUMENT+" "+String:C10($o.name)+" "+String:C10($o.type)+","
		
		If (Bool:C1537($o.primaryKey))
			
			DOCUMENT:=DOCUMENT+" PRIMARY KEY ("+String:C10($o.name)+"),"
			
		End if 
	End for each 
	
	DOCUMENT:=Delete string:C232(DOCUMENT;Length:C16(DOCUMENT);1)+");"
	
	Begin SQL
		
		EXECUTE IMMEDIATE :DOCUMENT
		
	End SQL
	
	If ($error.lastError().stack#Null:C1517)
		
		$o_result.errors.push($error.lastError().stack[0].error+" ("+$t+")")
		$o_result.log.push("failed to create table "+$o_this.deletedRecordsTable.name)
		
	End if 
	
	$o_result.success:=($o_result.errors.length=0)
	
	If ($o_result.success)
		
		For each ($o;$o_this.deletedRecordsTable.fields) While ($o_result.success)
			
			If (Bool:C1537($o.autoincrement))
				
				$error.reset()
				
				DOCUMENT:="ALTER TABLE "+String:C10($o_this.deletedRecordsTable.name)+" MODIFY "+String:C10($o.name)+" ENABLE AUTO_INCREMENT;"
				
				Begin SQL
					
					EXECUTE IMMEDIATE :DOCUMENT
					
				End SQL
				
				If ($error.lastError().stack#Null:C1517)
					
					$o_result.errors.push($error.lastError().stack[0].error+" ("+$t+")")
					$o_result.log.push("failed to create set auto increment for the field "+$o.name+" in "+$o_this.deletedRecordsTable.name)
					
				End if 
				
				$o_result.success:=($o_result.errors.length=0)
				
			End if 
		End for each 
	End if 
	
	If ($o_result.success)
		
		  // Create the indexes if any
		For each ($o;$o_this.deletedRecordsTable.fields) While ($o_result.success)
			
			If (Bool:C1537($o.indexed))
				
				DOCUMENT:="CREATE INDEX "+String:C10($o_this.deletedRecordsTable.name)+String:C10($o.name)+" ON "+String:C10($o_this.deletedRecordsTable.name)+" ("+String:C10($o.name)+");"
				
				$error.reset()
				
				Begin SQL
					
					EXECUTE IMMEDIATE :DOCUMENT
					
				End SQL
				
				If ($error.lastError().stack#Null:C1517)
					
					If ($error.lastError().stack[0].code=1155)
						
						  // Index already exists
						
					Else 
						
						$o_result.errors.push($error.lastError().stack[0].error+" ("+$t+")")
						$o_result.log.push("failed to create index for the field "+String:C10($o.name)+" in "+String:C10($o_this.deletedRecordsTable.name))
						
					End if 
				End if 
			End if 
		End for each 
		
		$o_result.success:=($o_result.errors.length=0)
		
	End if 
	
	If ($o_result.success)
		
		$o_result.log.push("table "+$o_this.deletedRecordsTable.name+" is up to date")
		
		For each ($t;$c_tables) While ($o_result.success)
			
			If (ds:C1482[$t]#Null:C1517)
				
				DOCUMENT:="ALTER TABLE ["+$t+"] ADD TRAILING "+String:C10($o_this.stampField.name)+" "+String:C10($o_this.stampField.type)+";"
				
				$error.reset()
				
				Begin SQL
					
					EXECUTE IMMEDIATE :DOCUMENT
					
				End SQL
				
				If ($error.lastError().stack#Null:C1517)
					
					If ($error.lastError().stack[0].code=1053)
						
						  // Field name already exists
						
					Else 
						
						$o_result.errors.push($error.lastError().stack[0].error+" ("+$t+")")
						$o_result.log.push("failed to create field "+String:C10($o_this.stampField.name)+" in "+$t)
						
					End if 
				End if 
				
				$o_result.success:=($o_result.errors.length=0)
				
				If ($o_result.success)
					
					If (Bool:C1537($o_this.stampField.indexed))
						
						DOCUMENT:="CREATE INDEX "+String:C10($o_this.stampField.name)+"_"+dev IndexName ($t)+" ON ["+$t+"] ("+String:C10($o_this.stampField.name)+");"
						
						$error.reset()
						
						Begin SQL
							
							EXECUTE IMMEDIATE :DOCUMENT
							
						End SQL
						
						If ($error.lastError().stack#Null:C1517)
							
							If ($error.lastError().stack[0].code=1155)
								
								  // Index already exists
								
							Else 
								
								$o_result.errors.push($error.lastError().stack[0].error+" ("+$t+")")
								$o_result.log.push("failed to create index for the field "+String:C10($o_this.stampField.name)+" in "+$t)
								
							End if 
						End if 
						
						$o_result.success:=($o_result.errors.length=0)
						
					End if 
				End if 
				
				If ($o_result.success)
					
					$o_result.log.push("table "+$t+" is up to date")
					
				End if 
				
			Else 
				
				$o_result.success:=False:C215
				$o_result.log.push("Missing table "+$t)
				
			End if 
		End for each 
	End if 
	
/* -----------------------------  STOP TRAPPING ERRORS ----------------------------- */
	$error.release()
	
	  // Restore DOCUMENT value
	DOCUMENT:=$t_document
	
End if 

  // Return result
$0:=$o_result