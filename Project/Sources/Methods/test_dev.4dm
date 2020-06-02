//%attributes = {}
C_OBJECT:C1216($o;$oDev)
C_COLLECTION:C1488($c)

$oDev:=MobileAppServer .Dev.new()

/* ========================================================== */
$o:=$oDev.updateStructure("Table_1")  // Should be a success

ASSERT:C1129($o.success)
ASSERT:C1129($o.errors.length=0)

If (Asserted:C1132($o.log.length=2))
	
	ASSERT:C1129($o.log[0]="table __DeletedRecords is up to date")
	ASSERT:C1129($o.log[1]="table Table_1 is up to date")
	
End if 

/* ========================================================== */
$o:=$oDev.updateStructure("table_1")  // Should be a failure (diacritic)

ASSERT:C1129(Not:C34($o.success))

If (Asserted:C1132($o.log.length=2))
	
	ASSERT:C1129($o.log[0]="table __DeletedRecords is up to date")
	ASSERT:C1129($o.log[1]="Missing table table_1")
	
End if 

/* ========================================================== */
$c:=New collection:C1472("Table_1";"Table_2")  // Should be a success
$o:=$oDev.updateStructure($c)

ASSERT:C1129($o.success)
ASSERT:C1129($o.errors.length=0)

If (Asserted:C1132($o.log.length=3))
	
	ASSERT:C1129($o.log[0]="table __DeletedRecords is up to date")
	ASSERT:C1129($o.log[1]="table Table_1 is up to date")
	ASSERT:C1129($o.log[2]="table Table_2 is up to date")
	
End if 

/* ========================================================== */

