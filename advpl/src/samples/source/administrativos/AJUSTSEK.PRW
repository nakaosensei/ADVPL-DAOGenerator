#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"

USER FUNCTION AJUSTSEK()
Private oWizard
Private aRet	:= { 0, 0, MsDate(),1}
Private lOk		:= .T.
Private lWizard:= .T. //Uso interno da função parambox()

oWizard := APWizard():New( "Assistente para Ajuste de campos." ,"Atenção!" ,;
"",;
"Este assistente tem como finalidade Atualizar o valor do campo EK_VLMOED1 das ordens de pago.";
+CHR(10)+CHR(13)+"- Somente rodar este ajuste em modo exclusivo!";
+CHR(10)+CHR(13)+"- Realizar backup do banco de dados antes da atualização.";
+CHR(10)+CHR(13)+"- Rodar a atualização primeiramente em base de homologação.";
+CHR(10)+CHR(13)+"- Os campos EK_NUM e EK_ORDPAGO devem estar com o mesmo tamanho.",;
{||.T.}, {|| .T.},,,,)

oWizard:NewPanel("Range de seleção.", ;
"Na próxima tela, informe uma data início e fim (EK_DTDIGIT) que deseja para filtrar os registros a serem atualizados da SEK.",;
{||.T.}/*<bBack>*/, ;
{||.T.} /*<bNext>*/ , ;
{|| FINEXECEK() } ,;
.T.  ,;
{|| .T. } )

ACTIVATE WIZARD oWizard CENTERED  WHEN {||.T.}

Return

STATIC FUNCTION FINEXECEK()
Local aConfig		:= {}
Local aParamFields := {}
Local dDataIni
Local dDataFim

aAdd(aParamFields, {1,"Data Inicial",CTOD("  /  /  "),"","","","",55,.T.}) //"Data Inicial"
aAdd(aParamFields, {1,"Data Final",CTOD("  /  /  "),"","","","",55,.T.}) //"Data Final"

If ParamBox(aParamFields,"Defina o período para ajustar campo EK_VLMOED1.",@aConfig, {|| ConfirmaX()} )
	dDataIni := aConfig[1]
	dDataFim := aConfig[2]
	ExecQrySEK(dDataIni, dDataFim)
Endif

RETURN .T.

STATIC FUNCTION ExecQrySEK(dDataIni, dDataFim)

Local cQuery 	:= ""
Local cAliasTmp := "SEKALIAS"
Local nTotal	:= 0
Local nRecSEK	:= 0
Local lFound := .F.
Local cFileLog := ""
Local cPath		:= ""
Local cNUM		:= ""

DEFAULT dDataIni := CtoD("  /  /  ")
DEFAULT dDataFim := CtoD("  /  /  ")

PRIVATE nValAnt	:= 0

cQuery := " SELECT EK_FILIAL,EK_ORDPAGO,EK_TIPODOC,EK_VALOR,EK_MOEDA,EK_VLMOED1,EK_EMISSAO, EK_DTDIGIT, EK_CANCEL, EK_NUM, R_E_C_N_O_ RECNOSEK FROM "+RetSqlName("SEK")
cQuery += " WHERE EK_TIPODOC = 'CP'"
cQuery += " AND EK_DTDIGIT >= '"+DtoS(dDataIni) + "'"
cQuery += " AND EK_DTDIGIT <= '"+DtoS(dDataFim) + "'"
cQuery += " AND EK_CANCEL = 'F' "
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY EK_FILIAL, EK_DTDIGIT , EK_ORDPAGO , EK_TIPODOC "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAliasTmp, .T., .T.)

(cAliasTmp)->(dbgoTop())

While (cAliasTmp)->(!eof())
	
	nRecSEK := (cAliasTmp)->(RECNOSEK)
	nTotal	:= 0
	nValAnt	:= (cAliasTmp)->(EK_VLMOED1)
	cNUM		:= PADR((cAliasTmp)->(EK_NUM), TAMSX3("EK_ORDPAGO")[1],"")
	dbSelectArea("SEK")
	DbSetOrder(1)	// EK_FILIAL+EK_ORDPAGO+EK_TIPODOC+EK_PREFIXO+EK_NUM+EK_PARCELA+EK_TIPO+EK_SEQ
	If DbSeek( (cAliasTmp)->(EK_FILIAL) + cNUM )

		While SEK->(!EOF()) .AND. (cAliasTmp)->(EK_FILIAL)+cNUM == SEK->(EK_FILIAL+EK_ORDPAGO)

			If SEK->EK_TIPODOC == (cAliasTmp)->(EK_TIPODOC)
				SEK->(DbSkip())
				Loop
			Endif
            lFound := .T.
            nTotal += SEK->EK_VLMOED1
    		SEK->(DbSkip())

		EndDo
		
		IF lFound
			SEK->(dbGoTo(nRecSEK))
			If EK_VLMOED1 <> nTotal
				RecLock("SEK", .F.)
					EK_VLMOED1 := nTotal
					EK_LA := ""
				MsUnlock()
				DbSelectArea(cAliasTmp)
				GeraLogSEK(cAliasTmp)
			Endif
			lFound := .F.
		Endif	
	Endif

	// posiciona no alias da query para gerar LOG
	DbSelectArea(cAliasTmp)
	(cAliasTmp)->(dbSkip())
Enddo

cFileLog := NomeAutoLog()

If cFileLog <> ""
	MostraErro(cPath,cFileLog)
Endif

EcdClrMsg() // limpo o controle de mensagens de erro

(cAliasTmp)->(dbclosearea())

RETURN

STATIC FUNCTION GeraLogSEK(cAliasSEK)
// ********* GERAÇÃO DO LOG ********* //
AutoGrLog("LOG de campo atualizado em: "+ DtoC(MsDate())+ ' ' + Time() 		)
AutoGrLog("Nro Ordem Pago  : "			+ (cAliasSEK)->(EK_NUM)				)
AutoGrLog("Valor Anterior EK_VLMOED1 : "+ Alltrim(STR(nValAnt))				)
AutoGrLog("Valor Atual EK_VLMOED1 : "	+ ALLTRIM(STR(SEK->(EK_VLMOED1))) 	)
AutoGrLog("Recno do Registro SEK: "		+ ALLTRIM(STR((cAliasSEK)->(RECNOSEK)))	  )
AutoGrLog("-----------------------------------------------------")
// ********* FINAL DA GERAÇÃO DO LOG ********* //
Return

STATIC FUNCTION ConfirmaX()
Local lOk := .F.

lOk := MsgYesNo("A base de dados será alterada após esta confirmação! Tem certeza que deseja atualizá-la?")

Return lOk