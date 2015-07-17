VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CResponseBuffer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private buf() As Byte
Public Position As Long
Public length As Long
Public isEmpty  As Boolean

Function GetBuf(sz As Long, outBuf() As Byte) As Boolean
        
    Dim endAt As Long
    
    Erase outBuf
    endAt = Position + sz
    If endAt > length Then Exit Function
    
    For i = 1 To sz
        bpush outBuf, buf(Position + i - 1)
        Position = Position + 1
    Next
    
    If Position = length Then isEmpty = True
    GetBuf = True
    
End Function

Sub Clear()
    Erase buf
    Position = 0
    length = 0
    isEmpty = True
End Sub

Sub AddByte(b)
    bpush buf, CByte(b)
    length = length + 1
    isEmpty = False
End Sub

Function ConstructMessage(d As Debug_Commands) As Boolean
    
    Clear
    
    If d = dc_stepInto Then
        AddByte DUK_DBG_MARKER_REQUEST
        AddByte &H80 + STEP_INTO_REQ
        AddByte DUK_DBG_MARKER_EOM
        ConstructMessage = True
    End If
    
    If d = dc_StepOver Then
        AddByte DUK_DBG_MARKER_REQUEST
        AddByte &H80 + STEP_OVER_REQ
        AddByte DUK_DBG_MARKER_EOM
        ConstructMessage = True
    End If
    
    If d = dc_Stepout Then
        AddByte DUK_DBG_MARKER_REQUEST
        AddByte &H80 + STEP_OUT_REQ
        AddByte DUK_DBG_MARKER_EOM
        ConstructMessage = True
    End If
    
    If d = dc_break Then
        AddByte DUK_DBG_MARKER_REQUEST
        AddByte &H80 + PAUSE_REQ
        AddByte DUK_DBG_MARKER_EOM
        ConstructMessage = True
    End If
    
    If d = dc_Resume Then
        AddByte DUK_DBG_MARKER_REQUEST
        AddByte &H80 + RESUME_REQ
        AddByte DUK_DBG_MARKER_EOM
        ConstructMessage = True
    End If
    
    If d = dc_GetLocals Then
        AddByte DUK_DBG_MARKER_REQUEST
        AddByte &H80 + GET_LOCALS_REQ
        AddByte DUK_DBG_MARKER_EOM
        ConstructMessage = True
    End If
    
End Function


Private Sub Class_Initialize()
    Clear
End Sub