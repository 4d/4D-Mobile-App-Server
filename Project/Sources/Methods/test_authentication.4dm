//%attributes = {"preemptive":"capable"}
C_OBJECT:C1216($input;$auth;$file;$session)
C_TEXT:C284($appID)

$input:=New object:C1471(\
"application";New object:C1471("id";"com.myCompany.My-App";"name";"My App");\
"team";New object:C1471("id";"58P9JF46LX"))
$auth:=Mobile App Authentication ($input)
$auth:=MobileAppServer .Authentication.new($input)

$appID:=$auth.getAppID()
ASSERT:C1129($appID#Null:C1517;"no app id")

$input.session:=New object:C1471("id";"547302015c7366daf048dfa58048d2ae37ae2bc8")
Folder:C1567(fk mobileApps folder:K87:18;*).folder($appID).create()

$file:=$auth.getSessionFile()
ASSERT:C1129($file#Null:C1517)

If ($file#Null:C1517)
	
	If (Not:C34($file.exists))
		
		$file.setText(\
			"{\"application\":{\"name\":\"My App\",\"version\":\"1.0.0\",\"id\":\"com.myCompany.My-App\"},"\
			+"\"team\":{\"id\":\"58P9JF46LX\"},"\
			+"\"email\":\"\",\"device\":{\"simulator\":true,\"id\":\"42A08892-63DB-4FD5-991A-0EB213219AE0\",\"description\":\"iPhone 11 Pro Max\"},"\
			+"\"language\":{\"id\":\"en\",\"code\":\"en\"},\"send\":\"link\","\
			+"\"session\":{\"id\":\"547302015c7366daf048dfa58048d2ae37ae2bc8\",\"ip\":\"::1\"},"\
			+"\"status\":\"accepted\",\"token\":\"eyJhcHBOYW1lSUQiOiJjb20ubXlDb21wYW55Lk15LUFwcCIsImlkIjoiNTQ3MzAyMDE1YzczNjZkYWYwNDhkZmE1ODA0OGQyYWUzN2FlMmJjOCIsInRlYW1JRCI6IjU4UDlKRjQ2TFgifQ\"}"\
			)
	End if 
	
	If ($file.exists)
		
		$session:=$auth.getSessionObject()
		ASSERT:C1129($session#Null:C1517)
		
		$session.status:="pending"
		$session.save()  // $file.setText(JSON Stringify($session))
		MOBILE APP REFRESH SESSIONS:C1596
		
	End if 
End if 