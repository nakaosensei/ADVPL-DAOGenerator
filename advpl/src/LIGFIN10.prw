#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"
#Include 'FWMVCDef.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGFIN06 ºAUTOR  ³ROBSON ADRIANO 		   ºDATA ³ 11/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ ROTINA PARA BAIXAR DUPLICATAS DO CLIENTES QUE ESTAO		    º±±
±±º          ³ EM ABERTO 													    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIGUE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  


User Function LIGFIN10(_CCLIENTE, _CLOJA, _CPREF,_CNUM,_CWHERE,_CMOTBX,_CAUTDTHIST) //BAIXA OS TITULOS ATRASADO PARA INCLUIR NA NOVA FATURA
************************************
LOCAL _AREA 	:= GETAREA()
LOCAL _NVLRET   := 0
LOCAL _CQUERY 	:= " "
Local NMULTA := 0
LOCAL _NTXMULTA := GETMV("MV_UTXMULT")

_CQUERY += " SELECT E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_VENCTO, E1.E1_VENCREA, "
_CQUERY += "        E1.E1_VALOR, E1.E1_SALDO, E1.E1_PORCJUR, E1.E1_MULTA, E1.E1_PORTADO, E1.E1_AGEDEP, E1.E1_CONTA  "
_CQUERY += " FROM "+RETSQLNAME("SE1")+" E1 "
_CQUERY += " WHERE E1.E1_FILIAL = '"+XFILIAL("SE1")+"' "
_CQUERY += " AND E1.E1_CLIENTE = '"+_CCLIENTE+"' "
_CQUERY += " AND E1.E1_LOJA = '"+_CLOJA+"' "
_CQUERY += " AND E1.E1_PREFIXO = '"+_CPREF+"' "
_CQUERY += " AND E1.E1_NUM = '"+_CNUM+"' "
//_CQUERY += " AND E1.E1_VENCTO >= '"+DTOS(ADA->ADA_UDTFEC)+"' "
//_CQUERY += " AND E1.E1_VENCREA < '"+DTOS(DDATABASE)+"' "
_CQUERY += " AND E1.E1_SALDO > 0 "
_CQUERY += " AND E1.D_E_L_E_T_ = ' ' "
_CQUERY += _CWHERE
_CQUERY := CHANGEQUERY(_CQUERY)
IF SELECT("TRE1")!=0
	TRE1->(DBCLOSEAREA())
ENDIF
TCQUERY _CQUERY NEW ALIAS "TRE1"
DBSELECTAREA("TRE1")
DBGOTOP()
WHILE !EOF()

	IF STOD(TRE1->E1_VENCREA)<DDATABASE
		NMULTA := ROUND((TRE1->E1_VALOR*_NTXMULTA)/100,2) 
	ENDIF
	NJUROS     := ROUND((TRE1->E1_VALOR*((DDATABASE-STOD(TRE1->E1_VENCTO))*TRE1->E1_PORCJUR))/100,2)
	DBAIXA     := DDATABASE
	DDTCREDITO := DDATABASE
	CBANCO     := TRE1->E1_PORTADO
	CAGENCIA   := TRE1->E1_AGEDEP
	CCONTA     := TRE1->E1_CONTA
	NVALREC    := TRE1->E1_SALDO + NMULTA + NJUROS
	
	DBSELECTAREA("SE1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SE1")+TRE1->E1_PREFIXO+TRE1->E1_NUM+TRE1->E1_PARCELA+TRE1->E1_TIPO)
	
	ABAIXA  :=  {	{"E1_PREFIXO"  	,SE1->E1_PREFIXO	 	,NIL},;
	{"E1_NUM"      	,SE1->E1_NUM  	  		,NIL},;
	{"E1_PARCELA"  	,SE1->E1_PARCELA	 	,NIL},;
	{"E1_TIPO"	    	,SE1->E1_TIPO	  		,NIL},;
	{"E1_CLIENTE"  	,SE1->E1_CLIENTE	 	,NIL},;
	{"E1_LOJA"     	,SE1->E1_LOJA  			,NIL},;
	{"AUTMOTBX"		,_CMOTBX			 		,NIL},;
	{"AUTBANCO"		,CBANCO			 		,NIL},;
	{"AUTAGENCIA"  	,CAGENCIA				,NIL},;
	{"AUTCONTA"		,CCONTA			 		,NIL},;
	{"AUTDTBAIXA"  	,DBAIXA   				,NIL},;
	{"AUTDTCREDITO"	,DDTCREDITO				,NIL},;
	{"AUTDTHIST"   	,_CAUTDTHIST	,NIL},;
	{"AUTDESCONT"  	,0		     	 		,NIL},;
	{"AUTJUROS"    	,NJUROS	       	,NIL,.T.},;
	{"AUTMULTA"    	,NMULTA	        	,NIL,.T.},;
	{"AUTOUTGAS"   	,0 						,NIL},;
	{"AUTVLRPG"    	,0 						,NIL},;
	{"AUTVLRME"    	,0 						,NIL},;
	{"AUTVALREC"   	,NVALREC     	 		,NIL},;
	{"AUTCHEQUE"   	,""             	 	,NIL}}
	
	LMSERROAUTO := .F.
	LMSHELPAUTO := .T.
	MSEXECAUTO({|X,Y| FINA070(X,Y)},ABAIXA,3)
	IF LMSERROAUTO
		MOSTRAERRO()
		RETURN()
	ELSE
		_NVLRET += NVALREC
	ENDIF
	
	DBSELECTAREA("TRE1")
	DBSKIP()
ENDDO
RESTAREA(_AREA)
Return

