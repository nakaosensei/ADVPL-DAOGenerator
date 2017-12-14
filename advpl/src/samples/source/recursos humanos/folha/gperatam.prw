#INCLUDE "PROTHEUS.CH"

#DEFINE GPRATAMARQ  "GPRATAM" //Nome do Arquivo de Trabalho que armazenara os valores de desconto dos dependentes rateado

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa    �GPERatAM  �Autor  �Alberto Deviciente  � Data � 18/Nov/2010 ���
���������������������������������������������������������������������������͹��
���Desc.       � Esta rotina efetua o rateio de desconto de Assistencia     ���
���            � Medica da base historica existente antes da melhoria do    ���
���            � Plano Assistencia Medica / Odontologica.                   ���
���            � Apos gerar o reteio sera possivel tambem efetuar manutencao���
���            � dos valores gerados no rateio.                             ���
���������������������������������������������������������������������������͹��
���Uso         � SIGAGPE                                                    ���
���������������������������������������������������������������������������ͼ��
���            ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.            ���
���������������������������������������������������������������������������͹��
���Programador � Data   � FNC         �  Motivo da Alteracao                ���
���������������������������������������������������������������������������͹��
���Alessandro  �10/03/11�00005878/2011�Ajuste para nao permitir manutencao  ���
���Santos      �        �			  �em valores zerados do Rateio de Assis���
���            �        �			  �tencia Medica - GPRtAMVl.            ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
User Function GPERATAM()
Local oMainWnd, oBtnRateio, oBtnManut, oBtnSair, oGrp1
Local cMsg 	:= ""

Private aIndexsArq := {}

cMsg := OemToAnsi("Esta rotina tem como objetivo gerar o Rateio de desconto de Assist�ncia M�dica ")
cMsg += OemToAnsi("de Dependentes que foram processados pelo antigo c�lculo.")
cMsg += OemToAnsi(Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Ap�s a gera��o, ser� poss�vel tamb�m realizar ajustes nos valores rateados.")
cMsg += OemToAnsi(Chr(13)+Chr(10)+Chr(13)+Chr(10)+"Escolha o que deseja executar agora.")

oMainWnd := MSDIALOG():Create()
oMainWnd:cName := "oMainWnd"
oMainWnd:cCaption := "Rateio de Desconto de Assist�ncia M�dica"
oMainWnd:nLeft := 0
oMainWnd:nTop := 0
oMainWnd:nWidth := 540
oMainWnd:nHeight := 250
oMainWnd:lShowHint := .F.
oMainWnd:lCentered := .T.

oGrp1 := TGROUP():Create(oMainWnd)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := ""
oGrp1:nLeft := 08
oGrp1:nTop := 08
oGrp1:nWidth := 520
oGrp1:nHeight := 150
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

TSay():New( 10/*<nRow>*/, 10/*<nCol>*/, {|| cMsg }	/*<{cText}>*/, oMainWnd/*[<oWnd>]*/, /*[<cPict>]*/, /*<oFont>*/, /*<.lCenter.>*/, /*<.lRight.>*/, /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 250/*<nWidth>*/, 100/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oBtnRateio := TButton():Create(oMainWnd)
oBtnRateio:cName := "oBtnRateio"
oBtnRateio:cCaption := "Gerar Rateio"
oBtnRateio:nLeft := 08
oBtnRateio:nTop  := 180
oBtnRateio:nHeight := 22
oBtnRateio:nWidth := 120
oBtnRateio:lShowHint := .F.
oBtnRateio:lReadOnly := .F.
oBtnRateio:Align := 0
oBtnRateio:bAction := {|| oMainWnd:End(), GPEProcRat() } 

oBtnManut := TButton():Create(oMainWnd)
oBtnManut:cName := "oBtnManut"
oBtnManut:cCaption := "Manuten��o Rateio"
oBtnManut:nLeft := 210
oBtnManut:nTop  := 180
oBtnManut:nHeight := 22
oBtnManut:nWidth := 120
oBtnManut:lShowHint := .F.
oBtnManut:lReadOnly := .F.
oBtnManut:Align := 0
oBtnManut:bAction := {|| oMainWnd:End(), GPEManRat() } 

oBtnSair := TButton():Create(oMainWnd)
oBtnSair:cName := "oBtnSair"
oBtnSair:cCaption := "Sair"
oBtnSair:nLeft := 408
oBtnSair:nTop  := 180
oBtnSair:nHeight := 22
oBtnSair:nWidth := 120
oBtnSair:lShowHint := .F.
oBtnSair:lReadOnly := .F.
oBtnSair:Align := 0
oBtnSair:bAction := {|| oMainWnd:End() } 

oMainWnd:Activate()

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEProcRat�Autor  �Alberto Deviciente  � Data � 18/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa o rateio de desconto de Assistencia Medica da base ���
���          �Historica existente antes da melhoria do Plano Assistencia  ���
���          �Medica / Odontologica.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPEProcRat()
Local cCadastro   	:= ""
Local nOpca 		:= 	0
Local aSays			:=	{}
Local aButtons		:= 	{}
Local aRegs	   		:= 	{}
Local cPerg			:= 	"GPERATAMED"

cCadastro := OemToAnsi("Processamento - Rateio de Desconto de Assist�ncia M�dica")

//+--------------------------------------------------+
//� mv_par01  - Filial De                            �
//� mv_par02  - Filial Ate                           �
//� mv_par03  - Matricula De                         �
//� mv_par04  - Matricula Ate                        �
//� mv_par05  - Centro de Custo De                   �
//� mv_par06  - Centro de Custo Ate                  �  
//� mv_par07  - Categorias                           �  
//� mv_par08  - Situacoes                            �  
//� mv_par09  - Data Pagamento De                    �  
//� mv_par10  - Data Pagamento Ate                   �  
//+--------------------------------------------------+
/*�������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
�           Grupo  Ordem Pergunta Portugues   Pergunta Espanhol       Pergunta Ingles         Variavel 	Tipo  Tamanho Decimal Presel  GSC   Valid                 Var01     	 Def01      DefSPA1      DefEng1      Cnt01          					  Var02  Def02    DefSpa2  DefEng2	Cnt02  Var03 Def03  DefSpa3 DefEng3 Cnt03  Var04  Def04  DefSpa4    DefEng4  Cnt04 		 Var05  Def05  DefSpa5 DefEng5   Cnt05  	XF3  GrgSxg   cPyme   aHelpPor  aHelpEng	 aHelpSpa    cHelp      �
���������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������*/
aAdd(aRegs,{cPerg,"01","Filial De          ?","�De Sucursal       ?","From Branch        ?","mv_ch1","C",02,0,0,"G","Naovazio"		,"mv_par01",""				,"","","01","","","","","","","","","","","","","","","","","","","","","SM0","" })
aAdd(aRegs,{cPerg,"02","Filial At�         ?","�A  Sucursal       ?","To Branch          ?","mv_ch2","C",02,0,0,"G","Naovazio"		,"mv_par02",""				,"","","99","","","","","","","","","","","","","","","","","","","","","SM0","" })
aAdd(aRegs,{cPerg,"03","Matricula De       ?","�De Matricula      ?","From Registration  ?","mv_ch3","C",06,0,0,"G","Naovazio"		,"mv_par03",""				,"","","000000","","","","","","","","","","","","","","","","","","","","","SRA","" })
aAdd(aRegs,{cPerg,"04","Matricula At�      ?","�A  Matricula      ?","To Registration    ?","mv_ch4","C",06,0,0,"G","Naovazio"		,"mv_par04",""				,"","","999999","","","","","","","","","","","","","","","","","","","","","SRA","" })
aAdd(aRegs,{cPerg,"05","Centro de Custo De ?","�De Centro de Costo?","From Cost Center   ?","mv_ch5","C",09,0,0,"G","Naovazio"		,"mv_par05",""				,"","","000000000","","","","","","","","","","","","","","","","","","","","","SI3","" })
aAdd(aRegs,{cPerg,"06","Centro de Custo At�?","�A  Centro de Costo?","To   Cost Center   ?","mv_ch6","C",09,0,0,"G","Naovazio"		,"mv_par06",""				,"","","999999999","","","","","","","","","","","","","","","","","","","","","SI3","" })
aAdd(aRegs,{cPerg,"07","Categorias         ?","�Categorias        ?","Categories         ?","mv_ch7","C",15,0,0,"G","fCategoria"	,"mv_par07",""				,"","","ACDEGHIJMPST","","","","","","","","","","","","","","","","","","","","","","","","","","",".RHCATEG." })
aAdd(aRegs,{cPerg,"08","Situacoes          ?","+Situaciones       ?","Status             ?","mv_ch8","C",05,0,0,"G","fSituacao"  	,"mv_par08",""				,"",""," ADFT","","","","","","","","","","","","","","","","","","","","","","","","","","",".RHSITUA." })
aAdd(aRegs,{cPerg,"09","Data Pagamento De  ?","+De Fecha Pago     ?","From Payment Date  ?","mv_ch9","D",08,0,0,"G","Naovazio"  	,"mv_par09",""				,"","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"10","Data Pagamento Ate ?","+A Fecha Pago      ?","To Payment Date    ?","mv_cha","D",08,0,0,"G","Naovazio"  	,"mv_par10",""				,"","","","","","","","","","","","","","","","","","","","","","","","","" })

ValidPerg(aRegs,cPerg,.F.)

Pergunte(cPerg,.F.)

AADD(aSays,OemToAnsi("Processamento para gera��o de Rateio de desconto de Assist�ncia  ") )
AADD(aSays,OemToAnsi("M�dica de Dependentes.") )

AADD(aButtons, { 5,.T.,{|| If(Pergunte(cPerg,.T. ), GPVldPerg(cPerg), Nil) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	//Valida a data inicial e final informadas no pergunte.
	if GPVldPerg(cPerg)
		Processa( {|lEnd| GPERtAMRun(@lEnd)}, "Processando...", "Aguarde...", .T.) 
	endif
Endif

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPERtAMRun�Autor  �Alberto Deviciente  � Data � 18/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa o processamento.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPERtAMRun(lCancel)
Local cHrIniProc:= dToc(ddatabase) + " - " + Time()
Local cHrFimProc
Local aCampos 	:= {}
Local aArqTRB 	:= {}
Local cAliasArq := GPRATAMARQ+cEmpAnt
Local cNomArq 	:= ""
Local aStruSRA  := {}
Local cQuery   	:= ""
Local nCount  	:= 0
Local nX        := 0
Local cInCatFunc:= ""
Local cInSituac := ""
Local lContinua := .T.
Local cIdVerAM  := "049" //Identificador de Calculo de Assistencia Medica do Funcionario (Titular)
Local cVerbaAM  := ""
Local cFilSRD   := if(empty(xFilial("SRD")),'"'+xFilial("SRD")+'"',"(cAliasSRA)->RA_FILIAL")
Local cFilSRV   := if(empty(xFilial("SRV")),'"'+xFilial("SRV")+'"',"(cAliasSRA)->RA_FILIAL")
Local cFilAux   := ""
Local aAssMedTp1:= {}
Local aAssMedTp2:= {}
Local nPlanAM   := 0
Local cChaveSRD := ""
Local aDados	:= {}
Local nTotDesLan:= 0
Local cFilialDe := if(empty(xFilial("SRA")),xFilial("SRA"),MV_PAR01)
Local cFilialAte:= if(empty(xFilial("SRA")),xFilial("SRA"),MV_PAR02)
Local dDtPgto   
Local cAnoProc  := ""
Local cMesProc  := ""
Local cMesProIni:= StrZero(Month(MV_PAR09),2)
Local cMesProFim:= StrZero(Month(MV_PAR10),2)
Local cAnoProIni:= Alltrim(str(Year(MV_PAR09)))
Local cAnoProFim:= Alltrim(str(Year(MV_PAR10)))
Local dDtPgtoAux:= ""

Private cAliasSRA := "SRA"
Private aLogErro  := {}

if cMesProIni == "01"
	cMesProIni := "12"
	cAnoProIni := alltrim(str(Val(cAnoProIni)-1))
else
	cMesProIni := StrZero(Val(cMesProIni)-1,2)
endif


cNomArq := cAliasArq+GetDBExtension()
cNomArq := RetArq(__LocalDriver,cNomArq,.T.)

if GetNewPar("MV_ASSIMED","1") <> "2"
	MsgStop("Para executar este processamento, o par�metro MV_ASSIMED deve estar configurado para o novo modelo de c�lculo.")
	Return
endif

if !(SRB->( FieldPos("RB_TPDEPAM") ) > 0)
	MsgStop("Para executar este processamento, a melhoria de Assist�ncia M�dica deve ser implantada.")
	Return
endif

//---------------------------------------------
//Cria o Arquivo ou apenas Abre  caso ja exista
//---------------------------------------------
If !GPECriaArq(cNomArq,cAliasArq,.F.)
	Return
Endif

//Indice 1 do Arquivo (FILIAL + MATFUNC + ANO + MES + CODDEP)
IndRegua(aIndexsArq[1][1],aIndexsArq[1][2],aIndexsArq[1][3],,,"Indexando Arquivo de Trabalho...")

dbSelectArea("SRV")
SRV->( dbSetOrder(2) ) //RV_FILIAL+RV_CODFOL

dbSelectArea("SRD")
SRD->( dbSetOrder(1) ) //RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC

dbSelectArea("SRA")
SRA->( dbSetOrder(1) )

//Busca a Verba de Desconto de Assistencia Medica do Funcionario (Titular) com Identificador "049"
While SRV->(!EOF())
	If SRV->RV_CODFOL == cIdVerAM
		If Empty(cVerbaAM)
			cVerbaAM := "'" + SRV->RV_COD + "'"
		Else
			cVerbaAM += ",'" + SRV->RV_COD + "'"
		EndIf
	EndIf
	SRV->(dbSkip())
End

#IFDEF TOP
	
	nX := 1
	while nX <= len(MV_PAR07)
		if SubStr(MV_PAR07,nX,1) <> "*"
			cInCatFunc += "'"+SubStr(MV_PAR07,nX,1)+"',"
		endif
		nX++
	end
	if empty(cInCatFunc)
		cInCatFunc := "'*',"
	endif
	cInCatFunc := SubStr(cInCatFunc,1,len(cInCatFunc)-1)
	
	nX := 1
	while nX <= len(MV_PAR08)
		if SubStr(MV_PAR08,nX,1) <> "*"
			cInSituac += "'"+SubStr(MV_PAR08,nX,1)+"',"
		endif
		nX++
	end
	if empty(cInSituac)
		cInSituac := "'*',"
	endif
	cInSituac := SubStr(cInSituac,1,len(cInSituac)-1)
	
	cAliasSRA := "GPEFILSRA"
	
	cQuery := "SELECT DISTINCT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CC, SRA.RA_NOME, SRA.RA_CIC, "
	cQuery += " SRA.RA_SITFOLH, SRA.RA_ASMEDIC, SRA.RA_CATFUNC "
	cQuery += "  FROM " + RetSQLName("SRA") + " SRA, "
	cQuery += "       " + RetSQLName("SRD") + " SRD  "
	cQuery += " WHERE RA_FILIAL >= '"+cFilialDe+"' AND RA_FILIAL <= '"+cFilialAte+"'"
	cQuery += "   AND RA_MAT    >= '"+MV_PAR03+"' AND RA_MAT    <= '"+MV_PAR04+"'"
	cQuery += "   AND RA_FILIAL = RD_FILIAL"
	cQuery += "   AND RA_MAT    = RD_MAT"
	cQuery += "   AND RD_DATPGT >= '"+dToS(MV_PAR09)+"' AND RD_DATPGT <= '"+dToS(MV_PAR10)+"'"
	If !Empty(cVerbaAM)
		cQuery += "   AND RD_PD IN ("+cVerbaAM+")" // Filtra de acordo com a verba a ser verificada.
	Else
		cQuery += "   AND RD_PD = ' ' "
	EndIf
	cQuery += "   AND RA_ASMEDIC <> ' '"
	cQuery += "   AND RA_CC >= '"+MV_PAR05+"' AND RA_CC <= '"+MV_PAR06+"'"
	cQuery += "   AND RA_CATFUNC IN ("+cInCatFunc+")"
	cQuery += "   AND RA_SITFOLH IN ("+cInSituac+")"
	cQuery += "   AND SRA.D_E_L_E_T_ = ' ' "
	cQuery += "   AND SRD.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY " + SqlOrder(SRA->(IndexKey()))
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSRA,.T.,.T.)
	
	aStruSRA := SRA->(dbStruct())
	
	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX
	
	(cAliasSRA)->( dbEval( {|| nCount++ } ) )
#ELSE
	nCount := (cAliasSRA)->(RecCount())
#ENDIF

(cAliasSRA)->( dbGoTop() )

nCount := nCount+2
ProcRegua( nCount )

IncProc( "Iniciando Processamento..." )

While (cAliasSRA)->( !EoF() )

	//��������������������������������������������������������������Ŀ
	//� Aborta o Calculo                                  	 	     �
	//����������������������������������������������������������������
	If lCancel
		MsgStop("Processamento cancelado pelo operador.")
		Exit
	EndIf
	
	/*
	�����������������������������������������������������������������������Ŀ
	�Consiste Filiais e Acessos                                             �
	�������������������������������������������������������������������������*/
	If (cAliasSRA)->RA_FILIAL < cFilialDe .Or. (cAliasSRA)->RA_FILIAL > cFilialAte
		(cAliasSRA)->( dbSkip() )
		IncProc()
		Loop
	Endif
	
	If (cAliasSRA)->RA_MAT < MV_PAR03 .Or. (cAliasSRA)->RA_MAT > MV_PAR04
		(cAliasSRA)->( dbSkip() )
		IncProc()
		Loop
	Endif
	
	//Verifica se o funcionario tem Assistencia Medica, senao desconsidera este funcionario
	if empty((cAliasSRA)->RA_ASMEDIC)
		(cAliasSRA)->( dbSkip() )
		IncProc()
		Loop
	endif
	
	If (cAliasSRA)->RA_CC < MV_PAR05 .Or. (cAliasSRA)->RA_CC > MV_PAR06
		(cAliasSRA)->( dbSkip() )
		IncProc()
		Loop
	Endif

	If !((cAliasSRA)->RA_CATFUNC $ MV_PAR07)
		(cAliasSRA)->( dbSkip() )
		IncProc()
		Loop
	Endif
	
	If !((cAliasSRA)->RA_SITFOLH $ MV_PAR08)
		(cAliasSRA)->( dbSkip() )
		IncProc()
		Loop
	Endif
	
	if cFilAux <> (cAliasSRA)->RA_FILIAL
		cFilAux := (cAliasSRA)->RA_FILIAL
		
		//Busca a Verba de Desconto de Assistencia Medica do Funcionario (Titular) com Identificador "049"
		if !SRV->( dbSeek(&(cFilSRV)+cIdVerAM) )
			IncProc()
			Loop
		else
			cVerbaAM := SRV->RV_COD
		endif
		
		
		//Carrega as Configuracoes de Desconto de Assistencia Medica (TIPO 1)
		aAssMedTp1 := GPCfgDesAM("1")
		
		//Carrega as Configuracoes de Desconto de Assistencia Medica (TIPO 2)
		aAssMedTp2 := GPCfgDesAM("2")
	endif
	
	IncProc( (cAliasSRA)->RA_FILIAL + " - " + (cAliasSRA)->RA_MAT + " - " + (cAliasSRA)->RA_NOME )
	
	cChaveSRD := &(cFilSRD)+(cAliasSRA)->RA_MAT
	
	cMesProc := cMesProIni
	cAnoProc := cAnoProIni
	
	//Inicializa data de pagamento auxiliar
	dDtPgtoAux:= ""
	while cAnoProc+cMesProc <= cAnoProFim+cMesProFim
		
		if SRD->( dbSeek(cChaveSRD+cAnoProc+cMesProc+cVerbaAM) )
			
			While SRD->(!Eof()) .And. SRD->(RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD) == cChaveSRD+cAnoProc+cMesProc+cVerbaAM
				
				//Despreza se nao for Lancamentos com data de pagamento dentro da data Inicial e Final
				If SRD->RD_DATPGT < MV_PAR09 .or. SRD->RD_DATPGT > MV_PAR10
					SRD->( dbSkip() )
					Loop
				Endif
				
				//Despreza os Lancamentos de transferencias de outras empresas
			   	If !Empty(SRD->RD_EMPRESA) .And. SRD->RD_EMPRESA # cEmpAnt
					SRD->( dbSkip() )
					Loop
				Endif
				
				dDtPgto    := SRD->RD_DATPGT
				//Verifica se exite mais de um lancamento no mes
			   	If dDtPgtoAux != SubStr(DtoS(dDtPgto),1,6)				
					nTotDesLan := 0
				EndIf
				
				//Atualiza data de pagamento auxiliar
				dDtPgtoAux := SubStr(DtoS(dDtPgto),1,6)				
				nTotDesLan += SRD->RD_VALOR
				
				SRD->(dbSkip())
			End
			
			if nTotDesLan > 0
				
				//Consiste e Carrega somente os Dependentes de Assist. Medica
				lContinua := GPEVerDep(dDtPgto,@aDados,cAnoProc,cMesProc)
				
				if lContinua
					
					//Verifica se eh Assistencia Medica TIPO 1 (Tabela 22) ou Assistencia Medica TIPO 2 (Tabela 58)
					if SubStr((cAliasSRA)->RA_ASMEDIC,1,1) == "E"
						//Assistencia Medica TIPO 2 (Tabela 58)
						nPlanAM := aScan( aAssMedTp2, { |x| x[1] == (cAliasSRA)->RA_ASMEDIC } )
						if nPlanAM > 0
							//Calcula o Rateio da Assistencia Medica (TIPO 2)
							GPRatAMTp2(aAssMedTp2[nPlanAM],dDtPgto,nTotDesLan,@aDados,cMesProc)
						else
							aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, cMesProc, oemtoansi("Assistencia medica associada a este funcionario nao foi encontrada") } )
							Exit
						endif
					else
						//Assistencia Medica TIPO 1 (Tabela 22)
						nPlanAM := aScan( aAssMedTp1, { |x| x[1] == (cAliasSRA)->RA_ASMEDIC } )
						if nPlanAM > 0
							//Calcula o Rateio da Assistencia Medica (TIPO 1)
							GPRatAMTp1(aAssMedTp1[nPlanAM],dDtPgto,nTotDesLan,@aDados,cMesProc)
						else
							aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, cMesProc, oemtoansi("Assistencia medica associada a este funcionario nao foi encontrada") } )
							Exit
						endif
					endif
					
					//Grava o Arquivo
					GPERatGrav(cAliasArq,aDados,Alltrim(str(Year(dDtPgto))),StrZero(Month(dDtPgto),2))
					
				else
					Exit
				endif
				
			endif
		
		endif
		
		//Proximo Mes / Ano
		if cMesProc == "12"
			cAnoProc := alltrim(Str(Val(cAnoProc)+1))
			cMesProc := "01"
		else
			cMesProc := Soma1(cMesProc)
		endif
		
	end
	
	(cAliasSRA)->( dbSkip() )
End

//����������������������������������Ŀ
//� Apaga o Indice e Fecha Arquivo   �
//������������������������������������
GPEApgIndx(cNomArq,cAliasArq)

#IFDEF TOP
	(cAliasSRA)->( dbCloseArea() )                                             			
#ENDIF

cHrFimProc := dToc(ddatabase) + " - " + Time()
if len(aLogErro) > 0
	IncProc( "Montando LOG de Inconsist�ncias..." )
endif
Aviso( "Finalizado", "Inicio: "+cHrIniProc +Chr(13)+Chr(10)+Chr(13)+Chr(10)+ "Fim    :"+ cHrFimProc, { "Ok" },,"Processamento finalizado" )

if len(aLogErro) > 0
	//��������������������������������������������������Ŀ
	//� Monta LOG de Inconsistencias do processamento.   �
	//����������������������������������������������������
	GPEImprLOG()
endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �GPECriaArq� Autor � Alberto Deviciente    | Data � 23/Nov/10���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica o arquivo e cria se necessario no caminho: 	      ���
���          � "RootPath"+"StartPath"                              	      ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SIGAGPE  												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GPECriaArq(cArqNome,cArqAlias,lManut)
Local aCampos 	:={}
Local lCria 	:= .F.
Local aIndexs   := {}
Local cNomeInd  := ""
Local cIndChave := ""
Local nX 		:= 0

aIndexsArq := {}

//Define os Indices do Arquivo
aAdd( aIndexs , "FILIAL + MATFUNC + ANO + MES + CODDEP" ) //Indice 1
aAdd( aIndexs , "FILIAL + MATFUNC + CODDEP + ANO + MES" ) //Indice 2


If MSFile(cArqNome,,__LocalDriver)     
	If !MsOpenDbf( .T. , __LocalDriver , cArqNome , cArqAlias , .F. , .F. )
		Aviso( "Aten��o","N�o foi poss�vel abrir o arquivo "+cArqAlias+". Verifique se o arquivo est� aberto ou se este processo j� est� sendo executado em outra esta��o.", { "Ok" },,"Erro ao tentar abrir o arquivo" )
		Return(.F.)
	Endif
	
	//Cria Indices
	for nX:=1 to len(aIndexs)
		cNomeInd 	:= FileNoExt(cArqNome)+Soma1(cValToChar(nX-1))
		cIndChave 	:= aIndexs[nX]
		IndRegua(cArqAlias,cNomeInd,cIndChave,,,"Indexando Arquivo de Trabalho...")
		aAdd( aIndexsArq, {cArqAlias,cNomeInd,cIndChave} )
	next nX
Else
	if lManut
		Aviso("Aten��o", "Arquivo n�o encontrado para esta empresa. O rateio ainda n�o foi processado.", {"Ok"})
		Return(.F.)
	else
		lCria := .T.
	endif
Endif		

If lCria
	//Estrutura do Arquivo
				     //Nome      Tipo  Tamanho         		Decimal
	AADD( aCampos, { "FILIAL"	, "C", FWGETTAMFILIAL		, 0} )
	AADD( aCampos, { "MATFUNC"	, "C", TamSx3("RA_MAT")[1]	, 0} )
	AADD( aCampos, { "ANO"		, "C", 04					, 0} )
	AADD( aCampos, { "MES"		, "C", 02					, 0} )
	AADD( aCampos, { "CODDEP"	, "C", 02					, 0} )
	AADD( aCampos, { "CPF"		, "C", TamSx3("RA_CIC")[1]	, 0} )
	AADD( aCampos, { "VALOR" 	, "N", 12     				, 2} )
	
	dbCreate(cArqNome,aCampos,__LocalDriver)
	dbUseArea( .T.,__LocalDriver, cArqNome, cArqAlias, .F., .F. )
	
	//Cria Indices
	for nX:=1 to len(aIndexs)
		cNomeInd 	:= FileNoExt(cArqNome)+cValToChar(nX)
		cIndChave 	:= aIndexs[nX]
		IndRegua(cArqAlias,cNomeInd,cIndChave,,,"Indexando Arquivo de Trabalho...")
		aAdd( aIndexsArq, {cArqAlias,cNomeInd,cIndChave} )
	next nX
EndIf

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcai    �GPEApgIndx  �Autor  �Alberto Deviciente� Data �  23/Nov/10  ���
�������������������������������������������������������������������������͹��
���Desc.     � Apaga indices e fecha o arquivo quando sair da rotina.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPEApgIndx(cArqNome,cArqAlias)
Local nVezes 	:= 0
Local nZ 		:= 0
Local cArqIndex := ""

//Fecha Arquivo de Trabalho 
dbSelectArea(cArqAlias)
(cArqAlias)->( dbCloseArea() )

//Apaga Indices
for nZ:=1 to len(aIndexsArq)
	cArqIndex := aIndexsArq[nZ][2]+OrdBagExt()
	nVezes := 0
	While File(cArqIndex)
		nVezes ++
	   	If nVezes >= 10
			Aviso( "Aten��o","Nao foi possivel excluir o arquivo de indice "+'"'+cArqIndex +'"', { "Ok" },,"Erro ao Excluir arquivo" )
			Return
		EndIf
		FErase(cArqIndex)
	EndDo
next nZ

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPCfgDesAM�Autor  �Alberto Deviciente  � Data � 23/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega as Configuracoes de Desconto de Assistencia Medica ���
���          � TIPO 1 e TIPO 2                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPCfgDesAM(cTpAssMed)
Local aRet 		:= {}
Local cChaveSRX := ""
Local cCodPlan  := ""
Local nVlTitular:= 0
Local nVlrDepend:= 0
Local nPercAM	:= 0
Local nVlrPlano := 0
Local nLimSal1 	:= 0
Local nPercFun1 := 0
Local nPercDep1 := 0
Local nLimSal2 	:= 0
Local nPercFun2 := 0
Local nPercDep2 := 0
Local nLimSal3 	:= 0
Local nPercFun3 := 0
Local nPercDep3 := 0
Local nLimSal4 	:= 0
Local nPercFun4 := 0
Local nPercDep4 := 0
Local nLimSal5 	:= 0
Local nPercFun5 := 0
Local nPercDep5 := 0
Local nLimSal6 	:= 0
Local nPercFun6 := 0
Local nPercDep6 := 0

dbSelectArea("SRX")
SRX->( dbSetOrder(1) ) //RX_FILIAL+RX_TIP+RX_COD

if cTpAssMed == "1" //TIPO 1 (Tabela 22)
	
	//Busca Configuracoes de Desconto de Assistencia Medica TIPO 1 (Tabela 22)
	if SRX->( dbSeek((cAliasSRA)->RA_FILIAL+"22") )
		cChaveSRX := (cAliasSRA)->RA_FILIAL+"22"
	elseif SRX->( dbSeek(Space(FWGETTAMFILIAL)+"22") )
		cChaveSRX := Space(FWGETTAMFILIAL)+"22"
	endif
	
	if SRX->(Found())
		while SRX->( !EoF() ) .and. SRX->(RX_FILIAL+RX_TIP) == cChaveSRX
			cCodPlan 	:= Right(Alltrim(SRX->RX_COD),2)
			nVlTitular	:= Val(SubStr(SRX->RX_TXT,21,12))
			nVlrDepend	:= Val(SubStr(SRX->RX_TXT,33,12))
			nPercAM		:= Val(SubStr(SRX->RX_TXT,45,07))
			aAdd( aRet, { cCodPlan, nVlTitular, nVlrDepend, nPercAM } )
			SRX->( dbSkip() )
		end
	endif
	
elseif cTpAssMed == "2" //TIPO 2 (Tabela 58)
	
	//Busca Configuracoes de Desconto de Assistencia Medica TIPO 2 (Tabela 58)
	if SRX->( dbSeek((cAliasSRA)->RA_FILIAL+"58") )
		cChaveSRX := (cAliasSRA)->RA_FILIAL+"58"
	elseif SRX->( dbSeek(Space(FWGETTAMFILIAL)+"58") )
		cChaveSRX := Space(FWGETTAMFILIAL)+"58"
	endif
	
	if SRX->(Found())
		while SRX->( !EoF() ) .and. SRX->(RX_FILIAL+RX_TIP) == cChaveSRX
			cCodPlan := SubStr(Right(Alltrim(SRX->RX_COD),4),1,2)
			nVlrPlano := Val(SubStr(SRX->RX_txt,21,14))
			
			SRX->( dbSkip() )
			nLimSal1    := Val(SubStr(SRX->RX_txt,01,14))
			nPercFun1   := Val(SubStr(SRX->RX_txt,15,06))
			nPercDep1   := Val(SubStr(SRX->RX_txt,21,06))
			If nLimSal1 == 0
				nLimSal1 := 99999999999.99
			EndIf
			nLimSal2    := Val(SubStr(SRX->RX_TXT,27,14))
			nPercFun2   := Val(SubStr(SRX->RX_TXT,41,06))
			nPercDep2   := Val(SubStr(SRX->RX_TXT,47,06))
			If nLimSal2 == 0
				nLimSal2 := 99999999999.99
			EndIf
			SRX->( dbSkip() )
			nLimSal3    := Val(SubStr(SRX->RX_TXT,01,14))
			nPercFun3   := Val(SubStr(SRX->RX_TXT,15,06))
			nPercDep3   := Val(SubStr(SRX->RX_TXT,21,06))
			If nLimSal3 == 0
				nLimSal3 := 99999999999.99
			EndIf
			nLimSal4    := Val(SubStr(SRX->RX_TXT,27,14))
			nPercFun4   := Val(SubStr(SRX->RX_TXT,41,06))
			nPercDep4   := Val(SubStr(SRX->RX_TXT,47,06))
			If nLimSal4 == 0
				nLimSal4 := 99999999999.99
			EndIf
			SRX->( dbSkip() )
			nLimSal5    := Val(SubStr(SRX->RX_TXT,01,14))
			nPercFun5   := Val(SubStr(SRX->RX_TXT,15,06))
			nPercDep5   := Val(SubStr(SRX->RX_TXT,21,06))
			If nLimSal5 == 0
				nLimSal5 := 99999999999.99
			EndIf
			nLimSal6    := Val(SubStr(SRX->RX_TXT,27,14))
			nPercFun6   := Val(SubStr(SRX->RX_TXT,41,06))
			nPercDep6   := Val(SubStr(SRX->RX_TXT,47,06))
			If nLimSal6 == 0
				nLimSal6 := 99999999999.99
			EndIf
			
			aAdd( aRet, { cCodPlan, nVlrPlano,;
				{nLimSal1, nPercFun1, nPercDep1},;
				{nLimSal2, nPercFun2, nPercDep2},;
				{nLimSal3, nPercFun3, nPercDep3},;
				{nLimSal4, nPercFun4, nPercDep4},;
				{nLimSal5, nPercFun5, nPercDep5},;
				{nLimSal6, nPercFun6, nPercDep6} } )
			
			SRX->( dbSkip() )
		end
	endif

endif

Return aRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEVerDep �Autor  �Alberto Deviciente  � Data � 23/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Consiste os Dependentes Cadastrados.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPEVerDep(dDtPagto,aDados,cAno,cMes)
Local lRet 		:= .T.
Local cFilSRB 	:= if(empty(xFilial("SRB")),Space(FWGETTAMFILIAL),(cAliasSRA)->RA_FILIAL)
Local nIdade  	:= 0
Local lIsDepAM  := .F.
Local cAnoMesRef:= cAno+cMes
Local dDtVlIdade:= cToD("31/12/"+AllTrim(Str(Year(dDtPagto)))) //Data a ser considerada para verifica a idade do Dependente

aDados := {}

if empty((cAliasSRA)->RA_CIC)
	aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, "--" , oemtoansi("Deve ser informado o CPF deste Funcion�rio") } )
	Return .F.
endif

aAdd( aDados, { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, "  ", (cAliasSRA)->RA_CIC, 0 } )

dbSelectArea("SRB")
SRB->( dbSetOrder(1) ) //RB_FILIAL+RB_MAT
if SRB->( dbSeek(cFilSRB+(cAliasSRA)->RA_MAT) )
	while SRB->( !EoF() ) .and. SRB->(RB_FILIAL+RB_MAT) == cFilSRB+(cAliasSRA)->RA_MAT
		//Verifica se os NOVOS campos estao alimentados
		if empty(SRB->RB_TPDEPAM)
			aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, "--", oemtoansi("Informar se o Dependente "+SRB->RB_COD + "-" + Left(SRB->RB_NOME,15) + " � ou n�o dependente de Assist. M�dica") } )
			lRet := .F.
			SRB->( dbSkip() )
			Loop
		else 
			lIsDepAM := SRB->RB_TPDEPAM $ "1|2" //1=Dependente; 2=Agregado
			
			if lIsDepAM //Eh Dependente de Assist. Medica
				
				//����������������������������������������������������������������������Ŀ
				//�Verifica se a Assist. Medica esta vigente na data de pagto. em questao�
				//������������������������������������������������������������������������
				if !empty(SRB->RB_DTINIAM) .and. cAnoMesRef < AllTrim(Str(Year(SRB->RB_DTINIAM)))+StrZero(Month(SRB->RB_DTINIAM),2)
				
					SRB->( dbSkip() )
					Loop
				endif
				
				if !empty(SRB->RB_DTFIMAM) .and. cAnoMesRef > AllTrim(Str(Year(SRB->RB_DTFIMAM)))+StrZero(Month(SRB->RB_DTFIMAM),2)
					SRB->( dbSkip() )
					Loop
				endif
				
				//Verifica a idade do dependente
				nIdade := Calc_Idade( dDtVlIdade , SRB->RB_DTNASC )
				
				//Se for maior de Idade, obriga ter o CPF informado para o Dependente
				if nIdade >= 18 .and. empty(SRB->RB_CIC)
					aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, cMes , oemtoansi("Deve ser informado o CPF do Dependente "+SRB->RB_COD + "-" + RTrim(SRB->RB_NOME)) } )
					lRet := .F.
				else
					
					                //Filial        Mat. Func   Cod Depend.  CPF Depend   Vlr Desc. Ass. Med. do Dependente
									//   01            02            03           04       05
					aAdd( aDados, { SRB->RB_FILIAL, SRB->RB_MAT, SRB->RB_COD, SRB->RB_CIC, 0 } )
				endif
			endif
			
		endif
		
		SRB->( dbSkip() )
	end
	
endif

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPRatAMTp1�Autor  �Alberto Deviciente  � Data � 23/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula o Rateio da Assistencia Medica (TIPO 1)            ���
���          � (tabela 22)                                                ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPRatAMTp1(aAssistMed,dDtRefPag,nVlrAMLanc,aDados,cMes)
Local nX := 0
Local nVlrTitula := aAssistMed[2]
Local nVlrDepend := aAssistMed[3]
Local nPercDesc  := aAssistMed[4] / 100
Local nDescFunc  := 0
Local nDescDep   := 0
Local nTotDesDep := 0
Local nTotDesCal := 0
Local nPerRatFun := 0
Local nPerRatDep := 0
Local nDesRatFun := 0
Local nDesRatDep := 0
Local nTotRatDep := 0

//Calcula os valores de desconto do plano de Assis. Medica conforme esta configurado o Plano atualmente
nDescFunc := nVlrTitula * nPercDesc
nDescDep  := nVlrDepend * nPercDesc


//Totaliza o valor calculado de descontos de todos os dependentes do funcionario
nTotDesDep := nDescDep * (len(aDados)-1) //Multiplica o valor de desconto do dependente pelo numero de Dependentes

//Totaliza o Desconto Calculado (Funcionario + Dependentes)
nTotDesCal := nDescFunc + nTotDesDep


//Calcula o percentual de desconto a ser considerado para o Funcionario
nPerRatFun := nDescFunc / nTotDesCal

//Calcula o percentual de desconto a ser considerado para cada Dependente
nPerRatDep := nDescDep / nTotDesCal

//Valor de desconto rateado para o Funcionario
nDesRatFun := nVlrAMLanc * nPerRatFun

//Valor de desconto rateado para cada Dependente
nDesRatDep := nVlrAMLanc * nPerRatDep

//Valor do Funcionario (Titular)
aDados[1][5] := nDesRatFun

//Valor dos Dependentes
For nX:=2 to len(aDados)
	aDados[nX][5] := nDesRatDep
	nTotRatDep += nDesRatDep
Next nX

//TIRA TEIMA:
//Verificar se os valores Rateados equivale ao valor Total de Desconto de Assist. Medica Lancado na tabela SRD
if nVlrAMLanc <> (nTotRatDep + nDesRatFun)
	aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, cMes, oemtoansi("Valores Diferentes: Lan�ado(RD_VALOR)= "+AllTrim(Transform(nVlrAMLanc, "@E 999,999.99"))+ " # Total rateado(Func.+Dep.)= "+AllTrim(Transform(nTotRatDep+nDesRatFun, "@E 999,999.99"))) } )
endif

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPRatAMTp2�Autor  �Alberto Deviciente  � Data � 23/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Calcula o Rateio da Assistencia Medica (TIPO 2)            ���
���          � (tabela 58)                                                ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPRatAMTp2(aAssistMed,dDtRefPag,nVlrAMLanc,aDados,cMes)
Local nSalFunc 	:= fBuscaSal(dDtRefPag,,,.T.,) //Busca Salario do funcionario na data de referencia
Local nInd 		:= 0
Local nX 		:= 0
Local nValorPlan:= aAssistMed[2] //Valor do Plano
Local nPerDesFun:= 0
Local nPerDesDep:= 0
Local nVlrDesFun:= 0
Local nVlrDesDep:= 0
Local nTotDesDep:= 0
Local nTotRatDep:= 0
Local nTotDesCal:= 0
Local nPerRatFun:= 0
Local nPerRatDep:= 0
Local nDesRatFun:= 0 //Armazena o desconto rateado de Assis. Medica Lancado para o Funcionaio
Local nDesRatDep:= 0 //Armazena o desconto rateado de Assis. Medica Lancado para os Dependentes

//Calcula os valores de desconto do plano de Assis. Medica conforme esta configurado o Plano atualmente
For nInd:=3 to 8
	If nSalFunc < aAssistMed[nInd][1]  //Faixa de Salario
		nPerDesFun := aAssistMed[nInd][2] / 100 //Percentual de Desconto Funcionario
		nPerDesDep := aAssistMed[nInd][3] / 100 //Percentual de Desconto Dependente
		
		nVlrDesFun := nValorPlan * nPerDesFun   //Calcula Valor de Desconto do Funcionario
		nVlrDesDep := nValorPlan * nPerDesDep   //Calcula Valor de Desconto do Dependente
		
		Exit
	EndIf
Next nX

//Totaliza o valor calculado de descontos de todos os dependentes do funcionario
nTotDesDep := nVlrDesDep * (len(aDados)-1) //Multiplica o valor de desconto do dependente pelo numero de Dependentes

//Totaliza o Desconto Calculado (Funcionario + Dependentes)
nTotDesCal := nVlrDesFun + nTotDesDep


//Calcula o percentual de desconto a ser considerado para o Funcionario
nPerRatFun := nVlrDesFun / nTotDesCal

//Calcula o percentual de desconto a ser considerado para cada Dependente
nPerRatDep := nVlrDesDep / nTotDesCal

//Valor de desconto rateado para o Funcionario
nDesRatFun := nVlrAMLanc * nPerRatFun

//Valor de desconto rateado para cada Dependente
nDesRatDep := nVlrAMLanc * nPerRatDep

//Valor do Funcionario (Titular)
aDados[1][5] := nDesRatFun

//Valor dos Dependentes
For nX:=2 to len(aDados)
	aDados[nX][5] := nDesRatDep
	nTotRatDep += nDesRatDep
Next nX

//TIRA TEIMA:
//Verificar se os valores Rateados equivale ao valor Total de Desconto de Assist. Medica Lancado na tabela SRD
if nVlrAMLanc <> (nTotRatDep + nDesRatFun)
	aAdd( aLogErro , { (cAliasSRA)->RA_FILIAL, (cAliasSRA)->RA_MAT, (cAliasSRA)->RA_NOME, cMes, oemtoansi("Valores Diferentes: Lan�ado(RD_VALOR)= "+AllTrim(Transform(nVlrAMLanc, "@E 999,999.99"))+ " # Total rateado(Func.+Dep.)= "+AllTrim(Transform(nTotRatDep+nDesRatFun, "@E 999,999.99"))) } )
endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPVldPerg �Autor  �Alberto Deviciente  � Data � 23/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a data inicial e final informadas no pergunte.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPVldPerg(cPerg)
Local lOk := .T.

if Year(MV_PAR09) <> Year(MV_PAR10)
	Aviso("Aten��o", 'A "Data de Pagamento De/Ate" deve estar dentro do mesmo ano.', {"Ok"})
	lOk := .F.
elseif empty(MV_PAR09) .or. Empty(MV_PAR10)
	Aviso("Aten��o", 'A "Data de Pagamento De/Ate" deve ser informada.', {"Ok"})
	lOk := .F.
elseif MV_PAR09 > MV_PAR10
	Aviso("Aten��o", 'A Data de Pagamento "De" deve ser menor que a Data de Pagamento "At�".', {"Ok"})
	lOk := .F.
endif

if !lOk
	If Pergunte(cPerg,.T. )
		lOk := GPVldPerg(cPerg)
	EndIf
endif

Return lOk

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPERatGrav�Autor  �Alberto Deviciente  � Data � 24/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Descontos de Assistencia Medica Rateado.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPERatGrav(cAliasArq,aDadosGrv,cAno,cMes)
Local nW := 0

(cAliasArq)->( dbGoTop() )
//Se ja existir dados gravados para o Mes/Ano, exclui e gera de novo
while (cAliasArq)->( dbSeek((cAliasSRA)->RA_FILIAL+(cAliasSRA)->RA_MAT+cAno+cMes) )
	(cAliasArq)->( dbDelete() )
end

For nW:=1 to len(aDadosGrv)
	
	//Efetua Gravacao
	RecLock(cAliasArq, .T.)
	(cAliasArq)->FILIAL 	:= (cAliasSRA)->RA_FILIAL
	(cAliasArq)->MATFUNC	:= (cAliasSRA)->RA_MAT
	(cAliasArq)->ANO 		:= cAno
	(cAliasArq)->MES 		:= cMes
	(cAliasArq)->CODDEP 	:= aDadosGrv[nW][3]
	(cAliasArq)->CPF		:= aDadosGrv[nW][4]
	(cAliasArq)->VALOR 		:= aDadosGrv[nW][5]
	(cAliasArq)->( MsUnLock() )
	
Next nW

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEImprLOG�Autor  �Alberto Deviciente  � Data � 26/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprimi o LOG de Inconsistencias.                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPEImprLOG()
Local aTitle	:= {}
Local aLog		:= {}
Local nTamSpcFil:= 0
Local nZ 		:= 0

//��������������������������������������������������Ŀ
//� Monta LOG com resultado do processamento.        �
//����������������������������������������������������
If len(aLogErro) > 0
	aAdd( aLog , {} )
	aAdd( aTitle , oEmToAnsi("INCONSIST�NCIAS ENCONTRADAS DURANTE O PROCESSAMENTO:") )
	nTamSpcFil := if((FWGETTAMFILIAL-2)==0,0,(FWGETTAMFILIAL-4)) + 2
	aAdd( aLog[1] , "Fil."+Space(nTamSpcFil)+"Mat.   Nome                       Mes  Ocorrencia" )
	aAdd( aLog[1] , replicate("-",130) )
	For nZ := 1 to len(aLogErro)
		aAdd( aLog[1] , aLogErro[nZ,1] + Space(3) + aLogErro[nZ,2] + Space(2) + Left(aLogErro[nZ,3],25) + Space(2) + aLogErro[nZ,4] + Space(3) + aLogErro[nZ,5] )
	Next nZ
Endif

//Exibe o LOG
fMakeLog(aLog,aTitle,,,"GPERATAM"+DTOS(Date()),oEmToAnsi("Log de Ocorr�ncias - Gera��o de Rateio de Desconto de Assist. M�dica de Dependentes"),"M","L",,.F.)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPEManRat �Autor  �Alberto Deviciente  � Data � 29/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela de manutencao dos descontos de Assist. Medica Rateado.���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPEManRat()
Local aIndexSRA		:= {}
Local bFiltraBrw 	:= {|| Nil}		//Variavel para Filtro

Private aRotina 	:=  MenuDef()

cCadastro 			:= OemToAnsi("Descontos Rateados - Assist. M�dica Dependentes")

//��������������������������������������������������������������Ŀ
//� Verifica se o Arquivo Esta Vazio                             �
//����������������������������������������������������������������
If !ChkVazio("SRA")
	Return
Endif

//������������������������������������������������������������������������Ŀ
//� Inicializa o filtro utilizando a funcao FilBrowse                      �
//��������������������������������������������������������������������������
cFiltraRh := CHKRH("GPERATAMED","SRA","1")
bFiltraBrw 	:= {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }
Eval(bFiltraBrw)

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������                 
SetBrwCHGAll( .F. ) // nao apresentar a tela para informar a filial	
dbSelectArea("SRA")
mBrowse( 6, 1,22,75,"SRA",,,,,,fCriaCor() )

//������������������������������������������������������������������������Ŀ
//� Deleta o filtro utilizando a funcao FilBrowse                     	   �
//��������������������������������������������������������������������������
EndFilBrw("SRA",aIndexSra)

Return 

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Alberto Deviciente    � Data �29/Nov/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �	  1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
Local aRotina := {		{ "Pesquisar"	, "PesqBrw"		, 0 , 1,,.F.},;	//"Pesquisar"
                     	{ "Visualizar"	, "U_GPEAMMan"	, 0 , 2		},;	//"Visualizar"
                     	{ "Alterar"		, "U_GPEAMMan"	, 0 , 4		},;	//"Alterar"
					  	{ "Legenda"		, "GpLegend"    , 0 , 5 , ,.F.}}//"Legenda"
                     	
                     	
Return aRotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GPEAMMan �Autor  �Alberto Deviciente  � Data � 29/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Manutencao dos registros rateados gerados no arquivo.      ���
���          � (Visualizacao, Alteracao, Exclusao)                        ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPEAMMan(cAlias,nReg,nOpc)
Local lVisualz 		:= nOpc==2
Local lAltera  		:= nOpc==3
Local lExclui  		:= nOpc==4
Local cFilSRB   	:= ""
Local cChaveSRB 	:= ""
Local cAliasArq 	:= GPRATAMARQ+cEmpAnt
Local cNomArq 		:= ""
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local aAnos  		:= {}
Local nOpcA 		:= 0
Local oDlg
Local oFont
Local oGroup 
Local aCmpsMes 		:= {}
Local cCampo   		:= ""
Local nVlrTot  		:= 0
Local cDepends 		:= ""
Local nLinhaCols    := 0
Local aCamposAlt    := {}
Local nY 			:= 0
Local nPosCmpTot  	:= 0

Private aHeader 	:= {}
Private aCols   	:= {}
Private cAnoSelec   := ""

/*
��������������������������������������������������������������Ŀ
� Monta as Dimensoes dos Objetos         					   �
����������������������������������������������������������������*/
aAdvSize		:= MsAdvSize()
aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )
aAdd( aObjCoords , { 000 , 000 , .T. , .T. } )
aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )


aCmpsMes 		:= { "CMP_JAN",;
					 "CMP_FEV",;
					 "CMP_MAR",;
					 "CMP_ABR",;
					 "CMP_MAI",;
					 "CMP_JUN",;
					 "CMP_JUL",;
					 "CMP_AGO",;
					 "CMP_SET",;
					 "CMP_OUT",;
					 "CMP_NOV",;
					 "CMP_DEZ" }
					 
aCamposAlt := aCmpsMes

cNomArq := cAliasArq+GetDBExtension()
cNomArq := RetArq(__LocalDriver,cNomArq,.T.)

//-------------
//Abre Arquivo 
//-------------
If !GPECriaArq(cNomArq,cAliasArq,.T.)
	Return
Endif

//Indice 2 do Arquivo  ("FILIAL + MATFUNC + CODDEP + ANO + MES ")
IndRegua(aIndexsArq[2][1],aIndexsArq[2][2],aIndexsArq[2][3],,,"Indexando Arquivo de Trabalho...")

if !(cAliasArq)->( dbSeek(SRA->RA_FILIAL+SRA->RA_MAT) )
	Aviso("Aten��o","N�o existem informa��es para este funcion�rio", {"Ok"})
	//����������������������������������Ŀ
	//� Apaga o Indice e Fecha Arquivo   �
	//������������������������������������
	GPEApgIndx(cNomArq,cAliasArq)
	Return
endif

cAnoSelec := (cAliasArq)->ANO

while (cAliasArq)->( !EoF() ) .and. (cAliasArq)->(FILIAL+MATFUNC) == SRA->(RA_FILIAL+RA_MAT)
	if aScan( aAnos, (cAliasArq)->ANO ) == 0
		aAdd( aAnos, (cAliasArq)->ANO )
	endif
	(cAliasArq)->( dbSkip() )
end

//Se existir mais de 1 ano gerado no arquivo, entao apresenta telinha para o usuario escolher qual ano deseja considerar
if len(aAnos) > 1
	aSort( aAnos )
	if !GPESelAno(aAnos)
		Return
	endif
endif

(cAliasArq)->( dbSeek(SRA->RA_FILIAL+SRA->RA_MAT) )

//Define os campos da GetDados
SX3->( dbSetOrder(2) )
SX3->( dbSeek("RB_COD") )
aAdd( aHeader, { 	"Identif."						,;  //X3_TITULO
					"CMP_IDENT"						,;  //X3_CAMPO
					""								,;  //X3_PICTURE
					7								,;  //X3_TAMANHO
					0								,;  //X3_DECIMAL
					""								,;  //X3_VALID
					Nil								,;  //X3_USADO
					"C"								,;  //X3_TIPO
					Nil 							,;  //X3_F3
					"V" 							} ) //X3_CONTEXT

aAdd( aHeader, {	Alltrim(SX3->( X3Titulo() ))	,;  //X3_TITULO
					"CMP_CODDEP"					,;  //X3_CAMPO
					SX3->X3_PICTURE					,;  //X3_PICTURE
					SX3->X3_TAMANHO					,;  //X3_TAMANHO
					SX3->X3_DECIMAL					,;  //X3_DECIMAL
					SX3->X3_VALID					,;  //X3_VALID
					SX3->X3_USADO					,;  //X3_USADO
					SX3->X3_TIPO					,;  //X3_TIPO
					Nil 							,;  //X3_F3
					SX3->X3_CONTEXT 				} ) //X3_CONTEXT

SX3->( dbSeek("RB_NOME") )
aAdd( aHeader, {	Alltrim(SX3->( X3Titulo() ))	,;  //X3_TITULO
					"CMP_NOME"						,;  //X3_CAMPO
					SX3->X3_PICTURE					,;  //X3_PICTURE
					SX3->X3_TAMANHO					,;  //X3_TAMANHO
					SX3->X3_DECIMAL					,;  //X3_DECIMAL
					SX3->X3_VALID					,;  //X3_VALID
					SX3->X3_USADO					,;  //X3_USADO
					SX3->X3_TIPO					,;  //X3_TIPO
					Nil 							,;  //X3_F3
					"V" 							} ) //X3_CONTEXT

SX3->( dbSeek("RB_CIC") )
aAdd( aHeader, {	Alltrim(SX3->( X3Titulo() ))	,;  //X3_TITULO
					"CMP_CPF"				   		,;  //X3_CAMPO
					SX3->X3_PICTURE					,;  //X3_PICTURE
					SX3->X3_TAMANHO					,;  //X3_TAMANHO
					SX3->X3_DECIMAL					,;  //X3_DECIMAL
					SX3->X3_VALID					,;  //X3_VALID
					SX3->X3_USADO					,;  //X3_USADO
					SX3->X3_TIPO					,;  //X3_TIPO
					Nil 							,;  //X3_F3
					SX3->X3_CONTEXT 				} ) //X3_CONTEXT

aAdd( aHeader, { 	"Janeiro"						,;  //X3_TITULO
					"CMP_JAN"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil 							,;  //X3_F3
					" " 							} ) //X3_CONTEXT
					
aAdd( aHeader, { 	"Fevereiro"						,;  //X3_TITULO
					"CMP_FEV"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
										
aAdd( aHeader, { 	"Mar�o"							,;  //X3_TITULO
					"CMP_MAR"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil 							,;  //X3_F3
					" " 							} ) //X3_CONTEXT
										
aAdd( aHeader, { 	"Abril"							,;  //X3_TITULO
					"CMP_ABR"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
										
aAdd( aHeader, { 	"Maio"							,;  //X3_TITULO
					"CMP_MAI"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
										
aAdd( aHeader, { 	"Junho"					   		,;  //X3_TITULO
					"CMP_JUN"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil 							,;  //X3_F3
					" " 							} ) //X3_CONTEXT
										
aAdd( aHeader, { 	"Julho"							,;  //X3_TITULO
					"CMP_JUL"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
										
aAdd( aHeader, { 	"Agosto"						,;  //X3_TITULO
					"CMP_AGO"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
					
aAdd( aHeader, { 	"Setembro"						,;  //X3_TITULO
					"CMP_SET"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
					
aAdd( aHeader, { 	"Outubro"						,;  //X3_TITULO
					"CMP_OUT"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
					
aAdd( aHeader, { 	"Novembro"						,;  //X3_TITULO
					"CMP_NOV"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
							
aAdd( aHeader, { 	"Dezembro"						,;  //X3_TITULO
					"CMP_DEZ"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					"Positivo() .and. U_GPRtAMVl(ReadVar())",;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					" " 							} ) //X3_CONTEXT
					
aAdd( aHeader, { 	"Total"							,;  //X3_TITULO
					"CMP_TOTAL"						,;  //X3_CAMPO
					"@R 999,999,999.99"				,;  //X3_PICTURE
					12								,;  //X3_TAMANHO
					2								,;  //X3_DECIMAL
					Nil								,;  //X3_VALID
					Nil								,;  //X3_USADO
					"N"								,;  //X3_TIPO
					Nil		 						,;  //X3_F3
					"V" 							} ) //X3_CONTEXT
					
dbSelectArea("SRB")
SRB->( dbSetOrder(1) )

cFilSRB   := if(empty(xFilial("SRB")),xFilial("SRB"),(cAliasArq)->FILIAL)
cChaveSRB := cFilSRB+SRA->RA_MAT

nPosCmpTot := aScan( aHeader, { |x| x[2] == "CMP_TOTAL" } )


//Carrega aCols 
while (cAliasArq)->( !EoF() ) .and. (cAliasArq)->( FILIAL + MATFUNC) == SRA->(SRA->RA_FILIAL+SRA->RA_MAT)
	
	if cAnoSelec <> (cAliasArq)->ANO
		(cAliasArq)->( dbSkip() )
		Loop
	endif
	
	
	if !(cAliasArq)->CODDEP $ cDepends
		
		if empty((cAliasArq)->CODDEP) //Funcionario Titular do Plano de Assist. Medica
			
			cDepends += (cAliasArq)->CODDEP+"|"
			
			aAdd( aCols, Array( len(aHeader)+1 ) )
			aCols[len(aCols),len(aHeader)+1] := .F.
			
			nLinhaCols := len(aCols)
			
			aCols[nLinhaCols][01] := "Titular"
			aCols[nLinhaCols][02] := (cAliasArq)->CODDEP
			aCols[nLinhaCols][03] := SRA->RA_NOME
			aCols[nLinhaCols][04] := SRA->RA_CIC
			
			//Inicia com zero os campos de valores
			for nY:= 1 to len(aCmpsMes)
				cCampo := aCmpsMes[nY]
				aCols[nLinhaCols][aScan( aHeader, { |x| x[2] == cCampo } )] := 0
			next
			aCols[nLinhaCols][nPosCmpTot] := 0
			
		elseif SRB->( dbSeek(cChaveSRB) ) //Dependente
			while SRB->( !EoF() ) .and. cChaveSRB == SRB->( RB_FILIAL+RB_MAT )
				
				if (cAliasArq)->CODDEP == SRB->RB_COD
					
					cDepends += (cAliasArq)->CODDEP+"|"
					
					if nLinhaCols > 0
						aCols[nLinhaCols][nPosCmpTot] := nVlrTot
					endif
					
					nVlrTot := 0
					
					aAdd( aCols, Array( len(aHeader)+1 ) )
					aCols[len(aCols),len(aHeader)+1] := .F.
					
					nLinhaCols := len(aCols)
					
					aCols[nLinhaCols][01] := "Depend."
					aCols[nLinhaCols][02] := (cAliasArq)->CODDEP
					aCols[nLinhaCols][03] := SRB->RB_NOME
					aCols[nLinhaCols][04] := (cAliasArq)->CPF
					
					//Inicia com zero os campos de valores
					for nY:= 1 to len(aCmpsMes)
						cCampo := aCmpsMes[nY]
						aCols[nLinhaCols][aScan( aHeader, { |x| x[2] == cCampo } )] := 0
					next
					aCols[nLinhaCols][nPosCmpTot] := 0
					
					Exit
				endif
				SRB->( dbSkip() )
			end
		else
			nLinhaCols := 0
		endif
		
	endif
	
	if nLinhaCols > 0
		cCampo := aCmpsMes[VAL((cAliasArq)->MES)]
		
		aCols[nLinhaCols][aScan( aHeader, { |x| x[2] == cCampo } )] := (cAliasArq)->VALOR
		
		nVlrTot += (cAliasArq)->VALOR
	endif
	
	(cAliasArq)->( dbSkip() )
end

if nLinhaCols > 0
	aCols[nLinhaCols][nPosCmpTot] := nVlrTot
endif
	
DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Manuten��o - Rateio de Desconto de Assist�ncia M�dica") FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL

@ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] - 3 ),( ( aObjSize[1,4]/100*10 - 2 ) ) LABEL OemToAnsi("Matricula:") OF oDlg PIXEL
oGroup:oFont:= oFont
@ aObjSize[1,1] , ( ( aObjSize[1,4]/100*10 ) ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),( aObjSize[1,4]/100*80 - 2 ) LABEL OemToAnsi("Funcion�rio:") OF oDlg PIXEL
oGroup:oFont:= oFont
@ aObjSize[1,1] , ( aObjSize[1,4]/100*80 ) GROUP oGroup TO ( aObjSize[1,3] - 3 ),aObjSize[1,4] LABEL OemToAnsi("Ano Calend�rio:") OF oDlg PIXEL
oGroup:oFont:= oFont

@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( aObjSize[1,2] + 5 )				SAY OemToAnsi(SRA->RA_MAT)		SIZE 050,10 OF oDlg PIXEL FONT oFont
@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*10 ) + 5 )	SAY OemToAnsi(SRA->RA_NOME) 	SIZE 146,10 OF oDlg PIXEL FONT oFont
@ ( ( aObjSize[1,3] ) - ( ( ( aObjSize[1,3] - 3 ) - aObjSize[1,2] ) / 2 ) ) , ( ( aObjSize[1,4]/100*80 ) + 5 )	SAY cAnoSelec					SIZE 050,10 OF oDlg PIXEL FONT oFont

oGetD :=MsNewGetDados():New(aObjSize[2,1],aObjSize[2,2],aObjSize[2,3],aObjSize[2,4],if(lAltera, GD_UPDATE, Nil),,,,aCamposAlt/*alteraveis*/,/*freeze*/,120,/*fieldok*/,/*superdel*/,/*delok*/, oDlg, aHeader, aCols )
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {|| nOpcA:=1, oDlg:End()}, {|| nOpcA:=0, oDlg:End()} ) 


If nOpcA == 1
	//Grava manutencao efetuada no Arquivo
	aCols := oGetD:ACOLS
	if !lVisualz
		GPGravaArq(cAliasArq)
	endif
Endif

//����������������������������������Ŀ
//� Apaga o Indice e Fecha Arquivo   �
//������������������������������������
GPEApgIndx(cNomArq,cAliasArq)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GPRtAMVl �Autor  �Alberto Deviciente  � Data � 30/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Valid dos campos de valores dos meses de Jan a Dez.        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GPRtAMVl(cCmp)
Local nVlrAnt 	 := GdFieldGet(SubStr(cCmp,4))
Local nVlrNew 	 := &(cCmp)
Local nVlrTotAtu := GdFieldGet("CMP_TOTAL")
Local nVlrAux 	 := 0

if nVlrAnt <> nVlrNew
	If nVlrAnt == 0 .AND. nVlrNew > 0
		Alert("N�o � permitida manuten��o em campo zerado, a altera��o ser� desconsiderada.")
		&(cCmp) := 0
	Else 
		nVlrAux := nVlrNew - nVlrAnt
	
		nVlrTotAtu += nVlrAux
	
		//Atualiza valor Total
		GdFieldPut("CMP_TOTAL", nVlrTotAtu)
	EndIf
endif

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPGravaArq�Autor  �Alberto Deviciente  � Data � 30/Nov/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua a gravacao da manutencao efetuada no arquivo que    ���
���          �possui os valores de Assist. Medica de Dependentes Rateado. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPGravaArq(cAliasArq)
Local cAno 		:= cAnoSelec
Local cMes  	:= ""
Local nInd 		:= 0
Local nX 		:= 0
Local nY 		:= 0
Local nPos  	:= 0
Local cCmpo     := ""
Local cCodDep 	:= ""
Local cCPF   	:= ""
Local cMsg      := ""
Local aMsg      := {}
Local aMeses	:= {}

aMeses:= { 	{"01", "JAN"},;
			{"02", "FEV"},;
			{"03", "MAR"},;
			{"04", "ABR"},;
			{"05", "MAI"},;
			{"06", "JUN"},;
			{"07", "JUL"},;
			{"08", "AGO"},;
			{"09", "SET"},;
			{"10", "OUT"},;
			{"11", "NOV"},;
			{"12", "DEZ"} }


for nX:= 1 to len(aCols)
	
	cCodDep := "  "
	
	for nY:=1 to len(aHeader)
		
		cCmpo := aHeader[nY][2]
		
		if cCmpo $ "CMP_IDENT|CMP_CODDEP|CMP_NOME|CMP_CPF|CMP_TOTAL"
			if cCmpo == "CMP_CODDEP"
				cCodDep := aCols[nX][nY]
			elseif cCmpo == "CMP_CPF"
				cCPF := aCols[nX][nY]
	  		endif
			Loop
  		endif
		
		nPos := aScan( aMeses, { |x| x[2] == Right(cCmpo,3) } )
		cMes := aMeses[nPos][1]
		
		if (cAliasArq)->( dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+cCodDep+cAno+cMes) )
			RecLock(cAliasArq, .F.)
			(cAliasArq)->VALOR := aCols[nX][nY]
			(cAliasArq)->( MsUnLock() )
		endif
		
	next nY
	
next nX

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPESelAno �Autor  �Alberto Deviciente  � Data � 01/Dez/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta Telinha com ComboBox para permitir o usuario escolher���
���          �qual ano gerado deseja efetuar a manutencao dos valores     ���
���          �rateados.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GPESelAno(aCmbAnos)
Local oWndCombo, oGrup, oBtnOK, oComboPer, oBtnCancel
Local cAnoCmb
Local lRet 	:= .T.
Local lOk  	:= .F.

oWndCombo := MSDIALOG():Create()
oWndCombo:cName := "oWndCombo"
oWndCombo:cCaption := "Selecione o ano"
oWndCombo:nLeft := 0
oWndCombo:nTop := 0
oWndCombo:nWidth := 370
oWndCombo:nHeight := 150
oWndCombo:lShowHint := .F.
oWndCombo:lCentered := .T.

oGrup := TGROUP():Create(oWndCombo)
oGrup:cName := "oGrup"
oGrup:cCaption := ""
oGrup:nLeft := 08
oGrup:nTop := 10
oGrup:nWidth := 350
oGrup:nHeight := 65
oGrup:lShowHint := .F.
oGrup:lReadOnly := .F.
oGrup:Align := 0
oGrup:lVisibleControl := .T.


TSay():New( 10/*<nRow>*/, 10/*<nCol>*/, {|| OemToAnsi("Selecione o ano que deseja efetuar a manuten��o dos valores.") }	/*<{cText}>*/, oWndCombo/*[<oWnd>]*/, /*[<cPict>]*/, /*<oFont>*/, /*<.lCenter.>*/, /*<.lRight.>*/, /*<.lBorder.>*/, .T./*<.lPixel.>*/, /*<nClrText>*/, /*<nClrBack>*/, 250/*<nWidth>*/, 100/*<nHeight>*/, /*<.design.>*/, /*<.update.>*/, /*<.lShaded.>*/, /*<.lBox.>*/, /*<.lRaised.>*/, /*<.lHtml.>*/ )

oCombo := TCOMBOBOX():Create(oWndCombo)
oCombo:cName := "oCombo"
oCombo:cCaption := ""
oCombo:nLeft := 23
oCombo:nTop := 42
oCombo:nWidth := 70
oCombo:nHeight := 21
oCombo:lReadOnly := .F.
oCombo:Align := 0
oCombo:cVariable := "cAnoCmb"
oCombo:bSetGet := {|u| If(PCount()>0,cAnoCmb:=u,cAnoCmb) }
oCombo:lVisibleControl := .T.
oCombo:aItems := aCmbAnos

oBtnOK := TButton():Create(oWndCombo)
oBtnOK:cName := "oBtnOK"
oBtnOK:cCaption := "Ok"
oBtnOK:nLeft := 08
oBtnOK:nTop  := 95
oBtnOK:nHeight := 22
oBtnOK:nWidth := 120
oBtnOK:lShowHint := .F.
oBtnOK:lReadOnly := .F.
oBtnOK:Align := 0
oBtnOK:bAction := {|| lOk:=.T., oWndCombo:End() }

oBtnCancel := TButton():Create(oWndCombo)
oBtnCancel:cName := "oBtnCancel"
oBtnCancel:cCaption := "Cancelar"
oBtnCancel:nLeft := 240
oBtnCancel:nTop  := 95
oBtnCancel:nHeight := 22
oBtnCancel:nWidth := 120
oBtnCancel:lShowHint := .F.
oBtnCancel:lReadOnly := .F.
oBtnCancel:Align := 0
oBtnCancel:bAction := {|| lOk:=.F., oWndCombo:End() }

oWndCombo:Activate()

if lOk
	cAnoSelec := cAnoCmb
endif

lRet := lOk

Return lRet
