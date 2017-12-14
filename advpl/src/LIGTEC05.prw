#Include 'Protheus.ch'

/*
LIGFIN06   - Programa para gerar chamado tecnico 
Autor      - Robson Adriano
Parametros - _cliente,_loja,_itens do chamado
*/

User Function LIGTEC05(_codCli, _lojaCli, aItens)

Local aCabec := {} 
Local cChamado := ""
Local iOK := .T.

PRIVATE lMsErroAuto := .F.

ConOut("Inicio: "+Time())

cChamado := GetSXENum("AB1","AB1_NRCHAM")
RollBackSx8()

// Montar cabecalho do chamado tecnico
aAdd(aCabec,{"AB1_NRCHAM",cChamado,Nil})
aAdd(aCabec,{"AB1_EMISSA",dDataBase,Nil})
aAdd(aCabec,{"AB1_CODCLI",_codCli,Nil})
aAdd(aCabec,{"AB1_LOJA" ,_lojaCli,Nil})
aAdd(aCabec,{"AB1_HORA" ,Time(),Nil})
aAdd(aCabec,{"AB1_ATEND" ,cUserName,Nil})
  
TECA300(,,aCabec,aItens,3)

If !lMsErroAuto
		ConOut("Incluido com sucesso! "+cChamado)
Else
		iOK := .F.
		MostraErro()
		ConOut("Erro na inclusao!")
EndIf


ConOut("Fim : "+Time())

Return iOK	