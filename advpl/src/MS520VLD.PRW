#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MS520VLD  ºAutor  ³CASSIUS C MARTINS   º Data ³  29/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE EXECUTADO PARA VALIDAR A EXCLUSAO DO SF2 NA MATA521     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIGUE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MS520VLD()
***********************************  
LOCAL _AREA 	:= GETAREA()
LOCAL _CQUERY   := " "
LOCAL _LRET		:= .T.

_CQUERY := " SELECT E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_EMISSAO, E1.E1_VALOR, E1.E1_SALDO, "
_CQUERY += "        E1.E1_UFILNF1, E1.E1_USERNF1, E1.E1_UNUMNF1, E1.E1_UVALNF1, "
_CQUERY += "        E1.E1_UFILNF2, E1.E1_USERNF2, E1.E1_UNUMNF2, E1.E1_UVALNF2, "
_CQUERY += "        E1.E1_UFILNF3, E1.E1_USERNF3, E1.E1_UNUMNF3, E1.E1_UVALNF3, "
_CQUERY += "        E1.E1_UFILNF4, E1.E1_USERNF4, E1.E1_UNUMNF4, E1.E1_UVALNF4, "
_CQUERY += "        E1.E1_UFILNF5, E1.E1_USERNF5, E1.E1_UNUMNF5, E1.E1_UVALNF5  "
_CQUERY += " FROM "+RETSQLNAME("SE1")+" E1 "
_CQUERY += " WHERE ((E1.E1_UFILNF1='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF1='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF1='"+SF2->F2_DOC+"') "
_CQUERY += " OR (E1.E1_UFILNF2='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF2='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF2='"+SF2->F2_DOC+"') "  
_CQUERY += " OR (E1.E1_UFILNF3='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF3='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF3='"+SF2->F2_DOC+"') "  
_CQUERY += " OR (E1.E1_UFILNF4='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF4='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF4='"+SF2->F2_DOC+"') " 
_CQUERY += " OR (E1.E1_UFILNF5='"+SF2->F2_FILIAL+"' AND E1.E1_USERNF5='"+SF2->F2_SERIE+"' AND E1.E1_UNUMNF5='"+SF2->F2_DOC+"')) "
_CQUERY += " AND E1.D_E_L_E_T_=' ' "                                           
_CQUERY := CHANGEQUERY(_CQUERY)
IF SELECT("TRB1")!=0
	TRB1->(DBCLOSEAREA())
ENDIF
TCQUERY _CQUERY NEW ALIAS "TRB1"
DBSELECTAREA("TRB1")
DBGOTOP() 
WHILE !EOF()            
	DBSELECTAREA("SE1")
	DBSETORDER(1) 
	DBSEEK(TRB1->E1_FILIAL+TRB1->E1_PREFIXO+TRB1->E1_NUM+TRB1->E1_PARCELA+TRB1->E1_TIPO)
	
	DO CASE
		CASE SE1->E1_UFILNF1+SE1->E1_USERNF1+SE1->E1_UNUMNF1==SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC
			IF SE1->E1_SALDO<SE1->E1_UVALNF1
				MSGSTOP("Contas a receber nao possui saldo suficiente para remover a nota."+CHR(13)+CHR(10)+;
						"Por favor, remova baixas do titulo "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" antes de excluir a nota fiscal."+CHR(13)+CHR(10)+;
						"Exclusao nao permitida do documento "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
				RETURN(.F.)				
			ENDIF
			
		CASE SE1->E1_UFILNF2+SE1->E1_USERNF2+SE1->E1_UNUMNF2==SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC
			IF SE1->E1_SALDO<SE1->E1_UVALNF2
				MSGSTOP("Contas a receber nao possui saldo suficiente para remover a nota."+CHR(13)+CHR(10)+;
						"Por favor, remova baixas do titulo "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" antes de excluir a nota fiscal."+CHR(13)+CHR(10)+;
						"Exclusao nao permitida do documento "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
				RETURN(.F.)				
			ENDIF		
			
		CASE SE1->E1_UFILNF3+SE1->E1_USERNF3+SE1->E1_UNUMNF3==SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC
			IF SE1->E1_SALDO<SE1->E1_UVALNF3
				MSGSTOP("Contas a receber nao possui saldo suficiente para remover a nota."+CHR(13)+CHR(10)+;
						"Por favor, remova baixas do titulo "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" antes de excluir a nota fiscal."+CHR(13)+CHR(10)+;
						"Exclusao nao permitida do documento "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
				RETURN(.F.)				
			ENDIF
			
		CASE SE1->E1_UFILNF4+SE1->E1_USERNF4+SE1->E1_UNUMNF4==SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC
			IF SE1->E1_SALDO<SE1->E1_UVALNF4
				MSGSTOP("Contas a receber nao possui saldo suficiente para remover a nota."+CHR(13)+CHR(10)+;
						"Por favor, remova baixas do titulo "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" antes de excluir a nota fiscal."+CHR(13)+CHR(10)+;
						"Exclusao nao permitida do documento "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
				RETURN(.F.)				
			ENDIF
			
		CASE SE1->E1_UFILNF5+SE1->E1_USERNF5+SE1->E1_UNUMNF5==SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC
			IF SE1->E1_SALDO<SE1->E1_UVALNF5
				MSGSTOP("Contas a receber nao possui saldo suficiente para remover a nota."+CHR(13)+CHR(10)+;
						"Por favor, remova baixas do titulo "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"-"+SE1->E1_PARCELA+" antes de excluir a nota fiscal."+CHR(13)+CHR(10)+;
						"Exclusao nao permitida do documento "+SF2->F2_SERIE+"/"+SF2->F2_DOC)
				RETURN(.F.)				
			ENDIF                               
			
	ENDCASE
	
	DBSELECTAREA("TRB1")
	DBSKIP()
ENDDO        
TRB1->(DBCLOSEAREA())                                         

RESTAREA(_AREA)
RETURN(_LRET)