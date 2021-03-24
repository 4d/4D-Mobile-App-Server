//%attributes = {}

If (curlWinPath=Null:C1517)
	
	If (Folder:C1567(fk resources folder:K87:11).file("curl.exe").exists)
		
		// use embedded curl
		curlWinPath:="\""+File("/RESOURCES/curl.exe").platformPath+"\""  // escaped one
		
	Else 
		
		// or find one in path
		C_TEXT:C284($out; $in; $err; $path; $line)
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "True")
		LAUNCH EXTERNAL PROCESS:C811("where curl.exe"; $in; $out; $err)
		
		C_COLLECTION:C1488($lines)
		$lines:=Split string:C1554($out; "\r\n")
		
		// LAUNCH EXTERNAL PROCESS("curl.exe --version"; $in; $out; $err) // to check one that 4D launch from path (seems to use system one instead of one from path)
		
		$path:=""
		For each ($line; $lines) Until (Length:C16($path)>0)
			If (Length:C16($line)>0)
				SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "True")
				LAUNCH EXTERNAL PROCESS:C811("\""+$line+"\" --http2 -sSf http://example.org"; $in; $out; $err)
				If (Position:C15("Unsupported protocol"; $err)=0)
					$path:=$line
				End if 
				
/*LAUNCH EXTERNAL PROCESS($line+" --version"; $in; $out; $err)
$pos:=Position("("; $out)
If ($pos>0)
C_TEXT($version)
$version:=Substring($out; 6; $pos-7)
C_COLLECTION($versionComponents)
$versionComponents:=Split string($version; ".")
If (Num($versionComponents[0])>=7)
End if
End if */
			End if 
		End for each 
		
		If (Length:C16($path)>0)
			curlWinPath:="\""+$path+"\""  // escaped one
		Else 
			curlWinPath:="curl.exe"
		End if 
	End if 
	
End if 