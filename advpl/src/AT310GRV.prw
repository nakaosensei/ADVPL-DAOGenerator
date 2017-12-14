#Include 'Protheus.ch'

User Function AT310GRV()
Local _area := getarea()
Local _aAB7 := AB7->(getarea())
Local _msgFinal := ""

_descOco := POSICIONE( "AAG", 1,XFILIAL( "AAG" )+ABK->ABK_CODPRB,"AAG_DESCRI")
_descTecHD := POSICIONE( "AA1", 1,XFILIAL( "AA1" )+ABK->ABK_CODTEC,"AA1_NOMTEC")
_memo := MSMM(ABK->ABK_CODMEM)

dbselectarea("AB7")
dbsetorder(9)
if dbseek(xFilial()+ABK->ABK_NRCHAM)

	U_LIGTEC10(AB7->AB7_NUMOS)
	 
	_nTam := TamSX3("ABK_MEMO")
	_nTam1 := _nTam[1]
			
	MSMM(ABK->ABK_CODMEM,_nTam1,,_memo,1,,,"AB7","AB7_MEMO1")
	
	MSGINFO('Ordem de serviço gerada :' + AB7->AB7_NUMOS)
	
	_descTecOS := POSICIONE( "AB6", 1,XFILIAL( "AB6" )+AB7->AB7_NUMOS,"AB6_ATEND")
	_msgFinal += "<p>Este Help Desk deu origem a Ordem de Serviço: <b>" + AB7->AB7_NUMOS +"</b>, para o Técnico: <b>" + _descTecOS +"</b> , Ocorrencia: <b>" + _descOco + "</b></p>"
endif	
	_msgFinal += "<p>Técnico do Help Desk:<b>"+_descTecHD+"</b>, Laudo: <b>'" + _memo + "'</b></p>"
	
IF(ABK_SITUAC = '1' .AND. ABK_UVALAT = ' ')
	AT310A(_msgFinal)
ENDIF
	
restarea(_aAB7)
restarea(_area)	
Return

STATIC FUNCTION AT310A(_msgFinal) //VALIDAR SE TEM MAIS O.S DE ATIVAÇÃO EM ABERTO
Local _emails := getmv("MV_UEMLHD") //Emails para envolvidos na validação do Help Desk

dbselectarea("SA1")
dbsetorder(1)//Z2_FILIAL+AB6_UNUMCT
if dbseek(xFilial("SA1")+ABK->ABK_CODCLI+ABK->ABK_LOJA) 
	_MSG := "<p>Help Desk: <b>" + ABK->ABK_NRCHAM + "</b></p>"
	_MSG += "<p>Código : " + ABK->ABK_CODCLI + " Nome : " + SA1->A1_NOME + "</p>"
	_MSG += "<p>Endereço : " + SA1->A1_END + ", Bairro : " + SA1->A1_BAIRRO + ", Cidade : " + SA1->A1_MUN + "</p>"
	_MSG += "<p>Telefone : (" + SA1->A1_DDD + ")" + SA1->A1_TEL + ", Cel : " + SA1->A1_CEL + "</p>"
	_MSG += _msgFinal
	_MSG += "<p>Favor entrar em contato para validação do Help Desk.</p>"
   
	U_LIGGEN03(_emails,"","","Email para validação de Help Desk",_MSG,.T.,"")
endif	

RETURN 

