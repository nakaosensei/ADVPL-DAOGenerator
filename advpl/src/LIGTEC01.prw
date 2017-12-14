#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
LIGTEC01   - Programa pra incluir ordem de serviço automaticamente
Autor      - Daniel Gouvea
Data       - 06/05/14
Parametros - _produto,_cliente,_loja,_cond,_oco,_serv,_quant,_valor

*/

User Function LIGTEC01(_produto,_cliente,_loja,_cond,_oco,_serv,_quant,_valor,_numser,_msg,_atend,_situ1,_cNumCtr)
	Local _cOS := ""
	Local _area := getarea()
	Local _aSA1 := SA1->(getarea())
	Local _aSB1 := SB1->(getarea())
	Local _aSE4 := SE4->(getarea())
	Local _aAA3 := AA3->(getarea())
	Local _aAAG := AAG->(getarea())
	Local _aAA5 := AA5->(getarea())

	CONOUT(" ------------ ENTROU LIGTEC01 -------- "+dtoc(date())+" HORA "+TIME())
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+_cliente+_loja)
		DbSelectArea("SB1")
		DbSetOrder(1)
		if dbseek(xFilial()+_produto)
			DbSelectArea("SE4")
			DbSetOrder(1)
			if dbseek(xFilial()+_cond)
				DbSelectArea("AA3")
				DbSetOrder(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
				if dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SB1->B1_COD+_numser)
					DbSelectArea("AAG")
					DbSetOrder(1)//AAG_FILIAL+AAG_CODPRB
					if dbseek(xFilial()+_oco)
						DbSelectArea("AA5")
						DbSetOrder(1)
						if dbseek(xFilial()+_serv)
							ConOut("Inicio do execauto: "+Time())
							cNumOS := GetSXENum("AB6","AB6_NUMOS")
							RollBackSx8()
							aCabec := {}
							aItem := {}
							aItens := {}
							aAdd(aCabec,{"AB6_NUMOS",cNumOS,Nil})
							aAdd(aCabec,{"AB6_CODCLI",SA1->A1_COD,Nil})
							aAdd(aCabec,{"AB6_LOJA"  ,SA1->A1_LOJA,Nil})
							aAdd(aCabec,{"AB6_EMISSA",dDataBase,Nil})
							aAdd(aCabec,{"AB6_UNUMCT",cValToChar(ALLTRIM(_cNumCtr)),Nil})
							
							IF EMPTY(_atend)
								aAdd(aCabec,{"AB6_ATEND" ,usrfullname(__cuserid),Nil})
							ELSE
								aAdd(aCabec,{"AB6_UCODAT" ,_atend,Nil})
								aAdd(aCabec,{"AB6_ATEND" ,POSICIONE( "AA1", 1, XFILIAL( "AA1" ) + _atend, "AA1_NOMTEC"),Nil})
							ENDIF
							
							aAdd(aCabec,{"AB6_USITU1",_situ1,Nil})
							
							aAdd(aCabec,{"AB6_CONPAG",SE4->E4_CODIGO,Nil})
							aAdd(aCabec,{"AB6_HORA"  ,Time(),Nil})
							aAdd(aCabec,{"AB6_MSG"  ,_msg,Nil})
							aAdd(aItem,{"AB7_ITEM"  ,StrZero(1,2),Nil})
							aAdd(aItem,{"AB7_TIPO"  ,"1",Nil})
							aAdd(aItem,{"AB7_CODPRO",AA3->AA3_CODPRO,Nil})
							aAdd(aItem,{"AB7_NUMSER",AA3->AA3_NUMSER,Nil})
							aAdd(aItem,{"AB7_CODPRB",AAG->AAG_CODPRB,Nil})
							aAdd(aItens,aItem)
							lMsErroAuto := .f.
							lMsHelpAuto := .f.
							_modAnt := nModulo
							nModulo := 28
							TECA450(,aCabec,aItens,{},3)
							nModulo := _modAnt
							If !lMsErroAuto
								ConOut("Inclusao com sucesso! ")
								_cOS := cNumOS
							Else
								ConOut("Erro na inclusao!")
								mostraerro("\logerro\")
								MOSTRAERRO()
								ALERT("ERRO AO TENTAR INCLUIR UMA OS")
							EndIf
						else //AA5
							conout(" ELSE DA AA5. _SERV="+_serv)
						endif //if do AA5
					else
						conout(" ELSE DA AAG. _OCO="+_oco)
					endif //if do AAG
				else
					conout(" ELSE DA AA3. _numser="+_numser)
				endif //if do AA3
			else
				conout(" ELSE DA SE4. _cond="+_cond)
			endif //if do SE4
		else
			conout(" ELSE DA SB1. _produto="+_produto)
		endif//if do SB1
	else
		conout(" ELSE DA SA1. _cliente+_loja="+_cliente+_loja)
	endif //if do SA1

	restarea(_aAA5)
	restarea(_aAAG)
	restarea(_aAA3)
	restarea(_aSE4)
	restarea(_aSB1)
	restarea(_aSA1)
	restarea(_area)
return _cOS

/**
ADADOS[1]	= _produto
ADADOS[2]	= _cliente 
ADADOS[3]	= _loja
ADADOS[4]	= COND PAGAMENTO
ADADOS[5]	= OCOREENCIA
ADADOS[6]	= SERVIÇO
ADADOS[7]	= QUANTIDADE
ADADOS[8]	= PREÇO
ADADOS[9]	= NUM SERIE
ADADOS[10]	= MSG DO ITEM
ADADOS[11]	= ATENDENTE
ADADOS[12]	= SITUAÇÃO
ADADOS[13]	= NUMCTR
ADADOS[14]	= ITEM CTR
ADADOS[15]	= ACAO INICIO / FIM VIGENCIA
ADADOS[16]	= NUMERO CALLCENTER
ADADOS[17]	= MSG DO CABEÇALHO DA SUA/ADA
ADADOS[18]	= ASSINOU CTR S/N
**/
User Function LIGTEC1A(aDados)
	Local _cOS := ""
	Local _area := getarea()
	Local _aSA1 := SA1->(getarea())
	Local _aSB1 := SB1->(getarea())
	Local _aSE4 := SE4->(getarea())
	Local _aAA3 := AA3->(getarea())
	Local _aAAG := AAG->(getarea())
	Local _aAA5 := AA5->(getarea())

  //BEGIN TRANSACTION
	
	CONOUT(" ------------ ENTROU LIGTEC1A -------- "+dtoc(date())+" HORA "+TIME())
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+aDados[1,2]+aDados[1,3])
		ConOut("Inicio do execauto: "+Time())
		cNumOS := GetSXENum("AB6","AB6_NUMOS")
		RollBackSx8()
		aCabec := {}
		aItens := {}
		aItem := {}
		FOR J:=1 TO LEN(aDados)
			DbSelectArea("SB1")
			DbSetOrder(1)
			if dbseek(xFilial()+aDados[j,1])
				DbSelectArea("SE4")
				DbSetOrder(1)
				if dbseek(xFilial()+aDados[j,4])
					DbSelectArea("AA3")
					DbSetOrder(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
					if dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SB1->B1_COD+aDados[j,9])
						DbSelectArea("AAG")
						DbSetOrder(1)//AAG_FILIAL+AAG_CODPRB
						if dbseek(xFilial()+aDados[j,5])
							DbSelectArea("AA5")
							DbSetOrder(1)
							if dbseek(xFilial()+aDados[j,6])
								if len(aCabec)==0
									aAdd(aCabec,{"AB6_NUMOS",cNumOS,Nil})
									aAdd(aCabec,{"AB6_CODCLI",SA1->A1_COD,Nil})
									aAdd(aCabec,{"AB6_LOJA"  ,SA1->A1_LOJA,Nil})
									aAdd(aCabec,{"AB6_EMISSA",dDataBase,Nil})
									aAdd(aCabec,{"AB6_UNUMCT",cValToChar(ALLTRIM(aDados[j,13])),Nil})
									
									IF EMPTY(aDados[j,11])
										aAdd(aCabec,{"AB6_ATEND" ,usrfullname(__cuserid),Nil})
									ELSE
										aAdd(aCabec,{"AB6_UCODAT" ,aDados[j,11],Nil})
										aAdd(aCabec,{"AB6_ATEND" ,POSICIONE( "AA1", 1, XFILIAL( "AA1" ) + aDados[j,11], "AA1_NOMTEC"),Nil})
									ENDIF
									
									aAdd(aCabec,{"AB6_USITU1","1",Nil})
									
									aAdd(aCabec,{"AB6_CONPAG",SE4->E4_CODIGO,Nil})
									aAdd(aCabec,{"AB6_HORA"  ,Time(),Nil})
									aAdd(aCabec,{"AB6_MSG"  ,aDados[j,17],Nil})
								endif
								aAdd(aItem,{"AB7_ITEM"  ,StrZero(J,2),Nil})
								aAdd(aItem,{"AB7_TIPO"  ,"1",Nil})
								aAdd(aItem,{"AB7_CODPRO",AA3->AA3_CODPRO,Nil})
								aAdd(aItem,{"AB7_NUMSER",AA3->AA3_NUMSER,Nil})
								aAdd(aItem,{"AB7_UDTVIG",STOD(""),Nil})
								aAdd(aItem,{"AB7_CODPRB",AAG->AAG_CODPRB,Nil})
								aAdd(aItem,{"AB7_UMSG"  ,SUBSTR(aDados[j,10],1,200),Nil})
								
								aAdd(aItens,aItem)
								
								RECLOCK("SZ2",.T.)
								SZ2->Z2_FILIAL  := xFilial()
								SZ2->Z2_NUMATEN := aDados[J,16]
								SZ2->Z2_NUMCTR  := aDados[J,13]
								SZ2->Z2_ITEMCTR := aDados[J,14]
								SZ2->Z2_NUMOS   := cNumOs
								SZ2->Z2_PRODUTO := aDados[J,1]
								SZ2->Z2_ITEMOS  := strzero(J,2)
								SZ2->Z2_ACAO    := aDados[J,15]
								MSUNLOCK()
								
								aItem := {}								
							else //AA5
								conout(" ELSE DA AA5. _SERV="+aDados[j,6])
							endif //if do AA5
						else
							conout(" ELSE DA AAG. _OCO="+aDados[j,5])
						endif //if do AAG
					else
						conout(" ELSE DA AA3. _numser="+aDados[j,9])
					endif //if do AA3
				else
					conout(" ELSE DA SE4. _cond="+aDados[j,4])
				endif //if do SE4
			else
				conout(" ELSE DA SB1. _produto="+aDados[j,1])
			endif//if do SB1
		NEXT
	else
		conout(" ELSE DA SA1. _cliente+_loja="+aDados[1,2]+aDados[1,3])
	endif //if do SA1
	
	_cOS := ""
	
	if len(aCabec)>0 .and. len(aItens)>0
		lMsErroAuto := .f.
		lMsHelpAuto := .f.
		_modAnt := nModulo
		nModulo := 28
		TECA450(,aCabec,aItens,{},3)
		nModulo := _modAnt
		If !lMsErroAuto
			ConOut("Inclusao com sucesso! ")
			_cOS := cNumOS
			MSGINFO("OS Incluida com sucesso. "+cNumOS)
		Else
			ConOut("Erro na inclusao!")
	//		mostraerro("\logerro\")
			MOSTRAERRO()
			ALERT("ERRO AO TENTAR INCLUIR UMA OS")
		EndIf
	endif
	
	//END TRANSACTION
	
	restarea(_aAA5)
	restarea(_aAAG)
	restarea(_aAA3)
	restarea(_aSE4)
	restarea(_aSB1)
	restarea(_aSA1)
	restarea(_area)
return _cOS