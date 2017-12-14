#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGVAL01  ºAUTOR  ³ROBSON ADRIANO      º DATA ³  10/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³PRENCHE CODIGO DO MUNICIPIO NA VALIDACAO DO CEP			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIG                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                         
USER FUNCTION LIGVAL01()       
	
	DBSELECTAREA("CC2")
	DBSETORDER(4)         
	DBGOTOP()
	IF DBSEEK(XFILIAL("CC2") + M->A2_EST + UPPER(NOACENTO(ALLTRIM(M->A2_MUN)))) 
   		M->A2_COD_MUN = CC2->CC2_CODMUN
	ENDIF

RETURN(.T.)  

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;"
 
For nX:= 1 To Len(cString)
               cChar:=SubStr(cString, nX, 1)
               IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
                              nY:= At(cChar,cAgudo)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf
                              nY:= At(cChar,cCircu)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf
                              nY:= At(cChar,cTrema)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf
                              nY:= At(cChar,cCrase)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
                              EndIf                   
                              nY:= At(cChar,cTio)
                              If nY > 0         
                                            cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
                              EndIf                   
                              nY:= At(cChar,cCecid)
                              If nY > 0
                                            cString := StrTran(cString,cChar,SubStr("cC",nY,1))
                              EndIf
               Endif
Next
 
If cMaior$ cString
               cString := strTran( cString, cMaior, "" )
EndIf
If cMenor$ cString
               cString := strTran( cString, cMenor, "" )
EndIf
 
For nX:=1 To Len(cString)
               cChar:=SubStr(cString, nX, 1)
               If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
                              cString:=StrTran(cString,cChar,".")
               Endif
Next nX
Return cString

