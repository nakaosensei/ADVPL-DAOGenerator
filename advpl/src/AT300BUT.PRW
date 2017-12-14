#include 'protheus.ch'
#include 'parmtype.ch'

/*
Atualizar boleto pela tela de Chamados
AUTOR: NOEMI SCHERER
DATA: 10/03/17
*/

/*
Esse ponto de entrada é chamado no
momento da definição dos botões padrão
do chamado técnico (apenas Protheus).
*/
user function AT300BUT()
	aBotao := {}
	AAdd( aBotao, { "PRODUTO", {|| U_300BUT01() }, "Atualizar boleto"})
return aBotao

/*
Abrir tela com faturas com
as faturas em aberto,
par usuário selecionar qual
deseja atualizar.
*/

user function 300BUT01()
	//	Local nLoja
	//	Local nPrefixo
	//	Local nNum
	//	Local nParcela

	Private dData := dDataBase

	nCod := U_TEC18A() //LIGTEC18.PRW
	lDeve := U_TEC18B()//LIGTEC18.PRW

	IF !EMPTY(nCod)
		IF lDeve = .T.

			dbSelectArea("SE1")
			dbSetOrder(8) //E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_STATUS

			aBrowse:={}
			//Verificar se cliente possui contas em aberto
			IF dbSeek(xFilial("SE1") + nCod)

				WHILE !EOF() .AND. E1_FILIAL + E1_CLIENTE == xFilial("SE1") + nCod

					IF E1_STATUS == "A" .AND. E1_VENCTO < dData .AND. EMPTY(E1_BAIXA)

						//calcula juros
						_nValorTit  := E1_VALOR + E1_ACRESC
						IF ddatabase>E1_VENCREA
							_nValorTit += NOROUND(E1_VALOR*(2/100),2) //2% DE MULTA
							_nValorTit += ROUND(E1_VALOR*(ddatabase-E1_VENCREA)*E1_PORCJUR/100,2) //JUROS 1% AO DIA
						ENDIF

						//Dados da fatura do cliente
						AaDd(aBrowse, {E1_NOMCLI, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_VENCREA, E1_VALOR, _nValorTit})
					ELSEIF E1_STATUS == "A"  .AND. EMPTY(E1_BAIXA)
						// Caso não esteja atrazado
						AaDd(aBrowse, {E1_NOMCLI, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_VENCREA, E1_VALOR, E1_VALOR})
					
					ENDIF

					dbSelectArea("SE1")
					dbSkip()
				ENDDO
			ENDIF

			DEFINE MSDIALOG oDlgFt TITLE "Faturas em aberto: "+nCod FROM 180,180 TO 530,793 COLORS 0, 16777215 PIXEL
			lCheck := .T.    // Usando New

			oBrowse := TCBrowse():New( 01 , 01, 306, 156,, {'Nome Cliente','Loja', 'Prefixo', 'Título', 'Parcela', 'Data Venc.', 'Valor', 'Valor com Juros'},{50,20,30,30,30,30,30}, oDlgFt,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

			//Seta vetor para a browse
			oBrowse:SetArray(aBrowse)
			oBrowse:bLine := {||{ 	aBrowse[oBrowse:nAt,01],;
			aBrowse[oBrowse:nAt,02],;
			aBrowse[oBrowse:nAt,03],;
			aBrowse[oBrowse:nAt,04],;
			aBrowse[oBrowse:nAt,05],;
			aBrowse[oBrowse:nAt,06],;
			aBrowse[oBrowse:nAt,07],;
			aBrowse[oBrowse:nAt,08] } }

			TButton():New( 162, 140, "Atualizar", oDlgFt,{|| U_300BUT02(oBrowse:nAt, nCod) },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
			TButton():New( 162, 200, "Cancelar", oDlgFt,{|| oDlgFt:End(), oBrowse:setFocus() },40,010,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE MSDIALOG oDlgFt

		ELSE
			MsgInfo("Cliente não possui faturas em aberto!")
		ENDIF

	ELSE
		MsgInfo("Cliente não selecionado!")
	ENDIF
return

/*
Função responsável por encontrar
os dados corretos da fatura do cliente
para realizar a impressão do boleto
*/
user function 300BUT02(_pNat, nCod)

	nLoja := aBrowse[_pNat][2]
	nPrefixo := aBrowse[_pNat][3]
	nNum := aBrowse[_pNat][4]
	nParcela := aBrowse[_pNat][5]

	dbSelectArea("SE1")
	dbSetOrder(2) //E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO

	IF dbSeek(xFilial("SE1")+ nCod + nLoja + nPrefixo + nNum + nParcela)
		U_ROT01()
	ENDIF

return

