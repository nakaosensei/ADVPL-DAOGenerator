/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj030ECF  �Autor  �Andre Alves Veiga   � Data �  26/09/00   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao do resumo de caixa na impressora fiscal           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Lj030ECF()

Local aCaixa 		:= {}                                           // Array com os valores do Caixa
Local cString 		:= ''											// String que sera impressa
Local nTroco        := 0                                            // Variavel que armazena o Troco
Local nTotCredito   := 0                                            // Total de Credito
Local nTotDebito    := 0                                            // Total de Debito
Local nRet 			:= 0                                            // Retorno da impressora 
Local lAberto                                                       // Se o Caixa esta aberto
Local cCaixa 		:= MV_PAR03                                     // Caixa do Resumo
Local dDataMovto 	:= MV_PAR01                                     // Data da Movimentacao
Local nI 			:= 0										    // Contador 
Local nSaldFinal	:= 0       										// Valor com o Saldo Final
Local aContFina 	:= {0,0,0,0,0,0,0,0,0 }							// Contadores utilizados nos tipos de finaliza��es 
Local aSinal  		:= {"+","+","+","+","+","","+","+","+"}			// Array com as sinais realizados 
Local nVlrCred	    := 0											// Valor do Credito 
Local aDDown		:= {}											// Array com o segundo nivel das opcoes 
Local nEstac		:= 0                                           	// Valor referente ao estacionamento (restaurante) 
Local nGorjeta		:= 0											// Valor referente a gorjeta (restaurante)
Local aDadosVen		:= {}                                          	// Array com os dados das vendas
Local aDadosSan		:= {}											// Array com os dados da sangria 
Local nOpcao		:= 0											// Define qual elemento do ListBox recebeu o DbClick 
Local nTrocoSaida   := 0											// Somatoria dos trocos de saida						
Local lUsaNMov      := .F.											// Verifica se foi criado MV_PAR09

//���������������������������������������������������������������������������������������������������������������Ŀ
//� Pergunta que define o numero do movimento - (Somente se houver a tabela SLW)																  |
//�����������������������������������������������������������������������������������������������������������������
If AliasIndic("SLW")
	lUsaNMov := .T.
Endif

//���������������������������������������������������������������Ŀ
//�Carrega array com valores totais do caixa em uma data          �
//�����������������������������������������������������������������
aCaixa := MovimCaixa( cCaixa	 , dDataMovto	, NIL		, NIL 		,;
					  NIL		 , NIL    		, NIL   	, lUsaNmov  ,  NIL )

//�������������������������������������������Ŀ
//�Alimenta Totalizadores / Arrays aDados...  �
//���������������������������������������������
Lj030Dados(	aCaixa	,	nOpcao		, 	NIL			,	@nTrocoSaida,;	
			@nTroco	,	@nTotCredito, @nTotDebito	,	@nSaldFinal	,;
			nEstac	,	nGorjeta	, @aDadosVen	,	aSinal		,;
			@aDDown	, 	aContFina	, @aDadosSan	,	nVlrCred	,)

//�������������������������������������������������������Ŀ
//�Monta o relat�rio gerencial                            �
//���������������������������������������������������������
cString := chr(10) + chr(10) + Repl('-',40) + chr(10)
cString += Space((40-Len("RESUMO DE CAIXA"))/2) + "RESUMO DE CAIXA" + chr(10)
cString += Repl('-',40) + chr(10)
cString += "Codigo do Caixa: " + SA6->A6_COD+"-"+SA6->A6_NOME + chr(10) 
cString += "Data Movimento: " + Dtoc(dDataMovto)	+ chr(10)
cString += Repl('-',40) + chr(10)
cString += Subst("Saldo Inicial: " + Space(26),1,26) + Trans(nTroco,'@E 999,999,999.99') + chr(10)
cString += Repl('-',40) + chr(10)

cString += Subst("Credito/Vendas" + Space(26),1,26) + Trans(nTotCredito,'@E 999,999,999.99')	+ chr(10)
For nI :=1 to len(aDadosVen)
	lAberto := (Left(aDadosVen[nI][1],1)=="-" .and. aDadosVen[nI][2] # 0)
	cString += padr(aDadosVen[nI][1]+" ",26,IIf(lAberto,"",".")) +;
	IIf(lAberto,"",Trans(aDadosVen[nI][2],'@E 999,999,999.99')) + Chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)

cString += Subst("Debitos/Sangrias" + Space(26),1,26) + Trans(nTotDebito,'@E 999,999,999.99') + chr(10)
For nI :=1 to len(aDadosSan)
	cString += padr(aDadosSan[nI][1]+" ",26,".") + Trans(aDadosSan[nI][2],'@E 999,999,999.99') + chr(10)
Next
cString += Repl('-',40) + chr(10) + chr(10)
cString += Subst("SALDO FINAL" + Space(26),1,26) + Trans(nSaldFinal,'@E 999,999,999.99') + chr(10)
cString += Repl('-',40) + chr(10)

//�������������������������������������������������������Ŀ
//�Envia o relat�rio para a impressora                    �
//���������������������������������������������������������

nRet := IFRelGer(nHdlECF,cString,1)
If nRet <> 0
	MsgStop("Problemas com a Impressora Fiscal")
Endif

Return
