#Include 'Protheus.ch'

//MONTAR ITENS DA O.S (AB7), PEGANDO TODAS AS BASE ATENDIMENTO DO CLIENTE
//CADA BASE DE ATENDIMENTO É UM NOVO ITEM DA O.S
//Autor : Robson Adriano 05/09/2014
//RETORNA : OS ITENS(AB7) PARA ABRIR A O.S(AB6)

User Function LIGTEC08(_codCli,_lojaCli,_pOco,_pNumCtr)
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
				IF _pNumCtr == AA3->AA3_UNUCTR 
					count ++
					//Montar item da ordem de serviço
					//Cada base instalada sera aberto como novo item do chamado
					aItem := {}
					aAdd(aItem,{"AB7_ITEM" ,StrZero(count,2),Nil})
					aAdd(aItem,{"AB7_TIPO"  ,"1",Nil})
					aAdd(aItem,{"AB7_CODPRO",AA3->AA3_CODPRO,Nil})
					aAdd(aItem,{"AB7_NUMSER",AA3->AA3_NUMSER,Nil})
					aAdd(aItem,{"AB7_CODPRB",_pOco,Nil})
					aAdd(aItens,aItem)
				ENDIF
			DBSKIP()	
		ENDDO
	ENDIF
	
	restarea(_aAA3)
	restarea(_area)
RETURN aItens




User Function TEC08B(_pOco,_pNumOS)
//Retorna todos os itens da OS passada por parametro 
//e seta as ocorrencias de todos como a passada por parametro
	Local _area := getarea()		
	Local _aAB7 := AB7->(getarea())	
	Local aItens := {}
	Local aItem := {}
	Local count := 0			
	//Consultar a base instalada do cliente
	DbSelectArea("AB7")	       
	IF DBSEEK(xFilial() + _pNumOS + "01")  //Move o ponteiro para o primeiro item da OS em questão de AB7
		WHILE (!EOF() .AND. AB7->AB7_FILIAL+AB7->AB7_NUMOS == xFilial() + _pNumOS)
			count ++
			//Montar item da ordem de serviço
			//Cada base instalada sera aberto como novo item do chamado
			aItem := {}
			aAdd(aItem,{"AB7_ITEM" ,StrZero(count,2),Nil})
			aAdd(aItem,{"AB7_TIPO"  ,"1",Nil})
			aAdd(aItem,{"AB7_CODPRO",AB7->AB7_CODPRO,Nil})
			aAdd(aItem,{"AB7_NUMSER",AB7->AB7_NUMSER,Nil})
			aAdd(aItem,{"AB7_CODPRB",_pOco,Nil})
			aAdd(aItens,aItem)
			DBSKIP()	
		ENDDO
	ENDIF	
	restarea(_aAB7)
	restarea(_area)
return aItens