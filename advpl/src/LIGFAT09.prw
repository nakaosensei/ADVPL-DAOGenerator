#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "totvs.ch"
#Include "TOPCONN.CH"


// ROTINA PARA RE-IMPRESSAO DAS FATURAS
User Function LIGFAT09()
Local	_NTotal := 0
Local 	_area := getarea()
Local  _aSE1 := SE1->(getarea())
Private oMark
Private aRotina := MenuDef()
Private _CPERG		:= "FAT10A"


VALIDPERG()                   
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF 
                   
	IF SELECT("TSE1")!=0
		TSE1->(DBCLOSEAREA())
	ENDIF

	DbSelectArea("SE1")
		cQuery := "SELECT E1_OK, E1_STATUS, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_NOMCLI, E1_LOJA, E1_EMISSAO, E1_PORTADO,"
		cQuery += " E1_VENCTO, E1_VALOR,E1_SALDO,E1_UEMP"
		cQuery += " FROM " + RetSqlName("SE1") + " SE1 "
		cQuery += " WHERE SE1.D_E_L_E_T_ = ' ' "	
		cQuery += " AND SE1.E1_VENCTO >= '" +DTOS(mv_par01)+ "'"
		cQuery += " AND SE1.E1_VENCTO <= '" +DTOS(mv_par02)+ "'"
		cQuery += " AND SE1.E1_PREFIXO = '"+mv_par03+"'"
		cQuery += " AND SE1.E1_NUM >= '" +mv_par04+ "'"
		cQuery += " AND SE1.E1_NUM <= '" +mv_par05+ "'"
		//cQuery += " AND SE1.E1_UEMP = '" +mv_par06+ "'"
		cQuery += " ORDER BY E1_NUM"	
	TCQUERY cQuery NEW ALIAS "TSE1"
	DbSelectArea("TSE1")
	DBGOTOP()
	
	U_FAT09A()
restarea(_aSE1)	
restarea(_area)
Return

Static Function MenuDef()
Local aRotina := {}
ADD OPTION aRotina TITLE 'Processar' ACTION 'U_FAT09A()' OPERATION 2 ACCESS 0
Return aRotina

User Function FAT09A()
	PROCESSA({||FAT09B()})
RETURN
	
Static Function FAT09B()
Local aArea := GetArea()
//Local cMarca := oMark:Mark()
Local nCt := 0
Local _ATITULOSBRA	:= {}
Local _ATITULOSHSBC	:= {}  
Local _ATITULOCAIXA	:= {}
Local _NImprimi := ""
LOCAL _NQTREGUA := 0

_dadosbanco := alltrim(getmv("MV_UBCOBOL"))
_banco      := substr(_dadosbanco,1,3)

DBSELECTAREA("TSE1")
//DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	_NQTREGUA++
	DBSKIP()
ENDDO
PROCREGUA(_NQTREGUA)

TSE1->( dbGoTop() )
While !TSE1->( EOF() )
	INCPROC("Processando...")
//	If oMark:IsMark(cMarca)
			// Apenas Faturas com vencimento anterior ao Database pode ser impressas, atrazadas apenas por boleto
			if  TSE1->E1_PREFIXO == mv_par03 .AND. STOD(TSE1->E1_VENCTO) >= mv_par01 .AND. STOD(TSE1->E1_VENCTO) <= mv_par02 .AND. TSE1->E1_NUM >= mv_par04 .AND. TSE1->E1_NUM <= mv_par05 .AND. (EMPTY(ALLTRIM(mv_par06)) .OR. TSE1->E1_UEMP == mv_par06)
				nCt++
		   		IF ALLTRIM(TSE1->E1_PORTADO) == "237"
					AADD(_ATITULOSBRA, {TSE1->E1_PREFIXO, TSE1->E1_NUM, TSE1->E1_PARCELA, "BOL", TSE1->E1_CLIENTE, TSE1->E1_LOJA})
				ENDIF
				IF ALLTRIM(TSE1->E1_PORTADO) == "399"
					AADD(_ATITULOSHSBC, {TSE1->E1_PREFIXO, TSE1->E1_NUM, TSE1->E1_PARCELA, "BOL", TSE1->E1_CLIENTE, TSE1->E1_LOJA})
				ENDIF
				IF ALLTRIM(TSE1->E1_PORTADO) == "104" .OR. EMPTY(ALLTRIM(TSE1->E1_PORTADO)) 
					AADD(_ATITULOCAIXA, {TSE1->E1_PREFIXO, TSE1->E1_NUM, TSE1->E1_PARCELA, "BOL", TSE1->E1_CLIENTE, TSE1->E1_LOJA})
				ENDIF
			else
				_NImprimi  += TSE1->E1_PREFIXO+"-"+TSE1->E1_NUM+"-"+TSE1->E1_PARCELA+"/"	
			endif
//	EndIf

	TSE1->( dbSkip() )
End

IF !EMPTY(_ATITULOSBRA)
	U_LIGFAT02(,,,,,,_ATITULOSBRA,,.T.) 	
ENDIF

IF !EMPTY(_ATITULOSHSBC)
	U_LIGFAT14(,,,,,,_ATITULOSHSBC,,.T.) 
ENDIF

IF !EMPTY(_ATITULOCAIXA)
	U_LIGFAT16(,,,,,,_ATITULOCAIXA,,.T.) 
ENDIF

ApMsgInfo( 'Foram marcados ' + AllTrim( Str( nCt ) ) + ' registros.')

IF !EMPTY (_NImprimi)
	MSGINFO("Não foi possivel imprimir a(s) seguinte(s) Fatura(s) : "+CHR(10)+CHR(13)+_NImprimi)
ENDIF


DBCLOSEAREA("TSE1")

RestArea( aArea )
Return


/*
	VALIDAPERG
*/
STATIC FUNCTION VALIDPERG
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(aRegs,{_CPERG,"01","Vencimento de         ?","Espanhol","Ingles","mv_ch1","D",8,0,0,"G","","mv_par01","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_CPERG,"02","Vencimento ate        ?","Espanhol","Ingles","mv_ch2","D",8,0,0,"G","","mv_par02","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"03","Prefixo      ?","","","MV_CH3","C",03,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"04","Numero DE      ?","","","MV_CH4","C",09,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","ADA",""})
AADD(AREGS,{_CPERG,"05","Numero ATE     ?","","","MV_CH5","C",09,0,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","ADA",""})
AADD(AREGS,{_CPERG,"06","Empresa     	?","","","MV_CH6","C",1,0,0, "G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"07","Cidade     	?","","","MV_CH7","C",05,0,0, "G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","CC2",""})


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


