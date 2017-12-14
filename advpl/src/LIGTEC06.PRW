#Include 'Protheus.ch'

//ABRIR CHAMADO TECNICO PARA CANCELAMENTO DO SERVICO
//RETORNA : OS ITENS PARA ABRIR O CHAMADO TECNICO
User Function LIGTEC06(_codCli,_lojaCli,_cTipoCh,_cClassi,_pOcoDes)//Paramentro de Ocorrencia
	Local _area := getarea()		
	Local _aAA3 := AA3->(getarea())
	
	Local aItens := {}
	Local aItem := {}
	Local count := 0	
			
	//Consultar a base instalada do cliente
	DbSelectArea("AA3")
	DBSETORDER(8)       
	IF DBSEEK(xFilial() + _codCli + _lojaCli)  //VERIFICAR SE TEM BASE INSTALADA PRA ESSE CLIENTE
		WHILE !EOF() .AND. AA3->AA3_FILIAL+AA3->AA3_CODCLI+AA3->AA3_LOJA == xFilial() + _codCli + _lojaCli // PEGAR TODAS A BASE INSTALADAS DESSE CLIENTE PARA ABRIR CHAMADO
				count ++
				//Montar item do chamado tecnico
				//Cada base instalada sera aberto como novo item do chamado
				aItem := {}
					aAdd(aItem,{"AB2_ITEM" ,StrZero(count,2),Nil})
					aAdd(aItem,{"AB2_TIPO" ,_cTipoCh,Nil})
					aAdd(aItem,{"AB2_CLASSI",_cClassi,Nil})
					aAdd(aItem,{"AB2_CODPRO",AA3->AA3_CODPRO,Nil})
					aAdd(aItem,{"AB2_NUMSER",AA3->AA3_NUMSER,Nil})
					aAdd(aItem,{"AB2_CODPRB",_pOcoDes,Nil})
					aAdd(aItens,aItem)
			DBSKIP()	
		ENDDO
	ENDIF
	
	restarea(_aAA3)
	restarea(_area)
RETURN aItens
