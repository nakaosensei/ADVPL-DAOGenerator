#include 'protheus.ch'
#include 'parmtype.ch'

/*
+=========================================+
|Programa: Adicionar campo NR Ctr na tela 
de Tele Atendimento Ligue				   |
|Autor: Noemi 							   |
|Data: 27/01/2017						   |
+=========================================+
*/

user function LIGCAL09(nCod)
	Local nContrato := ""
	
	nVenda := u_venda(nCod)
	IF !EMPTY(nVenda)
		nContrato := u_contrato(nVenda)
	ENDIF

return nContrato

/*
Função responsável por encontrar o número da
última venda associada a um atendimento.
*/
user function venda(nCodAtend)
	Local _area := GetArea()
	Local _aSUA := SUA->(getarea())
	Local nNumAtual
	Local sMaiorCod:="000000"
	Local nVenda := ""
	
	dbSelectArea("SUA")
	dbSetOrder(12) //UA_FILIAL+UA_UATEND
	dbGoTop()
	
	IF dbSeek(xFilial("SUA") + nCodAtend) //Encontra venda associada ao atendimento
		//Encontrar a ultima venda
		WHILE !EOF() .AND. SUA->UA_FILIAL + UA_UATEND == xFilial("SUA") + nCodAtend
			IF SUA->UA_NUM>sMaiorCod
				sMaiorCod := SUA->UA_NUM
				nVenda:=UA_NUM
			ENDIF
		
			DbSelectArea("SUA")
			DbSkip()
		ENDDO
	
	ENDIF
	
	restarea(_aSUA)
	restarea(_area)
return nVenda


/*
Função responsável por encontrar
o número do contrato de um atendimento
que possui uma venda.
*/
user function contrato(nVenda)
	Local _area := GetArea()
	Local _aADA := ADA->(getarea())
	Local nContrato := ""
	
	dbSelectArea("ADA")
	dbSetOrder(3) //ADA_FILIAL + ADA_UCALLC
	dbGoTop()
	
	IF dbSeek(xFilial("ADA") + nVenda)
		nContrato := ADA->ADA_NUMCTR
	ENDIF
	//dbCloseArea()

	restarea(_aADA)
	restarea(_area)

return nContrato