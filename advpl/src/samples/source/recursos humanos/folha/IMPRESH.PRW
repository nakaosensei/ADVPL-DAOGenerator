#INCLUDE "Protheus.CH"
#INCLUDE "IMPRESH.CH"
#INCLUDE "MSOLE.CH"
#DEFINE   nColMax	 2335
#DEFINE   nLinMax  2900

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRESW   ºAutor  ³Wagner Montenegro            º Data ³  15/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao da Rescisao em modo Grafico Homolognet                     º±±
±±º          ³                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±  
±±³                ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS/FNC  ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Wagner C.   ³03/01/2011³30047/2010 ³Correções na impressao de dados do sindica  ³±± 
±±³            ³03/01/2011³           ³to e valor da multa 476-A                   ³±± 
±±³Mauricio MR ³06/01/2011³000185/2011³Ajuste no texto do artigo 477.			   ³±±
±±³Mauricio MR ³11/01/2011³000081/2011³Ajuste para impressao do periodo aquisitivo.³±±
±±³Mauricio MR ³12/01/2011³000455/2011³Ajuste para impressao integral do TRCT e    ³±±
±±³            ³          ³           ³dizeres dos campos.                         ³±±
±±³Mauricio MR ³13/01/2011³000608/2011³Ajuste para Impressao de verbas com inciden-³±±
±±³            ³          ³           ³cia de DSR. Ajuste na restauracao da area da³±±
±±³            ³          ³           ³SRV ao carregar verbas de hora extra. Ajuste³±±
±±³            ³          ³           ³na quebra de pagina.                    	   ³±±
±±³Christiane V³17/01/2011³000795/2011³Criação e vínculo do arquivo IMPRESH.CH.    ³±±
±±³Mauricio MR ³31/01/2011³002005/2011³Ajuste no laco de impressao do campo 95 - Ou³±±
±±³            ³          ³           ³tras verbas.								   ³±±
±±³Mauricio MR ³01/02/2011³002209/2011³Ajuste para forcar a impressao do campo 71  ³±±
±±³Mauricio MR ³16/02/2011³003385/2011³Ajuste p/ obter adequadamente remuneracao do³±±
±±³            ³          ³           ³mes anterior ao afastamento (campo 23).     ³±±
±±³Kelly Soares³10/03/2011³000954/2011³Alteracoes para impressao de ferias por     ³±±
±±³            ³          ³           ³periodos aquisitivos - homolognet.          ³±±
±±³Kelly Soares³07/04/2011³000954/2011³Horas extras ordenadas por percentual.      ³±±
±±³Renata Elena³03/05/2011³010639/2011³Ajuste na paginacao do codigo de afastamento³±±
±±³            ³          ³           ³(cCodAfa), p\paginar codigo de saque.	   ³±±
±±³Renata Elena³07/06/2011³012786/2011³Ajuste na paginacao da qtd de horas do      ³±±
±±³            ³          ³           ³adicional noturno p\paginar com 2 decimais  ³±±
±±³Mauricio MR ³22/06/2011³013409/2011³Ajuste para descontar as verbas de descontos³±±
±±³            ³          ³           ³no saldo de salario qdo solicitado.		   ³±±
±±³Mauricio MR ³06/07/2011³012011/2011³Ajuste p/ iniciar a numeracao dos descontos ³±±
±±³            ³          ³           ³denominados "Outros" em '115'.			   ³±±
±±³Mauricio MR ³20/07/2011³016177/2011³Ajuste p/ deduzir do saldo de salario dedu- ³±±
±±³            ³          ³           ³coes determinadas na parametrizacao da roti-³±±
±±³            ³          ³           ³na , mesmo que o total de deducoes seja i-  ³±±
±±³            ³          ³           ³gual ao saldo de salario.				   ³±±
±±³Mauricio MR ³22/07/2011³017012/2011³Ajuste p/ considerar o parametro 14, para   ³±±
±±³            ³          ³           ³imprimir ou nao a data de homologacao/local.³±±
±±³Renata Elena³25/08/2011³023283/2011³Ajuste na paginacao do item 66.ferias inde- ³±±
±±³            ³          ³           ³nizadas, mesmo que funcionario nao tenha.   ³±±
±±³Allyson M   ³16/09/2011³022500/2011³Ajuste no desconto de valores no campo 50.  ³±±
±±³            ³          ³           ³Caso as verbas informadas sejam em horas,   ³±±
±±³            ³          ³           ³efetua a conversao em dias, conforme horas/ ³±±
±±³            ³          ³           ³dia do cadastro do funcionario. 			   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function IMPRESH()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis PRIVATE utilizadas para Impressao Grafica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nPos		:= 0				//LINHA DE IMPRESSAO DO RELATORIO GRAFICO
Private nTot		:= 0
Private nNumMax		:= 18			//Numero maximo de verbas impressas no Detalhe da rescisao 
Private nImprime	:= 1 				//Variavel Auxiliar 
Private nImpre		:= 1 
Private CONTFL		:= 1				//CONTA PAGINA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Objetos para Impressao Grafica - Declaracao das Fontes Utilizadas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oFont06,oFont08, oFont08n,oFont09, oFont09n,oFont10,oFont10n, oFont14n, oFont16n

oFont06	:= TFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
oFont08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont09	:= TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
oFont10	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont08n:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)	//Negrito//
oFont09n:= TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.)    //Negrito//
oFont10n	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oFont14n:= TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)    //Negrito//
oFont16n:= TFont():New("Courier New",16,16,,.T.,,,,.T.,.F.)    //Negrito//

nEpoca:= SET(5,1910)
//-- MUDAR ANO PARA 4 DIGITOS 
SET CENTURY ON 

fHomolog()

Set(5,nEpoca)
If nTdata > 8
	SET CENTURY ON
Else
	SET CENTURY OFF
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fHomolog  ³ Autor ³ Wagner Montenegro     ³ Data ³ 15.12.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Formulario Homolonet                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fHomolog()

Local cCateg	:= fCateg(0)
Local aString	:= {} 
Local nBloco1	:=360
Local nX
Local nPT :=05
Local nPD :=30
Local aAreaSRD
Local aAreaSRV
Local nOrderSRD
Local nFalta	:= 0
Local nY,nW
Local nCkHomV:=0
Local n_XX 
Local n_X
Local n_Y
Local n_XX1
Local n_X1
Local n_Y1,nFor,nT
Local aPreSelect	:={}
Local cPreSelect	:=MV_PAR32
Local nAchou		:=0
Local cD1			:=""
Local cD2			:=""
Local aPer			:= {}
Local nBoxIni		:=0
Local cOrgao		:=""  
Local nCont   
Local nPosFixa 		:= 0
Local cVrbFixa 		:= ""
Local cString      
Local cCompet 		:= GetMv( "MV_FOLMES",,Space(06) ) 
Local cDSRSalV		:= LoadCodDSR(.F.,SRA->RA_FILIAL)    
Local lTemVerba 	:= .F.
Local aTab25  		:= {}
Local nPenunSal 	:= 0.00
Local cCodSaqIOB	:= "01_02_03_04_05_06_07_10_23_26_27_50_70_80_81_82_86_87_88_91_92_93_94_95"  //Codigos de Saque Validos Segundo o Calendario de    Obrigacoes e Tabelas Praticas do IOB de Out/99 Paginas 62 a 68. 
Local cItem			:= ''
Local cTpFalta		:= ""

Private aCpoForm	:={}
Private aCpoFor1	:={}
Private aCpoFormD	:={}
Private cPercSRV	:=""
Private aCpoExtra	:={}
Private nCl01a		:=60
Private nCl01b		:=510
Private nCl02a		:=780
Private nCl02b		:=1295
Private nCl03a		:=1567
Private nCl03b		:=2065
Private nL			:=0 
Private nTamL		:=10
Private nAddL		:=65
Private nXCol 
Private cCodAfa 	:= ""
                           

Static aCodFol:={}   

fp_CodFol( @aCodFol , xFilial("SRV"), .F. ) 

oPrint:StartPage() 			//Inicia uma nova pagina  

Aadd(aCpoForm,{"72",2,"Percentagem","006","",""})
Aadd(aCpoForm,{"73",2,"Prêmios","008","",""})
Aadd(aCpoForm,{"74",2,"Viagens","010","",""})
Aadd(aCpoForm,{"75",2,"Sobreaviso","015","",""})
Aadd(aCpoForm,{"76",2,"Prontidão","016","",""})
Aadd(aCpoForm,{"77",2,"Adicional por tempo de serviço","018","",""})
Aadd(aCpoForm,{"78",2,"Adicional por Transferência de Localidade de Trabalho","019","",""})
Aadd(aCpoForm,{"79",2,"Salário Família excedente ao Valor Legal","020","",""})
Aadd(aCpoForm,{"80",2,"Abono/Gratificação de Férias Excedente 20 dias de salário","021","",""})
Aadd(aCpoForm,{"81",2,"Valor global diárias para viagem Excedente 50% salário","022","",""})
Aadd(aCpoForm,{"82",2,"Ajuda de Custo art. 470/CLT","023","",""})
Aadd(aCpoForm,{"83",2,"Etapas marítimos","024","",""})
Aadd(aCpoForm,{"84",2,"Licença Prêmio indenizada","025","",""})
Aadd(aCpoForm,{"85",2,"Quebra de Caixa","026","",""})
Aadd(aCpoForm,{"86",2,"PLR","027","",""})
Aadd(aCpoForm,{"87",2,"Indenização a Título de Incentivo à demissão","028","",""})
Aadd(aCpoForm,{"88",2,"Bolsa Aprendizagem","029","",""})
Aadd(aCpoForm,{"89",2,"Abonos Desvinculados do Salário","030","",""})
Aadd(aCpoForm,{"90",2,"Ganhos Eventuais Desvinculados do Salário","031","",""})
Aadd(aCpoForm,{"91",2,"Reembolso Creche","032","",""})
Aadd(aCpoForm,{"92",2,"Reembolso Babá","033","",""})
Aadd(aCpoForm,{"93",2,"Gratificação Semestral","034","",""})

Aadd(aCpoFor1,{"96",1,"Indenização art 9º Lei 7238/84","178","",""})
Aadd(aCpoFor1,{"98",2,"Multa art. 476-A & 5º da CLT","036","",""})
Aadd(aCpoFor1,{"99",1,"Ajuste do Saldo Devedor","045","",""})

Aadd(aCpoFormD,{"115",1,"Outros descontos não previstos acima","","",""})

GPER140Sum(1,,,.T.)
GPER140Sum(2,,,.T.)
For nY:=1 to Len(aCpoForm)
	If Val(Strtran(StrTran(aCpoForm[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next
For nY:=1 to Len(aCpoFor1)
	If Val(Strtran(StrTran(aCpoFor1[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next
For nW:= 1 to Len(aHomV)
	If aHomV[nW,7]==0
	   nCkHomV++
	Endif
Next	   
If nCkHomV>=3
	nTamL:=nTamL+Int(nCkHomV/3)	
Endif              

fRetTab(@aTab25,"S025",,,,,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³TERMO DE RESCISAO DO CONTRATO DE TRABALHO                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nL:=005
//oPrint:Box(nL, 035,nL+nAddL+10+nAddL+(nAddL*4)+(nAddL*3)+20+10+20+(nAddL*6) , nColMax ) 		//-- Box p/ Tit. "TERMO DE RESCISÃO DO CONTRATO DE TRABALHO"

oPrint:Box(nL, 035,nL+(nAddL-50)+(nAddL+10)+nPT+10+nAddL+nAddL+(nAddL*3)+20+nPT+nAddL+(nAddL*4)+nAddL+(nAddL*3)  , nColMax ) 		//-- Box p/ Tit. "TERMO DE RESCISÃO DO CONTRATO DE TRABALHO"

nL:=nL+nAddL-50
oPrint:say (nL,500,STR0003, oFont16n) //-- "TERMO DE RESCISÃO DO CONTRATO DE TRABALHO"

nL:=nL+nAddL+10
oPrint:line(nL,035 ,nL,nColMax) 			//Linha Horizontal

nL:=nL+nPT+nPT
oPrint:say (nL,840,STR0002, oFont14n) 	//-- "IDENTIFICAÇÃO DO EMPREGADOR"



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IDENTIFICACAO DO EMPREGADOR                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nL:=nL+nAddL
//oPrint:Box( nL , 0035 , nL+(nAddL*3) ,nColMax ) 	//-- Box Identificacao do Trabalhador
                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a impressao do texto na vertical                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oPrint:line(nL,035 ,nL,nColMax) 							//Linha Horizontal
oPrint:line(nL,735 ,nL+nAddL,735 )							//Linha Vertical Meio
oPrint:say (nL+10,0060,STR0056, oFont06) 		 			//"01- CNPJ/CEI: 	
oPrint:say (nl+10,0750,STR0001, oFont06)					//"02- Razão Social / Nome:"
oPrint:say (nL+nPD,060 ,SUBSTR(aInfo[8]+Space(20),1,20), oFont10 ) //"|01- CNPJ: 
oPrint:say (nL+nPD,765 ,aInfo[3], oFont10 )					//"02- Razao Social / Nome:"

oPrint:line(nL+nAddL,035 ,nL+nAddL,nColMax) 				//Linha Horizontal	
oPrint:line(nL+nAddL,1600,nL+(nAddL*2),1600)				//Linha Vertical Meio	BAIRRO
oPrint:say (nL+nAddL+10,060 ,"03 "+STR0005, oFont06)  
oPrint:say (nL+nAddL+10,1620,"04 "+STR0014, oFont06)		//04 Bairro : "
oPrint:say (nL+nAddL+nPD,065 ,aInfo[4], oFont09)			//03 Endereco   : "
oPrint:say (nL+nAddL+nPD,920 ,aInfo[14], oFont09)			//03 Complemento
oPrint:say (nL+nAddL+nPD,1835,aInfo[13], oFont09)	   		//04 Bairro : "
	
oPrint:line(nL+(nAddL*2),850 ,nL+(nAddL*3),850 )		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2),1150,nL+(nAddL*3),1150)		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2),1500,nL+(nAddL*3),1500)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2),1750,nL+(nAddL*3),1750)		//Linha Vertical Meio
oPrint:line(nL+(nAddL*2),0035,nL+(nAddL*2),nColMax) 	//Linha Horizontal
oPrint:say (nL+(nAddL*2)+10,060 ,"05 "+STR0015, oFont06)										//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+10,870 ,"06 "+STR0016, oFont06)										//"|06 UF : "
oPrint:say (nL+(nAddL*2)+10,1170,"07 "+STR0013, oFont06)								   	//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+10,1520,"08 "+STR0017, oFont06)										//"|08 CNAE " 
oPrint:say (nL+(nAddL*2)+10,1770,"09 "+STR0004, oFont06)										//"|09 CNPJ/CEI Tomador/Obra: "

oPrint:say (nL+(nAddL*2)+nPD,075 ,aInfo[5] , oFont09)									   	//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+nPD,885 ,aInfo[6] , oFont09)									   	//"|06 UF : "
oPrint:say (nL+(nAddL*2)+nPD,1185,aInfo[7] , oFont09)									  		//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+nPD,1535,aInfo[16], oFont09)									  		//"|08 CNAE"
oPrint:say (nL+(nAddL*2)+nPD,1785,Substr(fDesc("CTT",SRA->RA_CC,"CTT_CEI")+Space(5),1,15), oFont09)//"|09 CNPJ/CEI Tomador/Obra: "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³IDENTIFICACAO DO TRABALHADOR                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nL:=535
nL:=nL+(nAddL*3)+10 

//oPrint:Box(nL, 035,nL+81+(nAddL*4), nColMax ) 	//-- Box p/ Tit. Identificacao do Trabalhador 
oPrint:line(nL,035 ,nL,nColMax) 		//Linha Horizontal	
oPrint:say (nL+10,810,STR0006, oFont14n)  
nL:=nL+10
oPrint:line(nL+nAddL,035 ,nL+nAddL,nColMax) 		//Linha Horizontal		 											//-- Identificacao do Trabalhador 
nL:=nL+nPT
nL:=nL+nAddL

oPrint:say (nL+nPT,060 ,STR0025, oFont06) 		//"10 PIS/PASEP:" 
oPrint:say (nL+nPT,525 ,STR0023, oFont06)		//"11 NOME:"
oPrint:line(nL+nAddL,035 ,nL+nAddL,nColMax) 	//Linha Horizontal
oPrint:line(nL,505 ,nL+nAddL,505 )				//Linha Vertical Meio	

oPrint:say (nL+nPD,065 ,SRA->RA_PIS,oFont10) //PIS
If SRA->(FieldPos("RA_NOMECMP")) # 0 .And. !Empty(SRA->RA_NOMECMP)
	oPrint:say (nL+nPD,525 ,Subs(SRA->RA_NOMECMP+Space(60),1,60),oFont10) //NOME
Else
	oPrint:say (nL+nPD,525 ,Subs(SRA->RA_NOME+Space(30),1,30),oFont10) //NOME
EndIf	
	
oPrint:say (nL+nAddL+nPT,060 ,"12 "+STR0005, oFont06)  	
oPrint:say (nL+nAddL+nPT,1820,"13 "+STR0014, oFont06)	  	//"|04 Bairro : "
oPrint:say (nL+nAddL+nPD,065 ,SRA->RA_ENDEREC, oFont09)	//"|03 Endereco   : "
oPrint:say (nL+nAddL+nPD,920 ,SRA->RA_COMPLEM, oFont09)	//"|03 Complemento
oPrint:say (nL+nAddL+nPD,1835,SRA->RA_BAIRRO, oFont09)	//"|04 Bairro : "
oPrint:line(nL+(nAddL*2),035 ,nL+(nAddL*2),nColMax) 		//Linha Horizontal
oPrint:line(nL+nAddL,1805,nL+(nAddL*2),1805)					//Linha Vertical Meio	

oPrint:say (nL+(nAddL*2)+nPT,060 ,"14 "+STR0015, oFont06)	//"|05 Munic.: "
oPrint:say (nL+(nAddL*2)+nPT,870 ,"15 "+STR0016, oFont06)	//"|06 UF : "
oPrint:say (nL+(nAddL*2)+nPT,1170,"16 "+STR0013, oFont06)	//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+nPT,1520,"17 "+STR0024, oFont06)	//"|08 CNAE"

oPrint:say (nL+(nAddL*2)+nPD,065 ,SRA->RA_MUNICIP, oFont09)	//"|05 Munic.: " 
oPrint:say (nL+(nAddL*2)+nPD,890 ,SRA->RA_ESTADO , oFont09)	//"|06 UF : "
oPrint:say (nL+(nAddL*2)+nPD,1185,SRA->RA_CEP , oFont09)		//"|07 Cep: "
oPrint:say (nL+(nAddL*2)+nPD,1535,SRA->RA_NUMCP+"- "+SRA->RA_SERCP+"/"+SRA->RA_UFCP, oFont09)	//"|08 CNAE"

oPrint:line(nL+(nAddL*3),035 ,nL+(nAddL*3),nColMax) 	//Linha Horizontal 
oPrint:line(nL+(nAddL*2),850 ,nL+(nAddL*3),850 )		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2),1150,nL+(nAddL*3),1150)		//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2),1500,nL+(nAddL*3),1500)		//Linha Vertical Meio	

oPrint:say (nL+(nAddL*3)+nPT,060 , STR0012, oFont06)	//18 CPF:"
oPrint:say (nL+(nAddL*3)+nPT,780 , STR0027, oFont06)	//19 Nasc.:"
oPrint:say (nL+(nAddL*3)+nPT,1400, STR0007, oFont06)	//20 Nome da Mae"
oPrint:say (nL+(nAddL*3)+nPD,065 , SRA->RA_CIC, oFont09)	//18 CPF:"
oPrint:say (nL+(nAddL*3)+nPD,880 , DtoC(SRA->RA_NASC), oFont09)	//19 Nasc.:"
oPrint:say (nL+(nAddL*3)+nPD,1420, SUBSTR(SRA->RA_MAE+Space(30),1,40), oFont09)	//20 Nome da Mae"  
oPrint:line(nL+(nAddL*3),0770,nL+(nAddL*4),0770)	//Linha Vertical Meio	
oPrint:line(nL+(nAddL*3),1390,nL+(nAddL*4),1390)	//Linha Vertical Meio	

nL:=nL+(nAddL*4)+nPT
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DADOS DO CONTRATO	                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//oPrint:Box(nL, 035,nL+70+80+(nAddL*3), nColMax ) 	//-- Box p/ Tit. "DADOS DO CONTRATO"
oPrint:Line(nL,035,nL,nColMax) //Linha Horizontal
oPrint:say (nL+10,0975,STR0008, oFont14n) //-- "DADOS DO CONTRATO"
nL:=nL+nAddL
oPrint:Box(nL,035,nL,nColMax) //Linha Horizontal
oPrint:line(nL,1172 ,nL+nAddL,1172 )	//Linha Vertical Meio	
oPrint:say (nL+nPT,060	,STR0009	  , oFont06) 
oPrint:say (nL+nPD,080	,If( ( ( SRA->RA_TPCONTR=="1" ) .or. Empty(SRA->RA_TPCONTR)),;
								STR0010							  ,;
								If(SRA->RA_CLAURES=="1", STR0011, STR0018)), oFont09) 
oPrint:say (nL+nPT,1172+15,STR0019, oFont06) 
oPrint:say (nL+nPD,1172+30,SubStr(cCausa+Space(30),1,30), oFont09) 

oPrint:say (nL+nAddL+nPT,060	,STR0020	, oFont06) 
aAreaSRD:=GetArea()
nOrderSRD:=SRD->(DbSetOrder())
//SRD->(DbSetOrder(RETORDER("SRD","RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC")))
                                                                                                         
//If SRD->(DbSeek(xFilial("SRD")+SRA->RA_MAT+ALLTRIM(STR(YEAR(SRG->RG_DATADEM)))+ALLTRIM(STR(MONTH(SRG->RG_DATADEM)))+aCodFol[Val("318"),1]))
//	oPrint:say (nL+nAddL+nPD,080	,Transform(SRD->RD_VALOR, "@E 999,999,999.99"), oFont09) 
//Else
//	oPrint:say (nL+nAddL+nPD,080	,Transform(SRG->RG_SALMES,"@E 999,999,999.99"), oFont09)  
//Endif
//SRD->(DbSetOrder(nOrderSRD))

nPenunSal:= PenunSal(SRA->RA_ADMISSA, SRG->RG_DATADEM, '', /*cFolMes*/, acodfol[318,1])
IF Empty(nPenunSal)  
	nPenunSal:= SRG->RG_SALMES
Endif

oPrint:say (nL+nAddL+nPD,080	,Transform(nPenunSal,"@E 999,999,999.99"), oFont09) 

DbSelectArea(aAreaSRD)

oPrint:say (nL+nAddL+nPT,586+15,STR0021	, oFont06) 
oPrint:say (nL+nAddL+nPD,586+30,DtoC(SRA->RA_ADMISSA), oFont09) 
oPrint:say (nL+nAddL+nPT,1172+15,STR0022, oFont06) 
oPrint:say (nL+nAddL+nPD,1172+30,DtoC(SRG->RG_DTAVISO), oFont09) 
oPrint:say (nL+nAddL+nPT,1758+15,STR0026, oFont06) 
oPrint:say (nL+nAddL+nPD,1758+30,DtoC(SRG->RG_DATADEM), oFont09) 

oPrint:line(nL+nAddL,0586,nL+(nAddL*2),0586)	//Linha Vertical Meio	
oPrint:line(nL+nAddL,1172,nL+(nAddL*2),1172)	//Linha Vertical Meio	
oPrint:line(nL+nAddL,1758,nL+(nAddL*2),1758)	//Linha Vertical Meio
oPrint:line(nL+nAddL,035 ,nL+nAddL,nColMax) 	//Linha Horizontal
          
IF !(StrZero(Val(cCodSaq),2) $ cCodSaqIOB)  //Imprime NAO se Codigo nao for de Saque.
	cCodAfa := "NAO"
Else
	cCodAfa := cCodSaq
EndIF

oPrint:say (nL+(nAddL*2)+nPT,060	,STR0028	, oFont06) 
oPrint:say (nL+(nAddL*2)+nPD,080	,cCodAfa, oFont09) 
oPrint:say (nL+(nAddL*2)+nPT,586+15,STR0029	, oFont06) 
oPrint:say (nL+(nAddL*2)+nPD,586+30,Transform(nPerPensa,"@E 999.99"), oFont09) 
oPrint:say (nL+(nAddL*2)+nPT,1172+15,STR0030	, oFont06) 
oPrint:say (nL+(nAddL*2)+nPD,1172+30,Transform(nPerFGTS,"@E 999.99"), oFont09) 
oPrint:say (nL+(nAddL*2)+nPT,1758+15,STR0031	, oFont06) 
oPrint:say (nL+(nAddL*2)+nPD,1758+30,cCateg, oFont09) 

oPrint:line(nL+(nAddL*2),0586,nL+(nAddL*3),586 )										//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2),1172,nL+(nAddL*3),1172)											//Linha Vertical Meio	
oPrint:line(nL+(nAddL*2),1758,nL+(nAddL*3),1758)											//Linha Vertical Meio
oPrint:line(nL+(nAddL*2),035 ,nL+(nAddL*2),nColMax) 										//Linha Horizontal

IF MV_PAR25 == 1
	cOrgao	:=	fGetOrgao(SRA->RA_SINDICA,xFilial("RCE"))
ElseIf MV_PAR25 == 2
	cOrgao	:=	fGetOrgao(MV_PAR26,xFilial("RCE"))
Else                                            
	cOrgao	:=	""
EndIf

oPrint:say (nL+(nAddL*3)+nPT,060	,STR0033	, oFont06)
oPrint:say (nL+(nAddL*3)+nPT,780+15 ,STR0034	, oFont06) 
If MV_PAR25 <> 3
	oPrint:say (nL+(nAddL*3)+nPD,080	,RCE->RCE_ENTSIN, oFont09) 
	oPrint:say (nL+(nAddL*3)+nPD,780+30,RCE->RCE_CGC+" "+RCE->RCE_DESCRI, oFont09) 
Endif	

oPrint:line(nL+(nAddL*3),0780,nL+(nAddL*4),780 )											//Linha Vertical Meio	
oPrint:line(nL+(nAddL*3),035 ,nL+(nAddL*3),nColMax) 										//Linha Horizontal

nL:=nL+(nAddL*4)+20

oPrint:Box(nL, 035,nL+140, nColMax ) 	//-- Box p/ Tit. "DISCRIMINAÇÃO DAS VERBAS RESCISÓRIAS"
oPrint:say (nL+10,0725,STR0035, oFont14n) 	//-- "DISCRIMINAÇÃO DAS VERBAS RESCISÓRIAS"
oPrint:line(nL+70,035 ,nL+70,nColMax) 	//Linha Horizontal
oPrint:say (nL+80,0960,STR0036, oFont14n) //-- "VERBAS RESCISÓRIAS"

nL:=nL+140
nBoxIni:=nL      

// -------------------------------------------------------------------------------------------------------
//  Cabecalho de Verbas Rescisorias
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+02,nCl01a		,STR0037	, oFont08) //"RUBRICAS"
oPrint:say (nL+02,nCl01b+30		,STR0038	, oFont08) //"VALOR"
oPrint:say (nL+02,nCl02a+30		,STR0037	, oFont08) //"RUBRICAS"
oPrint:say (nL+02,nCl02b+30		,STR0038	, oFont08) //"VALOR"
oPrint:say (nL+02,nCl03a+30		,STR0037	, oFont08) //"RUBRICAS"
oPrint:say (nL+02,nCl03b+30		,STR0038	, oFont08) //"VALOR"
nL+=nAddL-40
oPrint:line(nL,035,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |50| Saldo de dias trabalhados 
// -------------------------------------------------------------------------------------------------------
n_Y:=0
n_Y1:=0
n_X:= GPER140Sum(1,1,"048/112",,,1)    //Considerar aviso previo trabalhado no mes como saldo de salario
n_X1:=GPER140Sum(1,1,"048/112",,2,1)
If !(Empty(Alltrim(cPreSelect)))
   	For nFor := 1 To Len( Alltrim(cPreSelect) ) Step 3
		aAdd( aPreSelect , SubStr( cPreSelect , nFor , 3 ) )
	Next nFor
	For nY:= 1 to Len(aPreSelect)
		For nT:= 1 to Len(aHomD)
			If aHomD[nT,4]==aPreSelect[nY]
				//-- Verifica se o tipo de lancamento da verba e' em horas ou em dias
				cTpFalta := PosSrv(aHomD[nT,4],SRA->RA_FILIAL,"RV_TIPO")
				//-- Se Verba e' em horas, converte as horas de falta em dias de acordo com as horas/mes do cadastro do funcionario
				If cTpFalta == "H"
					nFalta := Int(aHomD[nT,2]/Round(SRA->RA_HRSMES/30,2))
					//-- Se a falta for menor do que um dia, nao sera descontada do campo 50
					If nFalta >= 1
						n_Y	+= aHomD[nT,3]
						n_Y1+= nFalta
						aHomD[nT,7]	:= 2
					EndIf
			   	//-- Se Verba e' em Dias, utiliza os valores diretamente
			   	ElseIf cTpFalta == "D"
					n_Y	+= aHomD[nT,3]
					n_Y1+= aHomD[nT,2]
					aHomD[nT,7]	:= 2
			   	EndIf
			Endif
		Next
	Next
Else
   n_Y:=0
   n_Y1:=0
Endif	
n_XX := n_X - n_Y   //Valor
n_XX1:= n_X1 - n_Y1 //Dias
If n_X >= n_Y .and. n_X1 >= n_Y1 
    //-- Retira o valor anteriormente somado ao Provento
    nProv-= n_X
    //-- Recompoe o valor de provento através do valor liquido do saldo de salario
    nProv+= n_XX
    
    //-- Recompoe o valor do desconto, deduzindo as faltas (ou demais verbas correspondentes) utilizadas
    //-- no calculo do saldo de salario liquido
    nDesc-= n_Y
      
	oPrint:say (nL+nPT,nCl01a		,STR0039 + If(n_XX1<0,"00",StrZero(n_XX1,2)) + STR0040, oFont06) // 50 Saldo de 00/dias Salario 
	oPrint:say (nL+nPD,nCl01a		,STR0042 + StrZero(n_Y1,3)+STR0041, oFont06)                      //(liquido de 000/faltas acresc. do DSR)
	oPrint:say (nL+nPD,nCl01b+10	,If(n_XX<0,"         0.00",TransForm(n_XX,"@E 99,999,999.99")), oFont09) 
Else
	oPrint:say (nL+nPT,nCl01a		,STR0039 + StrZero(n_X1,2) + STR0040, oFont06) 
	oPrint:say (nL+nPD,nCl01a		,STR0043, oFont06) 
	oPrint:say (nL+nPD,nCl01a		,STR0044, oFont06) 			
	oPrint:say (nL+nPD,nCl01b+10	,TransForm(n_X,"@E 99,999,999.99"), oFont09) 
Endif			                        

// -------------------------------------------------------------------------------------------------------
//  |51| Comissoes
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,nCl02a+30	,STR0045, oFont06)  //"51 Comissoes"
oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(1,2,"007"), oFont09) 

// -------------------------------------------------------------------------------------------------------
//  |52| Gratificacoes
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,nCl03a+30	,STR0046, oFont06)  //"52 Gratificacoes"
oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(1,2,"017"), oFont09) 

nL+=nAddL
oPrint:line(nL,035,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |53| Insalubridade
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,nCl01a		,STR0047, oFont06)  //"53 Adicional de Insalubridade"
oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(1,2,"013"), oFont09) 

// -------------------------------------------------------------------------------------------------------
//  |54| Periculosidade
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,nCl02a+30	,STR0048, oFont06)  //"54 Adicional de Periculosidade"
oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(1,2,"014"), oFont09)

// -------------------------------------------------------------------------------------------------------
//  |55| Adicional Noturno
// -------------------------------------------------------------------------------------------------------
cPercSRV:="" 
oPrint:say (nL+nPT,nCl03a+30	,STR0049 + TransForm(GPER140Sum(1,2,"012",,2,1),"@E 999.99") + STR0050, oFont06) // "55 Adicional Noturno XX horas"
oPrint:say (nL+nPD,nCl03a+30	,cPercSRV+" %", oFont06) 
oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(1,2,"012"), oFont09) 
nL+=nAddL
oPrint:line(nL,035,nL,nColMax )

// -------------------------------------------------------------------------------------------------------
//  |56| Horas Extras
// -------------------------------------------------------------------------------------------------------

aAreaSRV:=GetArea()
SRV->(DbSetOrder(RETORDER("SRV","RV_FILIAL+RV_HOMOLOG+STR(RV_PERC,7,3)+RV_COD")))
SRV->(DbSeek(xFilial("SRV")+"004")) //004 = Cod.Homolognet p/ H.Extra
While !SRV->(EOF()) .and. SRV->RV_HOMOLOG=="004"
	Aadd(aCpoExtra,{"56.",2,SRV->RV_DESC,(SRV->RV_PERC-100),0,0,SRV->RV_COD,""})
	SRV->(DbSkip())
Enddo 
RestArea(aAreaSRV)
aSort(aCpoExtra,,,{|x,y| x[7] < y[7]}) //ordenado por codigo da verba

nCont := 1
For nY := 1 to Len(aCpoExtra)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCpoExtra[nY,7]}) ) > 0	.and. aHomV[nAchou,3] > 0
		aCpoExtra[nY,1] += cValToChar(nCont)
		aCpoExtra[nY,5] += aHomV[nAchou,2]
		aCpoExtra[nY,6] += aHomV[nAchou,3]						
		aHomV[nAchou,7]:=1
		nCont++
	Else
		aCpoExtra[nY,8] := "D" //Deletado
	Endif
Next nY

aSort(aCpoExtra,,, {|x,y| x[8]+Str(x[4])+x[7] < y[8]+Str(y[4])+y[7]})
nXCol := 1
If ( Len(aCpoExtra) = 0 ) .or. ( Len(aCpoExtra) > 0 .and. !Empty(aCpoExtra[1,8]) )
	oPrint:say (nL+nPT,nCl01a		,"56 " + STR0051 + " 0,00" + STR0050, oFont06) 
	oPrint:say (nL+nPD,nCl01a		,"   0,00%"	, oFont06) 
	oPrint:say (nL+nPD,nCl01b+10	,TransForm(0,"@E 99,999,999.99"), oFont09)
	fNewLine()    				
Else
	For nY := 1 to Len(aCpoExtra)
		If !Empty(aCpoExtra[nY,8])
			Exit
		Endif
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),aCpoExtra[nY,1] + STR0051 + TransForm(aCpoExtra[nY,5],"@E 999.99") + STR0050, oFont06)
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,80,40),TransForm(aCpoExtra[nY,4],"@E 999.99") + "%", oFont06)
		oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aCpoExtra[nY,6],"@E 99,999,999.99"), oFont09)
		fNewLine()
	Next nY
Endif
           
// -------------------------------------------------------------------------------------------------------
//  |57| Gorjetas
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0052, oFont06) 
oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,2,"011"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |58| DSR
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0053, oFont06)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0054, oFont06)
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"033"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |59| Reflexo do DSR
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0057, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0058, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1, 1,cDSRSalV,/*lCampo*/,/*nRef*/,/*nType*/,.T.), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |60| Multa Art. 477
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0059, oFont06)  
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,2,"009"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |61| Multa Art. 479
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),STR0060, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"176"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |62| Salario Familia
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0055, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"034"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |63| 13o. Salario Proporcional
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0061, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), GPER140Sum(1,1,"114",,2)+"/12 avos"	, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"114/251"), oFont09) 
fNewLine()
                  
// -------------------------------------------------------------------------------------------------------
//  |64| 13o. Salario Vencido
// -------------------------------------------------------------------------------------------------------
If Len(aTab25) > 0 .and. (nAchou := aScan(aTab25, {|x| x[5] = '64'})) > 0
	cVrbFixa := aTab25[nAchou,6]
	nPosFixa := aScan(aHomV, {|x| x[4] = cVrbFixa})
Endif

If nPosFixa > 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0062 + " " + SubStr(aHomV[nPosFixa,9],3,4), oFont06)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), SubStr(aHomV[nPosFixa,9],1,2) + "/12 " + STR0064, oFont06)  
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(aHomV[nPosFixa,3],"@E 99,999,999.99"), oFont09)  
	aHomV[nPosFixa,7] := 1
Else
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0062 + " AAAA", oFont06)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), " __/12 " + STR0064, oFont06)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont09)  
Endif
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |65| Ferias Proporcionais
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0065, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), GPER140Sum(1,1,"087",,2)+"/12 " + STR0064, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"087/249"), oFont09)
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |66| Ferias Vencidas
// -------------------------------------------------------------------------------------------------------
aPer := fPerArquisitivo()
If Len(aPer) = 0 .or. (Len(aPer) == 1 .and. aPer[1,5] < 30)
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), "66 " + STR0066, oFont06) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), '  /  /  '+" a "+'  /  /  '+"__/12 " + STR0064, oFont06)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont09)  
	fNewLine()
Else
	nCont := 1
	For nY := 1 to Len(aPer)            
		If aPer[nY,4] > 0
			oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), "66." + cValToChar(nCont) + " " + STR0066, oFont06) 
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),DTOC(aPer[nY,1])+" a "+DTOC(aPer[nY,2])+" "+GPER140Sum(1,1,"086",,2,,,DTOS(aPer[nY,1]) + " - " + DTOS(aPer[nY,2]))+"/12 "+ STR0064, oFont06)
			oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,GPER140Sum(1,1,"086/248",,,,,DTOS(aPer[nY,1]) + " - " + DTOS(aPer[nY,2])), oFont09)
			fNewLine()
			nCont++
		Endif
	Next nY
Endif

// -------------------------------------------------------------------------------------------------------
//  |67| Ferias em Dobro
// -------------------------------------------------------------------------------------------------------
aPerDobra := {}
If aCodFol[224,1] # Space(3)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCodFol[224,1]}) ) > 0
		While nAchou <= Len(aHomV) .and. aHomV[nAchou,4]==aCodFol[224,1]
			cString := aHomV[nAchou,9]
			aAdd(aPerDobra,{STOD(SubStr(cString,1,At("-",cString)-1)),STOD(SubStr(cString,At("-",cString)+2,Len(cString))),aHomV[nAchou,3]})
			aHomV[nAchou,7]:=1
			nAchou++
		Enddo
	Endif
Endif
If aCodFol[925,1] # Space(3)
	If ( nAchou := Ascan(aHomV,{|x| x[4]==aCodFol[925,1]}) ) > 0
		While nAchou <= Len(aHomV) .and. aHomV[nAchou,4]==aCodFol[224,1]
			cString := aHomV[nAchou,9]
			aAdd(aPerDobra,{STOD(SubStr(cString,1,At("-",cString)-1)),STOD(SubStr(cString,At("-",cString)+2,Len(cString))),aHomV[nAchou,3]})
			aHomV[nAchou,7]:=1
			nAchou++
		Enddo
	Endif
Endif

If Len(aPerDobra) = 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), "67 " + STR0063, oFont06) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), '  /  /  '+STR0067+'  /  /  ', oFont06)
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(0,"@E 99,999,999.99"), oFont09)  
	fNewLine()
Else
	aSort(aPerDobra,,,{|x,y| x[1] < y[1]})
	For nY := 1 to Len(aPerDobra)
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), "67." + cValToChar(nY) + " " + STR0063, oFont06) 
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),DTOC(aPerDobra[nY,1])+STR0067+DTOC(aPerDobra[nY,2]), oFont06)
		oPrint:say (nL+nPD,	&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aPerDobra[nY,3],"@E 99,999,999.99"), oFont09)
		fNewLine()
	Next nY
Endif

// -------------------------------------------------------------------------------------------------------
//  |68| 1/3 de Ferias 
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0068, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10	,GPER140Sum(1,1,"125/226/231/926"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |69| Aviso Previo Indenizado
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0069, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"111/250"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |70| 13o. Salario s/ Aviso Previo
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0070, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0071, oFont06) 		
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"115/253"), oFont09) 
fNewLine()

// -------------------------------------------------------------------------------------------------------
//  |71| Ferias s/ Aviso Previo
// -------------------------------------------------------------------------------------------------------
oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0119, oFont06) 
oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, GPER140Sum(1,1,"230/252"), oFont09) 
fNewLine()
       
// -------------------------------------------------------------------------------------------------------
//  |72| Percentagem - A - |93| Gratificacao Semestral
// -------------------------------------------------------------------------------------------------------
For nY := 1 to Len(aCpoForm)
   	If Val(Strtran(StrTran(aCpoForm[nY,5],".",""),",","."))>0 
		oPrint:line(nL,035,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),aCpoForm[nY,1]+" "+Substr(aCpoForm[nY,3],1,33), oFont06) 
		If Len(aCpoForm[nY,3])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),aCpoForm[nY,1]+" "+Substr(aCpoForm[nY,3],34,33), oFont06) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,aCpoForm[nY,5], oFont09) 
		fNewLine()
	Endif
Next
		
// -------------------------------------------------------------------------------------------------------
//  |94| Salario do mes anterior a rescisao
// -------------------------------------------------------------------------------------------------------
nPosFixa := 0
If Len(aTab25) > 0 .and. (nAchou := aScan(aTab25, {|x| x[5] = '94'})) > 0
	cVrbFixa := aTab25[nAchou,6]
	nPosFixa := aScan(aHomV, {|x| x[4] = cVrbFixa})
Endif

If nPosFixa > 0
	oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0), STR0120, oFont06) 
	oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10, TransForm(aHomV[nPosFixa,3],"@E 99,999,999.99"), oFont09) 
	aHomV[nPosFixa,7] := 1
	fNewLine()
Endif

// -------------------------------------------------------------------------------------------------------
//  |95| Outros
// -------------------------------------------------------------------------------------------------------
nCont := 1
For nY:= 1 to Len(aHomV)
	If aHomV[nY,7]==0
		oPrint:line(nL,035,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),"95."+AllTrim(Str(nCont))+" "+Substr(aHomV[nY,1],1,33), oFont06) 
		If Len(aHomV[nY,1])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),Substr(aHomV[nY,1],34,33), oFont06) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,TransForm(aHomV[nY,3],"@E 99,999,999.99"), oFont09) 
		nCont++
		fNewLine()
	Endif
Next  
        
// -------------------------------------------------------------------------------------------------------
//  |96| Indenização art. 9º, Lei nº 7.238/1984 - A - |99| Ajuste do Saldo Devedor
// -------------------------------------------------------------------------------------------------------
For nY := 1 to Len(aCpoFor1)
	If Val(Strtran(StrTran(aCpoFor1[nY,5],".",""),",","."))>0 
		oPrint:line(nL,035,nL,nColMax )
		oPrint:say (nL+nPT,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),aCpoFor1[nY,1]+" "+Substr(aCpoFor1[nY,3],1,33), oFont06) 
		If Len(aCpoFor1[nY,3])>33
			oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "a")+If(nXCol>1,30,0),aCpoFor1[nY,1]+" "+Substr(aCpoFor1[nY,3],34,33), oFont06) 
		Endif
		oPrint:say (nL+nPD,&("nCl0" + cValToChar(nXCol) + "b")+10,aCpoFor1[nY,5], oFont09) 
		fNewLine()
	Endif
Next

oPrint:say (nL+nPT,nCl03a+10,STR0072, oFont09n) 
oPrint:say (nL+nPD,nCl03b-10,Transform(nProv,"@E 999,999,999.99"), oFont09)

nL+=nAddL
oPrint:Box( nBoxIni, 035 ,nL,nColMax )
oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )
nTamL:=7
oPrint:Box(nL, 035,nL+70, nColMax ) 									
oPrint:say (nL+10,1050,STR0073, oFont14n) 		 											
nL+=70
nCkHomV:=0
For nY:=1 to Len(aCpoFormD)    
	If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0 
		nCkHomV++
	Endif
Next		
nBoxIni:=nL	
For nX:=1 to nTamL
	If nX==1
		oPrint:say (nL+02,nCl01a   ,STR0074, oFont08)	 //"DESCONTO"
		oPrint:say (nL+02,nCl01b+30	,STR0038, oFont08) 	 //"VALOR"
		oPrint:say (nL+02,nCl02a+30	,STR0074, oFont08) 	 //"DESCONTO"
		oPrint:say (nL+02,nCl02b+30	,STR0038, oFont08) 	 //"VALOR"
		oPrint:say (nL+02,nCl03a+30	,STR0074, oFont08) 	 //"DESCONTO"
		oPrint:say (nL+02,nCl03b+30	,STR0038, oFont08) 	 //"VALOR"
	Elseif nX==2
		oPrint:say (nL+nPT,nCl01a		,STR0075, oFont06)  //"100 Pensão Alimentícia"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,3,"172/170/128/058/056"), oFont09) // dentro da rotina os identificadores serao ignorados
		oPrint:say (nL+nPT,nCl02a+30	,STR0076, oFont06)  //"101 Adiantamento Salarial"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,2,"A01"), oFont09) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0077, oFont06)  //"102 Adiantamento de 13º Salário"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A02"), oFont09) 
	Elseif nX==3
		oPrint:say (nL+nPT,nCl01a		,STR0078, oFont06)  //"103 Aviso-Prévio Indenizado"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,1,"113"), oFont09) 
		oPrint:say (nL+nPT,nCl02a+30	,STR0079, oFont06)  //"104 Multa Art. 480/CLT"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,2,"A09"), oFont09) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0080, oFont06)  //"105 Empréstimo em Consignação"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A08"), oFont09)
		nL+=nAddL
		oPrint:line(nL,035,nL,nColMax )		 

		oPrint:say (nL+nPT,nCl01a		,STR0081, oFont06)  //"106 Vale-Transporte"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,2,"A04"), oFont09) 
		oPrint:say (nL+nPT,nCl02a+30	,STR0082, oFont06)  //"107 Reembolso do Vale-Transporte"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,2,"A06"), oFont09) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0083, oFont06)  //"108 Vale-Alimentação"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A05"), oFont09)
		nL+=nAddL
		oPrint:line(nL,035,nL,nColMax )

		oPrint:say (nL+nPT,nCl01a  		,STR0084, oFont06)  //"109 Reembolso Vale-Alimentação"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,2,"A07"), oFont09) 
		oPrint:say (nL+nPT,nCl02a+30	,STR0085, oFont06)  //"110 Contibuição para o FAPI"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,2,"A11"), oFont09) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0086, oFont06)  //"111 Contribuição Sindical Laboral"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A13"), oFont09)

	Elseif nX==4
		oPrint:say (nL+nPT,nCl01a  		,STR0087, oFont06)  //"112.1 Previdência Social"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,1,"064/065"), oFont09) 
		oPrint:say (nL+nPT,nCl02a+30	,STR0088, oFont06)  //"112.2 Previdência Social 13º Salario"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,1,"070"), oFont09) 
		oPrint:say (nL+nPT,nCl03a+30	,STR0089, oFont06)  //"113 Contribuição Previdência "
		oPrint:say (nL+nPD,nCl03a+30	,STR0090, oFont06)  //"Complementar"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,2,"A10"), oFont09) 
	Elseif nX==5
		oPrint:say (nL+nPT,nCl01a     	,STR0091, oFont06)  //"114.1 IRRF"
		oPrint:say (nL+nPD,nCl01b+10	,GPER140Sum(2,1,"066/067"), oFont09)    
		oPrint:say (nL+nPT,nCl02a+30	,STR0092, oFont06)  //"114.2 IRRF sobre 13º Salário"
		oPrint:say (nL+nPD,nCl02b+10	,GPER140Sum(2,1,"071"), oFont09) 
	  	oPrint:say (nL+nPT,nCl03a+30	,STR0093, oFont06)  //"114.3 IRRF sobre Participação nos "
	  	oPrint:say (nL+nPD,nCl03a+30	,STR0094, oFont06)  //"Lucros ou Resultados"
		oPrint:say (nL+nPD,nCl03b+10	,GPER140Sum(2,1,"152"), oFont09) 
		For nY:= 1 to Len(aHomD)
			If aHomD[nY,7]==0
			   nCkHomV++
			Endif
		Next
		If nCkHomV>=4
			nTamL:=nTamL+Int((nCkHomV-4)/3)	
		Endif		
	Elseif nX=6
		If nCkHomV<4
			nW:=0
			For nY := 1 to Len(aCpoFormD)
				If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0 
					nW++
					If nW==1
						oPrint:say (nL+nPT,nCl01a,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],1,33), oFont06) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl01a,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont06) 
						Endif
						oPrint:say (nL+nPD,nCl01b+10,aCpoFormD[nY,5], oFont09) 
					Elseif nW==2
						oPrint:say (nL+nPT,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],1,33), oFont06) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont06) 
						Endif
						oPrint:say (nL+nPD,nCl02b+10,aCpoFormD[nY,5], oFont09) 
					Elseif nW==3
						nW:=0
						oPrint:say (nL+nPT,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],1,33), oFont06) 
						If Len(aCpoFormD[nY,3])>33
							oPrint:say (nL+nPD,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont06) 
						Endif
						oPrint:say (nL+nPD,nCl03b+10,aCpoFormD[nY,5], oFont09) 
						nL+=nAddL
						oPrint:line(nL,035,nL,nColMax )	
					Endif
				Endif
			Next
			nT:=0	
			For nY:= 1 to Len(aHomD)
				If aHomD[nY,7]==0
					nW++
					nT++  
					cItem:= If(nT ==1,"115","115."+AllTrim(Str(nT-1)))
					If nW==1
						oPrint:say (nL+nPT,nCl01a,cItem+" "+Substr(aHomD[nY,1],1,33), oFont06) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl01a,Substr(aHomD[nY,1],34,33), oFont06) 
						Endif
						oPrint:say (nL+nPD,nCl01b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont09) 
					Elseif nW==2
						oPrint:say (nL+nPT,nCl02a+30,cItem+" "+Substr(aHomD[nY,1],1,33), oFont06) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl02a+30,Substr(aHomD[nY,1],34,33), oFont06) 
						Endif
						oPrint:say (nL+nPD,nCl02b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont09) 
					Elseif nW==3
						nW:=0
						oPrint:say (nL+nPT,nCl03a+30,cItem+" "+Substr(aHomD[nY,1],1,33), oFont06) 
						If Len(aHomD[nY,1])>33
							oPrint:say (nL+nPD,nCl03a+30,Substr(aHomD[nY,1],34,33), oFont06) 
						Endif
						oPrint:say (nL+nPD,nCl03b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont09)   
						nL+=nAddL
						oPrint:line(nL,035,nL,nColMax )	
					Endif
				Endif
			Next
			If nW ==0
				oPrint:say (nL+nPT,nCl01a,STR0095, oFont06)      //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl01a,STR0096, oFont06)      //"Quitado"
				oPrint:say (nL+nPD,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont09) 
				oPrint:say (nL+nPT,nCl03a+10,STR0097, oFont09n)  //"TOTAL DAS DEDUÇÕES"
				oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont09) 
			Elseif nW==1
				oPrint:say (nL+nPT,nCl02a+30,STR0095	, oFont06) //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl02a+30,STR0096	, oFont06) //"Quitado"
				oPrint:say (nL+nPD,nCl02b+10,TransForm(0,"@E 99,999,999.99"), oFont09) 
				oPrint:say (nL+nPT,nCl03a+10,STR0097, oFont09n)   //"TOTAL DAS DEDUÇÕES"
				oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont09) 
			Elseif nW==2
				oPrint:say (nL+nPT,nCl03a+10,STR0097, oFont09n)   //"TOTAL DAS DEDUÇÕES"
				oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont09) 
				nL+=nAddL
				oPrint:line(nL,035,nL,nColMax )	
				oPrint:say (nL+nPT,nCl01a,STR0095, oFont06)   //"116 Desc. de Valor Liq. de TRCT-"
				oPrint:say (nL+nPD,nCl01a,STR0096, oFont06)   //"Quitado"
				oPrint:say (nL+nPD,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont09)  
				lTemVerba := .T.
			Endif
			Exit 
		Else
			Loop
		Endif
	Elseif nX > 6
		nW:=0
  		For nY := 1 to Len(aCpoFormD)
		If Val(Strtran(StrTran(aCpoFormD[nY,5],".",""),",","."))>0   		
			nW++
			If nW==1 
				oPrint:say (nL+nPT,nCl01a,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],1,33), oFont06)
				If Len(aCpoFormD[nY,3]) >33
					oPrint:say (nL+nPD,nCl01a,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont06)
				Endif
				oPrint:say (nL+nPD,nCl01b+10,aCpoFormD[nY,5], oFont09) 
			Elseif nW==2
				oPrint:say (nL+nPT,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],1,33), oFont06) 
				If Len(aCpoFormD[nY,3]) >33
					oPrint:say (nL+nPD,nCl02a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont06)
				Endif					
				oPrint:say (nL+nPD,nCl02b+10,aCpoFormD[nY,5], oFont09) 
			Elseif nW==3 
				nW:=0
				oPrint:say (nL+nPT,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],1,33), oFont06) 
				If Len(aCpoFormD[nY,3]) >33
					oPrint:say (nL+nPD,nCl03a+30,aCpoFormD[nY,1]+" "+Substr(aCpoFormD[nY,3],34,33), oFont06)
				Endif					
				oPrint:say (nL+nPD,nCl03b+10,aCpoFormD[nY,5], oFont09) 				
				nL+=nAddL
				oPrint:line(nL,035,nL,nColMax )
			Endif
		Endif
		Next	
	   	nT:=0	
		For nY:= 1 to Len(aHomD)
			If aHomD[nY,7]==0
				nW++
				nT++ 
				cItem:= If(nT ==1,"115","115."+AllTrim(Str(nT-1)))
				If nW==1
					oPrint:say (nL+nPT,nCl01a,cItem+" "+Substr(aHomD[nY,1],1,33), oFont06) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl01a,cItem+" "+Substr(aHomD[nY,1],34,33), oFont06) 					
					Endif
					oPrint:say (nL+nPD,nCl01b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont09) 
				Elseif nW==2
					oPrint:say (nL+nPT,nCl02a+30,cItem+" "+Substr(aHomD[nY,1],1,33), oFont06) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl02a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont06) 					
					Endif
					oPrint:say (nL+nPD,nCl02b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont09) 
				Elseif nW==3
					nW:=0
					oPrint:say (nL+nPT,nCl03a+30,cItem+" "+Substr(aHomD[nY,1],1,33), oFont06) 
					If Len(aHomD[nY,1])>33
						oPrint:say (nL+nPD,nCl03a+30,cItem+" "+Substr(aHomD[nY,1],34,33), oFont06) 					
					Endif
					oPrint:say (nL+nPD,nCl03b+10,TransForm(aHomD[nY,3],"@E 99,999,999.99"), oFont09)   
					nL+=nAddL
					oPrint:line(nL,035,nL,nColMax )						
				Endif
			Endif
		Next
		If nW ==0
			oPrint:say (nL+nPT,nCl01a,STR0095, oFont06)      //"116 Desc. de Valor Liq. de TRCT-"
			oPrint:say (nL+nPD,nCl01a,STR0096, oFont06)      //"Quitado"
			oPrint:say (nL+nPD,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont09) 
			oPrint:say (nL+nPT,nCl03a+10,STR0097, oFont09n)  //"TOTAL DAS DEDUÇÕES"
			oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont09) 
		Elseif nW==1                                          
			oPrint:say (nL+nPT,nCl02a+30,STR0095, oFont06)      //"116 Desc. de Valor Liq. de TRCT-"
			oPrint:say (nL+nPD,nCl02a+30,STR0096, oFont06)      //"Quitado"
			oPrint:say (nL+nPD,nCl02b+10,TransForm(0,"@E 99,999,999.99"), oFont09) 
			oPrint:say (nL+nPT,nCl03a+10,STR0097, oFont09n)  //"TOTAL DAS DEDUÇÕES"
			oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont09) 				
		Elseif nW==2                
			oPrint:say (nL+nPT,nCl03a+10,STR0097, oFont09n)   //"TOTAL DAS DEDUÇÕES"
			oPrint:say (nL+nPD,nCl03b-10,Transform(nDesc,"@E 999,999,999.99"), oFont09) 
			nL+=nAddL
			oPrint:line(nL,035,nL,nColMax )	
			oPrint:say (nL+nPT,nCl01a,STR0095, oFont06)   //"116 Desc. de Valor Liq. de TRCT-"
			oPrint:say (nL+nPD,nCl01a,STR0096, oFont06)   //"Quitado"
			oPrint:say (nL+nPD,nCl01b+10,TransForm(0,"@E 99,999,999.99"), oFont09)  
			lTemVerba := .T.			
		Endif
		Exit 
	Endif
	If nX < 6 .or. nX<7 .and. nCkHomV>3 
		nL+=If(nX==1,(nAddL-40),nAddL)
		oPrint:line(nL,035,nL,nColMax )
	Endif
Next

IF lTemVerba 
	oPrint:say (nL+nPT,nCl02a+30	,"            ", oFont06) 
	oPrint:say (nL+nPD,nCl02b+10	,"            ", oFont09) 
	oPrint:say (nL+nPT,nCl03a+10	,STR0099, oFont09n) 
	oPrint:say (nL+nPD,nCl03b-10,Transform(nProv - nDesc,"@E 999,999,999.99"), oFont09)  	
Else
	nL+=nAddL
	oPrint:line(nL,035,nL,nColMax )
	oPrint:say (nL+nPT,nCl01a,"        "	   , oFont06)
	oPrint:say (nL+nPD,nCl01b+10,"            ", oFont09) 
	oPrint:say (nL+nPT,nCl02a+30,"            ", oFont06) 
	oPrint:say (nL+nPD,nCl02b+10,"            ", oFont09) 
	oPrint:say (nL+nPT,nCl03a+10,STR0099, oFont09n) 
	oPrint:say (nL+nPD,nCl03b-10,Transform(nProv - nDesc,"@E 999,999,999.99"), oFont09) 	
Endif	

nL+=nAddL 

oPrint:Box( nBoxIni,  035,nL,nColMax )
oPrint:line(nBoxIni,nCl01b+20,nL,nCl01b+20 )
oPrint:line(nBoxIni,nCl02a,nL,nCl02a )
oPrint:line(nBoxIni,nCl02b+20,nL,nCl02b+20 )
oPrint:line(nBoxIni,nCl03a,nL,nCl03a )
oPrint:line(nBoxIni,nCl03b+20,nL,nCl03b+20 )
If nL > 2530
	oPrint:EndPage() 
	oPrint:StartPage()  
	nL:=20
Endif	
nTamL:=10
oPrint:Box(nL, 035,nL+70, nColMax ) 									
oPrint:say (nL+10,860,STR0100, oFont14n) //"FORMALIZAÇÃO DA RESCISÃO"
nL+=70
oPrint:Box(nL, 035,nL+(nTamL*nAddL)+nPT+nPD+100, nColMax )
oPrint:line(nL,1174,nL+(10*nAddL)+30,1174 )
oPrint:line(nL+(2*nAddL)+60,1761,nL+(8*nAddL)+60,1761 )
oPrint:line(nL+(1*nAddL)+30,035,nL+(1*nAddL)+30,nColMax )
oPrint:line(nL+(2*nAddL)+60,035,nL+(2*nAddL)+60,nColMax )
oPrint:line(nL+(8*nAddL)+60,035,nL+(8*nAddL)+60,nColMax )
oPrint:line(nL+(10*nAddL)+30,035,nL+(10*nAddL)+30,nColMax )
nTamL:=20
For nX:=1 to nTamL
	If nX==1
		oPrint:say (nL+nPT,060		,STR0101, oFont06) //"150 Local e data do recebimento"
		oPrint:say (nL+nPT,1174+30	,STR0102, oFont06) //"151 Carimbo e assinatura do empregador ou preposto"
		If !(Empty(mv_par27+mv_par28))
			oPrint:say (nL+nPD,1174+30, STR0118 + mv_par27 + " - " + mv_par28, oFont09) //"RG - Nome do empregador    
		Endif		
		nL+=30
   Elseif nX==3
		oPrint:say (nL+nPT,060		,STR0103, oFont06) //"152 Assinatura do Trabalhador"
		oPrint:say (nL+nPT,1174+30	,STR0104, oFont06) //"153 Assinatura do responsável legal do trabalhador"
		nL+=30
	Elseif nX==5
		oPrint:say (nL+nPT,060		,STR0105, oFont06) //"154 HOMOLOGAÇÃO"
		oPrint:say (nL+nPT,1174+30	,STR0106, oFont06) //"155 Digital do Trabalhador"
		oPrint:say (nL+nPT,1761+30	,STR0107, oFont06) //"156 Digital do responsável legal"
   Elseif nX==6
		oPrint:say (nL+nPT,050		,STR0108, oFont06) //"Foi prestada, gratuitamente, assistência ao trabalhador, nos termos do art.477,§1º,"
   Elseif nX==07
		oPrint:say (nL+nPT,050		,STR0109, oFont06) //"da Consolidação das Leis do Trabalho-CLT, sendo comprovado, neste ato, o efetivo"
   Elseif nX==08 
		oPrint:say (nL+nPT,050		,STR0110, oFont06) //"pagamento das verbas rescisórias acima especificadas."
	Elseif nX==10
	   oPrint:line(nL+nPD,060,nL+nPD,(nColMax/8)*2 )   
	   If Mv_par14 == 1
			oPrint:say (nL+nPD,250		, Rtrim(aInfo[5]) + " - "+ Dtoc(SRG->RG_DATAHOM), oFont06)
		Else 
			oPrint:say (nL+nPD,250		,STR0111, oFont06) //"Local e Data"
		Endif

   Elseif nX==14
		oPrint:line(nL+nPD,060,nL+nPD,(nColMax/6)*2 )
		oPrint:say (nL+nPD,250		,STR0112, oFont06) //"Carimbo e assinatura do assistente"
   Elseif nX==17
		oPrint:say (nL+nPT,060		,STR0113, oFont06) //"157 Identificação do órgão homologador"
		oPrint:say (nL+nPT,1174+30	,STR0114, oFont06) //"158 Recepção pelo Banco(data e carimbo)"
		nL+=30
	Elseif nX==19
		nL+=10
		oPrint:say (nL+nPT,060		,STR0115, oFont06) //"A ASSISTÊNCIA NO ATO DA RESCISÃO CONTRATUAL É GRATUITA."
		oPrint:say (nL+nPD,060		,STR0116, oFont06) //"Pode o trabalhador iniciar ação judicial quanto aos créditos resultantes das relações de trabalho até o limite de dois anos após a extinção do contrato de trabalho"
		oPrint:say (nL+nPD+nPD,060	,STR0117, oFont06) //"(Inc. XXIX, Art.7º da Constituição Federal/1988)."
	Endif
	nL+=(nAddL/2)
Next

oPrint:EndPage()
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fNewLine  ³ Autor ³ Kelly Soares          ³ Data ³ 20.01.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicia nova linha na impressao das verbas rescisorias.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ RdMake                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fNewLine()

If nXCol = 3
	nXCol := 0
	nL+=nAddL
	oPrint:line(nL,035,nL,nColMax )		
Endif
nXCol++


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PenunSal  ³ Autor ³ Mauricio MR		    ³ Data ³ 16.02.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Obtem o penultimo salario do funcionario antes da demissao.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ IMPRESH                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function PenunSal(dAdmissao, dDemissao, cVerbas, cFolMes, cVerbSal)

Local nEpoch	:= Set( _SET_EPOCH  )	//Obtem a configuracao de seculo corrente

Local aArea		:= GetArea()
Local aSRCArea	:= SRC->(GetArea())

//-- Data do Penultimo Salario.
Local dDTPenSal 
Local nValPenSal     
Local cFilMat	:= SRA->(RA_FILIAL+RA_MAT)

DEFAULT dAdmissao	:= SRA->RA_ADMISSA	
DEFAULT	dDemissao  	:= SRG->RG_DATADEM  
DEFAULT	cVerbas		:= ''  
DEFAULT cFolMes		:= SuperGetMv("MV_FOLMES")  
DEFAULT cVerbSal	:= acodfol[318,1]


Set( _SET_EPOCH , 1920 )	//Altera o Set Epoch para 1920

dDTPenSal := If(Month(dDemissao)-1 != 0, CtoD('01/' +StrZero(Month(dDemissao)-1,2)+'/'+Right(StrZero(Year(dDemissao),4),2)),CtoD('01/12/'+Right(StrZero(Year(dDemissao)-1,4),2)) )

If MesAno(dDtPenSal) < MesAno(dAdmissao)
	dDTPenSal 	:= CTOD("  /  /  ")
	nValPenSal 	:= 0.00
Endif
//--Penultimo 
If !Empty(dDTPenSal)              
	nValPenSal := fBuscaAcm(cVerbas + cVerbSal  ,,dDTPenSal,dDTPenSal,"V")	//-- Salario do mes + verbas que incorporaram  ao salario
	//--Pesquisa no movimento mensal quando o mes corrente estiver aberto
	//--e nao encontrar salario nos acumulados anuais.
	If nValPenSal == 0 .And. MesAno(dDTPenSal) == cFolMes
		If SRC->(Dbseek(cFilMat))
			While !SRC->(eof()) .And. cFilMat == SRC->(RC_FILIAL+RC_MAT)
				If SRC->RC_PD $cVerbas + cVerbSal
					nValPenSal += SRC->RC_VALOR
				Endif
				SRC->(dbskip())
			Enddo
		Endif
	Endif
Endif             

/*/
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Restaura o Set Epoch Padrao								 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
Set( _SET_EPOCH , nEpoch )
	
RestArea(aSRCArea)
RestArea(aArea)

Return(nValPenSal)





