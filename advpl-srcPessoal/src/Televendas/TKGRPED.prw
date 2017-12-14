#include 'protheus.ch'
#include 'parmtype.ch'
//Ponto de entrada executado antes de gravar um chamado de Televendas.
User Function TKGRPED(nLiquido, aParcelas, cOpera, cNum,cCodLig, cCodPagto, cOpFat, cCodTransp)	
	Local condPg := getmv("MV_TVCP")
	//Function LIGVCP(LIG VALIDAR CONDIÇÃO DE PAGAMENTO)
	vld := u_LIGVCP(cCodPagto,condPg)		
Return vld

