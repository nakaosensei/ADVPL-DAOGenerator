#include "protheus.ch"
#include "rwmake.ch"

User Function TK271BOK(_nAux,_lAux)
	Local lRet := .t.
	Local _area := getarea()
	Local _aADA := ADA->(getarea())
	Local _aADB := ADB->(getarea())
	Local _nPosCTR 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UCTR" })
	Local _nPosIte	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UITTROC" })
	Local _nPosPro	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_PRODUTO" })
	Local _nPosQtd 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_QUANT" })
	Local _nPosQtd 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_QUANT" })
	Local _nPosVlr 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_VRUNIT" })
	Local _nPosMsg 	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UMSG" })
	Local _nPosIt  	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_ITEM" })
	Local _nMesIn  	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UMESINI" })
	Local _nMesCo  	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UMESCOB" })
	Local _nIdAga  	:= aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UIDAGA" })
	Local _nVlrChe  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "UB_UVLCHE" })
	Local _nDesc  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) 	== "UB_VALDESC" })
	Local _nDescPor  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) 	== "UB_DESC" })
	
	Public _lAlteraItem := .f.
	Public _aAltCtr     := {}
	IF nFolder == 2 //PRA SABER SE É DO TELEVENDAS
		if inclui .or. altera
			for i:=1 to len(aCols)
				if !aCols[i,len(aHeader)+1]
					if !empty(alltrim(aCols[i,_nPosCTR]))
//						if msgyesno("Deseja trocar de item ou incluir um novo item no contrato?") //COMENTADO POR DANIEL EM 19/12/16
							dbselectarea("ADA")
							dbsetorder(1) //ADA_FILIAL+ADA_NUMCTR
							if dbseek(xFilial()+aCols[i,_nPosCTR])
								if ADA->ADA_CODCLI+ADA->ADA_LOJCLI<>M->UA_CLIENTE+M->UA_LOJA
									alert("Cliente informado não é o mesmo do contrato. Favor informar um contrato do mesmo cliente:"+M->UA_CLIENTE+" loja "+M->UA_LOJA)
								else
									if ADA->ADA_MSBLQL=="1"
										alert("Projeto "+ADA->ADA_NUMCTR+" está bloqueado, não pode selecionar esse projeto.")
										lRet := .f.
									else
										dbselectarea("ADB")
										dbsetorder(1)
										if dbseek(xFilial()+ADA->ADA_NUMCTR)
											_lAchouProd := .f.
											while !eof() .and. xFilial()+ADA->ADA_NUMCTR==ADB->ADB_FILIAL+ADB->ADB_NUMCTR
												if ADB->ADB_ITEM==aCols[i,_nPosIte]
														_lAchouProd := .t.
														_lAlteraItem := .t.
																	 	//1               2               3                 4                 5                 6               7               8                 9              10				11					12					13			14				15				16
														aadd(_aAltCtr,{ADA->ADA_NUMCTR,ADB->ADB_CODPRO,aCols[i,_nPosPro],aCols[i,_nPosQtd],aCols[i,_nPosVlr],ADA->ADA_CODCLI,ADA->ADA_LOJCLI,aCols[i,_nPosMsg],ADB->ADB_ITEM,aCols[i,_nPosIt],aCols[i,_nMesIn], aCols[i,_nMesCo],aCols[i,_nIdAga],aCols[i,_nVlrChe],aCols[i,_nDesc],aCols[i,_nDescPor]})
//														exit
												else  //vai incluir sem o item, porque eh uma inclusao de novo item no contrato      

//														exit																									
												endif
												dbselectarea("ADB")
												dbskip()
											enddo
											if !_lAchouProd                 
												_lAchouProd := .t.
												 				 //1               2               3                 4                 5                 6               7               8                 9            10  11				12					13				14				15				16
												aadd(_aAltCtr,{ADA->ADA_NUMCTR,ADB->ADB_CODPRO,aCols[i,_nPosPro],aCols[i,_nPosQtd],aCols[i,_nPosVlr],ADA->ADA_CODCLI,ADA->ADA_LOJCLI,aCols[i,_nPosMsg],ADB->ADB_ITEM,aCols[i,_nPosIt],aCols[i,_nMesIn],  aCols[i,_nMesCo],aCols[i,_nIdAga],aCols[i,_nVlrChe],aCols[i,_nDesc],aCols[i,_nDescPor]})
											//	alert("Produto item "+aCols[i,_nPosite]+" não existe no contrato "+ADA->ADA_NUMCTR+".")
											endif
										else
											alert("Não existem items pra esse contrato "+ADA->ADA_NUMCTR)
										endif
									endif
								endif
							else
								alert("Contrato "+aCols[i,_nPosCTR]+" não existe.")
							endif
//						endif //COMENTADO POR DANIEL EM 19/12/16
					endif
				endif
			next
		endif
	ENDIF //TELEVENDAS

	restarea(_aADB)
	restarea(_aADA)
	restarea(_area)
return lRet
