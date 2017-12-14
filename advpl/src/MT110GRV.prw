#include 'protheus.ch'
#include 'parmtype.ch'

/**
* LOCALIZA��O : Function A110GRAVA - Fun��o da Solicita��o de Compras responsavel pela grava��o das SCs.
* EM QUE PONTO : No laco de grava��o dos itens da SC na fun��o A110GRAVA, executado ap�s gravar o item da SC, 
* a cada item gravado da SC o ponto � executado
*
* Objetivo: Gravar campo C1_APROV = 'L' para todas solicita��es vir liberadas
**/

User Function MT110GRV()
	lExp1 :=  PARAMIXB[1]
	//Rotina do Usuario para poder gravar campos especificos ou alterar campos gravados do item da SC.
	
	dbSelectArea("SC1")
	RecLock("SC1",.F.) 
		SC1->C1_APROV := 'L'
	SC1->(MsUnlock()) 
Return
