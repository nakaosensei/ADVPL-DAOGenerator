#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"

/*
FUNCAO PRA LIBERAÇÃO FINANCEIRA DO CONTRATO.
VAI ALTERAR O CAMPO ADA_ULIBER DE N PRA S E DISPARAR AS ORDENS DE SERVIÇO DE INSTALAÇÃO
*/

User Function LIGTEC02()
Local _area := getarea()
Local _bValida := .T.
Local _cOcoTsf 	:= getmv("MV_UOCOTSF") 	// Cod. Ocorrencia para Transferencia de Titularidade   
Local _cAtInst 	:= getmv("MV_UATINST") 	// Cod. Atendente para Ordem de Servico de Instalacao 
Local _cAtAtiv 	:= getmv("MV_UATATIV") 	// COD ATENDENTE DE ATIVACAO	
Local _cAtAtend1 := getmv("MV_UATEND1") // COD ATENDENTE DE INSTALACAO DE LINK FULL	
Local _cPrdLnkFl := getmv("MV_UPDLKF")  // Codigos dos produtos de itens de contrato link full ativação
Local _cSerIns 	:= getmv("MV_USERINS") 	//
Local _cProEnd := getmv("MV_UPROEND") // Cod. Atendente para Ordem de Servico de Instalacao  
Local _cCtrAnt 	:= ""
local _CosInclu := ""
Local _cProd := getmv("MV_UPDLKF")
Local _cAtPlug := getmv("MV_UATPLUG") // Cod. Atendente para Ordem de Servico de Instalacao 
Local aDados := {}

if ADA->ADA_ULIBER=="S"
	msginfo("Contrato já está liberado.")
else
	if msgyesno("Tem certeza de que deseja liberar o contrato? Fazendo isso serão disparadas as Ordens de Serviço referentes aos itens do contrato.") 
   		
   		//INICIO CODIGO ROBSON 01/09/2014
		if !EMPTY(ADA->ADA_UCTANT)
			//SE NAO TEM MUDANÇA DE ENDEREÇO TEM QUE COLOCAR A DATA ATUAL NA DATA DE FIM VINGENCIA NO CONTRATO ANTIGO E A DATA ATUAL + 1 DE INCIO DE VINGENCIA NO NOVO CONTRATO
			if !msgyesno("Contrato de Transferencia de Titularidade tem mudança endereço ?")
				
				LIGTEC02A(ALLTRIM(ADA->ADA_UCTANT),.F.) //ADICIONAR DATA FIM NO CONTRATO ANTIGO
						
				LIGTEC02A(ADA->ADA_NUMCTR,.T.) //ADICIONAR DATA INICIO NO CONTRATO NOVO
						         
				//INICIO MUDANCA TITULARIDE, ROBSON 05/09/2014
				_cCtrAnt := ALLTRIM(ADA->ADA_UCTANT)
				
				//Lançar base de atendimento para os itens do Contrato 
				U_TEC02C(ADA->ADA_NUMCTR)	//Montar itens da O.S baseado nas base de atendimento				
				aItens := U_LIGTEC08(ADA->ADA_CODCLI,ADA->ADA_LOJCLI,_cOcoTsf,ADA->ADA_NUMCTR)		
						                                                           	
				_cMsg := "Transferencia de Titularidade : "	+ U_TEC02D(_cCtrAnt)
				//Funcao que monta o cabecalho(AB6) da O.S e usa TECA450 para gerar chamados	
								//1 _cliente, 2 _loja, 3 Cond. PGTO, 4 Mensagem Cab. 5 _itens da Ordem, 6 Atendente , 7 Situacao , 8 NUMCTR
   				_ch := U_LIGTEC07(ADA->ADA_CODCLI, ADA->ADA_LOJCLI,ADA->ADA_CONDPG,_cMsg,aItens,_cAtAtiv,"10",ALLTRIM(ADA->ADA_NUMCTR))			
					
				if empty(_ch)
	   		  			MsgInfo("NÃO FOI POSSIVEL CRIAR A ORDEM PARA O CTR: "  + ADA->ADA_NUMCTR," Msg Info ")
	   		   			memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log","ERRO AO TENTAR INCLUIR UMA OS DE TRANSFERENCIA"+ADA->ADA_NUMCTR+" NA ROTINA AT450GRV")	
		   		else	
		   			_aADA := ADA->(getarea())
		   			dbselectarea("ADA")
					dbsetorder(1)
					DBGoTop() 
					if dbseek(xFilial()+ _cCtrAnt)
		   				RECLOCK("ADA",.F.) //Bloquear contrato antigo.
							ADA->ADA_MSBLQL := "1"
							ADA->ADA_UDTBLQ := date()
						MSUNLOCK()	 
				  
					endif
					restarea(_aADA)	
					_CosInclu += " OS: " + _ch+ " ; "													   		
				endif								
				
				_bValida := .F. 			
				//FIM MUDANCA TITULARIDADE, ROBSON 05/09/2014 
				
			ELSE // CASO TENHA MUDANCA, GERAR OS PARA RETIRAR EQUIPAMENTO DO ENDERECO ANTIGO
					
				LIGTEC02B(ALLTRIM(ADA->ADA_UCTANT)) // GERAR OS RETIRADA EQUIP.
				
				_cSerIns := getmv("MV_USERTFE")						
			endif			
		endif
		//FIM DO CODIGO ROBSON 01/09/2014           
	    _aADA := ADA->(getarea())
		 _aADB := ADB->(getarea())    
		                                
   		IF _bValida  // Valida portabilidade sem endereco
			_cOcoIns := getmv("MV_UOCOINS")
			
			_cOcoDes := getmv("MV_UOCODES")
			_cSerDes := getmv("MV_USERDES")
	
			dbselectarea("ADB")
			dbsetorder(1)
			if dbseek(xFilial()+ADA->ADA_NUMCTR)
				isLnkFull = .F.
				while !eof() .and. xFilial()+ADA->ADA_NUMCTR==ADB->ADB_FILIAL+ADB->ADB_NUMCTR	
					// VERIFICAR APENAS OS ADB QUE NÃO SÃO ITENS DO CONTRATO (EX: SERVICO DE INSTALACAO, MUDANCA ENDERECO)
					_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
				//	IF (_cItemCtr = 'N') //COMENTADO POR DANIEL EM 20/12/16 PRA NAO VERIFICAR MAIS ISSO
							//vai começar a preparar as variaveis pra chamar a LIGTEC01
							_condi := ADA->ADA_CONDPG
							if empty(_condi)
								_condi := ALLTRIM(GETMV("MV_UCONCTR"))
							endif
							
							_cNumSer := ""
							
							dbselectarea("SX6")
							dbsetorder(1)
							dbseek("    "+"MV_ATBSSEQ")
							_cNumSer := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
							reclock("SX6",.f.)
							SX6->X6_CONTEUD := _cNumSer
							msunlock()
							_cNumSer := alltrim(GETMV("MV_ATBSPRF"))+_cNumSer
							
							dbselectarea("AA3")
							reclock("AA3",.t.)
							AA3->AA3_FILIAL := xFilial()
							AA3->AA3_CODCLI := ADB->ADB_CODCLI
							AA3->AA3_LOJA   := ADB->ADB_LOJCLI
							AA3->AA3_CODPRO := ADB->ADB_CODPRO
							AA3->AA3_NUMSER := _cNumSer
							AA3->AA3_DTVEND := ddatabase
							AA3->AA3_DTGAR  := ddatabase
							AA3->AA3_STATUS := "03"
							AA3->AA3_HORDIA := 8   
							
							AA3->AA3_UNUCTR := ADB->ADB_NUMCTR //Numero do contrato que gerou a base de atendimento
							AA3->AA3_UITCTR := ADB->ADB_ITEM //Codigo do item do contrato que gerou a base de atendimento
							AA3->AA3_UIDAGA := ADB->ADB_UIDAGA	
							msunlock()
			
							//Codigo do produto
							
							
			
//								_os := U_LIGTEC01(ADB->ADB_CODPRO,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,ADB->ADB_QUANT,ADB->ADB_PRCVEN,_cNumSer,ADB->ADB_UMSG,_cAtInst,"1",ALLTRIM(ADA->ADA_NUMCTR))
								
							if(At(ALLTRIM(ADB->ADB_CODPRO),_cPrdLnkFl,1)>=1)//Se o codigo do produto de ADB está em _cPrdLnkFl, faça o atendente ser o atendente da instação link full
								isLnkFull := .T.								
							endif
							aAdd(aDados,{ADB->ADB_CODPRO,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,ADB->ADB_QUANT,ADB->ADB_PRCVEN,_cNumSer,ADB->ADB_UMSG,_cAtInst,"1",ALLTRIM(ADA->ADA_NUMCTR),ADB->ADB_ITEM,"INICIO VIGENCIA",""})
/*								if !empty(_os)
									dbselectarea("SZ2")
									reclock("SZ2",.t.)
									SZ2->Z2_FILIAL  := xFilial()
									//SZ2->Z2_NUMATEN := _naten
									SZ2->Z2_NUMCTR  := ADB->ADB_NUMCTR
									SZ2->Z2_ITEMCTR := ADB->ADB_ITEM
									SZ2->Z2_NUMOS   := _os
									SZ2->Z2_PRODUTO := ADB->ADB_CODPRO
									SZ2->Z2_ITEMOS  := "01"
									SZ2->Z2_ACAO    := "INICIO VIGENCIA"
									msunlock()
									
									_CosInclu += " OS: " + _os+ " ; "
								else
									memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log","ERRO AO TENTAR INCLUIR UMA OS	DO CONTRATO "+ADB->ADB_NUMCTR+" NA ROTINA LIGTEC02")	
									
									throw "Não foi possivel criar a ordem de Serviço para o Item:  " + ADB->ADB_CODPRO + " : " + ADB->ADB_DESPRO	    
								endif
								*/
										
//					ENDIF //COMENTADO POR DANIEL EM 20/12/16
					dbselectarea("ADB")
					dbskip()
				enddo
			endif		
		endif //FIM DO IF DE VALIDACAO DE PORTABILIDADE
		
		if len(aDados)>0
			//IMPLEMENTACAO DA REGRA DE ASSUNTO E CODIGO DE ATENDENTE
			lPlug := .T.            
			lInst := .F.                   
			lMudE := .F.    
			cAssunto := "3"
			for _i:=1 to len(aDados)
				dbselectarea("SB1")
				dbsetorder(1)
				if dbseek(xFilial()+aDados[_i,1])
					if !(SB1->B1_GRUPO $ "0106/0107/0108")                           
						lPlug := .F.
					endif	
					if SB1->B1_UITCONT=="N"
						lInst := .T.			
						if ALLTRIM(SB1->B1_COD)==ALLTRIM(_cProEnd)
							lMudE := .T.
							cAssunto := "8"  
						elseif !lMudE
							cAssunto := "1"
						endif
					endif
				endif																												
			next               
	
			if lPlug 
				for _i:=1 to len(aDados)
					aDados[_i,11] := _cAtPlug
					aDados[_i,12] := cAssunto
				next    
			elseif lInst
				for _i:=1 to len(aDados)
					aDados[_i,11] := _cAtInst
					aDados[_i,12] := cAssunto
				next      
			else
				for _i:=1 to len(aDados)
					aDados[_i,11] := _cAtAtiv
					aDados[_i,12] := cAssunto
				next      				
			endif	
			if(isLnkFull = .T.)
				for _i:=1 to len(aDados)
					aDados[_i,11] := _cAtAtend1					
				next  
			endif		
			_CosInclu := U_LIGTEC1A(aDados)			
		endif
		
		MsgInfo("Contrato liberado ! Ordem de serviços criadas : " + _CosInclu )
		RECLOCK("ADA",.F.)
			ADA->ADA_ULIBER := "S"
			ADA->ADA_UDTLIB := date()
			IF !_bValida
				ADA->ADA_ULIBEQ := "S"
			ENDIF
		MSUNLOCK()	     
	
		restarea(_aADB)
		restarea(_aADA)  
	else
		//Dialog para reprovação de Contrato
		 U_Obs_Repro()
	endif
endif

restarea(_area)
return   

//Metodo para atualizar os itens(ADB) do contrato com inicio ou fim de vingencia
Static Function LIGTEC02A(_nCtr,_bINICIO)
_aADB := ADB->(getarea())

dbselectarea("ADB")
dbsetorder(1)
DBGoTop()
if dbseek(xFilial()+_nCtr)
	while !eof() .and. xFilial() + _nCtr == ADB->ADB_FILIAL+ADB->ADB_NUMCTR
			RECLOCK("ADB",.F.)
			
			IF _bINICIO
				ADB->ADB_UDTINI := ddatabase
			ELSE
				IF EMPTY(ADB->ADB_UDTFIM)
					ADB->ADB_UDTFIM := ddatabase 
				ENDIF
			ENDIF
			
			MSUNLOCK()				
		dbselectarea("ADB")
		dbskip()
	enddo
endif
restarea(_aADB)
return

//Metodo para abrir O.S para retirada de equipamento do endereco do contrato antigo
Static Function LIGTEC02B(_nCtr)
Local _cMsgOS := "Retirada de Equipamento para transferencia de endereço"
Local _cAtAtiv := getmv("MV_UATATIV") // COD ATENDENTE DE ATIVACAO	

_aAA3 := AA3->(getarea())
_aSZ2 := SZ2->(getarea())

_cOcoRet := getmv("MV_UOCORET") // Cod. Ocorrencia para retirada do equipamento
_cSerTsf := getmv("MV_USERTSF") // Cod. Servico de retirada do equipamento
_cProTsf := getmv("MV_UPROTSF") // Cod. Produto que tem que fazer retiradas de equipamento


dbselectarea("AA3")
dbsetorder(9)
DBGoTop()
if dbseek(xFilial()+ _nCtr) //VERIFICAR AS BASE DE ATENDIMENTO DESSE CONTRATO PARA GERAR O.S DE RETIRADA DE EQUIPAMENTO
		while !eof() .and. xFilial() + _nCtr  == AA3->AA3_FILIAL + AA3->AA3_UNUCTR
			_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + AA3->AA3_CODPRO, "B1_UITCONT")
			IF (_cItemCtr = 'S')
			
				_os := U_LIGTEC01(AA3->AA3_CODPRO,AA3->AA3_CODCLI,AA3->AA3_LOJA,ADA->ADA_CONDPG,_cOcoRet,_cSerTsf,1,0,AA3->AA3_NUMSER,_cMsgOS,_cAtAtiv,"9",_nCtr)	
			
				if !empty(_os) //GERAR SZ2 PARA FIM DE VINGENCIA NOS ITENS DO CONTRATO ANTIGO QUANDO FOR RETIRADO O EQUIPAMENTO
						dbselectarea("SZ2")
						reclock("SZ2",.t.)
						SZ2->Z2_FILIAL  := xFilial()
						//SZ2->Z2_NUMATEN := _naten
						SZ2->Z2_NUMCTR  := AA3->AA3_UNUCTR
						SZ2->Z2_ITEMCTR := AA3->AA3_UITCTR 
						SZ2->Z2_NUMOS   := _os
						SZ2->Z2_PRODUTO := AA3->AA3_CODPRO
						SZ2->Z2_ITEMOS  := "01"
						SZ2->Z2_ACAO    := "FINAL VIGENCIA"
						msunlock()
				else
						memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log","ERRO AO TENTAR INCLUIR UMA OS	DO CONTRATO "+ADB->ADB_NUMCTR+" NA ROTINA LIGTEC02")	
				endif			
			endif
			
			dbselectarea("AA3")
			dbskip()
		enddo 
endif	

restarea(_aSZ2)
restarea(_aAA3)
return

//Criar base de atendimento para os itens do novo contrato
User Function TEC02C(_nCtr)
Local _area := getarea()
		
		dbselectarea("ADB")
		dbsetorder(1)
		if dbseek(xFilial()+_nCtr)
				while !eof() .and. xFilial()+_nCtr==ADB->ADB_FILIAL+ADB->ADB_NUMCTR
					// VERIFICAR APENAS OS ADB QUE NÃO SÃO ITENS DO CONTRATO (EX: SERVICO DE INSTALACAO, MUDANCA ENDERECO)
					_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
					IF (_cItemCtr = 'S')
							_cNumSer := ""
							
							dbselectarea("SX6")
							dbsetorder(1)
							dbseek("    "+"MV_ATBSSEQ")
							_cNumSer := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
							reclock("SX6",.f.)
							SX6->X6_CONTEUD := _cNumSer
							msunlock()
							_cNumSer := alltrim(GETMV("MV_ATBSPRF"))+_cNumSer
							
							dbselectarea("AA3")
							reclock("AA3",.t.)
							AA3->AA3_FILIAL := xFilial()
							AA3->AA3_CODCLI := ADB->ADB_CODCLI
							AA3->AA3_LOJA   := ADB->ADB_LOJCLI
							AA3->AA3_CODPRO := ADB->ADB_CODPRO
							AA3->AA3_NUMSER := _cNumSer
							AA3->AA3_DTVEND := ddatabase
							AA3->AA3_DTGAR  := ddatabase
							AA3->AA3_STATUS := "03"
							AA3->AA3_HORDIA := 8   
							
							AA3->AA3_UNUCTR := ADB->ADB_NUMCTR //Numero do contrato que gerou a base de atendimento
							AA3->AA3_UITCTR := ADB->ADB_ITEM //Codigo do item do contrato que gerou a base de atendimento
							AA3->AA3_UIDAGA := ADB->ADB_UIDAGA	
							msunlock()
					ENDIF			
					dbselectarea("ADB")
					dbskip()
				enddo
		ENDIF
				
restarea(_area)
return 

User Function TEC02D(_nCtr)
Local _aADA := ADA->(getarea())
Local _cCli := ""
	dbselectarea("ADA")
	dbsetorder(1)
	DBGoTop() 
	if dbseek(xFilial()+ _nCtr)
			_cNomCli := Posicione("SA1",1,xFilial("SA1")+ADA->ADA_CODCLI+ADA->ADA_LOJCLI,"A1_NOME")   
			_cCli += "Cliente Antigo: " + _cNomCli + " Cod: " + ADA->ADA_CODCLI + " Loja: " + ADA->ADA_LOJCLI + " Contrato := " + ADA->ADA_NUMCTR
	endif
	
restarea(_aADA)			
return _cCli

//Adicionar MEMO de msg de reprovação de contrato
User Function Obs_Repro()
	Local lOk:=.f.
	Local oDlg
	Private oCombo
	 

	cCombo := "R" //- Variavel que receberá o conteúdo
	aItem := {"R=Restrição","E=Erro cadastro"} // array com os itens
		
	cTexto := ADA->ADA_UDSREP
	
	@ 116,001 To 476,1020 Dialog oDlgMemo Title "Mensagem de reprovação de Contrato"
	@ 05,10 say "Contrato : " + ADA->ADA_NUMCTR  of OdlgMemo Pixel
		
	@ 15, 10 SAY oSay2 PROMPT "Assunto: " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 15, 40 ComboBox oCombo Var cCombo Items aItem Size 085,09 Of oDlg Pixel 
	
	@ 32,10 Get cTexto Size 490,120 MEMO of OdlgMemo Pixel
	
	@ 155,200 Button "Salvar"         Size 35,14 Action FRSalva() of OdlgMemo Pixel
	@ 155,250 Button "Sair"          Size 35,14 Action Close(oDlgMemo) of OdlgMemo Pixel
	Activate Dialog oDlgMemo  
Return

User Function TEC02E(_nCtr)

	dbselectarea("ADA")
	dbsetorder(1)
	dbGoTop()

	_cProd := getmv("MV_UPDLKF") // Parâmetro para saber se o produto é LINK FULL
	
	if dbseek(xFilial() + _nCtr)
		while !eof .and. xFilial() + _nCtr == ADB->ADB_FILIAL + ADB->ADB_NUMCTR
			if (_cProd == .t.) // Se o produto for igual ao que está cadastrado no parâmetro
				_os := U_LIGTEC01(AA3->AA3_CODPRO,AA3->AA3_CODCLI,AA3->AA3_LOJA,ADA->ADA_CONDPG,_cOcoRet,_cSerTsf,1,0,AA3->AA3_NUMSER,_cMsgOS,_cAtAtiv,"9",_nCtr)	
			
				if !empty(_os) //GERAR SZ2 PARA FIM DE VINGENCIA NOS ITENS DO CONTRATO ANTIGO QUANDO FOR RETIRADO O EQUIPAMENTO
						dbselectarea("SZ2")
						reclock("SZ2",.t.)
						SZ2->Z2_FILIAL  := xFilial()
						//SZ2->Z2_NUMATEN := _naten
						SZ2->Z2_NUMCTR  := AA3->AA3_UNUCTR
						SZ2->Z2_ITEMCTR := AA3->AA3_UITCTR 
						SZ2->Z2_NUMOS   := _os
						SZ2->Z2_PRODUTO := AA3->AA3_CODPRO
						SZ2->Z2_ITEMOS  := "01"
						SZ2->Z2_ACAO    := "FINAL VIGENCIA"
						msunlock()
				else
						memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log","ERRO AO TENTAR INCLUIR UMA OS	DO CONTRATO "+ADB->ADB_NUMCTR+" NA ROTINA LIGTEC02")	
				endif
			endif
			
			dbselectarea("ADA")
			dbskip()
			
		enddo
	endif

return


Static Function FRSalva()
	IF valTexto()
		RECLOCK("ADA",.F.)
			ADA->ADA_ULIBER := "R"
			ADA->ADA_UFIREP := cCombo
			ADA->ADA_UDSREP := cTexto
		MSUNLOCK()
		
		msginfo("Mensagem gravada com sucesso")
		Close(oDlgMemo)
	endif
Return

static function valTexto()
	if len(alltrim(cTexto))>400
		msginfo("Texto muito grande. No maximo 400 caracteres.")
		return .f.
	endif
return .t.