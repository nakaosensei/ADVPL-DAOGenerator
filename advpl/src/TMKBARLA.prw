#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

User Function TMKBARLA(aBotao, aTitulo)
	aAdd(aBotao,{"POSCLI"  , {|| TMKBARLA1()()} ,"Cliente"})
	aAdd(aBotao,{"S4WB010N"  , {|| TMKBARLA2()()} ,"Atualizar Boleto"})
	
Return( aBotao )


Static Function TMKBARLA1()
	Local _cCodCli := M->UA_CLIENTE
	Local _cLoja := M->UA_LOJA
	Local aArea := GetArea()
	Local _aSA1 := SA1->(getarea())
	
	dbselectarea("SA1")
	dbsetorder(1)
	if dbseek(xFilial()+_cCodCli+_cLoja)
		FWExecView('Inclusao por FWExecView','AGBSA1_MVC', MODEL_OPERATION_UPDATE, , { || .T. }, , , )
	else
		ALERT('Não foi possivel localizar o Cliente do Tele Vendas.')
	endif
	
	restarea(_aSA1)
	RestArea( aArea )
Return

/*===============================
Atualizar boleto na tela de 
Tele Cobrança
AUTOR: NOEMI
DATA: 02/02/17 
================================*/

Static Function TMKBARLA2()
	//dbSetOrder(2) //ACG_FILIAL + ACG_PREFIX + ACG_TITULO + ACG_PARCEL + ACG_TIPO + ACG_FILORI
	Local area := getarea()
	Local aACG := ACG->(getarea())
	
	Local nPref 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "ACG_PREFIX" })
	Local nTitulo 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "ACG_TITULO" })
	Local nParcel 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "ACG_PARCEL" })
	Local lImprim := .T.
	Local i:=1
	
	IF nFolder == 3
		WHILE i<=LEN(aCols)
			nP := aCols[i, nPref]
			nT := aCols[i, nTitulo]
			nPa := aCols[i, nParcel]
			lImprim = .F.	
				
				IF !empty(alltrim(aCols[i, nPref])) .AND. !empty(alltrim(aCols[i, nTitulo])) .AND. !empty(alltrim(aCols[i, nParcel]))	
					dbSelectArea("SE1")
					dbSetOrder(1) //E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					
					IF dbSeek(xFilial("SE1") + aCols[i, nPref] + aCols[i, nTitulo] + aCols[i, nParcel])					
						
						WHILE !EOF() .AND. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA  == xFilial("SE1") + aCols[i, nPref] + aCols[i, nTitulo] + aCols[i, nParcel]
							
							IF E1_PREFIXO == aCols[i, nPref] .AND. E1_NUM == aCols[i, nTitulo] .AND. E1_PARCELA == aCols[i, nParcel] .AND. lImprim = .F.
								U_ROT01()
								lImprim := .T.
							ENDIF
							
							dbSelectArea("SE1")
							dbSkip()
							
						ENDDO
					
					ENDIF
					
				ELSE
					ALERT("Campos vazio")
				ENDIF
			i++
		ENDDO
	
	ELSE
		MsgInfo("Essa rotina só é possível executar em Telecobrança")
	ENDIF

	
	restarea(aACG)
	restarea(area)
	
return
