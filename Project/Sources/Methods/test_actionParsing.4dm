//%attributes = {}

C_TEXT:C284($text)
C_OBJECT:C1216($action)
$text:="{\"action\":\"action_0\",\"context\":{\"dataClass\":\"Table_1\"},\"application\":{\"name\":\"My App\",\"id\":\"com.myCompany.My-App\"},\"team\":{\"id\":\"37UG5W39Z2\"},\"session\":{\"id\":\"b727a8c74e653137506fa4f3f11c933d8d33b2f9\",\"ip\":\"::1\"}}"
$action:=JSON Parse:C1218($text)


$action:=cs:C1710.Action.new($action)

