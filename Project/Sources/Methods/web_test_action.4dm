//%attributes = {"invisible":true,"publishedWeb":true}
var $handler; $context; $response : Object

$handler:=cs:C1710.WebHandler.new()
$context:=$handler.getContext()

$response:=New object:C1471("getDataClass"; $context.getDataClass()#Null:C1517)

WEB SEND TEXT:C677(JSON Stringify:C1217($response))