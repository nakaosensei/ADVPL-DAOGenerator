#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

User Function MyTECA040()
	Local bases   := {}	
	Local aItens040 := {} 	
	Local lRet      := .T.   
	Local nILocal 
	aNrsSerie := {} 	
	Local dData:= "20/01/2011"
	PRIVATE lMsErroAuto := .F.
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "TEC" TABLES "AA3","AA4","SXB"
	Aadd(aNrsSerie,"10203040506070809010")
	For nI := 1 to Len(aNrsSerie)
		Aadd(bases, { "AA3_FILIAL" , "", NIL } )
		Aadd(bases, { "AA3_CODCLI" , "000001", NIL } )
		Aadd(bases, { "AA3_LOJA", "01", NIL } ) 
		Aadd(bases, { "AA3_CODPRO", "PRODUTO01", NIL } )
		Aadd(bases, { "AA3_NUMSER", aNrsSerie[nI]  , NIL } )
		Aadd(bases, { "AA3_DTVEN", dData, NIL } )
		TECA040(,bases,aItens040,3)
		If lMsErroAuto
			lRet := !lMsErroAuto
		Endif
		bases := {}
	Next
Return lRet