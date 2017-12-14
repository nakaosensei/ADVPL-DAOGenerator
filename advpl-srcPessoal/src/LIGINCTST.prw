#include 'protheus.ch'
#include 'parmtype.ch'




user function NkGera(cod,nome,email,ddd,dddPais,telefone,endereco,bairro,cep,municipio,estado,cpf,celular,ativo,cdMun,pais)
	if(cod = nil)
		MsgAlert("Falha ao gerar um contato automaticamente para esse cliente pois seu código é nulo")
		return
	endif
	BEGIN TRANSACTION	
		dbSelectArea("SU5")
		codCont := VAL(SU5->U5_CODCONT)+1
		codCont := CVALTOCHAR(codCont)
		//codCont := GetSXENum("SU5","SU5_CODCONT") //Pega o proximo numero disponivel em SXE/SXF
		//RollBackSx8() //Como usaremos o MSExecAuto, é preciso retroceder ao indice passado após o gerar 
		dbCloseArea()
		aContato := {}
		aEndereco := {}
		aTelefone := {}
		aAuxDados := {}
		private lMsErroAuto := .F.		
		AAdd(aContato,{"U5_FILIAL", xFilial("SU5"),Nil})
		AAdd(aContato,{"U5_CODCONT",codCont, Nil})
		AAdd(aContato,{"U5_CONTAT",nome, Nil})
		AAdd(aContato,{"U5_EMAIL",email, Nil})
		AAdd(aContato,{"U5_CPF",cpf, Nil})
		AAdd(aContato,{"U5_ATIVO", ativo, Nil})				
		AAdd(aContato,{"U5_END",endereco, Nil})
		AAdd(aContato,{"U5_BAIRRO",bairro, Nil})
		AAdd(aContato,{"U5_MUN", municipio, Nil})		
		AAdd(aContato,{"U5_EST",estado, Nil})
		AAdd(aContato,{"U5_CEP",cep, Nil})		
		AAdd(aContato,{"U5_DDD", ddd, Nil})
		AAdd(aContato,{"U5_FONE", telefone, Nil})
		AAdd(aContato,{"U5_CELULAR", celular, Nil})
		
		
		dbSelectArea("AGB")
		dbGoBottom()
		codAgb := VAL(AGB->AGB_CODIGO)+1
		codAgb := CVALTOCHAR(codAgb)
		//codAgb := GetSXENum("AGB","AGB_CODIGO") //Pega o proximo numero disponivel em SXE/SXF
		//RollBackSx8() //Como usaremos o MSExecAuto, é preciso retroceder ao indice passado após o gerar
		dbCloseArea()
		
		//Popula aux com os detalhes do telefone
		AAdd(aAuxDados, {"AGB_FILIAL", xFilial("SA1"), Nil})
		AAdd(aAuxDados, {"AGB_TIPO", "1", Nil})
		AAdd(aAuxDados, {"AGB_PADRAO", "1", Nil})
		AAdd(aAuxDados, {"AGB_DDI", dddPais, Nil})
		AAdd(aAuxDados, {"AGB_DDD", ddd, Nil})
		AAdd(aAuxDados, {"AGB_TELEFO", telefone, Nil})
		AAdd(aAuxDados, {"AGB_CODIGO"}, codAgb, Nil)
		AAdd(aAuxDados, {"AGB_ENTIDA"}, "SU5", Nil)
		AAdd(aAuxDados, {"AGB_CODENT"}, codCont, Nil)
		AAdd(aTelefone, aAuxDados)	
		aAuxDados := {}	
		
		dbSelectArea("AGA")
		dbGoBottom()
		codAga := VAL(AGA->AGA_CODIGO)+1
		codAga := CVALTOCHAR(codAga)
		//codAga := GetSXENum("AGA","AGA_CODIGO") //Pega o proximo numero disponivel em SXE/SXF
		//RollBackSx8() //Como usaremos o MSExecAuto, é preciso retroceder ao indice passado após o gerar
		dbCloseArea()
		AAdd(aAuxDados, {"AGA_TIPO", "1", Nil})
		AAdd(aAuxDados, {"AGA_PADRAO", "1", Nil})
		AAdd(aAuxDados, {"AGA_END", endereco, Nil})
		AAdd(aAuxDados, {"AGA_CEP", cep, Nil})
		AAdd(aAuxDados, {"AGA_BAIRRO", bairro, Nil})
		AAdd(aAuxDados, {"AGA_MUNDES", municipio, Nil})
		AAdd(aAuxDados, {"AGA_MUN", cdMun, Nil})
		AAdd(aAuxDados, {"AGA_PAIS", pais, Nil})
		AAdd(aAuxDados, {"AGA_FILIAL", xFilial("SA1"), Nil})
		AAdd(aAuxDados, {"AGA_EST", estado, Nil})
		AAdd(aAuxDados, {"AGA_CODIGO", codAga, Nil})
		AAdd(aAuxDados, {"AGA_ENTIDA", "SU5", Nil})	
		AAdd(aAuxDados, {"AGA_CODENT", codCont, Nil})
		AAdd(aEndereco, aAuxDados)		
		AAdd(aContato,{"U5_CODAGA", codAga, Nil})
		
		/*
		dbSelectArea("SA1")
		dbGoBottom()
		RECLOCK("SA1", .F.)
		SA1->A1_CONTATO:=nome
		MSUNLOCK()
		dbCloseArea()
		*/
		
		MSExecAuto({|x,y,z,a,b|TMKA070(x,y,z,a,b)},aContato,3,aEndereco,aTelefone, .F.)
		If lMsErroAuto = .T. 
		    MsgAlert("Falha ao gerar um contato automaticamente para esse cliente.")
		    mostraerro("\logerro\")
			MOSTRAERRO()
		Else 
		    Alert("Um contato foi gerado para este cliente, seu id é : "+codCont)
		    u_NkUpdAC8(cod,codCont)//Atualiza a tabela AC8, que institui a relação(cardinalidade) entre SA1 e SU5
		EndIf		
	END TRANSACTION	
return

user function NkTstGr(cod,nome,email,ddd,dddPais,telefone,endereco,bairro,cep,municipio,estado,cpf,celular,ativo,cdMun,pais)
	Local aContato := {}
	Local aEndereco := {}
	Local aTelefone := {}
	Local aAuxDados := {}
	Private lMsErroAuto := .F.
	dbSelectArea("SU5")
	codCont := VAL(SU5->U5_CODCONT)+1
	codCont := CVALTOCHAR(codCont)
	MsgAlert("TESTE")
	AAdd(aContato,{"U5_FILIAL", "LG",Nil})
	AAdd(aContato,{"U5_CODCONT",codCont, Nil})
	AAdd(aContato,{"U5_CONTAT","Nome do contato", Nil})
	AAdd(aContato,{"U5_EMAIL","teste@totvs.com.br", Nil})
	AAdd(aContato,{"U5_FONE", "35293774", Nil})
	AAdd(aContato,{"U5_CELULAR", "98020248", Nil})
	dbSelectArea("AGB")
	dbGoBottom()
	codAgb := VAL(AGB->AGB_CODIGO)+1
	codAgb := CVALTOCHAR(codAgb)
	dbCloseArea()
	//AAdd(aAuxDados, {"AGB_TIPO", "1", Nil})
	AAdd(aAuxDados, {"AGB_PADRAO", "1", Nil})
	AAdd(aAuxDados, {"AGB_DDI", "55", Nil})
	AAdd(aAuxDados, {"AGB_DDD", "11", Nil})
	AAdd(aAuxDados, {"AGB_TELEFO", "12349874", Nil})
	AAdd(aAuxDados, {"AGB_FILIAL", xFilial("SA1"), Nil})
	//AAdd(aAuxDados, {"AGB_CODIGO"}, codAgb, Nil)
	//AAdd(aAuxDados, {"AGB_ENTIDA"}, "SU5", Nil)
	//AAdd(aAuxDados, {"AGB_CODENT"}, codCont, Nil)
	
	dbSelectArea("AGA")
	dbGoBottom()
	codAga := VAL(AGA->AGA_CODIGO)+1
	codAga := CVALTOCHAR(codAga)
	dbCloseArea()
	AAdd(aTelefone, aAuxDados)
	aAuxDados := {}
	//AAdd(aAuxDados, {"AGA_TIPO", "1", Nil})
	AAdd(aAuxDados, {"AGA_PADRAO", "1", Nil})
	AAdd(aAuxDados, {"AGA_END", "R. Totvs", Nil})
	AAdd(aAuxDados, {"AGA_CEP", "12345123", Nil})
	AAdd(aAuxDados, {"AGA_BAIRRO", "Bairro Totvs", Nil})
	AAdd(aAuxDados, {"AGA_MUNDES", "Cidade Totvs", Nil})
	AAdd(aAuxDados, {"AGA_EST", "SP", Nil})	
	//AAdd(aAuxDados, {"AGA_ENTIDA"}, "SU5", Nil)
	//AAdd(aAuxDados, {"AGA_CODIGO", codAga, Nil})
	//AAdd(aAuxDados, {"AGA_CODENT"}, codCont, Nil)
	AAdd(aAuxDados, {"AGA_FILIAL", xFilial("SA1"), Nil})
	AAdd(aEndereco, aAuxDados)
	MSExecAuto({|x,y,z,a,b|TMKA070(x,y,z,a,b)},aContato,3,aEndereco,aTelefone, .F.)
	If lMsErroAuto 
	    MsgStop("Erro na gravação do contato")
	    MsgAlert("Falha ao gerar um contato automaticamente para esse cliente.")
		mostraerro("\logerro\")
		MOSTRAERRO() 
	Else 
	    MsgAlert('Incluido contato com sucesso.') 
	EndIf		
return