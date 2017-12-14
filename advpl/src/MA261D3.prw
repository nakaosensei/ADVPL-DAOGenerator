User Function MA261D3()
Local nPosUso := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_USOLICI"})
LOCAL REGSD3, I
	_area    := getarea()
	_areaSD3 := SD3->(getarea())
	_doc := SD3->D3_DOC	
	DBSELECTAREA("SD3")
	REGSD3 := RECNO()
	FOR I := LEN(aRegSD3)-1 TO LEN(aRegSD3)     
		DBGOTO(aRegSD3[I])
		IF RECLOCK("SD3",.F.)              
			SD3->D3_USOLICI := ACOLS[PARAMIXB,nPosUso]
			MSUNLOCK()              
		ENDIF
	NEXT
	DBGOTO(REGSD3)
	          
	restarea(_areaSD3)
	restarea(_area)
Return