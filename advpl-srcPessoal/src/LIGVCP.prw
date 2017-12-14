#include 'protheus.ch'
#include 'parmtype.ch'
//Function LIGVCP(LIG VALIDAR CONDIÇÃO DE PAGAMENTO)
//A FUNÇÃO ABAIXO VALIDA UMA VENDA A PARTIR DA CONDIÇÃO DE PAGAMENTO
//ESCOLHIDA, SE A CONDIÇÃO FOR IGUAL A UMA DAS PASSADAS POR PARAMETRO,
//A VENDA É EFETIVADA, CASO CONTRARIO ELA É CANCELADA E O USUÁRIO
//É INFORMADO DISSO
//RETORNA TRUE CASO A VALIDAÇÃO TENHA SUCESSO, FALSE EM FALHA
//IN: condIn = A condição de pagamento selecionada pelo vendedor
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
		MsgAlert("A condição de pagamento é invalida, sugerimos "+condPg)
		return ""
	endif	
return condIn