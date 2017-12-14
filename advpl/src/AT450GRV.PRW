#include "protheus.ch"
#include "topconn.ch"

/*
PONTO DE ENTRADA NA FINALIZAÇÃO DA O.S.
*/
User Function AT450GRV()
	Local _area := getarea()
	Local _aAB7 := AB7->(getarea())
	Local _cCodAda
	Local _cSituBoas := getmv("MV_UBOASV") //Situacao do boas vindas
	Local uNkOS := AB6->AB6_NUMOS //Num OS
	Local uNkItem := "" //Item da OS
	Local uNkCodTec := AB6->AB6_UCODAT //Codigo do atendente da OS
	Local unkCabEM := "" //String para exibir ra mensagem de erro de strOut com o cabecalho no comeco
	Local unkErrorMsg := "" //String para armazenar mensagem de erro
	
	CONOUT("ENTROU AT450GRV "+TIME())
	dbselectarea("AB7")
	dbsetorder(1)
	dbseek(xFilial()+AB6->AB6_NUMOS)
	while !eof() .AND. xFilial("AB6")+AB6->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
		uNkItem := AB7->AB7_ITEM
		IF AB7->AB7_TIPO=='5' //ENCERRADO
			dbselectarea("SZ2")
			dbsetorder(2)//Z2_FILIAL+Z2_NUMOS+Z2_PRODUTO+Z2_ITEMOS
			if dbseek(xFilial()+AB7->AB7_NUMOS+AB7->AB7_CODPRO+AB7->AB7_ITEM)
				if SZ2->Z2_EXECUTA!="S"
					if ALLTRIM(SZ2->Z2_ACAO)=="INICIO VIGENCIA"
						_cCodAda := SZ2->Z2_NUMCTR
						//INICIO - CASSIUS - 13/08/14 - REGRA PARA VALORES PARCELADOS DE O.S. CONFORMTE TELEVENDAS
						DBSELECTAREA("ADA")
						DBSETORDER(1)
						DBSEEK(XFILIAL()+SZ2->Z2_NUMCTR)
						DBSELECTAREA("ADB")
						DBSETORDER(1)
						IF DBSEEK(XFILIAL()+SZ2->Z2_NUMCTR+SZ2->Z2_ITEMCTR)
							IF EMPTY(ADB->ADB_UNUMAT)
								RECLOCK("ADB",.F.)
								//IF EMPTY(AB6->AB6_UDTVIG) //COMENTADO POR DANIEL EM 20/12/16
								IF EMPTY(AB7->AB7_UDTVIG)
									ADB->ADB_UDTINI := DDATABASE
									MSUNLOCK()
									//AB6->AB6_UDTVIG  := DDATABASE //COMENTADO POR DANIEL EM 20/12/16
									RECLOCK("AB7",.F.)
									AB7->AB7_UDTVIG  := DDATABASE
									MSUNLOCK()
								ELSE
									ADB->ADB_UDTINI := AB7->AB7_UDTVIG //ALTERADO POR DANIEL, DE AB6 PRA AB7
								ENDIF
								DBSELECTAREA("SZ2")
								RECLOCK("SZ2",.F.)
								SZ2->Z2_EXECUTA := "S"
								MSUNLOCK()
							ELSE
								DBSELECTAREA("SB1")
								DBSETORDER(1)
								DBSEEK(XFILIAL("SB1")+ADB->ADB_CODPRO)
								//IF EMPTY(AB6->AB6_UDTVIG)//COMENTADO POR DANIEL EM 20/12/16
								IF EMPTY(AB7->AB7_UDTVIG)
									_DDTEXEC := DDATABASE
									RECLOCK("AB7",.F.)
									AB7->AB7_UDTVIG := DDATABASE
									MSUNLOCK()
									//AB6->AB6_UDTVIG  := DDATABASE //COMENTADO POR DANIEL EM 20/12/16
								ELSE
									_DDTEXEC := AB7->AB7_UDTVIG //ALTERADO POR DANIEL, DE AB6 PRA AB7
								ENDIF

								//LEVAR EM CONSIDERACAO DT DE INICIO QUANDO FOR ITEM DE NAO CONTRATO, EX: SERVICO DE INSTALACAO
								IF SB1->B1_UITCONT =="N"
									IF DAY(_DDTEXEC)<=(ADA->ADA_UDIAFE)
										_DDTEXEC := STOD(ANOMES(MONTHSUB(_DDTEXEC,1))+ALLTRIM(STR(ADA->ADA_UDIAFE+1)))
									ELSE
										_DDTEXEC := STOD(ANOMES(_DDTEXEC)+ALLTRIM(STR(ADA->ADA_UDIAFE+1)))
									ENDIF
								ENDIF

								_DINIVIG := MONTHSUM(_DDTEXEC,ADB->ADB_UMESIN)
								_DFIMVIG := STOD("")
								_NQTPARC := ADB->ADB_UMESCO
								_NUNIT   := 0
								_NTOTAL	 := 0
								IF ADB->ADB_UMESCO!=0
									_DFIMVIG := MONTHSUM(_DINIVIG,ADB->ADB_UMESCO)
									_CQUERY := " SELECT ABA.*, AA5.AA5_TES, AA5.AA5_PRCCLI "
									_CQUERY += " FROM "+RETSQLNAME("ABA")+" ABA "
									_CQUERY += " INNER JOIN "+RETSQLNAME("AB6")+" AB6 ON AB6.AB6_FILIAL=ABA.ABA_FILIAL AND AB6.AB6_NUMOS=SUBSTRING(ABA.ABA_NUMOS,1,6) AND AB6.AB6_STATUS<>'A' AND AB6.D_E_L_E_T_=' ' "
									_CQUERY += " INNER JOIN "+RETSQLNAME("AB9")+" AB9 ON ABA.ABA_FILIAL=AB9.AB9_FILIAL AND AB9.AB9_NUMOS=ABA.ABA_NUMOS "
									_CQUERY += " INNER JOIN "+RETSQLNAME("AA5")+" AA5 ON ABA.ABA_CODSER=AA5.AA5_CODSER AND AA5.AA5_PRCCLI>0 AND AA5.D_E_L_E_T_=' ' "
									_CQUERY += " WHERE AB9.D_E_L_E_T_=' ' "
									_CQUERY += " AND SUBSTRING(ABA.ABA_NUMOS,1,6) = '"+SZ2->Z2_NUMOS+"' "
									_CQUERY += " AND ABA.ABA_UTOTAL > 0 "
									_CQUERY += " AND ABA.D_E_L_E_T_ = ' ' "
									_CQUERY += " ORDER BY ABA.ABA_FILIAL, ABA.ABA_NUMOS "
									_CQUERY := CHANGEQUERY(_CQUERY)
									IF SELECT("TRAB8")!=0
										TRAB8->(DBCLOSEAREA())
									ENDIF
									TCQUERY _CQUERY NEW ALIAS "TRAB8"
									DBSELECTAREA("TRAB8")
									DBGOTOP()
									WHILE !EOF()
										_NUNIT  += ROUND((TRAB8->ABA_UTOTAL*TRAB8->AA5_PRCCLI)/100,2) //SOMENTE PERCENTUAL FATURADO PARA O CLIENTE - AA5_PRCCLI
										DBSKIP()
									ENDDO
									_NTOTAL  := _NUNIT*ADB->ADB_QUANT
									TRAB8->(DBCLOSEAREA())
								ENDIF

								//INICIO CODIGO ROBSON 29092014
								//PEGAR NUMERO DE COBRANDO QUANDO PRODUTO FOR DO TIPO 0101 QUE É TELEFONE
								_cCodGrup := getmv("MV_UGRNCOB") // Parametro para pegar Grupo do Produto que precisa do numerod e cobrança

								IF (SB1->B1_GRUPO == _cCodGrup)
									dbselectarea("ADA")
									dbsetorder(1)
									IF dbseek(xFilial("ADA")+ _cCodAda)
										IF !EMPTY(ADA->ADA_UNRCOB)
											IF msgyesno("Contrato já contém numero de cobrança : " + ADA->ADA_UNRCOB + "! Tem certeza que deseja trocar o numero ?")
												AT450B()
											ENDIF
										ELSE
											AT450B()
										ENDIF
									ENDIF
								ENDIF
								
								//FIM CODIGO NUMERO DE COBRANÇA
								//PEGAR CODIGO DO YATE QUANDO CAMPO NO CTR TIVER VAZIO
								IF SB1->B1_UITCONT =="S"
									dbselectarea("ADA")
									dbsetorder(1)
									IF dbseek(xFilial("ADA")+ _cCodAda)
										IF EMPTY(ADA->ADA_UIDYAT)
											//CHAMAR ROTINA PARA PEGAR CODIGO DO YATE
											AT450D()
										ENDIF
									ENDIF
								ENDIF
								//FIM CODIGO DO YATE

								DBSELECTAREA("ADB")
								RECLOCK("ADB",.F.)
								bAdb := .T.
								IF (!EMPTY(ADB->ADB_UDTINI))
									bAdb := msgyesno("Item já contém inicio de Vigencia : " + DTOC(ADB->ADB_UDTINI) + " ! Deseja sobrescrever essa data?")
								ENDIF

								IF bAdb
									ADB->ADB_UDTINI := _DINIVIG
									ADB->ADB_UDTFIM	:= _DFIMVIG
								ENDIF

								IF _NUNIT>0 //SE NAO HOUVE APONTAMENTO DE PRODUTOS QUE JUSTIFIQUE A ALTERACAO DO VALOR MANTEM O QUE ESTA NO CONTRATO.
									ADB->ADB_PRCVEN := _NUNIT
									ADB->ADB_TOTAL  := _NTOTAL
								ENDIF
								MSUNLOCK()

								//VERIFICAR O.S ENCERRADAS POR SITUACAO
								AT450E(AB6->AB6_USITU1)

								DBSELECTAREA("SZ2")
								RECLOCK("SZ2",.F.)
								SZ2->Z2_EXECUTA := "S"
								MSUNLOCK()

								IF ADB->ADB_CODPRO$GETMV("MV_UADMCTR")
									U_AT450F()
								ENDIF
							ENDIF
						ENDIF
						//FIM CASSIUS - 13/08/14

					elseif ALLTRIM(SZ2->Z2_ACAO)=="FINAL VIGENCIA"
						IF EMPTY(AB6->AB6_UDTVIG)
							AB6->AB6_UDTVIG  := DDATABASE
						ENDIF

						//	_areaAB9 := AB9->(GETAREA())
						//	dbselectarea("AB9")
						//	dbsetorder(1)//AB9_FILIAL+AB9_NUMOS+AB9_CODTEC+AB9_SEQ
						//	if dbseek(xFilial()+AB7->AB7_NUMOS+AB7->AB7_ITEM)
						DBSELECTAREA("ADB")
						DBSETORDER(1) //ADB_FILIAL+ADB_NUMCTR+ADB_ITEM
						IF DBSEEK(XFILIAL()+SZ2->Z2_NUMCTR+SZ2->Z2_ITEMCTR)
							RECLOCK("ADB",.F.)
							IF EMPTY(ADB->ADB_UDTFIM)
								ADB->ADB_UDTFIM := AB6->AB6_UDTVIG
							ENDIF
							MSUNLOCK()
							DBSELECTAREA("SZ2")
							RECLOCK("SZ2",.F.)
							SZ2->Z2_EXECUTA := "S"
							MSUNLOCK()
						ENDIF
						//	endif
						//	restarea(_areaAB9)
					endif
				endif
			endif
			//INICIO GERACAO MOVIMENTO INTERNO
			if(ALLTRIM(AB7->AB7_UBAIXA)<> "S")//Se o item da OS ainda nao foi baixado			
				BEGIN TRANSACTION
					_aABC := ABC->(getarea())
					dbselectarea("ABC")
					dbsetorder(1)//ABC_FILIAL+ABC_NUMOS+ABC_CODTEC+ABC_SEQ+ABC_ITEM				
					/*
					O dbSeek a seguir pode parecer estranho, mas eu o irei explicar.
					Perceba que o campo ABC_NUMOS e composto pelo numero da OS de 6 caracteres mais os dois
					ultimos caracteres que sao referentes ao item daquela OS, no dbSeek o uNkItem nao vai
					filtrar por ABC_CODTEC+ABC_SEQ, mas sim pelo item da OS em ABC.	
					Tendo selecionado o item em questão na busca do laco de repeticao(Que percorre os itens)			
					*/
					if dbseek(xFilial("AB6")+uNkOS+uNkItem)
						_aCab := {}
						_aItem := {}
						uNkProblems := {} //Array usado para validacao
						_atotitem:={}
						lMsErroAuto := .f.
						lMsHelpAuto := .f.
						_aCab := { {"D3_TM" ,"509" , NIL},{"D3_EMISSAO" ,ddatabase, NIL}}
						while !eof() .and. xFilial("AB6")+uNkOS+uNkItem==ABC->ABC_FILIAL+ABC->ABC_NUMOS
							dbselectarea("SB1")
							dbsetorder(1)
							if dbseek(xFilial()+ABC->ABC_CODPRO)
								_local := ""
								if empty(ABC->ABC_UARMAZ)
									_local := SB1->B1_LOCPAD
								else
									_local := ABC->ABC_UARMAZ
								endif
								_aItem:={ {"D3_COD" ,SB1->B1_COD ,NIL},{"D3_UM" ,SB1->B1_UM ,NIL},{"D3_QUANT" ,ABC->ABC_QUANT ,NIL},{"D3_LOCAL" ,_local ,NIL}}
								aAdd(_atotitem,_aitem)
							endif
							dbselectarea("ABC")
							dbskip()						
						enddo
						
						if len(_aCab)>0 .and. len(_atotitem)>0
							lMsErroAuto := .F.
							_auxMod := nModulo
							nModulo := 4											
							for nki:=1 to len(_atotitem)
								CONOUT("COD:"+_atotitem[nki][1][2]+" ARMAZEM:"+_atotitem[nki][4][2]+" QUANTIDADE:"+CVALTOCHAR(_atotitem[nki][3][2]))
								cAliasSB2 := GetNextAlias()
								cQuery := "SELECT B2_QATU FROM "+RetSqlName("SB2")+" SB2 WHERE SB2.B2_FILIAL='LG01' AND SB2.B2_COD='" +ALLTRIM(_atotitem[nki][1][2])+"' AND SB2.B2_LOCAL='"+ALLTRIM(_atotitem[nki][4][2])+"' AND SB2.D_E_L_E_T_<>'*'"								
								cQuery := ChangeQuery(cQuery)	 
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB2,.T.,.T.)
								nkQtEstoque := (cAliasSB2)->B2_QATU //Quantidade em estoque do armazem do produto em quatao
								CONOUT(cQuery)
								CONOUT(nkQtEstoque)							
								if nkQtEstoque = nil .OR. nkQtEstoque < _atotitem[nki][3][2]						
									aAdd(uNkProblems, {POSICIONE("SB1",1,xFilial("SB1")+_atotitem[nki][1][2],"B1_DESC")+"("+_atotitem[nki][1][2]+")",_atotitem[nki][4][2]})
								endif				
							next
							
							if len(uNkProblems)>0							
								for nki := 1 to len(uNkProblems)
									unkErrorMsg := unkErrorMsg + u_barraN("PRODUTO:"+ALLTRIM(uNkProblems[nki][1])+"  ARMAZEM:"+ALLTRIM(uNkProblems[nki][2]))
								next													
							else								
								dbselectarea("SD3")
								MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab,_atotitem,3)
								nModulo := _auxMod							
								If lMsErroAuto
									CONOUT(Mostraerro())
									Mostraerro()
									DisarmTransaction()
									break
								else
									DBSELECTAREA("AB7")
									RECLOCK("AB7",.F.)
									AB7->AB7_UBAIXA := "S"
									AB7->AB7_UDTBAX := DATE()
									MSUNLOCK()
								endif
							endif						
						endif
					endif
					restarea(_aABC)
				END TRANSACTION
			endif
		ENDIF//FINAL IF TIPO "E" ENCERRADO
		dbselectarea("AB7")
		dbskip()
	enddo
	//Se haviam produtos sem estoque o suficiente, a string unkErrorMsg nao sera vazia
	if ALLTRIM(unkErrorMsg)<>""		
		unkCabEM := u_barraN("EXISTEM PRODUTOS QUE NAO ESTAO DISPONIVEIS NO ESTOQUE, LOGO A O.S NAO PODE SER ENCERRADA, SEGUEM OS PRODUTOS QUE FALTARAM NO ESTOQUE:")
		unkCabEM := unkCabEM + unkErrorMsg
		MsgAlert(unkCabEM)
	endif
	U_AssuntoOS()	
	u_AT450I()//Funcao que faz envio de email ao cliente dependendo da situacao da ordem de servico
	restarea(_aAB7)
	restarea(_area)
return

user function AssuntoOS()
	Local _area := getarea()
	Local _aAB6 := AB6->(getarea())
	Local _aAB7 := AB7->(getarea())
	Local _cAssunOS := getmv("MV_UASSUNT") //Cod do assunto de retirada de equipamento
	Local _cOcorD := getmv("MV_UOCOGEO") //Cod da ocorrencia padrao quando transf endereco
	Local _cAssunTE := getmv("MV_UASTE") //Cod do assunto de transferencia de endereco
	Local _codAtd := getmv("MV_TEATD") //Cod do atendente responsavel por verificar a mudança de um endereço
	Local itens := {}
	Local _situ1 := AB6->AB6_USITU1
	Local _nCtr := AB6->AB6_UNUMCT
	IF _situ1 == _cAssunTE // Se o assunto for transferencia de endereço
		if u_AT450G()
			itens := u_TEC08B(_cOcorD,AB6->AB6_NUMOS)
			u_LIGTEC07(AB6->AB6_CODCLI,AB6->AB6_LOJA,AB6->AB6_CONPAG,"MANUTENÇÃO GEOGRIDS",itens,_codAtd,"0",AB6->AB6_UNUMCT)
			MSGINFO("Ordem de serviço criada com sucesso! Uma nova OS informando a transferência de endereço foi gerada para o atendente "+_codAtd)
		endif
	ENDIF

	IF _situ1 == _cAssunOS  //Verifica se o assunto é retirada de equipamento
		if u_AT450G()
			_cOcoMC := getmv("MV_UOCOMC") // Cod. assunto padrão
			_cAtMC := getmv("MV_UATEMC") // Cod. Atendente para Caixa
			aItens := U_LIGTEC08(AB6->AB6_CODCLI,AB6->AB6_LOJA,_cOcoMC,_nCtr)
			//Funcao que monta o cabecalho(AB6) da O.S e usa TECA450 para gerar chamados
			//1	Cliente		2 Loja 		  3	Cond Pgto		4 msg	5 itens, 6 ATENDE, 7 ASSUNTO, 8 CTR
			_os := U_LIGTEC07(AB6->AB6_CODCLI, AB6->AB6_LOJA,AB6->AB6_CONPAG,"RETIRADA DE CLIENTE DA CAIXA",aItens,_cAtMC,"2",_nCtr)
			MSGINFO("Ordem de serviço criada com sucesso!")
		else
			MSGALERT("Não foi possível criar uma nova Ordem de Serviço. Todos os itens devem ter a 'Situação' como 'Encerrada'.","Não foi possível criar nova O.S")
		endif
	endif

	restarea(_aAB7)
	restarea(_aAB6)
	restarea(_area)

return

STATIC FUNCTION AT450A() //DIALOG PARA PEGAR NUMERO DE COBRANÇA
	Private oDlg
	Private oButton1
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
	Private oGet1
	Private cGet1 := SPACE(20) //SERIAL, VAI GRAVAR NO AA3_NUMSER
	Private oSay1

	DEFINE MSDIALOG oDlg TITLE "INFORMAR O NUMERO DE COBRANÇA" FROM 000, 000  TO 190, 400 COLORS 0, 16777215 PIXEL
	@ 008, 004 SAY oSay1 PROMPT "Favor informar o numero de cobrança do plano:" SIZE 185, 014 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 024, 005 MSGET oGet1 VAR cGet1 SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 151 BUTTON oButton1 PROMPT "OK" action oDlg:End() SIZE 037, 012 OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg
RETURN cGet1

STATIC FUNCTION AT450B() //GRAVAR ADA
	_cNumCob := AT450A()
	WHILE EMPTY(ALLTRIM(_cNumCob)) .OR. LEN(ALLTRIM(cValToChar(_cNumCob))) < 10
		_cNumCob := AT450A()
	ENDDO
	reclock("ADA",.F.)
	ADA->ADA_UNRCOB := _cNumCob
	msunlock()
RETURN

STATIC FUNCTION AT450C() //DIALOG PARA PEGAR CODIGO DO YATE
	Private oDlg
	Private oButton1
	Private oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
	Private oGet1
	Private cGet1 := SPACE(20)
	Private oSay1

	DEFINE MSDIALOG oDlg TITLE "INFORMAR O CODIGO DO YATE" FROM 000, 000  TO 190, 400 COLORS 0, 16777215 PIXEL
	@ 008, 004 SAY oSay1 PROMPT "Favor informar o código de cadastro no YATE:" SIZE 185, 014 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 024, 005 MSGET oGet1 VAR cGet1 SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 151 BUTTON oButton1 PROMPT "OK" action oDlg:End() SIZE 037, 012 OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg
RETURN cGet1

STATIC FUNCTION AT450D() //GRAVAR ADA

	_cNumYate := AT450C()
	WHILE EMPTY(ALLTRIM(_cNumYate))
		_cNumYate := AT450C()
	ENDDO

	reclock("ADA",.F.)
	ADA->ADA_UIDYAT := _cNumYate
	msunlock()

RETURN

STATIC FUNCTION AT450E(_cSitu) //VALIDAR SE TEM MAIS O.S DE ACORDO COM SITUACAO PASSADA
	Local _area := getarea()
	Local _aAB6 := AB6->(getarea())
	Local _aAB7 := AB7->(getarea())
	Local _cSituAti := getmv("MV_UASUATI") //Cod situacao Ativacao
	Local _cSituIst := getmv("MV_UASUIST") //Cod situacao Instalacao
	Local _nCtr := AB6->AB6_UNUMCT
	Local _emails := ""
	Local _MSG := ""
	Local _Titulo := ""
	Local _lBoas := .T.
	Local _emailBoas := getmv("MV_UEMLOSB")
	Local _ocoBoas := getmv("MV_UOCOBOA")
	Local _atendBoas := getmv("MV_UATBOAS")
	Local _msgIFemptyOS := "NÃO FOI POSSIVEL CRIAR A ORDEM DE BOAS VINDAS"
	Local _msgIFerro := "ERRO AO TENTAR INCLUIR UMA OS DE BOAS VINDAS "
	Local _msgIFNovaOS := "<p>Nova Ordem de Serviço criada para Primeira Visita</p>"
	Local _msgIFContatoAgendamento := "<p>Favor entrar em contato para agendamento da visita.</p>"
	Local _titulo_IF := "Primeira visita"
	Local _emailGeoGrid := getmv("MV_UEMLGEO")
	Local _ocoGeoGrids := getmv("MV_UOCOGEO")
	Local _atendGeoGrids := getmv("MV_UATGEO")
	Local _msgEmptyOS_ELSE := "NÃO FOI POSSIVEL CRIAR A ORDEM DE CADASTRO DE CLIENTES NO GEOGRIDS"
	Local _msgERRO_ELSE := "ERRO AO TENTAR INCLUIR UMA OS DE CADASTRO DE CLIENTES NO GEOGRIDS "
	Local _msgNovaOS_ELSE := "<p>Nova Ordem de Serviço criada para Cadastro de Clientes no GeoGrids</p>"
	Local _msgContatoAgendamento_ELSE := "<p></p>"
	Local _titulo_ELSE := "Cadastro de Clientes no GeoGrids"
	//códigos dos assuntos das O.S
	Local _assuntoManut := "2"
	Local _assuntoBoasVindas := "7"
	Private _msgIFLIGTEC07 := 'OS DE BOAS VINDAS'
	Private _msgLIGTEC07_ELSE := 'CADASTRO DE CLIENTES NO GEOGRIDS'

	dbselectarea("AB6")
	dbsetorder(7)//Z2_FILIAL+AB6_UNUMCT
	if dbseek(xFilial()+_nCtr)
		while !eof() .AND. xFilial()+_nCtr==AB6->AB6_FILIAL+AB6->AB6_UNUMCT
			IF  AB6->AB6_USITU1 == "7"
				_lBoas := .F.
			ENDIF
			dbselectarea("AB6")
			dbskip()
		enddo
	ENDIF
	restarea(_aAB6)
	//Se todos os itens OS estao encerrados E
	//Se nenhuma ordem deste contrato e de boas vindas E
	//A ordem e de instalacao ou manutencao, entao gere uma ordem de boas vindas e uma do geogrids para o responsavel no dtpo de redes	 		
	if u_AT450G() .AND. _lBoas .AND. (AB6->AB6_USITU1 == _cSituAti .OR. AB6->AB6_USITU1 == _cSituIst)
		u_AT450H(_emailBoas, _ocoBoas, _atendBoas, _msgIFLIGTEC07,_msgIFemptyOS, _msgIFerro, _msgIFNovaOS, _msgIFContatoAgendamento, _titulo_IF, _assuntoBoasVindas)
		u_AT450H(_emailGeoGrid, _ocoGeoGrids, _atendGeoGrids, _msgLIGTEC07_ELSE, _msgEmptyOS_ELSE, _msgERRO_ELSE, _msgNovaOS_ELSE, _msgContatoAgendamento_ELSE, _titulo_ELSE, _assuntoManut)
	endif
	//ENDIF
	IF _cSituIst = _cSitu
		/* 
		_emails := getmv("MV_UEMLOSI") //Emails para envolvidos na Ordem de serviço de instalacao
		_Titulo := "O.S Instalação"
		_MSG := "<p>Nova Ordem de Serviço criada para Primeira Visita.</p>"
		_cCaixa := ""
		_cSplitter := ""
		_cPorta := ""
		_cMac := ""
		_cSerial := ""

		_aAA3 := AA3->(getarea())
		DbSelectArea("AA3")
		DbSetOrder(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
		if dbseek(xFilial()+AB6->AB6_CODCLID+AB6->AB6_LOJA+AB7->AB7_CODPRO+AB7->AB7_NUMSER)
		_cCaixa := AA3->AA3_UCAIXA
		_cSplitter := AA3->AA3_USPLT
		_cPorta := AA3->AA3_UPORTA
		_cMac := AA3->AA3_UMAC
		_cSerial := AA3->AA3_CHAPA
		endif
		restarea(_aAA3)

		_aADA := ADA->(getarea())
		dbselectarea("ADA")
		dbsetorder(1)
		IF dbseek(xFilial("ADA")+ _nCtr)
		U_LIGTEC09(_cCaixa,_cSplitter,_cPorta,_cMac,_cSerial)
		ENDIF
		restarea(_aADA)
		*/
	ENDIF
	restarea(_area)
RETURN

User Function AT450F()
	Local _emails := getmv("MV_UEMLOSI") //Emails para envolvidos na Ordem de serviço de instalacao
	Local _MSG := "<p>Nova Ordem de Serviço criada para Primeira Visita.</p>"
	Local _Titulo := "O.S Instalação"
	_MSG += "<p>Num OS: <b>" + AB6->AB6_NUMOS + "</b></p>"
	_MSG += "<p>Código : " + AB6->AB6_CODCLI + " Nome : " + SA1->A1_NOME + "</p>"
	_MSG += "<p>Endereço : " + SA1->A1_END + ", Bairro : " + SA1->A1_BAIRRO + ", Cidade : " + SA1->A1_MUN + "</p>"
	_MSG += "<p>Telefone : (" + SA1->A1_DDD + ")" + SA1->A1_TEL + ", Cel : " + SA1->A1_CEL + "</p>"
	_MSG += "<p>Favor entrar em contato para agendamento da visita.</p>"
	U_LIGGEN03(_emails,"","",_Titulo,_MSG,.T.,"")
RETURN

//Verifica se todos os itens da OS estao encerrados, se algum nao estiver encerrado, retorna .f.
//Requisitos: AB6 deve estar posicionado
user function AT450G()
	Local _area := getarea()
	Local _aAB7 := AB7->(getarea())
	dbselectarea("AB7")
	dbsetorder(1)
	dbseek(xFilial()+AB6->AB6_NUMOS)
	while !eof() .AND. xFilial()+AB6->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
		IF AB7->AB7_TIPO!='5' //ENCERRADO
			return .f.
		endif
		dbselectarea("AB7")
		dbskip()
	enddo
	restarea(_aAB7)
return  .t.

//Gera Ordem de Servico e tambem faz o envio de email
user function AT450H(_email, _ocorrencia, _atendente, _msgLIGTEC07, _msgEmptyOS, _msgERRO, _msgNovaOS, _msgContatoAgendamento, _titulo, _paramAssunto)
	Local _area := getarea()
	Local _aAB6 := AB6->(getarea())
	Local _aADA := ADA->(getarea())
	Local _aSA1 := SA1->(getarea())
	Local _nCtr := AB6->AB6_UNUMCT
	Local _emails := _email
	Local _cOcoBoas := _ocorrencia
	Local _cAtboas := _atendente
	Local _MSG := ""
	Local _Titulo := ""

	aItens := U_LIGTEC08(AB6->AB6_CODCLI,AB6->AB6_LOJA,_cOcoBoas,_nCtr)
	//Funcao que monta o cabecalho(AB6) da O.S e usa TECA450 para gerar chamados
	//1	Cliente		2 Loja 		  3	Cond Pgto		4 msg	5 itens, 6 ATENDE, 7 ASSUNTO, 8 CTR
	_os := U_LIGTEC07(AB6->AB6_CODCLI, AB6->AB6_LOJA,AB6->AB6_CONPAG,_msgLIGTEC07,aItens,_cAtboas,_paramAssunto,_nCtr)

	if empty(_os) //GERAR SZ2 PARA FIM DE VINGENCIA NOS ITENS DO CONTRATO ANTIGO QUANDO FOR RETIRADO O EQUIPAMENTO
		MsgInfo(_msgEmptyOS  + AB6->AB6_CODCLI," Msg Info ")
		memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log",_msgERRO+ADB->ADB_NUMCTR+" NA ROTINA AT450GRV")
	else
		if(_paramAssunto=="7")//Se a ordem gerada e de boas vindas
			DBSELECTAREA("AB6")
			if dbSeek(xFilial("AB6")+_os)
				CONOUT(_os)
				CONOUT(AB6->AB6_NUMOS)
				CONOUT(AB6->AB6_USITU1)
				u_AT450I()
			endif			
		else
			dbselectarea("SA1")
			dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
			if dbseek(xFilial("SA1")+AB6->AB6_CODCLI+AB6->AB6_LOJA)
				_MSG := _msgNovaOS
				_MSG += "<p>Num OS: <b>" + AB6->AB6_NUMOS + "</b></p>"
				_MSG += "<p>Código : " + AB6->AB6_CODCLI + " Nome : "  + SA1->A1_NOME + "</p>"
				_MSG += "<p>Endereço : " + SA1->A1_END + ", Bairro : " + SA1->A1_BAIRRO + ", Cidade : " + SA1->A1_MUN + "</p>"
				_MSG += "<p>Telefone : (" + SA1->A1_DDD + ")" + SA1->A1_TEL + ", Cel : " + SA1->A1_CEL + "</p>"
				_MSG += _msgContatoAgendamento
				_Titulo := _titulo	
				U_LIGGEN03(_emails,"","",_Titulo,_MSG,.T.,"")
			endif		
		endif
	endif
	restarea(_area)
	restarea(_aADA)
	restarea(_aAB6)
	restarea(_aSA1)
return

//Essa funcao faz o envio de email aos clientes em duas possiveis situacoes
//1) A ordem e de boas vindas e todos os itens da OS estao em aberto
//2) Todos os itens da ordem foram marcados como encerrados, e a ordem nao e de boas vindas, viabilidade, tsf endereco nem retirada equipamento
user function AT450I()
	Local _aAB6 := AB6->(getarea())
	Local os   := ""
	Local nome := ""
	Local atdt := ""
	Local dsOcor:= ""	
	Local msg := ""
	Local nkEmail :=""
	Local envEmail := ALLTRIM(AB6->AB6_UENVEM) //Enviou email?
	Local situ := ALLTRIM(AB6->AB6_USITU1)
	Local flagEncerrado := 1
	Local flagAberta := 1
	Local cAliasAB6 := ""
	Local cQuery := ""
	
	cAliasAB6 := GetNextAlias()
	cQuery := "SELECT AB6_NUMOS,AB6_ATEND,AB6_USITU1,A1_COD,A1_NOME,A1_EMAIL,AB7_ITEM,AB7_TIPO,AB7_CODPRO,AAG_DESCRI,AB6_UENVEM FROM "+RetSqlName("AB6")+" AB6  INNER JOIN "+RetSqlName("SA1")+ " SA1 ON AB6_CODCLI=A1_COD AND AB6_LOJA=A1_LOJA	INNER JOIN "+RetSqlName("AB7")+" AB7 ON AB6_NUMOS=AB7_NUMOS LEFT JOIN "+RetSqlName("AAG")+" AAG ON AAG.AAG_CODPRB = AB7.AB7_CODPRB  WHERE AB6_NUMOS='"+AB6->AB6_NUMOS+"'"
	cQuery := ChangeQuery(cQuery)	 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAB6,.T.,.T.)
	nkemail := ALLTRIM((cAliasAB6)->A1_EMAIL)	
	os := ALLTRIM((cAliasAB6)->AB6_NUMOS)
	nome := ALLTRIM((cAliasAB6)->A1_NOME)
	atdt := ALLTRIM((cAliasAB6)->AB6_ATEND)
	//Se a ordem ja tiver enviado email ou
	//Se a ordem for de viabilidade, transferencia de endereco ou retirada de equipamento
	//O email nao e enviado para o cliente e a funcao morre aqui
	if(situ=="6" .OR. situ=="8" .OR. situ=="9" .OR. envEmail=="S")
		return .F.
	endif	
	situ := if(situ == "0", "padrão", situ)
	situ := if(situ == "1", "de instalação", situ)
	situ := if(situ == "2", "de manutenção", situ)
	situ := if(situ == "3", "de ativação", situ)
	situ := if(situ == "4", "de suporte", situ)
	situ := if(situ == "5", "de ampliação", situ)
	//situ := if(situ == "6", "de viabilidade", situ)
	situ := if(situ == "7", "de boas vindas", situ)
	//situ := if(situ == "8", "de transferência de endereço", situ)
	//situ := if(situ == "9", "de retirada de equipamento", situ)
	if(situ=="de boas vindas")//Se a ordem e de boas vindas, use o modelo 1 de mensagem
		msg :=  "<p style='color:black;'>Primeiramente, agradecemos por confiar em nossos serviços e nos escolher como sua operadora. É um imenso orgulho para nós tê-lo como nosso cliente.  Esperamos que nossa parceria seja proveitosa e duradoura.</p>"
		msg += "<p style='color:black;'>Gostariamos de lhe informar que a Ordem de Serviço de número "+os+", referente ao assunto "+situ+" foi atendida por "+atdt+". Seguem os produtos contratados e/ou ativados:</p>"
	else
		msg += "<p style='color:black;'>Gostariamos de lhe informar que a Ordem de Serviço de número "+os+", referente ao assunto "+situ+" foi atendida por "+atdt+". Seguem os produtos e/ou procedimentos envolvidos:</p>"
	endif		
	WHILE !EOF()									
		tipo := ALLTRIM((cAliasAB6)->AB7_TIPO)					
		produto := ALLTRIM((cAliasAB6)->AB7_CODPRO)		
		dsOcor := ALLTRIM((cAliasAB6)->AAG_DESCRI)		
		desPro := POSICIONE("SB1", 1, xFilial("SB1") + produto, "B1_DESC")		
		if(tipo<>"5")//Se o item nao estiver encerrado, a flag recebe 0, indicando que um item da OS nao esta encerrado														
			flagEncerrado := 0													
		endif
		if(tipo<>"1")//Se o item nao estiver em aberto, a flag recebe 0, indicando que um item da OS nao esta em aberto
			flagAberta := 0
		endif										
		msg := msg + "<br><br>" + desPro+"("+produto+") / OCORRÊNCIA: "+dsOcor
		DBSKIP()
	ENDDO
	//Se a ordem e de boas vindas e todos os itens estao em aberto OU
	//a ordem esta encerrada e a ordem nao e de boas vindas
	if((situ=="de boas vindas" .and. flagAberta = 1) .OR. (flagEncerrado=1 .and. situ<>"de boas vindas"))
		u_nkMailCli(msg,nome,nkemail,"Ordem de Serviço atendida - Ligue Telecomunicações - "+DTOC(DATE()))//Funcao padrao de envio de email para clientes, na LIGNNKUT.prw
		RECLOCK("AB6",.F.)
		AB6->AB6_UENVEM :="S"
		MSUNLOCK()								
	endif	
	restarea(_aAB6)
return .T.
