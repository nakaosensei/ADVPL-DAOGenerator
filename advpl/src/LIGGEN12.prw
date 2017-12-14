#Include 'Protheus.ch'

User Function LIGGEN12()
Local _area := getarea()
Local _cont := 0
Private _CPERG		:= "GEN12A"
VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF 

DBSELECTAREA("SB1")
DBGoTop()
while !eof()
	IF (SB1->B1_USER01 = MV_PAR01)				
		reclock("SB1",.F.)
			SB1->B1_USER01 :=  MV_PAR02		
		msunlock()	
		
		_cont ++		
	ENDIF  	
			  
	dbselectarea("SB1")
	dbskip()
enddo

restarea(_area)	
MsgInfo("A rotina foi executada ! Foram alterados : " + CVALTOCHAR(_cont) + " registros.")	
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
AADD(AREGS,{_CPERG,"01","SERIE ANTIGA      ?","","","MV_CH1","C",03,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","SERIE NOVA        ?","","","MV_CH2","C",03,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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