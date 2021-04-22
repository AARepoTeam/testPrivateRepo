Dim src_file1 'vMyDocPath
src_file1 = WScript.Arguments.Item(0)
'src_file1 = "C:\Users\BTDevGsc02\Documents\Automation Anywhere Files\Automation Anywhere\My Docs\GSC\PSC\SAP PGrp to ARIBA MDG Sync\"

Dim objExcel
Set objExcel = CreateObject("Excel.Application")
objExcel.Windowstate = -4137
objExcel.DisplayAlerts =False
objExcel.Visible = True
objExcel.EnableEvents = False

Set objWorkbook1= objExcel.Workbooks.Open(src_file1&"Exported File.csv")
Set objWorksheet1 = objWorkbook1.Worksheets("Exported File")

'Delete columns N thru V (Or just delete column N 9 times)
objWorksheet1.Columns("N:V").Delete

'Delete columns O thru RA (Or just delete column O 455 times)
objWorksheet1.Columns("O:RA").Delete

objWorkbook1.Save
objExcel.Quit
