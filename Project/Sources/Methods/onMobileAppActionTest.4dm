//%attributes = {"invisible":true,"preemptive":"capable"}

C_OBJECT:C1216($0; $response)
C_OBJECT:C1216($1; $action)

$action:=cs:C1710.Action.new($1)  // Informations provided by mobile application
$response:=New object:C1471  // Informations returned to mobile application

C_OBJECT:C1216($app)
$app:=$action.getApp()

Case of 
		
	: ($action.name="action_0")
		
		// Insert here the code for the action "action_0"
		
		$response:=$action.shareContext()
		
	: ($action.name="addTable1")
		
		// Insert here the code for the action "Add…"
		
	: ($action.name="editTable2")
		
		// Insert here the code for the action "Edit…"
		
	Else 
		
		// Unknown action
		
End case 

$0:=$response