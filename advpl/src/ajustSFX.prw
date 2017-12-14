#INCLUDE "PROTHEUS.CH"

User Function ajustSFX()       

wfprepenv("01","LG01")

dbselectarea("SFT")
dbsetorder(1)
dbgotop()
while !eof()
	if alltrim(SFT->FT_SERIE)=="21" .or. alltrim(SFT->FT_SERIE)=="22" .AND. ALLTRIM(SFT->FT_OBSERV)<>"NOTA CANCELADA" .AND. SFT->FT_FILIAL==cFilAnt
		RecLock("SFX",.T.)
 		SFX->FX_FILIAL  := SFT->FT_FILIAL
		SFX->FX_TIPOMOV := SFT->FT_TIPOMOV
		SFX->FX_DOC     := SFT->FT_NFISCAL
		SFX->FX_SERIE   := SFT->FT_SERIE
		SFX->FX_ESPECIE := SFT->FT_ESPECIE
		SFX->FX_CLIFOR  := SFT->FT_CLIEFOR
		SFX->FX_LOJA    := SFT->FT_LOJA
		SFX->FX_ITEM    := SFT->FT_ITEM
		SFX->FX_COD     := SFT->FT_PRODUTO
//		SFX->FX_GRPCLAS := SFT->FT_GRPCLAS
//		SFX->FX_CLASSIF := SFT->FT_CLASSIF
		SFX->FX_TIPOREC := SFT->FT_TIPO
		SFX->FX_TIPSERV := "0"
		dbselectarea("SA1")
		dbsetorder(1)
		if dbseek(xFilial()+SFT->FT_CLIEFOR+SFT->FT_LOJA)
			if SA1->A1_PESSOA=="F"
				SFX->FX_TPASSIN := "3"    
			else
				SFX->FX_TPASSIN := "1"    
			endif                       
		endif
		SFX->FX_TPCLASS := ''
		SFX->FX_CLASCON := '00'
		SFX->FX_GRPCLAS := '01'
		SFX->FX_CLASSIF := '01'
		SFX->FX_VALTERC := 50.00
		SFX->FX_TIPOREC := '0'
		SFX->FX_RECEP   := SFT->FT_CLIEFOR
		SFX->FX_LOJAREC := SFT->FT_LOJA
		SFX->FX_TIPSERV := '0'
		SFX->FX_DTINI   := STOD("20140901")
		SFX->FX_DTFIM   := STOD("20140930")
		SFX->FX_PERFIS  := SUBSTR(DTOS(SFT->FT_EMISSAO),5,2)+SUBSTR(DTOS(SFT->FT_EMISSAO),1,4)
		SFX->FX_AREATER := ''
		SFX->FX_TERMINA := '44'
		SFX->FX_VOL115  := ''
		dbselectarea("SF3")
		dbsetorder(4)//F3_FILIAL+F3_CLIEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE
		if dbseek(xFilial()+SFT->FT_CLIEFOR+SFT->FT_LOJA+SFT->FT_NFISCAL+SFT->FT_SERIE)
			SFX->FX_CHV115  := SF3->F3_MDCAT79       
		else
			SFX->FX_CHV115  := "NAO ACHOU SF3"
		endif
//		SFX->FX_TPASSIN        :='3'
		SFX->FX_ESTREC         :='2'
		
		MsUnLock()
	endif
	dbselectarea("SFT")
	dbskip()
enddo

return
