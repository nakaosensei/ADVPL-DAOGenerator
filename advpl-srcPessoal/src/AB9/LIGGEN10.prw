#Include 'Protheus.ch'

/*
	@author:nakao
	Trigger para retornar o a proxima sequencia do atendimento da OS.
	Requisitos:
	M->AB9_CODTEC
	M->AB9_NUMOS
	Ambos devem estar carregados
*/
User Function LIGGEN10()
	Local _area := getarea()
	Local seque := 0
	Local strSq := "01"
	cAliasAB9 := GetNextAlias()
	cQuery := "SELECT MAX(AB9_SEQ) AS AB9_SEQ FROM "+RetSqlName("AB9")+" AB9 WHERE AB9.AB9_FILIAL='"+xFilial("AB9")+"' AND AB9.AB9_CODTEC='" +M->AB9_CODTEC+"' AND AB9.AB9_NUMOS='" +M->AB9_NUMOS+"' AND AB9.D_E_L_E_T_<>'*'"
	cQuery := ChangeQuery(cQuery)	 
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAB9,.T.,.T.)
	strSq := (cAliasAB9)->AB9_SEQ
	if(strSq <> nil)
		seque := VAL(strSq)+1	
	endif
	if(seque<=9)
		strSq := "0"+CVALTOCHAR(seque)
	else
		strSq := CVALTOCHAR(seque)
	endif
	dbCloseArea()
	dbSelectArea("AB9")
	restarea(_area)	
Return strSq