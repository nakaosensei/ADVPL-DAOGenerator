#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
LIGTEC01   - Programa pra incluir ordem de serviço automaticamente
Autor      - Daniel Gouvea
Data       - 06/05/14
Parametros - _produto,_cliente,_loja,_cond,_oco,_serv,_quant,_valor

*/

User Function LIGFLD01(_produto,_cliente,_loja,_cond,_oco,_serv,_quant,_valor,_numser)
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
							aAdd(aCabec,{"AB6_ATEND" ,usrfullname(__cuserid),Nil})
							aAdd(aCabec,{"AB6_CONPAG",SE4->E4_CODIGO,Nil})
							aAdd(aCabec,{"AB6_HORA"  ,Time(),Nil})
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
								_cOS := AB6->AB6_NUMOS
							Else
								ConOut("Erro na inclusao!")
								mostraerro("\logerro\")
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
