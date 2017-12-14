#Include 'Protheus.ch'

//AJUSTAR CFOP DA SFT DAS NOTAS FISCAIS
User Function LIGGEN08()
Local _area := getarea()
Private cPerg := "LIGGEN07"


MsgInfo("Esta rotina irá reajustar os CFOP da Tabela SFT ")
Validperg()
If !Pergunte(cPerg,.T.)
	Alert("Cancelado pelo Usuário!")
	Return
EndIf
		DBSELECTAREA("SFT")
		DBGoTop()
		while !eof()
			IF (SFT->FT_SERIE = MV_PAR01 .OR. SFT->FT_SERIE = MV_PAR02)				
				DBSELECTAREA("SA1")
				DBSETORDER(1)
				IF DBSEEK(xFilial("SA1")+SFT->FT_CLIEFOR+SFT->FT_LOJA)
			
					IF (SA1->A1_PESSOA = 'F')
						DBSELECTAREA("SFT")
						reclock("SFT",.F.)
							SFT->FT_CFOP :=  "5307"		
						msunlock()
					ENDIF
					
				ENDIF			
			ENDIF  
			//	restarea(_aADA)  
			
			  
			dbselectarea("SFT")
			dbskip()
		enddo
		 
restarea(_area)	
MsgInfo("A rotina foi executada ! ")		
Return

STATIC FUNCTION VALIDPERG  
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(cPerg,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(AREGS,{_CPERG,"01","Serie    ?",Space(20),Space(20),"mv_ch1","C",3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","Serie    ?",Space(20),Space(20),"mv_ch2","C",3,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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