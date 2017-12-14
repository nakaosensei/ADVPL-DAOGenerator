#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
                             
User Function GeraSFX(cDoc,cSerie)
Local cSql := ""
//Local aArea := GetArea()
Private cPerg := "GERASFX"

If cDoc == nil
	MsgInfo("Esta rotina irá gerar registros na tabela SFX - Complementos fiscais de Comunicaçao/Energia.")
	Validperg()
	If !Pergunte(cPerg,.T.)
		Alert("Cancelado pelo Usuário!")
		Return
	EndIf
Else
	Pergunte(cPerg,.F.)	
	mv_par01 := cSerie
EndIf

cSql := " SELECT FT_FILIAL AS FX_FILIAL, FT_TIPOMOV AS FX_TIPOMOV, FT_NFISCAL AS FX_DOC, FT_SERIE AS FX_SERIE, FT_ESPECIE AS FX_ESPECIE, "
cSql += " FT_CLIEFOR AS FX_CLIFOR, FT_LOJA AS FX_LOJA,  FT_ITEM AS FX_ITEM,  FT_PRODUTO AS FX_COD,  SUBSTRING(B5_CLIT,1,2) AS  FX_GRPCLAS, "
cSql += " SUBSTRING(B5_CLIT,3,2) AS FX_CLASSIF, '0' as FX_TIPOREC, "//-- 0=Serviços prestados
cSql += " CASE WHEN A1_TPUTI = '1' THEN '0'  " //--Telefonia
cSql += " 	ELSE  "
cSql += " 	CASE WHEN A1_TPUTI = '2' THEN '1'  " //--Comunicacao de Dados
cSql += " 		ELSE  "
cSql += " 		CASE WHEN A1_TPUTI = '3' THEN '2'  " //--Tv Assinatura
cSql += " 			ELSE  "
cSql += " 			CASE WHEN A1_TPUTI = '4' THEN '3'  " //--Internet
cSql += " 				ELSE  "
cSql += " 				CASE WHEN A1_TPUTI = '5' THEN '4'  " //--Multimidia
cSql += " 					ELSE  "
cSql += " 					CASE WHEN A1_TPUTI = '6' THEN '9'  " //--Outros
cSql += " 						ELSE '' "
cSql += " 					END "
cSql += " 				END "
cSql += " 			END "
cSql += " 		END "
cSql += " 	END "
cSql += " END   "
cSql += " as FX_TIPSERV,  "
cSql += " A1_TPASS as FX_TPASSIN "
cSql += " FROM "+RetSqlName("SFT")+" SFT "
cSql += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
//cSql += " 	ON A1_FILIAL = FT_FILIAL "
cSql += " 	ON A1_COD = FT_CLIEFOR "
cSql += " 	AND A1_LOJA = FT_LOJA "
cSql += " 	AND SA1.D_E_L_E_T_ <>'*' "
cSql += " LEFT JOIN "+RetSqlName("SB5")+" SB5 "
//cSql += " 	ON B5_FILIAL = FT_FILIAL "
cSql += " 	ON B5_COD = FT_PRODUTO "
cSql += " 	AND SB5.D_E_L_E_T_ <>'*' "
cSql += " WHERE FT_FILIAL='"+xFilial("SFT")+"'  "
cSql += " AND FT_TIPOMOV='S' "
If cDoc == nil
	cSql += " AND FT_ENTRADA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
	cSql += " AND FT_SERIE='"+MV_PAR01+"' "
Else
	cSql += " AND FT_NFISCAL = '"+cDoc+ "' "
	cSql += " AND FT_SERIE='"+cSerie+"' "
EndIf
//cSql += " AND FT_ESPECIE='NTSC'  "
cSql += " AND SFT.D_E_L_E_T_ <>'*'  "
cSql += " GROUP BY FT_FILIAL , FT_TIPOMOV , FT_NFISCAL , FT_SERIE , FT_ESPECIE , "
cSql += " FT_CLIEFOR ,FT_LOJA , FT_ITEM , FT_PRODUTO, B5_CLIT, A1_TPUTI, A1_TPASS "

MemoWrite("C:\Temp\QUERY_SFX.TXT",cSql)

If Select("QRY") > 0
	QRY->(DbCloseArea() )
EndIf

TcQuery cSql New Alias "QRY"
DbSelectArea("QRY")
DbGoTOp()
While !EOF() .AND. !Empty(QRY->FX_DOC)
	DbSelectArea("SFX")
	DbSetOrder(1)
	If DbSeek( QRY->( FX_FILIAL+FX_TIPOMOV+FX_SERIE+FX_DOC+FX_CLIFOR+FX_LOJA+FX_ITEM+FX_COD ) )
		RecLock("SFX",.F.)
	Else
		RecLock("SFX",.T.)
	EndIf
	
	SFX->FX_FILIAL 	:= QRY->FX_FILIAL
	SFX->FX_TIPOMOV := QRY->FX_TIPOMOV
	SFX->FX_DOC 	:= QRY->FX_DOC
	SFX->FX_SERIE 	:= QRY->FX_SERIE
	SFX->FX_ESPECIE := QRY->FX_ESPECIE
	SFX->FX_CLIFOR 	:= QRY->FX_CLIFOR
	SFX->FX_LOJA 	:= QRY->FX_LOJA
	SFX->FX_ITEM 	:= QRY->FX_ITEM
	SFX->FX_COD     := QRY->FX_COD         
//	SFX->FX_GRPCLAS := QRY->FX_GRPCLAS
	SFX->FX_CLASSIF := QRY->FX_CLASSIF
	SFX->FX_TIPOREC := QRY->FX_TIPOREC
	SFX->FX_TIPSERV := QRY->FX_TIPSERV
	SFX->FX_TPASSIN := QRY->FX_TPASSIN 
	SFX->FX_TPCLASS	:=''
	SFX->FX_CLASCON :='00'
	SFX->FX_GRPCLAS :='01'
	SFX->FX_CLASSIF :='01'
	SFX->FX_VALTERC :=50.00
	SFX->FX_TIPOREC :='0'
	SFX->FX_RECEP   :=QRY->FX_CLIFOR
	SFX->FX_LOJAREC :=QRY->FX_LOJA
	SFX->FX_TIPSERV :='0'
	SFX->FX_DTINI   :=MV_PAR02
	SFX->FX_DTFIM   :=MV_PAR03
	SFX->FX_PERFIS  := Month2Str(MV_PAR02)+Year2Str(MV_PAR02)
	SFX->FX_AREATER :=''            
	SFX->FX_TERMINA	:='44'
	SFX->FX_VOL115  :=''
	SFX->FX_CHV115  :=SF3->F3_MDCAT79    
	SFX->FX_TPASSIN :='3'
	SFX->FX_ESTREC  :='2'
	
	nAnoMes := '14'+Month2Str(MV_PAR02)+'NM'
	IF ALLTRIM(QRY->FX_ESPECIE) == 'NFSC'
		SFX->FX_VOL115  :='PR21 '+nAnoMes
	ENDIF
	IF ALLTRIM(QRY->FX_ESPECIE) == 'NTST'
		SFX->FX_VOL115  :='PR22 '+nAnoMes
	ENDIF  
	
	MsUnLock()
	
	QRY->( DbSkip() )
EndDo

If cSerie == nil
   MsgInfo("Processo finalizado")
EndIf

//RestArea(aArea)

Return

Static Function ValidPerg()
Private _sAlias,i,j
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

AADD(aRegs,{cPerg,"01","Serie           ?",Space(20),Space(20),"mv_ch1","C",3,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data de         ?","Espanhol","Ingles","mv_ch2","D",8,0,0,"G","","mv_par02","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data ate        ?","Espanhol","Ingles","mv_ch3","D",8,0,0,"G","","mv_par03","","","","'"+DTOC(dDataBase)+"'","","","","","","","","","","","","","","","","","","","","","",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			if j <= len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			endif
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

dbSelectArea(_sAlias)
