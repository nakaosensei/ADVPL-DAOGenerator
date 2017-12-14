#include 'protheus.ch'
#include 'parmtype.ch'

/*
Ajustes Pedidos de Compra (SC7)
Ponto de entrada, para carregar o
campo C7_PROJET com o valor C1_PROJET
Correspondente.
AUTOR: Noemi Scherer
DATA: 22/02/17
*/

/*
AVALCOT: Manipula Pedido de Compras da tabela SC7
*/
user function AVALCOT()
	Local nEvento := PARAMIXB[1] //Valor 4
	Local aArea := GetArea()
	Local nProjet := ""
	Local nObs := ""

	If nEvento == 4
		dbSelectArea("SC7")
		dbSetOrder(2) //C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA

		//RecLock("SC7",.F.)
		nFilial := SC7->C7_FILIAL
		nProduto := SC7->C7_PRODUTO
		nFornece := SC7->C7_FORNECE
		nItem := SC7->C7_ITEMSC
		nLoja := SC7->C7_LOJA
		nNum := SC7->C7_NUMSC
		nQuant := SC7->C7_QUANT
		dEmi := SC7->C7_EMISSAO

		uitem := SC7->C7_ITEM
		unum := SC7->C7_NUM
		//----------------------------------------------------
		dbSelectArea("SC1")
		dbSetOrder(1) //C1_FILIAL+ C1_NUM+ C1_ITEM
		dbGoTop()

		IF dbSeek(nFilial + nNum + nItem )
			//			Alert("Achou")
			WHILE !EOF() .AND. SC1->C1_FILIAL+SC1->C1_PRODUTO+ SC1->C1_NUM+ SC1->C1_ITEM+ SC1->C1_FORNECE+ SC1->C1_LOJA == nFilial + nProduto + nNum + nItem +  nFornece + nLoja
				IF(SC1->C1_QUANT == nQuant .AND. SC1->C1_EMISSAO = dEmi)
					nProjet := SC1->C1_UPROJ
					nObs := SC1->C1_OBS
					//Gravar o projeto de SC1 em SC7
					dbSelectArea("SC7")
					dbSetOrder(1) //C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA
					dbSeek(xFilial("SC7")+ uNum + uItem)
					RecLock("SC7",.F.)
					SC7->C7_UPROJET := nProjet
					SC7->C7_OBS := nObs
					MsUnlock()
					EXIT
				ENDIF

				dbSelectArea("SC1")
				dbSkip()

			ENDDO
		ENDIF
	EndIf

	RestArea(aArea)
return

/*
Função responsável por
encontrar o numero do projeto
em SC1 correspondente aos dados
passado por parâmetro de SC7.
*/
//user function proj_sc1(nFilial, nProduto, nFornece, nItem, nLoja, nNum, nQuant, dEmi)
//	Local nProjet := ""
//
//	dbSelectArea("SC1")
//	dbSetOrder(2) //C1_FILIAL+C1_PRODUTO+ C1_NUM+ C1_ITEM+ C1_FORNECE+ C1_LOJA
//	dbGoTop()
//
//	IF dbSeek(nFilial + nProduto + nNum + nItem +  nFornece + nLoja)
//		Alert("Achou")
//		WHILE !EOF() .AND. C1_FILIAL+C1_PRODUTO+ C1_NUM+ C1_ITEM+ C1_FORNECE+ C1_LOJA == nFilial + nProduto + nNum + nItem +  nFornece + nLoja
//
//			IF(C1_QUANT == nQuant .AND. C1_EMISSAO = dEmi)
//				nProjet := C1_PROJ
//				EXIT
//			ENDIF
//
//			dbSelectArea("SC1")
//			dbSkip()
//
//		ENDDO
//	ENDIF
//
//return nProjet
