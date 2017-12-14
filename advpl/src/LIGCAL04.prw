#Include "PROTHEUS.ch"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"
#include "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³LIGCAL04 ºAUTOR  ³ROBSON ADRIANO 		   ºDATA ³ 22/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ ROTINA PARA REALIZAR UM TRACER NOS ATENDIMENTO, TELEVENDAS º±±
±±º          ³ E CHAMADO TECNICO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ LIGUE                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   

User Function LIGCAL04()

Local _area := getarea()
	Local _aADE := ADE->(getarea())
	Local _aSUA := SUA->(getarea())
	Local _aAB1 := AB1->(getarea())
    Private _codAde := ADE->ADE_CODIGO
    Private _codCli := SUBSTR(ADE->ADE_CHAVE,1,9)
    Private _lojaCli := SUBSTR(ADE->ADE_CHAVE,10,3)
	Private _alias1 := "ADE"
	Private _alias2 := "SUA"
	Private _alias3 := "AB1"
	Private _contTe := 0
	Private _contCh := 0
	Private _codCh := ""
	Private _codTe := ""
	//PRIVATE _CPERG := "CAL02A"	

	Static oGet2
	Static cGet2
	Static oGet3
	Static cGet3 
	Static oGet4
	Static cGet4
	Static oGet5
	Static cGet5 
	Static oGet6
	Static cGet6 
	Static oGet7
	Static cGet7 
	Static oGet8
	Static cGet8 
	Static oGet9
	Static cGet9
	Static oGet10
	Static cGet10
	Static oSay1
	Static oSay2
	Static oSay3
	Static oSay4
	Static oSay5
	Static oSay6
	Static oSay7
	Static oSay8  
	Static oSay9  
	
	//Pergunte(_CPERG, .T.)

	DEFINE DIALOG oDlg TITLE "Tela de Tracker" FROM 000,000 TO 600,1100 PIXEL	    

	oTree := DbTree():New(0,0,300,553,oDlg,,,.T.) // Cria a Tree       

	DBSelectArea(_alias1)
	DBSetOrder(1)
	DBGOTOP()
	IF DBSEEK(XFilial(_alias1) + _codAde)
		// Insere itens    
		oTree:AddItem("Tele Atendimento","001", "FOLDER5" ,,,,1)    	
	ENDIF
	

	//VERIFICA SE TEM TELEVENDAS COM O CODIGO INFORMADO DO ATENDIMENTO
	
	IF oTree:TreeSeek("001")       
		oTree:AddItem("Tele Vendas","002", "FOLDER5",,,,2)	   
	ENDIF
	SuaTree()
	
	//FIM DO TRACKER DO TELEVENDAS
	
	//VERIFICA SE TEM CHAMADOS TECNICO COM O CODIGO INFORMADO DO ATENDIMENTO
	DBSelectArea(_alias3)
	DBSetOrder(6)
	DBGOTOP()
	IF DBSeek(XFilial(_alias3) + _codAde)
		IF oTree:TreeSeek("001")       
			oTree:AddItem("Chamados Técnicos","003", "FOLDER5",,,,2)	 
		ENDIF		
			  
		WHILE !EOF() .AND. AB1->AB1_FILIAL + AB1->AB1_UATEND == xFilial(_alias3) + _codAde // PEGER APENAS OS CHAMADOS TECNICOS QUE SAO DO CODIGO INFORMADO
			
			IF oTree:TreeSeek("003")    
				_contCh ++     
				_codCh := "C" + strzero(_contCh,2) 
				oTree:AddItem(AB1->AB1_NRCHAM, _codCh , "FOLDER10",,,,2)	       
			ENDIF  
			  
			DBSKIP()
		END
	ENDIF
    //FIM DO TRACKER DO CHAMADOS TECNICO

	// Retorna ao primeiro nível 
	oTree:TreeSeek("001") 

	// Cria botões com métodos básicos   
	
	TButton():New( 285,400,"Dados do item", oDlg,{|| TreeDetail()},		 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	TButton():New( 285,445,"Copiar Tele Vendas", oDlg,{|| COPIA()},		 60,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	TButton():New( 285,510,"Ajustar Vendas", oDlg,{|| ALTERARSUA()},		 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 

 	// Indica o término da contrução da Tree   
 	oTree:EndTree() 
 
 	ACTIVATE DIALOG oDlg CENTERED 

	// RESTAURAR O PONTEIRO
	restarea(_aADE)
	restarea(_aSUA)
	restarea(_aAB1)
	
	restarea(_area)
Return

STATIC FUNCTION COPIA()
Local _codAdeAnt  := ""

//COMPARA SE O OTREE SELECIONADO E UM TELE VENDAS
		IF AT("T", oTree:GetCargo())  > 0
				DBSELECTAREA("SUA")
				DBSETORDER(1)//"SUA"_FILIAL+ UA_NUM
				IF DBSEEK(xFilial() + oTree:GetPrompt(.T.)) //POSICIONAR PONTEIRO NO SUA DO TREE SELECIONADO
					
					IF EMPTY(ALLTRIM(SUA->UA_UATEND))// SUA FORAM REPLICADOS DO ADA, POR ISSO ANTIGOS NAO TEM UATEND
						RECLOCK("SUA",.F.)
							SUA->UA_UATEND :=	_codAde
						MSUNLOCK()
					ELSE
						_codAdeAnt := SUA->UA_UATEND
					ENDIF    
					
					_ch := TK271COPIA("SUA",SUA->(RECNO()),6)
							
					IF !_ch 
						_aSUA1 := SUA->(getarea())
				
						DBSelectArea(_alias2)
						DBSetOrder(13)
						DBGOTOP()
						IF DBSEEK(XFilial("SUA") + oTree:GetPrompt(.T.)) 
							WHILE !EOF() .AND. SUA->UA_FILIAL + SUA->UA_UCCANT == XFilial("SUA") + oTree:GetPrompt(.T.)
								IF SUA->UA_UATEND = _codAdeAnt .AND.  SUA->UA_UCCANT = oTree:GetPrompt(.T.)
									RECLOCK("SUA",.F.)
										SUA->UA_UATEND :=	_codAde
									MSUNLOCK() 
								ENDIF
							DBSKIP()
							END
						ENDIF 
					
						restarea(_aSUA1)     
						
						delSuaTree()
						SuaTree()
		 				MSGINFO("Tele Vendas foi copiado com Sucesso !.")
		 			ELSE
		 				ALERT("Não foi possivel realizar copia !")	
		 			ENDIF
				ENDIF
		ELSE
		     ALERT("NAO PODE COPIAR POIS NAO ESTA VINCULADO A UM TELEVENDAS.")
		ENDIF

RETURN

STATIC FUNCTION ALTERARSUA()
Local _area := getarea()
Local _aSUA := SUA->(getarea())

	IF AT("T", oTree:GetCargo())  > 0
		DBSELECTAREA("SUA")
		DBSETORDER(1)//"SUA"_FILIAL+ UA_NUM
		IF DBSEEK(xFilial() + oTree:GetPrompt(.T.)) //POSICIONAR PONTEIRO NO SUA DO TREE SELECIONADO
			IF SUA->UA_OPER != "1"	
				BEGIN TRANSACTION
				mafisini(SUA->UA_CLIENTE,SUA->UA_LOJA,"C","N")
		
				dbselectarea("SUB")
				dbselectarea("SUA")
				TK271CallCenter("SUA",SUA->(RECNO()),4)
		
				END TRANSACTION 
				
				delSuaTree()
				SuaTree()        
				

			ELSE
				ALERT("TELE VENDAS SELECIONADO É DE FATURAMENTO, POR ISSO NÃO PODE SER AJUSTADO.")
			ENDIF
		ENDIF  
	ELSE
		 ALERT("NAO PODE COPIAR POIS NAO ESTA VINCULADO A UM TELEVENDAS.")
	ENDIF	
	
restarea(_aSUA)	
restarea(_area)
RETURN

return               

Static Function TreeDetail()  
		
		//Compara se o oTree selecionado e um Chamado Tecnico
		IF AT("C", oTree:GetCargo()) > 0	
				dbselectarea("AB1")
				dbsetorder(1)//AB1_FILIAL+AB1_NRCHAM
				IF dbseek(xFilial() + oTree:GetPrompt(.T.)) //POSICIONAR PONTEIRO NO AB1 DO TREE SELECIONADO
					cGet2 :=AB1->AB1_NRCHAM
					cGet3 := AB1->AB1_EMISSA
					cGet4 := AB1->AB1_CODCLI
					cGet5 := AB1->AB1_LOJA
					cGet6 := Posicione("SA1",1,xFilial("SA1")+AB1->AB1_CODCLI+AB1->AB1_LOJA,"A1_NOME")
					cGet7 := AB1->AB1_HORA
					cGet8 := AB1->AB1_CONTAT
					cGet9 := AB1->AB1_TEL
					cGet10 := AB1->AB1_ATEND
					
					DEFINE MSDIALOG oDlg1 TITLE "Detalhes do chamado" FROM 000, 000  TO 600, 1100 COLORS 0, 16777215 PIXEL	  
					  @ 010, 002 SAY oSay1 PROMPT "Chamado" SIZE 028, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
					  @ 010, 079 SAY oSay2 PROMPT "Emissão" SIZE 021, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
					  @ 010, 150 SAY oSay3 PROMPT "Cliente" SIZE 019, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
					  @ 010, 028 MSGET oGet2 VAR cGet2 SIZE 047, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 104 MSGET oGet3 VAR cGet3 SIZE 039, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 170 MSGET oGet4 VAR cGet4 SIZE 033, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 210 MSGET oGet5 VAR cGet5 SIZE 011, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 236 MSGET oGet6 VAR cGet6 SIZE 110, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 025, 002 SAY oSay5 PROMPT "Hora" SIZE 021, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
					  @ 025, 027 MSGET oGet7 VAR cGet7 SIZE 029, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 025, 068 SAY oSay6 PROMPT "Contato" SIZE 020, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
					  @ 025, 097 MSGET oGet8 VAR cGet8 SIZE 080, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 025, 190 SAY oSay7 PROMPT "Telefone" SIZE 023, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
					  @ 025, 220 MSGET oGet9 VAR cGet9 SIZE 073, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
			    	  fMSNewGetDadosChamado(oTree:GetPrompt(.T.))
			    	  @ 185, 004 SAY oSay8 PROMPT "Técnico:" SIZE 025, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
		              @ 185, 033 MSGET oGet10 VAR cGet10 SIZE 082, 010 OF oDlg1 WHEN .F. COLORS 0, 16777215 PIXEL
			  		ACTIVATE MSDIALOG oDlg1 CENTERED 
				ENDIF
		ENDIF
		
		//COMPARA SE O OTREE SELECIONADO E UM TELE VENDAS
		IF AT("T", oTree:GetCargo())  > 0
				DBSELECTAREA("SUA")
				DBSETORDER(1)//"SUA"_FILIAL+ UA_NUM
				IF DBSEEK(xFilial() + oTree:GetPrompt(.T.)) //POSICIONAR PONTEIRO NO SUA DO TREE SELECIONADO
					cGet2 := SUA->UA_NUM
					cGet3 := SUA->UA_CLIENTE
					cGet4 := SUA->UA_LOJA
					cGet5 := Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME")
					cGet6 := SUA->UA_CONDPG
					cGet7 := SUA->UA_VALMERC
					cGet8 := SUA->UA_EMISSAO
					cGet9 := Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_NOME")
				    cGet10 := Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")
				
					
					DEFINE MSDIALOG oDlg2 TITLE "Detalhes do Tele vendas" FROM 000, 000  TO 600, 1100 COLORS 0, 16777215 PIXEL	  
					  @ 010, 002 SAY oSay1 PROMPT "Tele Vendas" SIZE 028, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
					  @ 010, 079 SAY oSay2 PROMPT "Cliente" SIZE 021, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
					  @ 010, 028 MSGET oGet2 VAR cGet2 SIZE 047, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 100 MSGET oGet3 VAR cGet3 SIZE 039, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 140 MSGET oGet4 VAR cGet4 SIZE 033, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
					  @ 010, 174 MSGET oGet5 VAR cGet5 SIZE 110, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
					  
					  @ 010, 287 SAY oSay3 PROMPT "Cond. Pgto" SIZE 031, 010 OF oDlg2 COLORS 0, 16777215 PIXEL
					  @ 010, 318 MSGET oGet6 VAR cGet6 SIZE 11, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
					  
					  @ 010, 342 SAY oSay4 PROMPT "Valor Total" SIZE 030, 010 OF oDlg2 COLORS 0, 16777215 PIXEL
					  @ 010, 373 MSGET oGet7 VAR cGet7 SIZE 080, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
					  
					  @ 025, 002 SAY oSay5 PROMPT "Emissao" SIZE 021, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
					  @ 025, 027 MSGET oGet8 VAR cGet8 SIZE 029, 007 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL

			    	  itensSub(oTree:GetPrompt(.T.)) //FUNCAO PARA MONTAR TABELA COM OS ITENS DO TELE VENDAS
			    	  @ 185, 004 SAY oSay6 PROMPT "Operador :" SIZE 025, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		              @ 185, 033 MSGET oGet9 VAR cGet9 SIZE 082, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
			    	  @ 185, 144 SAY oSay7 PROMPT "Vendedor :" SIZE 025, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		              @ 185, 173 MSGET oGet10 VAR cGet10 SIZE 082, 010 OF oDlg2 WHEN .F. COLORS 0, 16777215 PIXEL
			  		ACTIVATE MSDIALOG oDlg2 CENTERED 
				ENDIF			
		ENDIF
	
//	Alert("Cargo: " + oTree:GetCargo() + chr(13) + "Texto: " + oTree:GetPrompt(.T.)) 
Return

//Function para montar os dados dos Itens do Chamado Tecnico(AB2)
Static Function fMSNewGetDadosChamado(_pNRCHAM)

Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"AB2_ITEM","AB2_TIPO","AB2_CLASSI","AB2_CODPRO","B1_DESC","AB2_NUMSER","AB2_CODPRB","AAG_DESCRI","AB2_MEMO2"}
Local aAlterFields := {"AB2_MEMO2"}
Local oMSNewGetDados1
Local aHeaderEx := getHeader(aFields)

dbselectarea("AB2")
dbsetorder(1)
if dbseek(xFilial() + _pNRCHAM)
	while !eof() .and. xFilial()+_pNRCHAM == AB2->AB2_FILIAL+AB2->AB2_NRCHAM
		aadd(aColsEx,{AB2->AB2_ITEM,AB2->AB2_TIPO,AB2->AB2_CLASSI,AB2->AB2_CODPRO,POSICIONE("SB1",1,XFILIAL("SB1")+AB2->AB2_CODPRO,"B1_DESC"),AB2->AB2_NUMSER,AB2->AB2_CODPRB,Posicione( "AAG", 1, xFilial( "AAG" ) + AB2->AB2_CODPRB, "AAG_DESCRI"),MSMM(AB2->AB2_MEMO),.F.})
		dbselectarea("AB2")
		dbskip()
	enddo
endif	

oMSNewGetDados1 := MsNewGetDados():New( 045, 001, 175, 549, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg1, aHeaderEx, aColsEx)

Return oMSNewGetDados1

//Function para montar os dados dos Itens do Tele vendas(SUB)
Static Function itensSub(_pNRCHAM)

Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"UB_ITEM","UB_PRODUTO","B1_DESC","UB_QUANT","UB_VRUNIT","UB_VLRITEM","UB_TES","UB_UM","UB_DTENTRE","UB_UCTR","UB_UITTROC","UB_UMSG"}
Local oMSNewGetDados2
Local aHeaderEx := getHeader(aFields)

dbselectarea("SUB")
dbsetorder(1)
if dbseek(xFilial() + _pNRCHAM)
	while !eof() .and. xFilial()+_pNRCHAM == SUB->UB_FILIAL+SUB->UB_NUM
		aadd(aColsEx,{SUB->UB_ITEM,SUB->UB_PRODUTO,POSICIONE("SB1",1,XFILIAL("SB1")+SUB->UB_PRODUTO,"B1_DESC"),SUB->UB_QUANT,SUB->UB_VRUNIT,SUB->UB_VLRITEM,SUB->UB_TES,SUB->UB_UM,SUB->UB_DTENTRE,SUB->UB_UCTR,SUB->UB_UITTROC,SUB->UB_UMSG,.F.})
		dbselectarea("SUB")
		dbskip()
	enddo
endif	

oMSNewGetDados2 := MsNewGetDados():New( 045, 001, 175, 549, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2",,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg2, aHeaderEx, aColsEx)

Return oMSNewGetDados2

Static Function getHeader(_pFields)
Local nX
Local aHeaderEx := {}

DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(_pFields)
    If SX3->(DbSeek(_pFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  	  Endif
Next nX

return aHeaderEx



Static Function SuaTree()
Local _area := getarea() 
Local _aSUA := SUA->(getarea())
	
	_contTe := 0
	//VERIFICA SE TEM TELEVENDAS COM O CODIGO INFORMADO DO ATENDIMENTO
	DBSelectArea(_alias2)
	DBSetOrder(6)
	DBGOTOP()
	IF DBSEEK(XFilial(_alias2) + _codCli + _lojaCli) //Alterado 22/09/2014 Consultar todos os SUA do Cliente
		// PEGAR APENAS OS TELEVENDAS QUE SAO DO CODIGO INFORMADO
		WHILE !EOF() .AND. SUA->UA_FILIAL + SUA->UA_CLIENTE + SUA->UA_LOJA == xFilial(_alias2) + _codCli + _lojaCli //Alterado 22/09/2014 Verificar todos os SUA do Cliente
			_contTe ++     
			_codTe := "T" + strzero(_contTe,2) 
							
			IF oTree:TreeSeek("002")
				IF SUA->UA_OPER == "1"	
					oTree:AddItem(SUA->UA_NUM , _codTe, "FOLDER10",,,,2) 
				ELSE
					oTree:AddItem(SUA->UA_NUM , _codTe, "FOLDER7",,,,2)	     
				ENDIF          
								
			ENDIF    
							
 			DBSKIP()
		END
	ENDIF		
			
	
	DBSetOrder(12)
	DBGOTOP()
	IF DBSEEK(XFilial(_alias2) + _codAde)
		// PEGAR APENAS OS TELEVENDAS QUE SAO DO CODIGO INFORMADO
		WHILE !EOF() .AND. SUA->UA_FILIAL + SUA->UA_UATEND == xFilial(_alias2) + _codAde 
		
			IF  SUA->UA_CLIENTE + SUA->UA_LOJA != _codCli + _lojaCli
				_contTe ++     
				_codTe := "T" + strzero(_contTe,2) 
								
				IF oTree:TreeSeek("002")
					IF SUA->UA_OPER == "1"	
						oTree:AddItem(SUA->UA_NUM , _codTe, "FOLDER10",,,,2)	       
					ELSE
						oTree:AddItem(SUA->UA_NUM , _codTe, "FOLDER7",,,,2)	     
					ENDIF          
									
				ENDIF    
			ENDIF   				
 			DBSKIP()
		END
	ENDIF		
			
//FIM DO TRACKER DO TELEVENDAS
restarea(_aSUA)	
restarea(_area)
RETURN

Static Function delSuaTree()
	//Apagar Tree de Televendas
	FOR nCont := _contTe TO 1 STEP -1    
			_codTe := "T" + strzero(nCont,2)       				 
         	oTree:TreeSeek(_codTe)
         	oTree:DelItem()
         				
         	// MSGALERT( _codTe )
	NEXT nCont 
RETURN
