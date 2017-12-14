#include "PROTHEUS.CH"
#include "AJUSTADATA.CH"      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AJUSTADATA   บAutor  ณTOTVS               บ Data ณ  23/11/10 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os campos E5_VENCTO e E5_DTDISPO quando existir    บฑฑ 
ฑฑบ			 ณmov. que sejam imeditas e tiveram a data de vencimento 	  บฑฑ
ฑฑบ          ณ alterada                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AJUSTADATA()        


If Aviso(STR0001,STR0002 + CHR(13)+CHR(10) + STR0003,{STR0019,STR0021},3) == 1
	Processa({|lEnd| AJUSTADATASE5(@lEnd)},STR0001,STR0020,.F.)
Endif  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  AJUSTADATA   บAutor  ณTOTVS               บ Data ณ  23/11/10 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os campos E5_VENCTO e E5_DTDISPO quando existir    บฑฑ 
ฑฑบ			 ณmov. que sejam imeditas e tiveram a data de vencimento 	  บฑฑ
ฑฑบ          ณ alterada                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AJUSTADATASE5(lEnd)
Local cQuery := ""
Local aRegs := {}
Local nTot:=0       
Local cTmp := ""

#IFDEF TOP	  

	// Pega os tipos cadastrados que sejam considerados como efetivos
   	cTmp:=GetSESTipos({|| ES_RCOPGER == "2"},"2")



// Seleciona as resposi็๕es de caixinha que foram feitos como imediato porem
// com data de diferen็a diferente da data da reposi็ใo
	cQuery 	:=  "SELECT E5_HISTOR,E5_DATA,E5_VENCTO,E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_TIPO, R_E_C_N_O_ E5_RECNO FROM "+RetSqlName("SE5")
	cQuery	+=	" WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND "
	cQuery	+=	" E5_MOVCX='S' AND E5_TIPO IN " + FormatIn(cTmp,"|") + "	
 	cQuery	+=	" AND E5_RECPAG='P' AND (E5_DATA <> E5_DTDISPO OR E5_DATA <> E5_VENCTO)"
	cQuery	+=	" AND D_E_L_E_T_ = '' " 
	cQuery	+=	" ORDER BY E5_BANCO " 
	

	cQuery 	:= 	ChangeQuery(cQuery)                    
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE5",.F.,.T.)
		   
			
	dbSelectArea("TRBSE5")
		
	While !Eof()
	    Aadd(aRegs,{TRBSE5->E5_HISTOR,TRBSE5->E5_VENCTO,TRBSE5->E5_DATA,TRBSE5->E5_DTDISPO,TRBSE5->E5_BANCO,TRBSE5->E5_AGENCIA,TRBSE5->E5_CONTA,TRBSE5->E5_TIPO,TRBSE5->E5_RECNO,""})
   	  	If TRBSE5->E5_RECNO > 0
   	   		SE5->(DBGOTO(TRBSE5->E5_RECNO))
  			RECLOCK("SE5")
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_VENCTO :=  SE5->E5_DATA 			
 			MSUNLOCK()
	    EndIf 
		dbSelectArea("TRBSE5")
		TRBSE5->(dbSkip())
	EndDo
	
	dbSelectArea("TRBSE5")
	dbCloseArea()	
	
	
	
	// Seleciona as opera็๕es de ordem de pago e recibos que tenham altera็ใo na data de vencimento
	// quando o tipo de pagamento for Imediato

	cQuery 	:=  "SELECT E5_HISTOR,E5_DATA,E5_VENCTO,E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_TIPO, E5_ORDREC,R_E_C_N_O_ E5_RECNO FROM "+RetSqlName("SE5")
	cQuery	+=	" WHERE E5_FILIAL = '"+xFilial("SE5")+"'"
	cQuery	+=	" AND E5_ORDREC<>'' AND E5_TIPO IN " + FormatIn(cTmp,"|") "
 	cQuery	+=	" AND E5_TIPODOC = 'VL' AND E5_SITUACA<>'C'" 
 	cQuery	+=	" AND (E5_DATA <> E5_DTDISPO OR E5_DATA <> E5_VENCTO)"
	cQuery	+=	" AND D_E_L_E_T_ = '' "    
	cQuery	+=	" ORDER BY E5_BANCO " 

	cQuery 	:= 	ChangeQuery(cQuery)                    
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSE5",.F.,.T.)
		   
			
	dbSelectArea("TRBSE5")
		
	While !Eof()
	    Aadd(aRegs,{TRBSE5->E5_HISTOR,TRBSE5->E5_VENCTO,TRBSE5->E5_DATA,TRBSE5->E5_DTDISPO,TRBSE5->E5_BANCO,TRBSE5->E5_AGENCIA,TRBSE5->E5_CONTA,TRBSE5->E5_TIPO,TRBSE5->E5_RECNO,TRBSE5->E5_ORDREC})
	  	If TRBSE5->E5_RECNO > 0
   	   		SE5->(DBGOTO(TRBSE5->E5_RECNO))
  			RECLOCK("SE5")
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_VENCTO :=  SE5->E5_DATA 			
 			MSUNLOCK()
	    EndIf    
		dbSelectArea("TRBSE5")
		TRBSE5->(dbSkip())
	EndDo
	
	dbSelectArea("TRBSE5")
	dbCloseArea()
	
	
	
    If Len(aRegs) > 0 
		FaSE5GerLog( aRegs )
 	Else
  		MsgAlert(STR0004+".")		  
	Endif	
	
#ENDIF
	
Return .T.




Static Function FaSE5GerLog( aRegs )

Local cPath		:= ""
Local cBarra	:= If( isSrvUnix(), "/", "\" )
Local cDirAnt   := CurDir()
Local cSeqArq	:= "01"
Local cArqLog	:= ""
Local cTexto	:= ""
Local cSep		:= ";"
Local cTipoRen	:= ""
Local cPictCNPJ := ""

Local aDirLog	:= {}
Local aX1Def 	:= {}

Local nHandle	:= 0
Local nX		:= 0
Local nValPerg	:= 0

Local lRet		:= .T.

// Caso nao exista, cria pasta para armazenamento do log.
cPath	:= GetSrvProfString("StartPath", "") + If( Right( GetSrvProfString("StartPath",""), 1 ) == cBarra, "", cBarra ) + "LOGSE5"
cArqLog	:= "LOGSE5" + DtoS(dDataBase) + cSeqArq + ".CSV" 

                
// Cria a pasta caso nao exista. 
If !File( cPath )
	MakeDir(cPath)
EndIf

// Muda para pasta 
CurDir( cPath )

// Se o arquivo de log jah existe, gera outro arquivo com nova sequencia inicial
If File(cArqLog)            
	aDirLog := Directory( "LOGSE5" + AllTrim( Str( Year(dDataBase) ) ) + StrZero( Month(dDataBase), 2 ) + StrZero( Day(dDataBase), 2 ) + "??.CSV" )
	aSort( aDirLog,,,{|x,y| x[1] < y[1]} ) 
	cSeqArq := SubStr( aDirLog[ Len(aDirLog), 1 ], 1, At( ".", aDirLog[ Len(aDirLog), 1 ] ) -1 )
	cSeqArq := Soma1( Right( cSeqArq, 2 ) )
	cArqLog := "LOGSE5" + DtoS(dDataBase) + cSeqArq + ".CSV"
EndIf
        
// Tratamento para criacao do arquivo                                
If !File(cArqLog)
	nHandle := fCreate(cArqLog)
	If nHandle < 0                                                                           
		nError := fError()                                                      
		// Nao foi possivel criar o arquivo de Log ### Erro numero: 
		MsgAlert( STR0005 + cArqLog + ". " +STR0006 + PadR( Str(nError), 4 ) )
		lRet := .F.
	Else
		fClose(nHandle)
	EndIf	
Endif

// Se conseguiu criar o arquivo, grava os dados do vetor aLog
If lRet
	
	nHandle := fOpen( cArqLog, 2 )
	fSeek( nHandle, 0, 2 )     // Posiciona no final do arquivo
    
  

	fWrite( nHandle, Chr(13) + Chr(10), 2 )
	fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
	                          
	// Grava titulo das colunas
	cTexto :=	STR0007 + cSep + STR0008	+ cSep + STR0009 + cSep + STR0010 + cSep + STR0011 + cSep + STR0012 + cSep +;
				 STR0013	+ cSep + STR0014 + cSep + STR0015 + cSep + STR0016	
			
	
	fWrite( nHandle, cTexto + Chr(13) + Chr(10), Len(cTexto) + 2 )
	fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
		
			
	// Realiza a grava็ใo dos dados do array no arquivo .CSV
	For nX := 1 To Len( aRegs )
                         
 		cTexto := ""
   

		cTexto += 	ToXLSFormat( aRegs[nX, 5] )	+ cSep + ToXLSFormat(aRegs[nX, 6]  ) + cSep +;
				 	ToXLSFormat( aRegs[nX, 7] )	+ cSep + ToXLSFormat(aRegs[nX, 8]  ) + cSep +;
				 	ToXLSFormat( aRegs[nX, 1] )	+ cSep + ToXLSFormat(aRegs[nX, 10]  ) + cSep +;
				 	ToXLSFormat(aRegs[nX, 2]  ) + cSep + ToXLSFormat( aRegs[nX, 4] ) + cSep + ;
				 	ToXLSFormat(aRegs[nX, 3]  ) + cSep + ToXLSFormat( aRegs[nX, 9] )	
		
		fWrite( nHandle, cTexto + Chr(13) + Chr(10), Len( cTexto ) + 2 )
		fSeek(  nHandle, 0, 2 )     // Posiciona no final do arquivo
		
	Next nX

	fClose( nHandle )
	
	Aviso(STR0017, STR0018 + Str(Len(aRegs)) , {STR0019}, 2)
	
EndIf

// Volta para pasta \system
CurDir( cBarra + cDirAnt )

Return( cArqLog )