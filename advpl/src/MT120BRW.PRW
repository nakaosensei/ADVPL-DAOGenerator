#include 'protheus.ch'
#include 'parmtype.ch'

/*
Liberação de Dctos
AUTOR: Noemi Scherer
DATA: 17/03/17
*/


user function MT120BRW()
	 AAdd( aRotina, { "Liberação de Dcos", "U_120BRW01(C7_TIPO, C7_NUM)", 4, 0, 4 } )
return


user function 120BRW01(nTipo, nNum)
	nNum := nNum+"                                            "
	//Tipo: 1 = PC / 2 = DA
	IF nTipo = 1
		nTipoSCR := "PC"
	ELSE
		nTipoSCR := "DA"
	ENDIF
	''
	//Encontrar usuário
	dbSelectArea("SCR")
	dbSetOrder(2) //CR_FILIAL + CR_TIPO + CR_NUM + CR_USER
	
	IF dbSeek(xFilial("SCR")+ nTipoSCR + nNum + RetCodUsr())
		IF CR_STATUS == "02"//fatura para liberação
			U_A097Libera("SCR", SCR->(RECNO()) )
		ELSE
			MsgInfo("liberado ou bloqueio ja efetuado !")
		ENDIF
	
	ELSE
			MsgInfo("Usuário ou documento iválido!")		
	ENDIF

	
return