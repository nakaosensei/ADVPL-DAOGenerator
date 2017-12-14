#INCLUDE "RWMAKE.CH"                                                   
#INCLUDE "TOPCONN.CH" 
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPROGRAMA  ณLIGGEN03  บAUTOR  CASSIUS CARLOS MARTINS DATA ณ  19/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDESC.     ณ ENVIAR E-MAIL                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUSO       ณ LIGUE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
USER FUNCTION LIGGEN03(cPara, cCopia, cConhcopia, cAssunto, cTexto, LHTML, cFile)
	LOCAL lOk := .F.
	cPara  := ALLTRIM(cPara)	
	CDE := ALLTRIM(GETMV("MV_RELACNT"))	
	CACCOUNT := CDE	
	LHTML := IIF(VALTYPE(LHTML)="U",.F.,LHTML)
	CSERVER := ALLTRIM(GETMV("MV_RELSERV"))
	CPASSWORD := ALLTRIM(GETMV("MV_RELPSW"))
	CONNECT SMTP SERVER CSERVER ACCOUNT CACCOUNT PASSWORD CPASSWORD RESULT lOk
	IF lOk
		msgInfo("Teste 1")
	     /*IF !MAILAUTH(CACCOUNT,CPASSWORD)
	          GET MAIL ERROR CERRORMSG
	          HELP("",1,"AVG0001056",,"ERROR: "+CERRORMSG,2,0)
	          DISCONNECT SMTP SERVER RESULT lOk
	          IF !lOk
	               GET MAIL ERROR CERRORMSG
	               HELP("",1,"AVG0001056",,"ERROR: "+CERRORMSG,2,0)
	          ENDIF
	          RETURN ( .F. )
	     ENDIF*/
	     
	     IF !EMPTY(cCopia)
	          msgInfo("Teste 2")
	          IF LHTML
	          		msgInfo("Teste 3")
	               IF !EMPTY(cFile)
	                    SEND MAIL FROM CDE TO cPara CC cCopia SUBJECT cAssunto BODY cTexto ATTACHMENT cFile RESULT lOk
	               ELSE
	                    SEND MAIL FROM CDE TO cPara CC cCopia SUBJECT cAssunto BODY cTexto RESULT lOk
	               ENDIF
	          ELSE
	          		msgInfo("Teste 4")
	               IF !EMPTY(cFile)
	               		msgInfo("Teste 5")
	                    SEND MAIL FROM CDE TO cPara CC cCopia SUBJECT cAssunto BODY cTexto FORMAT TEXT ATTACHMENT cFile RESULT lOk
	                    
	               ELSE
	               		msgInfo("Teste 6")
	                    SEND MAIL FROM CDE TO cPara CC cCopia SUBJECT cAssunto BODY cTexto FORMAT TEXT RESULT lOk
	               ENDIF
	          ENDIF
	     ELSE
	     	ALERT("cCopia vazio")
	          IF LHTML
	               IF !EMPTY(cFile)
	                    SEND MAIL FROM CDE TO cPara BCC cConhcopia SUBJECT cAssunto BODY cTexto ATTACHMENT cFile RESULT lOk
	               ELSE
	                    SEND MAIL FROM CDE TO cPara BCC cConhcopia SUBJECT cAssunto BODY cTexto RESULT lOk
	               ENDIF
	          ELSE
	          		msgInfo("Teste 7")
	               IF !EMPTY(cFile)
	               		ALERT(" TEM ANEXO")
	                    SEND MAIL FROM CDE TO cPara BCC cConhcopia SUBJECT cAssunto BODY cTexto FORMAT TEXT ATTACHMENT cFile RESULT lOk
	                    ALERT("Email enviado ")
	               ELSE
	               		MsgInfo("Nใo anexo")
	                    //SEND MAIL FROM CDE TO cPara BCC cConhcopia SUBJECT cAssunto BODY cTexto FORMAT TEXT RESULT lOk
	                    SEND MAIL FROM CDE TO cPara BCC cConhcopia SUBJECT cAssunto BODY cTexto RESULT lOk
	                    MsgInfo("Enviou")
	               ENDIF
	          ENDIF
	     ENDIF
	     IF ! lOk
	          GET MAIL ERROR CERRORMSG
	          HELP("",1,"AVG0001056",,"ERROR: "+CERRORMSG,2,0)
	     ENDIF
	ELSE
	     GET MAIL ERROR CERRORMSG
	     HELP("",1,"AVG0001057",,"ERROR: "+CERRORMSG,2,0)
	ENDIF
	DISCONNECT SMTP SERVER	
	ALERT("Terminou ")
RETURN
