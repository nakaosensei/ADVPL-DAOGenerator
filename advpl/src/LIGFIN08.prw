#Include 'Protheus.ch'
#Include "TOPCONN.CH"

/*
LIGFIN08 - RELATORIO DE CONTAS A RECEBER POR DATA AGREGANDO VALOR POR FILIAL E MODELO DE NOTA EXCEL
AUTOR    - ROBSON ADRIANO
DATA     - 24/11/14
*/

User Function LIGFIN08()
Local nOrdem                        // publica variavel
Private cDirDocs := MsDocPath()     // priva variavel com o caminho do arquivo temporario na rotina
Private cNomeArq := CriaTrab(,.F.)
Private	CPERG       := "LIGFIN07  "

If !pergunte(cPerg,.T.)
	Return()
Endif

cAliasTop1 := GetNextAlias()        // da um nome pro arquivo temporario
 
_CQUERY := " SELECT F2.F2_FILIAL,F2.F2_SERIE, F2.F2_DOC, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_TIPO, E1.E1_EMISSAO, E1.E1_BAIXA, E5.E5_DTDISPO, E1.E1_VALOR,  E1.E1_VALLIQ, E1.E1_SALDO, F2.F2_VALBRUT, "
_CQUERY += "        E1.E1_UFILNF1, E1.E1_USERNF1, E1.E1_UNUMNF1, E1.E1_UVALNF1, "
_CQUERY += "        E1.E1_UFILNF2, E1.E1_USERNF2, E1.E1_UNUMNF2, E1.E1_UVALNF2, "
_CQUERY += "        E1.E1_UFILNF3, E1.E1_USERNF3, E1.E1_UNUMNF3, E1.E1_UVALNF3, "
_CQUERY += "        E1.E1_UFILNF4, E1.E1_USERNF4, E1.E1_UNUMNF4, E1.E1_UVALNF4, "
_CQUERY += "        E1.E1_UFILNF5, E1.E1_USERNF5, E1.E1_UNUMNF5, E1.E1_UVALNF5  "
_CQUERY += " FROM "+RETSQLNAME("SE1")+" E1, "+RETSQLNAME("SF2")+" F2, "+RETSQLNAME("SE5")+" E5 "
_CQUERY += " WHERE ((E1.E1_UFILNF1=F2.F2_FILIAL AND E1.E1_USERNF1=F2.F2_SERIE AND E1.E1_UNUMNF1=F2.F2_DOC) "
_CQUERY += " OR (E1.E1_UFILNF2=F2.F2_FILIAL AND E1.E1_USERNF2=F2.F2_SERIE AND E1.E1_UNUMNF2=F2.F2_DOC) "  
_CQUERY += " OR (E1.E1_UFILNF3=F2.F2_FILIAL AND E1.E1_USERNF3=F2.F2_SERIE AND E1.E1_UNUMNF3=F2.F2_DOC) "  
_CQUERY += " OR (E1.E1_UFILNF4=F2.F2_FILIAL AND E1.E1_USERNF4=F2.F2_SERIE AND E1.E1_UNUMNF4=F2.F2_DOC) " 
_CQUERY += " OR (E1.E1_UFILNF5=F2.F2_FILIAL AND E1.E1_USERNF5=F2.F2_SERIE AND E1.E1_UNUMNF5=F2.F2_DOC)) "
_CQUERY += " AND F2.F2_FILIAL = '" + MV_PAR01 + "'"                                      
_CQUERY += " AND F2.F2_SERIE =  '" + MV_PAR02 + "'"                                     
_CQUERY += " AND E5.E5_DTDISPO >= '"+DTOS(MV_PAR03)+"'                                  
_CQUERY += " AND E5.E5_DTDISPO <= '"+DTOS(MV_PAR04)+"'                                    
_CQUERY += " AND E5.E5_NUMERO = E1.E1_NUM "                                           
_CQUERY += " AND E5.E5_PARCELA= E1.E1_PARCELA "                                           
_CQUERY += " AND E5.E5_PREFIXO= E1.E1_PREFIXO "                                                                              
_CQUERY += " AND E5.E5_TIPODOC= 'VL' "                                                                              
_CQUERY += " AND E1.D_E_L_E_T_=' ' "                                           
_CQUERY += " AND F2.D_E_L_E_T_=' ' "                                           
_CQUERY += " AND E5.D_E_L_E_T_=' ' "                                           
_CQUERY += " ORDER BY E1.E1_BAIXA, E1.E1_NUM, E1.E1_PARCELA"   
                                        
_CQUERY := CHANGEQUERY(_CQUERY)
                  
TCQUERY _CQUERY NEW ALIAS "VENDX"                                             // executa a query e coloca a resposta em um alias
EXPEXCEL("VENDX") 
                                                              // executa a funcao excel com o arquivo temporario gerado
IF SELECT ("VENDX") > 0                                                                                                                                                                                                                          // para saber se nao esta em branco
   VENDX->(DBCLOSEAREA())                                                       // se esta em branco sai da rotina
ENDIF                                                                           // fecha o loop

FErase(cDirDocs+"\"+cNomeArq+".DBF")                                           // apaga o temporario

Return NIL                                                                      // retorna para o menu


STATIC FUNCTION EXPEXCEL(AREA)
Local cPath    := AllTrim(GetTempPath())
Local oExcelApp
Local cArquivo := cNomeArq

If ! ApOleClient( "MsExcel" )
   MsgStop("MsExcel nao instalado")
   Return Nil      
EndIf

dbSelectArea(AREA)              

X := cDirDocs+"\"+cArquivo+".DBF"
COPY TO &X VIA "DBFCDXADS"
CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , cPath, .T. )

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".DBF" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)
Return
