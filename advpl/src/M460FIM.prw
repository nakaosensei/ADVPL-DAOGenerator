User Function M460FIM()
Local aAreaOLD := GetArea()
Local _aSE1  := SE1->(GETAREA())

if ALLTRIM(funname())<>"LIGFAT01"
	dbselectarea("SE1")
	dbsetorder(2)
	dbseek(xfilial()+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL)
	while !eof() .and. SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DUPL == SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM
		if empty(SE1->E1_USERNF1)
			RECLOCK("SE1",.F.)
			SE1->E1_USERNF1 := SF2->F2_SERIE
			SE1->E1_UFILNF1 := SF2->F2_FILIAL
			SE1->E1_UNUMNF1 := SF2->F2_DOC
			SE1->E1_UVALNF1 := SF2->F2_VALBRUT
			MSUNLOCK()
		ENDIF
		dbselectarea("SE1")
		dbskip()
	enddo
ENDIF
restarea(_aSE1)
RESTAREA(aAreaOLD)
RETURN
