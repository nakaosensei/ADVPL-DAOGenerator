#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGFAT06 ºAUTOR  ³CASSIUS CARLOS MARTINS ºDATA ³ 06/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ ROTINA PARA CHAMAR A IMPRESSAO DE NOTAS FISCAIS MOD 21/22  º±±
±±º          ³ E TAMBEM DA FIBER                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIGUE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  
USER FUNCTION LIGFAT06()
************************************
LOCAL CVLDALT 		:= ".T." // OPERACAO: ALTERACAO
LOCAL CVLDEXC 		:= ".T." // OPERACAO: EXCLUSAO
LOCAL CALIAS		:= "SF2"
PRIVATE CCADASTRO 	:= "IMPRESSAO NOTAS - LIGUE"
PRIVATE _CPERG 	:= "FAT06A"
//PRIVATE _CWHERE	:= "(SUBSTRING(F2_FILIAL,1,2)='FB' AND RTRIM(F2_SERIE)='A') OR (SUBSTRING(F2_FILIAL,1,1)='C' OR SUBSTRING(F2_FILIAL,1,1)='D')"  //ALTERACAO DA REGRA PRA NF 21 E 22. AGORA É NF C E NF D, SEGUIDA DE UM NUMERO SEQUENCIAL

DBSELECTAREA(CALIAS)
DBSETORDER(1)

AROTINA := {{ "PESQUISAR", 	"AXPESQUI", 	0, 1},;
			 { "IMPRIMIR", 	"U_FAT06A()", 	0, 2},;
			 { "INTERVALO", 	"U_FAT06B()", 	0, 2}}

DBSELECTAREA(CALIAS)
DBGOTOP()
MBROWSE( 6,1,22,75,CALIAS,,,,,,,,,,,.F.,,,)
RETURN


USER FUNCTION FAT06A() //IMPRESSAO UNICA
*************************************
IF LEFT(CFILANT,2)=="FB"
	U_LIGFAT05()
ELSE
	IF !("C" $ SF2->F2_SERIE .OR. "D" $ SF2->F2_SERIE .OR. "21" $ SF2->F2_SERIE .OR. "22" $ SF2->F2_SERIE)
		U_LIGFAT17()
	ELSE
		IF (SF2->F2_FILIAL == "TV01")
			U_LIGFAT20()
		ELSE
			U_LIGFAT03()
		ENDIF
	ENDIF
ENDIF
RETURN


USER FUNCTION FAT06B() //IMPRIMIR INTERVALO DE NOTAS
*************************************
LOCAL _CQUERY := ""

VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF

_CQUERY += " SELECT F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE, F2.F2_CLIENTE, F2.F2_LOJA "
_CQUERY += " FROM "+RETSQLNAME("SF2")+" F2 "
_CQUERY += " WHERE F2.F2_DOC >= '"+MV_PAR01+"' "
_CQUERY += " AND F2.F2_DOC <= '"+MV_PAR02+"' "
_CQUERY += " AND F2.F2_SERIE = '"+MV_PAR03+"' "
//_CQUERY += " AND ((SUBSTRING(F2.F2_FILIAL,1,2)='FB' AND RTRIM(F2.F2_SERIE)='A') OR (SUBSTRING(F2.F2_FILIAL,1,1)='C' OR SUBSTRING(F2.F2_FILIAL,1,1)='D')) "  //ALTERACAO PRA TRATAMENTO DA NF 21 E 22
_CQUERY += " AND F2.D_E_L_E_T_ = ' ' "
_CQUERY := CHANGEQUERY(_CQUERY)
IF SELECT("TRB1")!=0
	TRB1->(DBCLOSEAREA())
ENDIF
TCQUERY _CQUERY NEW ALIAS "TRB1"

DBSELECTAREA("TRB1")
DBGOTOP()
WHILE !EOF()
	IF LEFT(CFILANT,2)=="FB"
		U_LIGFAT05(TRB1->F2_FILIAL, TRB1->F2_DOC, TRB1->F2_SERIE, TRB1->F2_CLIENTE, TRB1->F2_LOJA)
	ELSE
  		IF !("C" $ SF2->F2_SERIE .OR. "D" $ SF2->F2_SERIE .OR. "21" $ SF2->F2_SERIE .OR. "22" $ SF2->F2_SERIE)
	   		U_LIGFAT17()
   		ELSE
	   		U_LIGFAT03()
   		ENDIF
	ENDIF	
	DBSELECTAREA("TRB1")
	DBSKIP()
ENDDO
RETURN


STATIC FUNCTION VALIDPERG  
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(AREGS,{_CPERG,"01","NOTA FISCAL DE   ?","","","MV_CH1","C",09,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","NOTA FISCAL ATE  ?","","","MV_CH2","C",09,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"03","SERIE NOTA(S)    ?","","","MV_CH3","C",03,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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