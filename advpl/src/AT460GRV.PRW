#include 'protheus.ch'
#include 'parmtype.ch'
/*
Abrir novo campo no Atendimento OS(AB9)
AUTOR: Noemi Scherer
DATA: 07/03/17
*/


/*
Ponto disparado apos a atualizaçao
do atendimento da ordem de serviço
*/
user function AT460GRV()

	local aParam :=Paramixb[1]

	nNumOs := AB9->AB9_NUMOS
	nSitua2 := AB9->AB9_USITU2
	
	dbSelectArea("AB6")
	dbSetOrder(1) //AB6_FILIAL + AB6_NUMOS
	
	IF dbSeek(xFilial("AB6")+ nNumOs)
		RecLock("AB6",.F.)
		AB6->AB6_USITU2 := nSitua2
		MsUnlock()
	ENDIF
	
return


