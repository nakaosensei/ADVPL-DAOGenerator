#Include 'Protheus.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#include "totvs.ch"


// ROTINA LIBERAÇÃO DE C.R PARA APARECER NO PORTAL E ENVIO DE EMAILS NOTIFICANDO QUE A FATURA ENCONTRA-SE NO PORTAL.
User Function LIGFAT10()
Local aArea := GetArea()
Private oMark
Private aRotina := MenuDef()
Private _CPERG		:= "FAT10A"

VALIDPERG()
IF !PERGUNTE(_CPERG)
	RETURN
ENDIF 
//{1-PREF, 2-NUM, 3-PARC, 4-TIPO, 5-CLIENTE, 6-LOJA}
// Instanciamento do classe
oMark := FWMarkBrowse():New()

// Definição da tabela a ser utilizada
oMark:SetAlias('SE1')
// Define se utiliza controle de marcação exclusiva do oMark:SetSemaphore(.T.)
// Define a titulo do browse de marcacao
oMark:SetDescription('Seleção para Impressão de Faturas')
// Define o campo que sera utilizado para a marcação
oMark:SetFieldMark( 'E1_OK' )
// Define a legenda
filtro := "E1_BAIXA = '' .AND. E1_PREFIXO = '"+mv_par03+"' .AND. E1_VENCTO >= '" +DTOS(mv_par01)+ "' .AND. E1_VENCTO <= '" +DTOS(mv_par02)+ "' .AND. E1_ULIBFAT <> 'S'"
filtro += " .AND. E1_NUM >= '" +mv_par04+ "' .AND. E1_NUM <= '" +mv_par05+ "'"
oMark:SetFilterDefault(filtro)

// Ativacao da classe
oMark:AllMark()
oMark:Activate()

RestArea( aArea )
Return

Static Function MenuDef()
Local aRotina := {}
ADD OPTION aRotina TITLE 'Liberar Titulo(s)' ACTION 'U_FAT10A' OPERATION 2 ACCESS 0
Return aRotina

User Function FAT10A()
	PROCESSA({||FAT10B()})
RETURN
	
Static Function FAT10B()
Local aArea := GetArea()
Local cMarca := oMark:Mark()
Local nCt := 0
Local nEm := 0
Local _ATITULOS	:= {}
Local _NImprimi := ""
LOCAL _NQTREGUA := 0
Local _email := "robson.adriano@liguetelecom.com.br,financeiro@liguetelecom.com.br"
Local _cCemail := "suporte.ftth@liguetelecom.com.br"
Local _cAssunto := "Fatura Ligue Telecom"
Local _cAssunto1 := "Clientes sem email no Totvs"
Local _NImprimi := ""

DBSELECTAREA("SE1")
DBSETORDER(1)
DBGOTOP()
WHILE !EOF()
	_NQTREGUA++
	DBSKIP()
ENDDO

PROCREGUA(_NQTREGUA)

SE1->( dbGoTop() )
While !SE1->( EOF() ) 
	INCPROC("Processando...")

	If oMark:IsMark(cMarca)
			// Apenas Faturas com vencimento anterior ao Database pode ser impressas, atrazadas apenas por boleto
			if  EMPTY(SE1->E1_BAIXA) .AND. SE1->E1_PREFIXO = mv_par03 .AND. SE1->E1_VENCTO >= mv_par01 .AND. SE1->E1_VENCTO <= mv_par02 .AND. SE1->E1_ULIBFAT <> 'S' .AND. E1_NUM >= mv_par04 .AND. E1_NUM <= mv_par05
				
				
				_emailCli := ""
				_emailCli := POSICIONE( "SA1", 1, XFILIAL( "SA1" ) + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_EMAIL")
			   _emailCli := ALLTRIM(_emailCli)
			    
   			    IF EMPTY(_emailCli) .OR. !ISEMAIL(_emailCli)
   			    	_NImprimi  +="<p>Codigo : "+ SE1->E1_CLIENTE+" - "+SE1->E1_LOJA+" - Nome : "+SE1->E1_NOMCLI+" </p>"	
   			    ELSE
	   			    _MSG := msgNotificacao(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_NOMCLI,SE1->E1_EMISSAO,SE1->E1_VENCTO,SE1->E1_VALOR)
	   			   	 U_LIGGEN03(LOWER(_emailCli),"","",_cAssunto,_MSG,.T.,"")
	   			   	 nEm++
   			    ENDIF
   			    
   			    RecLock('SE1', .F.)
					SE1->E1_ULIBFAT := "S"
				 MsUnLock()
   			    nCt++
			endif
	EndIf

	SE1->( dbSkip() )
End

IF nCt > 0
	ApMsgInfo( 'Foram marcados ' + AllTrim( Str( nCt ) ) + ' registros. Foram enviados ' + AllTrim( Str( nEm ) ) + ' emails.')
ENDIF

IF !EMPTY (_NImprimi)
	MSGINFO("Total de clientes sem email : " + Str(nCt - nEm))
	U_LIGGEN03(_email,"","",_cAssunto1,_NImprimi,.T.,"")
ENDIF

RestArea( aArea )
Return

/*
	VALIDAPERG
*/
STATIC FUNCTION VALIDPERG
*********************************
_SALIAS := ALIAS()
AREGS := {}

DBSELECTAREA("SX1")
DBSETORDER(1)
_CPERG := PADR(_CPERG,10)

//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
AADD(aRegs,{_CPERG,"01","Vencimento de         ?","Espanhol","Ingles","mv_ch1","D",8,0,0,"G","","mv_par01","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{_CPERG,"02","Vencimento ate        ?","Espanhol","Ingles","mv_ch2","D",8,0,0,"G","","mv_par02","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"03","Prefixo      ?","","","MV_CH3","C",03,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"04","Numero DE      ?","","","MV_CH4","C",09,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(AREGS,{_CPERG,"05","Numero ATE     ?","","","MV_CH5","C",09,0,0, "G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})

FOR I:=1 TO LEN(AREGS)
	IF !DBSEEK(_CPERG+AREGS[I,2])
		RECLOCK("SX1",.T.)
		FOR J:=1 TO FCOUNT()
			IF J <= LEN(AREGS[I])
				FIELDPUT(J,AREGS[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
DBSELECTAREA(_SALIAS)
RETURN

Static Function msgNotificacao(_NPrefixo, _NNUM,_NParcela, _CNome,_DEmissao,_DVenc ,_NValor)
Local _cMsg := ""

_cMsg += "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
_cMsg += "<html xmlns='http://www.w3.org/1999/xhtml'>"
_cMsg += "<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
_cMsg += "<title>Ligue Telecom</title>"
_cMsg += "<style type='text/css'>"
_cMsg += "body {margin: auto; height: auto; min-height: 100%;font-size: 20px;font-family: 'Trebuchet MS', Verdana, Arial, Helvetica, sans-serif;}"
_cMsg += "a:link {text-decoration:none;} "
_cMsg += "th {text-align: rigth;}"
_cMsg += "</style>"
_cMsg += "</head>" 
_cMsg += "<body>"
_cMsg += "<div style='min-width: 600px;'>"
_cMsg += "<img src='http://portal.liguetelecom.com.br/faturaLigue.png' width='1000' height='214' border='0' align='top' usemap='#Ligue'/>"
_cMsg += "<br/><br/><br/>"
_cMsg += "<table border=1 style='min-width:1000px;'><tr>"
_cMsg += "<th>Prefixo</th>"
_cMsg += "<th>Titulo</th>"
_cMsg += "<th>Parcela</th>" 
_cMsg += "<th>Emissão</th>" 
_cMsg += "<th>Vencimento</th>" 
_cMsg += "<th>Valor</th>" 
_cMsg += "<th>Portal</th></tr>" 
_cMsg += "<tr><td>"+_NPrefixo+"</td>"
_cMsg += "<td>"+_NNUM+"</td>"
_cMsg += "<td>"+_NParcela+"</td>"
_cMsg += "<td>"+Transform(_DEmissao,"@E")+"</td>"
_cMsg += "<td>"+Transform(_DVenc,"@E")+"</td>"
_cMsg += "<td>R$"+Transform(_NValor,"@E 9,999,999.99",)+"</td>"
_cMsg += "<td><a href='http://portal.liguetelecom.com.br/'>Acessar</a></td>"
_cMsg += "</tr></table>"
_cMsg += "</br><p>Para retirar a segunda ou tirar extrato de ligações acesse o portal do cliente: <a href='http://portal.liguetelecom.com.br/'>portal.liguetelecom.com.br</a></p>"
_cMsg += "</br><p>Mensagem Enviada Automáticamente pelo sistema da Ligue Telecom.</p>"
_cMsg += "</div>"
_cMsg += "</body>"
_cMsg += "</html>"


RETURN _cMsg