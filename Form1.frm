VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4320
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9390
   LinkTopic       =   "Form1"
   ScaleHeight     =   4320
   ScaleWidth      =   9390
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   1845
      TabIndex        =   0
      Top             =   495
      Width           =   3750
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    
    Dim rv As Long
    Dim hDukLib As Long
    Dim dlg As New clsCmnDlg2
    Dim fso As New CFileSystem2
    Dim tmp As String
    
    hDukLib = LoadLibrary(App.Path & "\duk4vb.dll") 'to ensure the ide finds the dll
    
    If hDukLib = 0 Then
        MsgBox "Could not load duk4vb.dll?", vbCritical
        Exit Sub
    End If
    
    SetCallBacks AddressOf vb_stdout, 0, AddressOf HostResolver, AddressOf VbLineInput
    DukCreate
    AddObject dlg, "cmndlg"
    AddObject fso, "fso"
    AddObject Me, "form"
 
    'CallByNameEx dlg, "OpenDialog", VbMethod, Array(0, "title", "c:\", 4)
    
    rv = AddFile(App.Path & "\test.js")
    If rv <> 0 Then
        MsgBox "Addfile Error: " & GetLastString()
    End If
    
    rv = Eval("prompt('text')") 'works
    'rv = Eval("1+2") 'works
    'Eval "alert(1+2)" 'works
    'Eval "a='testing';alert(a[0]);" 'works
    'rv = Eval("pth = cmndlg.ShowOpen(4,'title','c:\\',0); alert(fso.ReadFile(pth))") 'works
    'Eval "form.caption = 'test!'; alert(form.ReadFile('c:\\lastGraph.txt'));"
    'Eval "form.caption = 'test!';alert(form.caption)"
     
    If rv < 0 Then
        Text1.text = "Error: " & GetLastString()
    Else
        If GetLastStringSize() > 0 Then
            Text1.text = GetLastString()
        End If
    End If
    
    DukDestroy
    FreeLibrary hDukLib 'so the ide doesnt hang on to the dll and we can recompile it..
    
End Sub
