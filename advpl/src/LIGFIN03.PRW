#INCLUDE "RWMAKE.CH"                                                           
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGFIN03  ºAUTOR  ³ROBSON ADRIANO      º DATA ³  13/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³CODIGO PARA DELETAR LOTES DE COMISSAO QUE O USUARIO INFORMARº±±
±±º          ³LIMPAR CAMPO DB_ULTCOM DA TABELA ADB                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIG                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                         
USER FUNCTION LIGFIN03()   

PRIVATE _CPERG := "FIN03A"

VALIDPERG()                    
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF
  
IF PROCESSA({||EXCLUIRSE3()})
	ATULIZAADB() 
ENDIF

RETURN  

STATIC FUNCTION EXCLUIRSE3() //EXCLUIR SE3
****************************************       
LOCAL _NQTSE3 := 0

DBSELECTAREA("SE3")
DBSETORDER(5)         
DBGOTOP()
DBSEEK(XFILIAL("SE3")+MV_PAR01) 
WHILE !EOF() .AND. SE3->E3_FILIAL+SE3->E3_ULTCOM==XFILIAL("SE3")+MV_PAR01  
	IF !EMPTY(SE3->E3_PROCCOM) 
		MSGSTOP("Nao foi possivel deletar as comissoes, por que ja foi gerado contas a pagar !")    
		RETURN(.F.)
	ENDIF
	_NQTSE3++
	DBSKIP()
ENDDO	

PROCREGUA(_NQTSE3)

DBSELECTAREA("SE3")
DBSETORDER(5)         
DBGOTOP()
DBSEEK(XFILIAL("SE3")+MV_PAR01) 
WHILE !EOF() .AND. SE3->E3_FILIAL+SE3->E3_ULTCOM==XFILIAL("SE3")+MV_PAR01  
	INCPROC("Aguarde...")
	RECLOCK("SE3",.F.)
	DBDELETE()
	MSUNLOCK()
	DBSKIP()
ENDDO	
RETURN(.T.)


STATIC FUNCTION ATULIZAADB() //ATUALIZAR ADB
****************************************
LOCAL _CQUERY := " " 

_CQUERY := " UPDATE "+RETSQLNAME("ADB")
_CQUERY += " SET ADB_ULTCOM = ' ' " 
_CQUERY += " WHERE ADB_ULTCOM = '"+MV_PAR01+"' "
_CQUERY += " AND ADB_FILIAL = '"+XFILIAL("ADB")+"' " 
_CQUERY += " AND D_E_L_E_T_ = ' ' " 
TCSQLEXEC(_CQUERY) 

RETURN



STATIC FUNCTION VALIDPERG  
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(AREGS,{_CPERG,"01","INFORME O LOTE     ?","","","MV_CH1","C",06,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(_CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
DBSELECTAREA(_SALIAS)
RETURN