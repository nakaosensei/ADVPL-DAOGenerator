#Include 'Protheus.ch'

//AJUSTAR VALOR E % DA ALIQ DE ICMS
User Function LIGFIS01()
Local _area := getarea()
Private cPerg := "LIGFIS01"


MsgInfo("Esta rotina irá reajustar os valores da Alíquato do Cabeçalho das notas de Saida:  SF3 SFT e SF2 SD2 de acordo com os parametro informados. ")
Validperg()
If !Pergunte(cPerg,.T.)
	Alert("Cancelado pelo Usuário!")
	Return
EndIf

//AJUSTE TABELAS DO LIVRO FISCAL
DBSELECTAREA("SF3")
DBSETORDER(5)
DBGOTOP()
DBSEEK(MV_PAR01 + MV_PAR02  )//FILIAL + SERIE
WHILE !EOF() .AND. SF3->F3_FILIAL + SF3->F3_SERIE == MV_PAR01 + MV_PAR02 
	_TotalIcm := 0
	
	DBSELECTAREA("SFT")								
	DBSETORDER(6)
	DBGOTOP()
	DBSEEK(SF3->F3_FILIAL + 'S' + SF3->F3_NFISCAL + SF3->F3_SERIE)//FILIAL + NOTA + SERIE
	WHILE !EOF() .AND. SFT->FT_FILIAL +'S'+SFT->FT_NFISCAL + SFT->FT_SERIE == SF3->F3_FILIAL + 'S' + SF3->F3_NFISCAL + SF3->F3_SERIE
		reclock("SFT",.F.)
			SFT->FT_ALIQICM := MV_PAR03	
			SFT->FT_VALICM := ROUND(SFT->FT_BASEICM * (MV_PAR03 / 100),2)			
		msunlock()
		
		_TotalIcm	+= SFT->FT_VALICM
				
		dbselectarea("SFT")
		dbskip()
	enddo
	
	reclock("SF3",.F.)
		SF3->F3_ALIQICM := MV_PAR03	 
		SF3->F3_VALICM := _TotalIcm	
	msunlock()
		
	dbselectarea("SF3")
	dbskip()
enddo

//AJUSTE TABELAS DO FATURAMENTO
DBSELECTAREA("SF2")
DBSETORDER(4)
DBGOTOP()
DBSEEK(MV_PAR01 + MV_PAR02  )//FILIAL + SERIE
WHILE !EOF() .AND. SF2->F2_FILIAL + SF2->F2_SERIE == MV_PAR01 + MV_PAR02 
	_TotalIcm := 0
	
	DBSELECTAREA("SD2")								
	DBSETORDER(3)
	DBGOTOP()
	DBSEEK(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE)//FILIAL + NOTA + SERIE
	WHILE !EOF() .AND. SD2->D2_FILIAL +SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE
		reclock("SD2",.F.)
			SD2->D2_PICM := MV_PAR03	
			SD2->D2_VALICM := ROUND(SD2->D2_BASEICM * (MV_PAR03 / 100),2)			
		msunlock()
		
		_TotalIcm	+= SD2->D2_VALICM
				
		dbselectarea("SD2")
		dbskip()
	enddo
	
	reclock("SF2",.F.)
		//SF3->F3_ALIQICM := MV_PAR03	 
		SF2->F2_VALICM := _TotalIcm	
	msunlock()
		
	dbselectarea("SF2")
	dbskip()
enddo

MsgInfo("Rotina concluída !")
restarea(_area)		
Return

STATIC FUNCTION VALIDPERG  
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(cPerg,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(AREGS,{_CPERG,"01","Filial           ?",Space(20),Space(20),"mv_ch1","C",4,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"02","Serie    ?",Space(20),Space(20),"mv_ch2","C",3,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"03","Aliquota           ?",Space(20),Space(20),"mv_ch3","N",5,2,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
