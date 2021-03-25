/*

Utility methods for development stage

*/

Class constructor
	
	This:C1470.deletedRecordsTable:=New object:C1471(\
		"name";"__DeletedRecords";\
		"fields";New collection:C1472)
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"ID";\
		"type";"INT64";\
		"indexed";True:C214;\
		"primaryKey";True:C214;\
		"autoincrement";True:C214))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__Stamp";\
		"type";"INT64";\
		"indexed";True:C214))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableNumber";\
		"type";"INT32"))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableName";\
		"type";"VARCHAR(255)"))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__PrimaryKey";\
		"type";"VARCHAR(255)"))
	
	This:C1470.stampField:=New object:C1471(\
		"name";"__GlobalStamp";\
		"type";"INT64";\
		"indexed";True:C214)
	
/*=======================================================*/
Function updateStructure  // executed on server if any
	
	C_VARIANT:C1683($1)
	C_OBJECT:C1216($0)
	
	$0:=dev UpdateStructure (This:C1470;$1)
	
/*=======================================================*/