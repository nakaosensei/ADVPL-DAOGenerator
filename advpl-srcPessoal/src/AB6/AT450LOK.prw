#include 'protheus.ch'
#include 'parmtype.ch'

user function AT450LOK()
	/*
	Local _area := getarea()
	Local _aAB7 := AB7->(getarea())
	Local _cCodAda
	Local _cSituBoas := getmv("MV_UBOASV") //Situacao do boas vindas
	Local uNkProblems := {} //Array usado para validacao
	Local uNkOS := M->AB6_NUMOS //Num OS
	Local uNkItem := "" //Item da OS
	Local uNkCodTec := AB6->AB6_UCODAT //Codigo do atendente da OS
	Local unkCabEM := "" //String para exibir ra mensagem de erro de strOut com o cabecalho no comeco
	Local unkErrorMsg := "" //String para armazenar mensagem de erro
	IF !Inclui
		CONOUT("ENTROU AT450LOK "+TIME())
		CONOUT("FILIAL+OS:"+xFilial("AB6")+M->AB6_NUMOS)
		dbselectarea("AB7")
		dbsetorder(1)
		dbseek(xFilial("AB6")+M->AB6_NUMOS)
		while !eof() .AND. xFilial("AB6")+M->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
			uNkItem := AB7->AB7_ITEM
			CONOUT("AB7 ITEM "+uNkItem+" AB7_TIPO "+AB7->AB7_TIPO+" AB7_BAIXA "+AB7->AB7_UBAIXA)
			IF AB7->AB7_TIPO=='5' .and. ALLTRIM(AB7->AB7_UBAIXA)<> "S" //Se o item da OS ainda nao foi baixado
				CONOUT("ENTROU NA CONDICAO AB7_TIPO = 5, AB7_BAIXA DIFERENTE DE S")
				_aABC := ABC->(getarea())
				dbselectarea("ABC")
				dbsetorder(1)//ABC_FILIAL+ABC_NUMOS+ABC_CODTEC+ABC_SEQ+ABC_ITEM				
				/*
				O dbSeek a seguir pode parecer estranho, mas eu o irei explicar.
				Perceba que o campo ABC_NUMOS e composto pelo numero da OS de 6 caracteres mais os dois
				ultimos caracteres que sao referentes ao item daquela OS, no dbSeek o uNkItem nao vai
				filtrar por ABC_CODTEC+ABC_SEQ, mas sim pelo item da OS em ABC.	
				Tendo selecionado o item em questão na busca do laco de repeticao(Que percorre os itens)			
				*/
		/*
				if dbseek(xFilial("AB6")+uNkOS+uNkItem)	
					CONOUT("ENTROU DBSEEK xFiliAB6 + unkOS + uNkItem")
					CONOUT(xFilial("AB6")+uNkOS+uNkItem)
					while !eof() .and. xFilial("AB6")+uNkOS+uNkItem==ABC->ABC_FILIAL+ABC->ABC_NUMOS
						CONOUT("ENTROU WHILE !eof() .and. xFilial(AB6)+uNkOS+uNkItem==ABC->ABC_FILIAL+ABC->ABC_NUMOS")
						dbselectarea("SB1")
						dbsetorder(1)
						if dbseek(xFilial()+ABC->ABC_CODPRO)
							_local := ""
							if empty(ABC->ABC_UARMAZ)
								_local := SB1->B1_LOCPAD
							else
								_local := ABC->ABC_UARMAZ
							endif														
							cAliasSB2 := GetNextAlias()
							cQuery := "SELECT B2_QATU FROM "+RetSqlName("SB2")+" SB2 WHERE SB2.B2_FILIAL='LG01' AND SB2.B2_COD='" +ALLTRIM(SB1->B1_COD)+"' AND SB2.B2_LOCAL='"+_local+"' AND SB2.D_E_L_E_T_<>'*'"
							cQuery := ChangeQuery(cQuery)	 
							CONOUT(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB2,.T.,.T.)
							nkQtEstoque := (cAliasSB2)->B2_QATU //Quantidade em estoque do armazem do produto em quatao
							CONOUT(nkQtEstoque)
							CONOUT(ABC->ABC_QUANT)
							if nkQtEstoque = nil .OR. nkQtEstoque < ABC->ABC_QUANT	
								CONOUT("PROBLEM")
								//aAdd(uNkProblems, {POSICIONE("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_DESC")+"("+SB1->B1_COD+")",_local})
							endif	
						endif
						dbselectarea("ABC")
						dbskip()						
					enddo
						
					if len(uNkProblems)>0							
						for nki := 1 to len(uNkProblems)
							unkErrorMsg := unkErrorMsg + u_barraN("PRODUTO:"+ALLTRIM(uNkProblems[nki][1])+"  ARMAZEM:"+ALLTRIM(uNkProblems[nki][2]))									
						next
						MsgAlert(unkErrorMsg)
						return .F.												
					endif		
				endif
				restarea(_aABC)
			endif					
			dbselectarea("AB7")
			dbskip()
		enddo	
	ENDIF
	restArea(_area)
	*/
return .T.