//%attributes = {"preemptive":"capable"}
C_OBJECT:C1216($input;$action)
C_OBJECT:C1216($entity;$status)
C_OBJECT:C1216($dataclass)

$input:=New object:C1471("context";New object:C1471("dataClass";"Table_1"))
$action:=Mobile App Action ($input)
$action:=MobileAppServer .Action.new($input)

  // TEST: get dataclass
$dataclass:=$action.getDataClass()

If (Asserted:C1132($dataclass#Null:C1517;"Not data class"))
	
	  // clean
	For each ($entity;$dataclass.all())
		$status:=$entity.drop()
	End for each 
	
	  // TEST: create entity
	$entity:=$action.newEntity()
	ASSERT:C1129($entity#Null:C1517)
	
	If ($entity#Null:C1517)
		
		$entity.ID:=1
		$status:=$entity.save()
		ASSERT:C1129($status.success;JSON Stringify:C1217($status))
		
		If ($status.success)
			  // TEST: get entity
			$input.context.entity:=New object:C1471("primaryKey";$entity.ID)
			ASSERT:C1129($action.getEntity().ID=$entity.ID)  // there is no equal for entity....
		End if 
		
		  // Test: get parent
		C_TEXT:C284($parentDataClassName)
		C_OBJECT:C1216($parent;$parentDataClass)
		
		$parentDataClassName:="Table_2"
		$parentDataClass:=ds:C1482[$parentDataClassName]
		For each ($parent;$parentDataClass.all())
			$status:=$parent.drop()
		End for each 
		
		$parent:=$parentDataClass.new()
		$parent.ID:=1
		$parent.save()
		
		$input.context.parent:=New object:C1471("dataClass";"Table_2";"primaryKey";$parent.ID)
		ASSERT:C1129($action.getParent().ID=$parent.ID)  // there is no equal for entity....
		
		  // Test: link
		C_OBJECT:C1216($entityLink)
		C_TEXT:C284($relationName;$inverseRelationName)
		
		$relationName:="table2"
		$inverseRelationName:="tables1"
		
		$input.context.entity.relationName:=$relationName
		$input.context.parent.relationName:=$inverseRelationName
		$entityLink:=$action.link()
		
		If (Asserted:C1132($entityLink.success;"link() method failed"))
			
			$status:=$entityLink.save()
			ASSERT:C1129($status.success;JSON Stringify:C1217($status))
			
			If (Asserted:C1132($entityLink.entity[$relationName]#Null:C1517;"No "+$relationName+" relation in entity"))
				
				ASSERT:C1129($entityLink.entity[$relationName].ID=$parent.ID)  // there is no equal for entity....
				ASSERT:C1129($parent[$inverseRelationName].contains($entityLink.entity))
				
				  // Test unlink
				$entityLink:=$action.unlink()
				
				If (Asserted:C1132($entityLink.success;"unlink() method failed"))
					
					$status:=$entityLink.save()
					ASSERT:C1129($status.success;JSON Stringify:C1217($status))
					
					ASSERT:C1129($entityLink.entity[$relationName]=Null:C1517;"unlink() method didn't nullify the relation")
					  //$parent:=$action.getParent()  // Workaround , gotten parent before has not been updated
					$status:=$parent.reload()
					ASSERT:C1129($status.success;JSON Stringify:C1217($status))
					
					ASSERT:C1129(Not:C34($parent[$inverseRelationName].contains($entityLink.entity)))
					
					
				End if 
			End if 
		End if 
	End if 
End if 

  // Test:- dropEntity
$status:=$action.dropEntity()
ASSERT:C1129($status.success;JSON Stringify:C1217($status))
ASSERT:C1129($action.getEntity()=Null:C1517;"entity not really dropped")