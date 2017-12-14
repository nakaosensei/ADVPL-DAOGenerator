#include 'protheus.ch'
#include 'parmtype.ch'

user function AT450LOK()
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
		dbselectarea("AB7")
		dbsetorder(1)
		dbseek(xFilial("AB6")+M->AB6_NUMOS)
		while !eof() .AND. xFilial("AB6")+M->AB6_NUMOS==AB7->AB7_FILIAL+AB7->AB7_NUMOS
			uNkItem := AB7->AB7_ITEM
			IF AB7->AB7_TIPO=='5' //ENCERRADO		
				//INICIO VALIDACAO MOVIMENTO INTERNO
				if(ALLTRIM(AB7->AB7_UBAIXA)<> "S")//Se o item da OS ainda nao foi baixado			
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
						if dbseek(xFilial("AB6")+uNkOS+uNkItem)
							_aCab := {}
							_aItem := {}
							_atotitem:={}
							lMsErroAuto := .f.
							lMsHelpAuto := .f.
							_aCab := { {"D3_TM" ,"509" , NIL},{"D3_EMISSAO" ,ddatabase, NIL}}
							while !eof() .and. xFilial("AB6")+uNkOS+uNkItem==ABC->ABC_FILIAL+ABC->ABC_NUMOS
								dbselectarea("SB1")
								dbsetorder(1)
								if dbseek(xFilial()+ABC->ABC_CODPRO)
									_local := ""
									if empty(ABC->ABC_UARMAZ)
										_local := SB1->B1_LOCPAD
									else
										_local := ABC->ABC_UARMAZ
									endif
									_aItem:={ {"D3_COD" ,SB1->B1_COD ,NIL},{"D3_UM" ,SB1->B1_UM ,NIL},{"D3_QUANT" ,ABC->ABC_QUANT ,NIL},{"D3_LOCAL" ,_local ,NIL}}
									aAdd(_atotitem,_aitem)
								endif
								dbselectarea("ABC")
								dbskip()						
							enddo
							
							if len(_aCab)>0 .and. len(_atotitem)>0
								lMsErroAuto := .F.
								_auxMod := nModulo
								nModulo := 4		
												
								for nki:=1 to len(_atotitem)
									cAliasSB2 := GetNextAlias()
									cQuery := "SELECT B2_QATU FROM "+RetSqlName("SB2")+" SB2 WHERE SB2.B2_FILIAL='LG01' AND SB2.B2_COD='" +ALLTRIM(_atotitem[nki][1][2])+"' AND SB2.B2_LOCAL='"+ALLTRIM(_atotitem[nki][4][2])+"' AND SB2.D_E_L_E_T_<>'*'"
									cQuery := ChangeQuery(cQuery)	 
									dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB2,.T.,.T.)
									nkQtEstoque := (cAliasSB2)->B2_QATU //Quantidade em estoque do armazem do produto em quatao
									if nkQtEstoque = nil .OR. nkQtEstoque < _atotitem[nki][3][2]						
										aAdd(uNkProblems, {_atotitem[nki][1][2],_atotitem[nki][4][2]})
									endif				
								next
								
								if len(uNkProblems)>0							
									for nki := 1 to len(uNkProblems)
										unkErrorMsg := unkErrorMsg + u_barraN("PRODUTO:"+ALLTRIM(uNkProblems[nki][1])+"  ARMAZEM:"+ALLTRIM(uNkProblems[nki][2]))									
									next
									MsgAlert(unkErrorMsg)
									return .F.												
								endif						
							endif
						endif
						restarea(_aABC)
				endif
			ENDIF
			
			dbselectarea("AB7")
			dbskip()
		enddo
	ENDIF
return .T.