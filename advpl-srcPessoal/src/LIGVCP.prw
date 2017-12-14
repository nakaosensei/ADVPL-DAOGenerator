#include 'protheus.ch'
#include 'parmtype.ch'
//Function LIGVCP(LIG VALIDAR CONDI��O DE PAGAMENTO)
//A FUN��O ABAIXO VALIDA UMA VENDA A PARTIR DA CONDI��O DE PAGAMENTO
//ESCOLHIDA, SE A CONDI��O FOR IGUAL A UMA DAS PASSADAS POR PARAMETRO,
//A VENDA � EFETIVADA, CASO CONTRARIO ELA � CANCELADA E O USU�RIO
//� INFORMADO DISSO
//RETORNA TRUE CASO A VALIDA��O TENHA SUCESSO, FALSE EM FALHA
//IN: condIn = A condi��o de pagamento selecionada pelo vendedor
//condPg = getmv("MV_TVCP")
user function LIGVCP(condIn,condPg)	
	conds := StrTokArr(condPg, ",")
	vld := .F.
	for i := 1 to len(conds)
		if(ALLTRIM(conds[i]) == ALLTRIM(condIn))
			vld := .T.
		endif
	next		
return vld

//Invocada pela trigger UA_CONDPG
user function LIGVCP2(condIn)	
	Local condPg := getmv("MV_TVCP")
	vld := u_LIGVCP(condIn,condPg)		
	if(vld = .F.)		
		MsgAlert("A condi��o de pagamento � invalida, sugerimos "+condPg)
		return ""
	endif	
return condIn