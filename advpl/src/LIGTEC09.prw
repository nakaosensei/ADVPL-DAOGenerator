#Include 'Protheus.ch'
#include "totvs.ch"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"

/*
LIGTEC09  - Programa pra realizar a liberação dos equipamentos e ordem de serviço de ativação no yate automaticamente
Autor      - Robson Adriano baseado no codigo Daniel Govea (antigo LIGTEC02)
Data       - 15/10/14

*/
User Function LIGTEC09(_pCaixa,_pSplitter,_pPorta,_pMac,_pSerial)
Local aArea := GetArea()
	_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
	_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7891) //CONECTA AO POSTGRES
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
	
	_st := .T.
	_st := U_TEC09A(_pCaixa,_pSplitter,_pPorta,_pMac,_pSerial)
	TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
RestArea( aArea )
return _st

User Function TEC09A(_pCaixa,_pSplitter,_pPorta,_pMac,_pSerial)
Local _area := getarea()
Local _emails := getmv("MV_UEMLOSI") //Emails para envolvidos na Ordem de serviço de instalacao	
Local _Titulo := "Cliente liberado para Ativação"
_MSG := ""
RET := .T.
//Static oDlg

IF ADA->ADA_ULIBEQ=="S"
	msginfo("Contrato já está liberado.")
ELSE
		_cOcoIns := getmv("MV_UOCOINS")
		_cSerIns := getmv("MV_USERINS")
		_cOcoDes := getmv("MV_UOCODES")
		_cSerDes := getmv("MV_USERDES")
		                  	
		_aADA := ADA->(getarea())
		_aADB := ADB->(getarea())
		dbselectarea("ADB")
		dbsetorder(1)
		if dbseek(xFilial()+ADA->ADA_NUMCTR)
			_CLI  := "CLIENTE "+POSICIONE("SA1",1,XFILIAL("SA1")+ADB->ADB_CODCLI+ADB->ADB_LOJCLI,"A1_NOME")
			
			while !eof() .and. xFilial()+ADA->ADA_NUMCTR==ADB->ADB_FILIAL+ADB->ADB_NUMCTR		
				// VERIFICAR APENAS OS ADB QUE SÃO ITENS DO CONTRATO (EX: INTERNET,TELEFONE, ASSINATURA)
				_cItemCtr := POSICIONE( "SB1", 1, XFILIAL( "SB1" ) + ADB->ADB_CODPRO, "B1_UITCONT")
				IF (_cItemCtr = 'S')
					
					IF	ADB->ADB_ULIBEQ <> "S"	
						//vai começar a preparar as variaveis pra chamar a LIGTEC01
						_condi := ADA->ADA_CONDPG
						if empty(_condi)
							_condi := ALLTRIM(GETMV("MV_UCONCTR"))
						endif
						
					   //	IF RET
					  		U_TEC09E(_pCaixa,_pSplitter,_pPorta,_pMac,_pSerial)
					  //	ELSE
					  //		EXIT
					 //	ENDIF
					
					ENDIF
				ENDIF
				dbselectarea("ADB")
				dbskip()
			enddo
			
			IF !EMPTY(_MSG)
				dbselectarea("ADB")
				_MSG2 := "<p><b>Ordem de Serviço liberada para ativação do Cliente.</b></p>"
				_MSG2 += "<p>Codigo : <b>" + ADB->ADB_CODCLI + "</b> Loja: <b>" + ADB->ADB_LOJCLI + "</b> Nome :<b> " + _CLI + "</b></p>"
				_MSG2 += _MSG
				//ALERT(_MSG)
				U_LIGGEN03(_emails,"","",_Titulo,_MSG2,.T.,"")
			ENDIF	 
		endif
		
		restarea(_aADB)
		restarea(_aADA) 
ENDIF		 
restarea(_area)	


Return RET


Static Function TEC09B()
Local aItems:= {}
//TCSETCONN(_NCONNPTG) //RETORNA CONEXAO POSTGRES

DbSelectArea("TRB0")
while !eof() 
		//caixas := {TRB0->CD_CAIXA,TRB0->DS_CAIXA}
		AADD(aItems, CVALTOCHAR(TRB0->CD_CAIXA) + " : " + TRB0->DS_CAIXA)
	dbselectarea("TRB0")
	dbskip()
enddo
	
oCombo1:SetItems(aItems)
//TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
RETURN

Static Function TEC09C()
Local _cAtAtiv := getmv("MV_UATATIV") // COD ATENDENTE DE ATIVACAO		
_cNumSer := ""

			  //	IF AB6->AB6_UNUMCT != ALLTRIM(_CDTOTVS) .OR. !EMPTY(ALLTRIM(_CLIYATE))
					
			  //		MSGINFO("Essa porta já contém Cliente : " + ALLTRIM(_CLIYATE))
			  //		RETURN .F.
			  //	ENDIF	
				
		
					dbselectarea("SX6")
					dbsetorder(1)
					dbseek("    "+"MV_ATBSSEQ")
					_cNumSer := SOMA1(ALLTRIM(SX6->X6_CONTEUD))
					reclock("SX6",.f.)
					SX6->X6_CONTEUD := _cNumSer
					msunlock()
					_cNumSer := alltrim(GETMV("MV_ATBSPRF"))+_cNumSer
					
					dbselectarea("AA3")
					dbsetorder(1)
					if	!dbseek(xFilial("AA3")+ ADB->ADB_CODCLI+ ADB->ADB_LOJCLI+ ADB->ADB_CODPRO+_cNumSer)
						reclock("AA3",.t.)
							AA3->AA3_FILIAL := xFilial()
							AA3->AA3_CODCLI := ADB->ADB_CODCLI
							AA3->AA3_LOJA   := ADB->ADB_LOJCLI
							AA3->AA3_CODPRO := ADB->ADB_CODPRO
							AA3->AA3_NUMSER := _cNumSer
							AA3->AA3_UMAC   := UPPER(cGet1)
							AA3->AA3_CHAPA  := UPPER(cGet2)
							AA3->AA3_DTVEND := ddatabase
							AA3->AA3_DTGAR  := ddatabase
							AA3->AA3_STATUS := "03"
							AA3->AA3_HORDIA := 8   
							
							AA3->AA3_UCAIXA := cCombo1   
							AA3->AA3_USPLT :=  cCombo2   
							AA3->AA3_UPORTA := cCombo3   
							
							AA3->AA3_UNUCTR := ADB->ADB_NUMCTR //Numero do contrato que gerou a base de atendimento
							AA3->AA3_UITCTR := ADB->ADB_ITEM //Codigo do item do contrato que gerou a base de atendimento
						msunlock()
					endif
					
		dbselectarea("ADB")
		_os := U_LIGTEC01(ADB->ADB_CODPRO,ADB->ADB_CODCLI,ADB->ADB_LOJCLI,_condi,_cOcoIns,_cSerIns,ADB->ADB_QUANT,ADB->ADB_PRCVEN,_cNumSer,ADB->ADB_UMSG,_cAtAtiv,"3",ADA->ADA_NUMCTR)	
		if !empty(_os)
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
						
				
				_MSG += "<p>O.S : " + _os + " Produto : " + ADB->ADB_DESPRO + "</p>"
			msunlock()
			
			dbselectarea("ADB")	
			RECLOCK("ADB",.F.)
				ADB->ADB_ULIBEQ := "S"
				ADB->ADB_UDTLBE := date()
			MSUNLOCK()
		else									
			memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log","ERRO AO TENTAR INCLUIR UMA OS	DO CONTRATO "+ADB->ADB_NUMCTR+" NA ROTINA LIGTEC02")		
			ALERT("Não foi possivel criar a ordem de Serviço para o Item:  " + ADB->ADB_CODPRO + " : " + ADB->ADB_DESPRO)	   
		endif			
RETURN .T.

Static Function TEC09D()
IF EMPTY (ALLTRIM(cGet1))
	ALERT('Por favor informar um Mac')
	RETURN
ENDIF

IF EMPTY (ALLTRIM(cGet2))
	ALERT('Por favor informar um Serial')
	RETURN
ENDIF

/*
IF EMPTY (ALLTRIM(cCombo1))
	ALERT('Por favor informar uma Caixa')
	RETURN
ENDIF

IF EMPTY (ALLTRIM(cCombo2))
	ALERT('Por favor informar um Splitter')
	RETURN
ENDIF

IF EMPTY (ALLTRIM(cCombo3))
	ALERT('Por favor informar uma Porta')
	RETURN
ENDIF
*/

TEC09C()
oDlg:End()
RETURN

User Function TEC09E(_pCaixa,_pSplitter,_pPorta,_pMac,_pSerial)
Local _area := getarea()
Local aItems:=  {_pCaixa}
Local aSplliters:=  {_pSplitter} 
Local aPortas:=  {_pPorta} 
Local cMac :=  _pMac
Local cSerial :=  _pSerial

Private oDlg
						Private oButton1
						Private oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
						Private oGet1
						Private cGet1 := SPACE(20) //SERIAL, VAI GRAVAR NO AA3_NUMSER
						Private oGet2
						Private cGet2 := SPACE(20) //MAC, VAI GRAVAR NO AA3_CHAPA
						Private oSay1
						Private oSay2
						Private oSay3
						Private oSay4
						Private oSay5
						Private oSay6
						Private oSay7
						Private oSay8	
						Private oSay9
						
						IF !EMPTY(ALLTRIM(cMac))
							cGet1 := UPPER(cMac)
						ENDIF
							
						IF !EMPTY(ALLTRIM(cSerial))
							cGet2 := UPPER(cSerial)
						ENDIF
						
						/*IF !EMPTY(ALLTRIM(aItems))
							TEC09B()
						ENDIF*/
						_CDTOTVS := ""
						_CLIYATE := ""
						
						_PROD := "PRODUTO "+ALLTRIM(ADB->ADB_CODPRO)+" "+POSICIONE("SB1",1,XFILIAL("SB1")+ADB->ADB_CODPRO,"B1_DESC")
						
						  DEFINE MSDIALOG oDlg TITLE "INFORMAR O MAC" FROM 000, 000  TO 550,700 COLORS 0, 16777215 PIXEL
						    @ 008, 004 SAY oSay1 PROMPT "Favor informar o serial e o MAC:" SIZE 155, 014 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
						    @ 025, 007 SAY oSay2 PROMPT _PROD SIZE 130, 007 OF oDlg COLORS 0, 16777215 PIXEL
						    @ 040, 007 SAY oSay3 PROMPT _CLI SIZE 130, 007 OF oDlg COLORS 0, 16777215 PIXEL
						 //   @ 055, 007 SAY oSay4 PROMPT ADB->ADB_UMSG SIZE 200, 007 OF oDlg COLORS 0, 16777215 PIXEL
						    @ 070, 007 SAY oSay5 PROMPT "MAC" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
						    @ 085, 007 SAY oSay6 PROMPT "Serial" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
						    @ 105, 007 SAY oSay7 PROMPT "Caixas" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
							@ 125, 007 SAY oSay8 PROMPT "Splitter" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
						   	@ 145, 007 SAY oSay9 PROMPT "Portas" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
						    
						    @ 070, 040 MSGET oGet1 VAR cGet1 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL
						    @ 085, 040 MSGET oGet2 VAR cGet2 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL
						  
						 
								cCombo1:= aItems[1]    
			  				 	oCombo1 := TComboBox():New(105,040,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},; 
			   						 aItems,100,20,oDlg,,{||U_TEC14D(cCombo1,_NCONNPTG,_NCONNSQL)}; 
			   							,,,,.T.,,,,,,,,,'cCombo1') 
			   							
			 				  	cCombo2:= aSplliters[1]    
			  				  	oCombo2 := TComboBox():New(125,040,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},; 
			  						  aSplliters,100,20,oDlg,,{||U_TEC14E(cCombo2,_NCONNPTG,_NCONNSQL)}; 
			 						   ,,,,.T.,,,,,,,,,'cCombo2')
			 						   
			 				 	cCombo3:= aPortas[1]    
							 	oCombo3 := TComboBox():New(145,040,{|u|if(PCount()>0,cCombo3:=u,cCombo3)},; 
			  					  aPortas,100,20,oDlg,,; 
			   					  ,,,,.T.,,,,,,,,,'cCombo3')
		   	 
		@ 105,170 Button "Alterar CX"         Size 35,14 Action U_TEC14G(_NCONNPTG,_NCONNSQL) of oDlg Pixel
		@ 165, 220 BUTTON oButton1 PROMPT "OK" action TEC09D() SIZE 037, 012 OF oDlg PIXEL
						 
						 
	ACTIVATE MSDIALOG oDlg
RETURN

