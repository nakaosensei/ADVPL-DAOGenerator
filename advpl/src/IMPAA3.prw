#include "protheus.ch"
#include "rwmake.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPAA3    บAutor  ณDaniel Gouvea       บ Data ณ  26/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para importar as bases de atendimento - AA3        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ligue                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPAA3()
Private cPerg   := "IMPAA3"
Private nPosCod := 1
Private nPosCGC := 2
Private nPosSN  := 3
Private nPosMAC := 4

validperg()

if !pergunte(cPerg,.t.)
	return
endif


If File(MV_PAR01)
	FT_FUse(MV_PAR01)
	FT_FGotop()
	aDados := {}
	aLinha := {}
	While !FT_FEOF()
		cLinha := FT_FReadLn()
		i     := 1
		iAux  := i
		nItem := 1
		cCod  := ""
		while i<=len(cLinha)
			if substr(cLinha,i,1)==";"
				aadd(aLinha,substr(cLinha,iAux,i-iAux))
				iAux := i+1
			endif
			i++
		enddo
		
		if substr(cLinha,len(cLinha)-2,1)<>";"
			
			aadd(aLinha,substr(cLinha,len(cLinha)-9,10)) //ULTIMO CAMPO
			
		else
			aadd(aLinha,"") //ULTIMO CAMPO, NรO TEM O ;
		endif
		aadd(aDados,aLinha)
		aLinha := {}
		FT_FSkip()
	EndDo
	FT_FUse()
else
	MSGINFO("Arquivo nใo encontrado. Favor verificar os parametros.")
endif

if len(aDados)==0
	msginfo("Nao existem dados para importar.")
	return
endif

for i:=1 to len(aDados)
	dbselectarea("SA1")
	dbsetorder(3)   //A1_FILIAL+A1_CGC
	if dbseek(xFilial()+aDados[i,nPosCGC])
		dbselectarea("SB1")
		dbsetorder(1)
		if dbseek(xFilial()+aDados[i,nPosCod])
			dbselectarea("AA3")
			dbsetorder(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
			if !dbseek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SB1->B1_COD+aDados[i,nPosSN])
				RECLOCK("AA3",.T.)
				AA3->AA3_FILIAL := XFILIAL("AA3")
				AA3->AA3_CODCLI := SA1->A1_COD
				AA3->AA3_LOJA   := SA1->A1_LOJA
				AA3->AA3_CODPRO := SB1->B1_COD
				AA3->AA3_NUMSER := aDados[i,nPosSN]
				AA3->AA3_CHAPA  := aDados[i,nPosMAC]
				AA3->AA3_DTVEND := ddatabase
				AA3->AA3_DTGAR  := ddatabase
				MSUNLOCK()
			endif			
		else
			alert("Nao existe o produto "+aDados[i,nPosCGC])
		endif
	else
		alert("Nao existe o CNPJ "+aDados[i,nPosCGC])
		return
	endif
next

return

Static Function ValidPerg
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aadd(aRegs,{cPerg,"01","Arquivo a Importar","Arquivo a Importar","Arquivo a Importar","mv_ch1","C",80,0,0,"G","MV_PAR01:=cGetFile('Selecao |*.*|','Selecione diretorio')   ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return
