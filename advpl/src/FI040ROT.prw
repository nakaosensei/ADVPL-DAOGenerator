#INCLUDE"PROTHEUS.CH"
#include 'parmtype.ch'
#include "TOTVS.CH" 
#include "rwmake.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ponto de entrada para inclusão de novos itens no menu aRotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function FI040ROT()

Local aRotina := {PARAMIXB[2],PARAMIXB[3],PARAMIXB[4],PARAMIXB[5],PARAMIXB[6]}

//adminAlert('Ponto de Entrada: FI040ROT');

aAdd( aRotina, {"Excluir LIGUE", "U_LIGEXSE1", 0, 7})
aAdd( aRotina, {"Imprimir Boleto", "U_ROT01", 0, 7})
aAdd( aRotina, {"Imprimir Fatura", "U_ROT04", 0, 7})

Return aRotina

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para excluir o título/nota Ligue						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
USER FUNCTION LIGEXSE1()

Local	_aSE2 := SE2->(getarea())
Local	 aArray 	 := {}
PRIVATE  lMsErroAuto := .F.
PRIVATE	 cFillig  	 := ""
PRIVATE  cClieFor    := ""
PRIVATE  cLoja       := ""
PRIVATE  cNota       := ""
PRIVATE  cSerie   	 := ""
       
IF !MSGYESNO("Tem certeza que deseja Excluir o titulo : " + SE1->E1_PREFIXO + " - "+ SE1->E1_NUM + " - " +SE1->E1_PARCELA)
	RETURN
ENDIF       
                  
If EMPTY(SE1->E1_UNUMNF1) .AND. (SE1->E1_TIPO <> 'RA')
	MSGINFO( "Para este título utilizar rotina de exclusão Padrão do Sistema!", "ATENÇÃO" )
	Return
ELSE
	
EndIf

If !EMPTY(SE1->E1_BAIXA)
	MSGINFO( "Não é possivel excluir o titulo com Baixa!", "ATENÇÃO" )
	Return
EndIf

aArray := { { "E1_PREFIXO"  , SE1->E1_PREFIXO		  , NIL },; //1
			{ "E1_NUM"      , SE1->E1_NUM             , NIL },; //2
			{ "E1_PARCELA"  , SE1->E1_PARCELA         , NIL },; //2
			{ "E1_TIPO"     , SE1->E1_TIPO  	      , NIL },; //3
			{ "E1_NATUREZ"  , SE1->E1_NATUREZ   	  , NIL },; //4
			{ "E1_CLIENTE"  , SE1->E1_CLIENTE         , NIL },; //5
			{ "E1_LOJA"		, SE1->E1_LOJA      	  , NIL },; //6
			{ "E1_EMISSAO"  , SE1->E1_EMISSAO		  , NIL },; //7
			{ "E1_VENCTO"   , SE1->E1_VENCTO		  , NIL },; //8
			{ "E1_VENCREA"  , SE1->E1_VENCREA  		  , NIL },; //9
			{ "E1_USERNF1"  , SE1->E1_USERNF1         , NIL },; //10
			{ "E1_UFILNF1"  , SE1->E1_UFILNF1         , NIL },; //11
			{ "E1_UNUMNF1"  , SE1->E1_UNUMNF1         , NIL },; //12
			{ "E1_UVALNF1"  , SE1->E1_UVALNF1         , NIL },; //13
			{ "E1_UFILNF2"  , SE1->E1_UFILNF2         , NIL },; //14
			{ "E1_USERNF2"  , SE1->E1_USERNF2         , NIL },; //15
			{ "E1_UNUMNF2"  , SE1->E1_UNUMNF2         , NIL },; //16
			{ "E1_UVALNF2"  , SE1->E1_UVALNF2         , NIL },; //17
			{ "E1_UFILNF3"  , SE1->E1_UFILNF3         , NIL },; //18
			{ "E1_USERNF3"  , SE1->E1_USERNF3         , NIL },; //19
			{ "E1_UNUMNF3"  , SE1->E1_UNUMNF3         , NIL },; //20
			{ "E1_UVALNF3"  , SE1->E1_UVALNF3         , NIL },; //21
			{ "E1_UFILNF4"  , SE1->E1_UFILNF4         , NIL },; //22
			{ "E1_USERNF4"  , SE1->E1_USERNF4         , NIL },; //23
			{ "E1_UNUMNF4"  , SE1->E1_UNUMNF4         , NIL },; //24
			{ "E1_UVALNF4"  , SE1->E1_UVALNF4         , NIL },; //25
			{ "E1_UFILNF5"  , SE1->E1_UFILNF5         , NIL },; //26
			{ "E1_USERNF5"  , SE1->E1_USERNF5         , NIL },; //27
			{ "E1_UNUMNF5"  , SE1->E1_UNUMNF5         , NIL },; //28
			{ "E1_UVALNF5"  , SE1->E1_UVALNF5         , NIL } } //29

		If !EMPTY(SE1->E1_UNUMNF1)
			cClieFor    :=	SE1->E1_CLIENTE  //aArray[1,5]
			cLoja       :=	SE1->E1_LOJA 	//aArray[1,6]
			cFillig		:=	SE1->E1_UFILNF1  //aArray[1,11]
			cSerie      :=	SE1->E1_USERNF1  //aArray[1,12]
			cNota       :=	SE1->E1_UNUMNF1  //aArray[1,10]
			EXCNOTA()
			MSGINFO( "Exclusão da Nota "+cNota+" Série "+cSerie+"  com sucesso!", "ATENÇÃO" )
		EndIf			
		If	!EMPTY(SE1->E1_UNUMNF2)
			cClieFor    :=	SE1->E1_CLIENTE  //aArray[1,5]
			cLoja       :=	SE1->E1_LOJA 	//aArray[1,6]
			cFillig		:=	SE1->E1_UFILNF2  //aArray[1,14]
			cSerie      :=	SE1->E1_USERNF2  //aArray[1,15]
			cNota       :=	SE1->E1_UNUMNF2  //aArray[1,16]
			EXCNOTA()
			MSGINFO( "Exclusão da Nota "+cNota+" Série "+cSerie+"  com sucesso!", "ATENÇÃO" )
		EndIf	
		If !EMPTY(SE1->E1_UNUMNF3)
			cClieFor    :=	SE1->E1_CLIENTE  //aArray[1,5]
			cLoja       :=	SE1->E1_LOJA 	//aArray[1,6]
			cFillig		:=	SE1->E1_UFILNF3  //aArray[1,18]
			cSerie      :=	SE1->E1_USERNF3  //aArray[1,19]
			cNota       :=	SE1->E1_UNUMNF3  //aArray[1,20]
			EXCNOTA()
			MSGINFO( "Exclusão da Nota "+cNota+" Série "+cSerie+"  com sucesso!", "ATENÇÃO" )
		EndIf	
		If !EMPTY(SE1->E1_UNUMNF4)
			cClieFor    :=	SE1->E1_CLIENTE  //aArray[1,5]
			cLoja       :=	SE1->E1_LOJA 	//aArray[1,6]
			cFillig		:=	SE1->E1_UFILNF4  //aArray[1,22]
			cSerie      :=	SE1->E1_USERNF4  //aArray[1,23]
			cNota       :=	SE1->E1_UNUMNF4  //aArray[1,24]
			EXCNOTA()
			MSGINFO( "Exclusão da Nota "+cNota+" Série "+cSerie+"  com sucesso!", "ATENÇÃO" )
		EndIf	
		If !EMPTY(SE1->E1_UNUMNF5)
			cClieFor    :=	SE1->E1_CLIENTE  //aArray[1,5]
			cLoja       :=	SE1->E1_LOJA 	//aArray[1,6]
			cFillig		:=	SE1->E1_UFILNF5  //aArray[1,26]
			cSerie      :=	SE1->E1_USERNF5  //aArray[1,27]
			cNota       :=	SE1->E1_UNUMNF5  //aArray[1,28]
			EXCNOTA()
			MSGINFO( "Exclusão da Nota "+cNota+" Série "+cSerie+"  com sucesso!", "ATENÇÃO" )
		EndIf	

DbSelectArea("SE1")
DbSetOrder(1)
If DbSeek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO) //Exclusão deve ter o registro SE1 posicionado
	
	cTipo := SE1->E1_TIPO

	MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 5)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If lMsErroAuto
		MostraErro()
	Else
		MSGINFO( "Exclusão do Título com sucesso!", "ATENÇÃO" )
		
		IF ALLTRIM(cTipo) == 'RA'
			dbSelectArea("SE5")
			SE5->(dbSetOrder(20))//E5_FILIAL+E5_CLIFOR+E5_LOJA+E5_VALOR+E5_DATA+E5_BANCO+E5_AGENCIA+E5_CONTA
			IF SE5->(dbSeek(xFilial("SE5")+SE1->E1_CLIENTE+ SE1->E1_LOJA+ str(SE1->E1_VALOR,16,2)+ dtos(SE1->E1_EMISSAO)+ SE1->E1_PORTADO +SE1->E1_AGEDEP+ SE1->E1_CONTA))
				RECLOCK("SE5",.F.)
					DBDELETE()
				MSUNLOCK()
				/*aFINA100 := { {"E5_DATA" ,SE5->E5_DATA ,Nil},;
					{"E5_MOEDAR" ,SE5->E5_FILIAL ,Nil},;	
					{"E5_MOEDAR" ,SE5->E5_CLIFOR ,Nil},;	
					{"E5_MOEDAR" ,SE5->E5_LOJA ,Nil},;	
					{"E5_MOEDAR" ,SE5->E5_VALOR ,Nil},;	
					{"E5_MOEDAR" ,SE5->E5_MOEDA ,Nil},;	
					{"E5_NATUREZ" ,SE5->E5_NATUREZ ,Nil},;	
					{"E5_BANCO" ,SE5->E5_BANCO ,Nil},;
					{"E5_AGENCIA" ,SE5->E5_AGENCIA ,Nil},;
					{"E5_CONTA" ,SE5->E5_CONTA ,Nil},;		
					{"E5_HISTOR" ,SE5->E5_HISTOR ,Nil},;	
					{"E5_TIPOLAN" ,SE5->E5_TIPOLAN ,Nil} }
						
					MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,5)
					If lMsErroAuto
						MostraErro()
					Else
						MsgAlert("Exclusão do Movimento realizada com sucesso !!!")
					EndIf */
			ENDIF
		ENDIF
		
	Endif
		
Else
	Alert("Título não foi encontrato")
EndIf

restarea(_aSE2)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para excluir Notas EXCNOTA()							³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
STATIC FUNCTION EXCNOTA()

dbSelectArea("SF3")
dbSetOrder(4)
If MsSeek(cFillig+cClieFor+cLoja+cNota+cSerie)
	While !SF3->(Eof()) .And. cFillig+cClieFor+cLoja+cNota+cSerie == SF3->F3_FILIAL+SF3->F3_CLIEFOR+SF3->F3_LOJA+SF3->F3_NFISCAL+SF3->F3_SERIE
		if Reclock("SF3",.F.)
			SF3->F3_OBSERV	:= "NOTA CANCELADA"
			SF3->F3_DTCANC	:= dDataBase
			Msunlock()
		EndIf
	SKIP
	Enddo

Else
	Alert("Nota "+cNota+" Não Encontrada na SF3, Nota Não Excluída!")
EndIf

dbSelectArea("SFT")
dbSetOrder(3)
								
If MsSeek(cFillig+"S"+cClieFor+cLoja+cSerie+cNota+"")
	While !SFT->(Eof()) .And. cFillig+cClieFor+cLoja+cNota+cSerie == SFT->FT_FILIAL+SFT->FT_CLIEFOR+SFT->FT_LOJA+SFT->FT_NFISCAL+SFT->FT_SERIE
		if Reclock("SFT",.F.)
			SFT->FT_OBSERV	:= "NOTA CANCELADA"
			SFT->FT_DTCANC	:= dDataBase
			Msunlock()
		EndIf 
		SKIP
	Enddo
Else
	Alert("Nota "+cNota+" Não Encontrada na SFT, Nota Não Excluída!")
EndIf

dbSelectArea("SF2")
dbSetOrder(1)
If MsSeek(cFillig+cNota+cSerie+cClieFor+cLoja)
	While !SF2->(Eof()) .And. cFillig+cNota+cSerie+cClieFor+cLoja == SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	reclock("SF2", .F.)
	dbdelete()
	msunlock()                
	SKIP
	ENDDO
Else
	Alert("Nota "+cNota+" Não Encontrada na SF2, Nota Não Excluída!")
EndIf

dbSelectArea("SD2")
dbSetOrder(3)
If MsSeek(cFillig+cNota+cSerie+cClieFor+cLoja+"")
	While !SD2->(Eof()) .And. cFillig+cNota+cSerie+cClieFor+cLoja == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
	reclock("SD2", .F.)
	dbdelete()
	msunlock()                
	SKIP
	ENDDO
Else
	Alert("Nota "+cNota+" Não Encontrada na SD2, Nota Não Excluída!")
EndIf


Return


User Function ROT01()
Local oButton1
Local oFont1 := TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Local oGet1
Local cGet1 := SPACE(20)
Local oSay1
Local oData
Local lHasButton := .T.

Private oCheck1
Private oDlgMC
Private dGet3 := Date() // Vari?el do tipo Data
Private dData := ""

IF EMPTY(SE1->E1_BAIXA)	

aItems1 := {"CAIXA", "HSBC","BRADESCO"}
cTexto := ADA->ADA_UDSCAN

	DEFINE MSDIALOG oDlgMC TITLE "Opções de impressão? : " + SE1->E1_NOMCLI  FROM 000, 000  TO 290, 500 COLORS 0, 16777215 PIXEL
	lCheck1 := .F.
	
		@ 015, 015 SAY oSay1 PROMPT "Banco ?" SIZE 185, 014 OF oDlgMC FONT oFont1 COLORS 0, 16777215 PIXEL
		 cCombo1:=  aItems1[1]      
		 oCombo1 := TComboBox():New(027,015,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},; 
	     aItems1,100,20,oDlgMC,,; 
	     ,,,,.T.,,,,,,,,,'cCombo1')   
		 
		@ 050, 015 SAY oData PROMPT "Data vencimento " SIZE 185, 014 OF oDlgMC FONT oFont1 COLORS 0, 16777215 PIXEL
		 
		 oGet3 := TGet():New( 060, 015, { | u | If( PCount() == 0, dGet3, dGet3 := u ) },oDlgMC, ;
	     060, 015, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,, "dGet3",,,,lHasButton  )
	     
		oCheck1 := TCheckBox():New(122, 015,'Enviar boleto por email', ,oDlgMC,100,210,,,,,,,,.T.,,,)
		oCheck1:bSetGet := {|| lCheck1 } 
		oCheck1:bLClicked := {|| lCheck1:=!lCheck1 } 
		oCheck1:bWhen := {|| .T.  }
  
		@ 122,131 Button "Imprimir"         	Size 50,14 Action U_ROT02(cGet1,cCombo1, dGet3, SE1->E1_NOMCLI, lCheck1) of oDlgMC Pixel
		
		@ 122,191 Button "Sair"          	Size 50,14 Action oDlgMC:End() of oDlgMC Pixel
	ACTIVATE MSDIALOG oDlgMC
	
ELSE
	MSGINFO('Este titulo não pode ser impresso pois ja cont? baixa realizada.')
ENDIF
Return


User Function ROT02(cGet1, cCombo1, dGet3, nNome, lCheck1)
	
	oDlgMC:End()
    
    
	_CNUMINI  	:= SE1->E1_NUM
	_CNUMFIM  	:= SE1->E1_NUM
	_CPREFIXO	:= SE1->E1_PREFIXO
	_CTIPO  	:= SE1->E1_TIPO
	_CPARCINI  := SE1->E1_PARCELA
	_CPARCFIM  := SE1->E1_PARCELA
	
	IF cCombo1 == "BRADESCO"
	
		_dadosbanco := alltrim(getmv("MV_UBCOBOL"))
		IF U_ROT03()
			U_LIGFIN04()
		ENDIF
	ENDIF	
		
	IF cCombo1 == "HSBC"
		_dadosbanco := alltrim(getmv("MV_UBCOHSB"))
		IF U_ROT03()
			U_LIGFIN11()
		ENDIF
	ENDIF
		
	IF cCombo1 == "CAIXA"
		_dadosbanco := alltrim(getmv("MV_UBCOCXA"))
		IF U_ROT03()
			U_LIGFIN12(dGet3, lCheck1, SE1->E1_CLIENTE, nNome)
			
		ENDIF    
    
	ENDIF
	
	
    
Return

User Function ROT03()
	_banco      := substr(_dadosbanco,1,3)
	_agencia    := substr(_dadosbanco,4,5)
	_conta      := substr(_dadosbanco,9,10)
	_subconta   := substr(_dadosbanco,19,3)
	
	IF EMPTY(SE1->E1_PORTADO) .AND. EMPTY(SE1->E1_AGEDEP) .AND. EMPTY(SE1->E1_CONTA)
		return .T.
	ENDIF 
	
	IF SE1->E1_PORTADO == _banco .AND.  SE1->E1_AGEDEP == _agencia .AND. SE1->E1_CONTA == _conta
		return .T.
	ELSE
		IF MSGYESNO('Titulo já foi impresso em outro Banco ! DESEJA TROCAR DE BANCO ?')
			RecLock("SE1",.F.)
				SE1->E1_NUMBCO  := " "
			msunlock()
		
			return .T.
		end
	ENDIF
	
Return .F.

//Impressão de Faturas
User Function ROT04()
Local aArea := GetArea()
Local _aSE1 := SE1->(getarea())
Local _ATITULOS	:= {}

	AADD(_ATITULOS, {SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "BOL", SE1->E1_CLIENTE, SE1->E1_LOJA})
	
	IF ALLTRIM(SE1->E1_PORTADO) == "237"
		U_LIGFAT02(,,,,,,_ATITULOS,,.T.) 	
	ENDIF
	
	IF ALLTRIM(SE1->E1_PORTADO) == "399"
		U_LIGFAT14(,,,,,,_ATITULOS,,.T.) 
	ENDIF
	
	IF ALLTRIM(SE1->E1_PORTADO) == "104" .OR. EMPTY(ALLTRIM(SE1->E1_PORTADO)) 
		U_LIGFAT16(,,,,,,_ATITULOS,,.T.)
	ENDIF
	
restarea(_aSE1)		
RestArea(aArea)


Return