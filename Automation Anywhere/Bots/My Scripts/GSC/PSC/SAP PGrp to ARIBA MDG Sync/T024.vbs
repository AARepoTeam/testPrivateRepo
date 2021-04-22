Dim src_file1
src_file1 = WScript.Arguments.Item(0)
'src_file1 = "C:\Users\BTDevGsc02\Documents\Automation Anywhere Files\Automation Anywhere\My Docs\GSC\PSC\SAP PGrp to ARIBA MDG Sync\"

'dim answer
'answer=MsgBox(src_file1,65,"vLocalMyDocs")


If Not IsObject(application) Then
   Set SapGuiAuto  = GetObject("SAPGUI")
   Set application = SapGuiAuto.GetScriptingEngine
End If
If Not IsObject(connection) Then
   Set connection = application.Children(0)
End If
If Not IsObject(session) Then
   Set session    = connection.Children(0)
End If
If IsObject(WScript) Then
   WScript.ConnectObject session,     "on"
   WScript.ConnectObject application, "on"
End If
session.findById("wnd[0]").maximize
session.findById("wnd[0]/tbar[0]/okcd").text = "SE16N"
session.findById("wnd[0]/tbar[0]/btn[0]").press
session.findById("wnd[0]/usr/ctxtGD-TAB").text = "T024"
session.findById("wnd[0]/usr/ctxtGD-TAB").caretPosition = 4
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/txtGD-MAX_LINES").text = ""
session.findById("wnd[0]/usr/txtGD-MAX_LINES").setFocus
session.findById("wnd[0]/usr/txtGD-MAX_LINES").caretPosition = 0
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/usr/cntlRESULT_LIST/shellcont/shell").pressToolbarContextButton "&MB_EXPORT"
session.findById("wnd[0]/usr/cntlRESULT_LIST/shellcont/shell").selectContextMenuItem "&XXL"
session.findById("wnd[1]/usr/cmbG_LISTBOX").setFocus
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[1]/usr/ctxtDY_PATH").setFocus
session.findById("wnd[1]/usr/ctxtDY_PATH").caretPosition = 0
session.findById("wnd[1]").sendVKey 4
session.findById("wnd[2]/usr/ctxtDY_PATH").text = src_file1
session.findById("wnd[2]/usr/ctxtDY_FILENAME").text = "T024.XLSX"
session.findById("wnd[2]/usr/ctxtDY_FILENAME").caretPosition = 9
session.findById("wnd[2]/tbar[0]/btn[11]").press
session.findById("wnd[1]/tbar[0]/btn[11]").press
session.findById("wnd[0]/tbar[0]/btn[3]").press

WScript.Sleep 9000

'T024.XLSX should already automatically be opened from SAP in Excel  here

'Set an Excel Session to the already open T024.XLSX file from SAP

Dim objExcel
Set objExcel = GetObject(src_file1&"T024.XLSX").Application
objExcel.Windowstate = -4137
objExcel.DisplayAlerts =False
objExcel.Visible = True
objExcel.EnableEvents = False

Set objWorkbook1= objExcel.ActiveWorkbook
Set objWorksheet1 = objWorkbook1.Worksheets("Sheet1")

'Remove all rows that contain "X" IN COLUMN E ("Fax number")
    objWorksheet1.Range("A1:H1048576").AutoFilter 5, "=x"
    objWorksheet1.AutoFilter.Range.Offset(1, 0).EntireRow.Delete
    objWorksheet1.AutoFilter.ShowAllData

	'Remove blank rows
    objWorksheet1.Range("A1:H1048576").AutoFilter 1, "="
    objWorksheet1.AutoFilter.Range.Offset(1, 0).EntireRow.Delete
    objWorksheet1.AutoFilter.ShowAllData

'Remove THE 001 PURCHASING GROUP ROW
    objWorksheet1.Range("A1:H1048576").AutoFilter 1, "=001"
    objWorksheet1.AutoFilter.Range.Offset(1, 0).EntireRow.Delete
    objWorksheet1.AutoFilter.ShowAllData

	'Create Concatenated Values for ARIBA
objWorksheet1.Range("I1:I" & objWorksheet1.UsedRange.Rows.Count).Formula = "=RC[-8]&"";""&RC[-7]"
objWorksheet1.Columns("I:I").Copy
objWorksheet1.Columns("I:I").PasteSpecial(-4163)
objWorkbook1.Worksheets("Sheet1").Range("I1").value = "AribaFormat"

'Remove all rows that contain "DO NOT USE" '3/4/2020 this section no longer needed since business proecss has been updated to utlize the "Fax number" to flag any invalid Pgrps by an "X" identifier
'    objWorksheet1.Range("A1:H1048576").AutoFilter 2, "=*DO NOT USE*"
'    objWorksheet1.AutoFilter.Range.Offset(1, 0).EntireRow.Delete
'    objWorksheet1.AutoFilter.ShowAllData

'Remove all rows that contain "DON'T USE" '3/4/2020 this section no longer needed since business proecss has been updated to utlize the "Fax number" to flag any invalid Pgrps by an "X" identifier
'    objWorksheet1.Range("A1:H1048576").AutoFilter 2, "=*DON'T USE*"
'    objWorksheet1.AutoFilter.Range.Offset(1, 0).EntireRow.Delete
'    objWorksheet1.AutoFilter.ShowAllData




objWorkbook1.Save
objExcel.Quit