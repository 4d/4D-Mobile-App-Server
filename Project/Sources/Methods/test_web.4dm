//%attributes = {}

var $server : Object
$server:=WEB Server:C1674()

If (Not:C34($server.isRunning))
	$server.start()
End if 

var $url : Text
$url:="http://127.0.0.1:"+String:C10($server.HTTPPort)+"/4DAction/web_test_action"

ARRAY TEXT:C222($HeaderNames; 1)
ARRAY TEXT:C222($HeaderValues; 1)

$HeaderNames{1}:="X-QMobile-Context"
$HeaderValues{1}:="eyJkYXRhQ2xhc3MiOiAiVGFibGVfMSJ9"

var $response : Object
var $status : Integer
$status:=HTTP Request:C1158(HTTP GET method:K71:1; $url; ""; $response; $HeaderNames; $HeaderValues)

ASSERT:C1129($response.getDataClass; "No dataclass found in context")

$server.stop()