#include 'protheus.ch'
#include 'parmtype.ch'

/**
* LOCALIZAÇÃO : Function A110GRAVA - Função da Solicitação de Compras responsavel pela gravação das SCs.
* EM QUE PONTO : No laco de gravação dos itens da SC na função A110GRAVA, executado após gravar o item da SC, 
* a cada item gravado da SC o ponto é executado
*
* Objetivo: Gravar campo C1_APROV = 'L' para todas solicitações vir liberadas
**/

User Function MT110GRV()
	lExp1 :=  PARAMIXB[1]
	//Rotina do Usuario para poder gravar campos especificos ou alterar campos gravados do item da SC.
	
	dbSelectArea("SC1")
	RecLock("SC1",.F.) 
		SC1->C1_APROV := 'L'
	SC1->(MsUnlock()) 
Return
