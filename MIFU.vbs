mcloc=InputBox("Please enter you .minecraft location ex.) C:\Path\To\Your\multimcinstace (leave blank if you wish to download to the directory this program is in)")
currDir = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")
if mcloc = nil then mcloc = currDir
Msgbox("You selected: " & mcloc)

Function checkModlist()
  Set fso = CreateObject("Scripting.FileSystemObject")
	If (fso.FileExists(currDir & "\Modlist.txt")) Then
	   'Modlist.txt Exists > Continue
	Else
		'Modlist.txt does not exist > Download default one
		Msgbox("Modlist.txt at: (" & currDir & ") doesn't exist.")
		strFileURL = "http://dl.bloccrew.com/Modlist.txt"
		download(currDir & "\Modlist.txt")
	End If
End Function

Sub download(strHDLocation)
    Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
    objXMLHTTP.open "GET", strFileURL, false
    objXMLHTTP.send()
    If objXMLHTTP.Status = 200 Then
      Set objADOStream = CreateObject("ADODB.Stream")
      objADOStream.Open
      objADOStream.Type = 1 
      objADOStream.Write objXMLHTTP.ResponseBody
      objADOStream.Position = 0    
      Set objFSO = Createobject("Scripting.FileSystemObject")
        If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation
      Set objFSO = Nothing
      objADOStream.SaveToFile strHDLocation
      objADOStream.Close
      Set objADOStream = Nothing
    End if
    Set objXMLHTTP = Nothing
End Sub

'checkModlist()
Const ForReading = 1
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objTextFile = objFSO.OpenTextFile _
    ("Modlist.txt", ForReading)
Do Until objTextFile.AtEndOfStream
    strNextLine = objTextFile.Readline
    arrModList = Split(strNextLine , ",")
	strFileURL = arrModList(0)
    For i = 1 to Ubound(arrModList)
		download(mcloc & arrModList(i))
    Next
Loop

MsgBox("Finished Downloading Mods")
