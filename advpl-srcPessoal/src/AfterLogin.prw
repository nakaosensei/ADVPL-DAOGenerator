#include "protheus.ch"

User Function AfterLogin()
	Local cId	:= ParamIXB[1]
	Local cNome := ParamIXB[2]      
	//ApMsgAlert("Usu�rio "+ cId + " - " + Alltrim(cNome)+" efetuou login �s "+Time()+" "+DTOC(Date()))
Return