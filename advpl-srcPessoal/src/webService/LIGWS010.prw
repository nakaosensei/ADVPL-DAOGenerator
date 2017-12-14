#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
author: @nakao
*/

WSSERVICE LIGWS010 Description "WS Cadastro Cliente Cianorte"

WSDATA CPESSOA  AS STRING OPTIONAL
WSDATA CCGC		AS STRING OPTIONAL
WSDATA CNOME	AS STRING OPTIONAL
WSDATA CEMAIL   AS STRING OPTIONAL
WSDATA CDTNASC  AS STRING OPTIONAL
WSDATA CINSCR   AS STRING OPTIONAL
WSDATA CRG		AS STRING OPTIONAL
WSDATA CCONTAT  AS STRING OPTIONAL
WSDATA CCPFCON  AS STRING OPTIONAL
WSDATA CTIPO    AS STRING OPTIONAL
WSDATA COK      AS STRING
WSDATA DDDCLI   AS STRING OPTIONAL
WSDATA TELCLI   AS STRING OPTIONAL
WSDATA DDDCELCL AS STRING OPTIONAL
WSDATA CELCLI   AS STRING OPTIONAL
WSDATA CODSU5   AS STRING OPTIONAL
WSDATA CDLJCLI  AS STRING OPTIONAL

WSDATA _DATA11 AS ITENSLIST11 OPTIONAL 
WSDATA _DATA12 AS ITENSLIST12 OPTIONAL 

WSMETHOD LIGWS10GR DESCRIPTION "Grava Dados Do Cliente" 

ENDWSSERVICE

// inicio das alterações 

WSSTRUCT LISTA11
  WSDATA DATA11 AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST11
  WSDATA REGISTROS11 AS ARRAY OF LISTA11
ENDWSSTRUCT

WSSTRUCT LISTA12
  WSDATA DATA12 AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST12
  WSDATA REGISTROS12 AS ARRAY OF LISTA12
ENDWSSTRUCT

/*
author: @nakao
Alterações:
1 - Inserção realizada pelos fontes de DAO das entidades.
2 - Agora podem existir varios endereços/telefones adicionais para um cliente.
3 - Diversas validações manuais, para tarefa foram criados os LGDAOAGA, LGDAOAGB, LGDAOSA1 e LGDAOSU5
PROCESSO:
1) Mapeamento das posicoes dos arrays DATA11 e DATA12, que são os arrays de telefone e endereco, isso é apenas um açucar-sintatico.
2) Retirada de filtro de alguns campos - TRIM, remoção de traços, etc..
3) Se for pessoa juridica, a fantasia recebe o nome
4.1) Escolha do telefone padrao, telefone comercial padrao, telefone celular padrao, isso pois no cadastro de cliente deve existir um telefone na tabela SA1, isso apenas serve para definir, o telefone padrão escolhido é o primeiro encontrado na lista
4.2) Escolha do endereco padrao, é escolhido simplesmente o primeiro endereço da lista de endereços para ser salvo em SA1
5) Validação dos campos, repare que para cada entidade é usado o metodo de validacao do seu respectivo DAO
6) Busque pelo codigo cliente passado por parametro, se achou:
6.1)Altere os endereços, quando o vetor na posicao peOp for diferente de Alteração, o endereço é cadastrado, se nao alterado
6.2)Altere os telefones, quando o vetor na posicao ptOp for diferente de Alteração, o telefone é cadastrado, se nao alterado
6.3)Altere o cliente.
6.4)Altere o telefone do contato do cliente
6.5)Altere o celular do contato do cliente
6.6)Altere o contato do cliente, se for criado atualize AC8
7)Se nao achou o codigo do cliente, cadastre-o

IMPORTANTE: PARA TODOS OS ITEMS DO PASSO 6, É FEITO UMA BUSCA NO BANCO PELO CODIGO PASSADO POR PARAMETRO, SE NAO
ACHOU É CADASTRADO, SE ACHOU É ALTERADO
7)
*/
WSMETHOD LIGWS10GR WSRECEIVE CPESSOA,CCGC,CNOME,CEMAIL,CDTNASC,CINSCR,CRG,CCONTAT,CCPFCON,CTIPO,DDDCLI,TELCLI,DDDCELCL,CELCLI,CODSU5,CDLJCLI,_DATA11,_DATA12 WSSEND COK WSSERVICE LIGWS010                    	
	Local codCont := ""
	//Abaixo, o mapeamento das posicoes de chegada do array _DATA12, array de endereços
	//Mas pra quê isso? Não era só acessar diretamente as posições? -Programador do futuro
	//Eu: Isso porquê a ordem dos parametros do array estava passando por muitas mudanças
	// quando eu estava desenvolvendo, e toda vez que mudava eu tinha que ir elemento por elemento
	// para atualizar, dessa forma caso seja preciso atualizar os vetores DATA11 e DATA12 será bem mais facil.
	Local peCep := 1     //CEP
	Local peEstado := 2  //ESTADO
	Local peMun := 3     //Descricao Municipio
	Local peEnd := 4     //Endereco
	Local peEndNum := 5  //Num Endereco
	Local peBairro := 6  //Bairro
	Local peTipo := 7    //Tipo(1=COMERCIAL;2=RESIDENCIAL)	
	Local peComp := 8    //Complemento
	Local peTipo2 := 9  //Tipo(instalação, cobrança, ou instalação e cobrança)
	Local peOp := 10     //Operacao, A = ALTERACAO
	Local cdEnd := 11    //Codigo do endereço quando for atualização
	Local pePadrao := 12  //Padrao(1=SIM;2=NAO)
	
	//Abaixo, o mapeamento das posicoes de chegada do array _DATA11, array de telefones
	Local ptDDDI := 1    //DDI
   	Local ptDDD  := 2    //DDD
   	Local ptTel  := 3    //Telefone
   	Local ptTipo := 4    //Tipo(1=Comercial;2=Residencial;3=Fax comercial;4=Fax residencial;5=Celular)                                                         )
   	Local ptPadrao := 5  //Padrao(1=Sim;2=Nao)
   	Local ptOp := 6     //Operacao, A=ALTERACAO, N=NOVO
	Local cdTel := 7    //Codigo do telefone quando for atualização	
	Local ptTipo2 := 8    //Linha Nova, Telefone, Portabilide
   	Local ptComp := 9    //Complemmento
	Local ptOwner := 9   //Titular da linha, nome do cliente
	Local ptCpfOw  := 9  //Cpf do titular da linha
		
	//As variaveis abaixo serão usadas para salvar pelo menos um endereço/telefone de cada das listas no cliente principal, e sim, o banco infelizmente tem redundancias, apenas tive que manter isso.
	endPadrao := {}        // Sequencia: CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CMUN, será usado para gravar o cliente o end padrao, que sempre será o primeiro end da lista
	CPESSOA := ALLTRIM(CPESSOA)
	CCONTAT := ALLTRIM(CCONTAT)
	CCGC := u_LGFTUMSK(CCGC) //Desmascara o CPF - Retira traços e pontos
	DDDCLI := u_LGFTUMSK(DDDCLI)
	DDDCELCL := u_LGFTUMSK(DDDCELCL) 
	CCGC := ALLTRIM(CCGC)    
	CODSU5:= ALLTRIM(CODSU5)
	CDLJCLI := ALLTRIM(CDLJCLI)	
	CDLJCLI :=  if((CDLJCLI = nil .OR. CDLJCLI==""), "-5", CDLJCLI)	
	
	RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})
	::cOk := "OK"		
	CONOUT("ENTROU LIGWS10GR DO NAKAO."+CCGC+"."+TIME()+" - "+CCGC)	
	CONOUT("VARIAVEIS QUE CHEGARAM NO CABECALHO:")
	CONOUT("CPESSOA:"+CPESSOA+",CGC:"+CCGC+",NOME:"+CNOME+",EMAIL:"+CEMAIL+",DTNAS:"+CDTNASC+",INSCR:"+CINSCR+",RG:"+CRG+",NMCONT:"+CCONTAT+",CPFCONT:"+CCPFCON+",TIPO:"+CTIPO+",DDDCLI:"+DDDCLI+",TELCLI:"+TELCLI+",DDDCELCL:"+DDDCELCL+",CELCLI:"+CELCLI+",CODCONT:"+CODSU5+",CODCLI+LOJCLI:"+CDLJCLI)	       
	CFANTAS := CNOME
				
	//Os dois laços abaixo validam os campos envolvidos nos arrays DATA11 e DATA12.
	CONOUT("AGB - Telefones do Array") 
	CONOUT("Ordem esperada: DDI, DDD, Telefone, Tipo(1=comercial;2=residencial;3=fax comercial;4=fax residencial;5=celular),Padrao(1=Sim;2=Nao),Operacao(A=ALTERACAO, N=NOVO),codTelefone, tipo2(linha nova, telefone ou portabilidade),vazio")	
	for j:=1 to len(::_DATA11:REGISTROS11)
		if(ALLTRIM(::_DATA11:REGISTROS11[j]:DATA11)<>"")	
			dadosTel := StrTokArr(ALLTRIM(::_DATA11:REGISTROS11[j]:DATA11),";")
			CONOUT(::_DATA11:REGISTROS11[j]:DATA11)
			if( len( u_DAgbVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo], dadosTel[ptPadrao] , dadosTel[ptDDD] ,dadosTel[ptTel]))>0) //Chama a funcao de validação de telefone, LGDAOAGB.prw
				CONOUT("LISTA DE TELEFONES CONTEM PELO MENOS UM REGISTRO NAO VALIDO")
				return .F.
			endif
		endif
	next		
	CONOUT("Ordem esperada: CEP,ESTADO,CIDADE,ENDERECO,NUMEROEND,BAIRRO,TIPO(1=comercial;2=residencial),complemento,tipo(instalacao;cobrança;instalacao e cobranca),operacao(A=Alteracao;N=Novo),codEndereco,Padrao(1=sim;2=nao)")
	CONOUT("AGA - Enderecos do Array")					
	for i:=1 to len(::_DATA12:REGISTROS12)
		if ALLTRIM(::_DATA12:REGISTROS12[i]:DATA12)<>""
			dadosEnd := StrTokArr(ALLTRIM(::_DATA12:REGISTROS12[i]:DATA12),";")
			CONOUT(::_DATA12:REGISTROS12[i]:DATA12)
			if(len(endPadrao)=0)
				aAdd(endPadrao,dadosEnd[peEstado])
				aAdd(endPadrao,dadosEnd[peCep])
				aAdd(endPadrao,ALLTRIM(dadosEnd[peEnd])+","+ALLTRIM(dadosEnd[peEndNum]))
				aAdd(endPadrao,dadosEnd[peComp])
				aAdd(endPadrao,dadosEnd[peBairro])
				aAdd(endPadrao,dadosEnd[peMun])
				aAdd(endPadrao,dadosEnd[peTipo2])
			endif	
			if( len(u_dAgaVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)),dadosEnd[peEstado],dadosEnd[peTipo], dadosEnd[pePadrao] ,dadosEnd[peBairro],"",dadosEnd[peMun], dadosEnd[peTipo2] ) )>0) //Chama a função de validação de endereco, LGDAOAGA.prw
				CONOUT("LISTA DE ENDERECOS CONTEM PELO MENOS UM ENDERECO INVALIDO")
				return .F.
			endif
		endif
	next
	
	ivld := 0
	if len(endPadrao)=0
		CONOUT("SEM ENDEREÇO PADRAO")		
		ivld := 1
		aAdd(endPadrao,"")
		aAdd(endPadrao,"")
		aAdd(endPadrao,"")
		aAdd(endPadrao,"")
		aAdd(endPadrao,"")
		aAdd(endPadrao,"")
	endif	
	if ALLTRIM(CCPFCON)==""//Se nao veio cpf ou nome do contato, ambos devem ser vazios
		CCONTAT := ""
	endif
	if CCONTAT==""//Se nao veio cpf ou nome do contato, ambos devem ser vazios
		CCPFCON := ""
	endif
	
	if ivld=1
		return .F.
	endif
	
	//VALIDACAO DE USUARIO
	if (len(  u_DSa1Vld(CCGC, CNOME, endPadrao[3], endPadrao[5], endPadrao[1], CEMAIL, "", endPadrao[6], endPadrao[2], DDDCLI,TELCLI , DDDCELCL, CELCLI, "1030001", "105", CDTNASC, CTIPO, CPESSOA )  )>0)
		return .F.
	endif
	
	if CDLJCLI=="-5"		
		CDLJCLI=SUBSTR(CCGC,1,9)
		if CPESSOA=="F" 
			CDLJCLI += "001"
		elseif CPESSOA=="J"
			CDLJCLI += SUBSTR(CCGC,10,3)
		end	
	endif
	
	//Agora que passou a etapa de validação, vamos ao cadastro/atualização.
	DBSELECTAREA("SA1")
	DBSETORDER(1)//FILIAL+CODCLI+LOJA
	dbgotop()
	IF DBSEEK(xFilial("SA1")+CDLJCLI) //Se o cliente já for cadastrado, entramos no caso da alteração
		//Atribuição de variaveis para uso temporario
		cli := ""
		tcodAga  := ""
		tcodAgb1 := "" 
		tcodAgb2 := ""			
		tcodSu5  := ""
		
		BEGIN TRANSACTION			
			//Primeiro, serão atualizados os endereços e telefones do cliente			
			
			for i:=1 to len(::_DATA12:REGISTROS12) //ALTERA/CADASTRA OS ENDERECOS
				if ALLTRIM(::_DATA12:REGISTROS12[i]:DATA12)<>""
					dadosEnd := StrTokArr(ALLTRIM(::_DATA12:REGISTROS12[i]:DATA12),";")
											
					if (ALLTRIM(dadosEnd[peOp])=="A")//O decimo elemento indica se é uma alteração ou inclusao, se alteração, procure o registro em questão na tabela de endereços
						u_DAgaAlter(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[peTipo], dadosEnd[pePadrao],dadosEnd[peEnd]+","+dadosEnd[peEndNum], dadosEnd[peCep], dadosEnd[peBairro], "", dadosEnd[peMun], dadosEnd[peEstado], "105",dadosEnd[peComp] , dadosEnd[peTipo2], dadosEnd[cdEnd])											
					else
					 	u_DAgaCad(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[peTipo], dadosEnd[pePadrao],dadosEnd[peEnd]+","+dadosEnd[peEndNum], dadosEnd[peCep], dadosEnd[peBairro], "", dadosEnd[peMun], dadosEnd[peEstado], "105",dadosEnd[peComp], dadosEnd[peTipo2])
					endif			    							 
				 endif			  
			next		
			
			for j:=1 to len(::_DATA11:REGISTROS11)//ALTERA/CADASTRA OS TELEFONES
				if(ALLTRIM(::_DATA11:REGISTROS11[j]:DATA11)<>"")		
				    dadosTel := StrTokArr(ALLTRIM(::_DATA11:REGISTROS11[j]:DATA11),";")
				    if(ALLTRIM(dadosTel[ptOp])=="A")//Se é uma alteração de endereco
				    	u_DAgbAlter(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw],dadosTel[cdTel])								    	
				    else
				    	u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw])
				    endif
				endif	   
			next			
			cli := u_DSa1Alter(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,endPadrao[1],endPadrao[2],endPadrao[3],endPadrao[4],endPadrao[5],"",endPadrao[6],DDDCLI,TELCLI,DDDCELCL,CELCLI,CDTNASC,CINSCR,CRG,"105",CCONTAT,CCPFCON,CTIPO,"1030001")//Altera o cliente
			dbSelectArea("AGB")		 
			dbSetOrder(2)	
						
			//Busque na base de dados pelo contato desse cliente, isso para que possamos edita-lo
			dbSelectArea("SU5")
			dbSetOrder(1)//Filial+Cod			
			if dbSeek(xFilial("SU5")+CODSU5) .AND. CODSU5 <> "" //Se achou o contato do cliente
				u_DSu5Alter(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCLI, TELCLI, CELCLI,"", "","","","",CODSU5)//Altere o contato					
			else//Se não achou o contato, cadastre-o
				tcodSu5  := GetSXENum("SU5","U5_CODCONT")
				ConfirmSx8()
				u_DSu5Cad(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCLI, TELCLI, CELCLI,"", "","",tcodAgb1,tcodAgb2,tcodSu5)
				u_NkUAC8(cli,tcodSu5)//Vincula o cliente ao contato em AC8
			endif			
		END TRANSACTION		
	else // Se não, cadastre um novo cliente, com seus respectivos endereços/telefone
		//CADASTRO		
		BEGIN TRANSACTION
			cli := ""
			tcodAga  := ""
			tcodAgb1 := "" 
			tcodAgb2 := ""				
			codCont  := GetSXENum("SU5","U5_CODCONT")//Codigo do contato, depois do cadastro de um cliente sempre se cadastra um contato(SU5)				
			ConfirmSx8()
			if CPESSOA=="F" //Se é pessoa fisica, cadastre um contato identico ao cliente, e o cliente com esse contato
				cli := u_DSa1Cad(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,endPadrao[1],endPadrao[2],endPadrao[3],endPadrao[4],endPadrao[5],"",endPadrao[6],DDDCLI,TELCLI,DDDCELCL,CELCLI,CDTNASC,CINSCR,CRG,"105",CNOME,CCGC,CTIPO,"1030001") //Cadastra o cliente
				u_DSu5Cad(XFILIAL("SU5"), CNOME, CCGC, endPadrao[3], endPadrao[5], CRG, endPadrao[6], endPadrao[1], endPadrao[2], DDDCLI, TELCLI, CELCLI,CEMAIL, CDTNASC,tcodAga,tcodAgb1,tcodAgb2,codCont)
				u_NkUAC8(cli,codCont)
			else //Se nao, ccadastre um contato com base no passado por parametro
				cli := u_DSa1Cad(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,endPadrao[1],endPadrao[2],endPadrao[3],endPadrao[4],endPadrao[5],"",endPadrao[6],DDDCLI,TELCLI,DDDCELCL,CELCLI,CDTNASC,CINSCR,CRG,"105",CCONTAT,CCPFCON,CTIPO,"1030001") //Cadastra o cliente
				if CCONTAT<>""					
					u_DSu5Cad(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", "", "", "","", "","",tcodAgb1,tcodAgb2,codCont)
					u_NkUAC8(cli,codCont)
				endif				
			endif						
			
			for i:=1 to len(::_DATA12:REGISTROS12)//CADASTRA OS ENDERECOS
				if ALLTRIM(::_DATA12:REGISTROS12[i]:DATA12)<>""
				    dadosEnd := StrTokArr(ALLTRIM(::_DATA12:REGISTROS12[i]:DATA12),";")
				    u_DAgaCad(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[peTipo], dadosEnd[pePadrao],dadosEnd[peEnd]+","+dadosEnd[peEndNum], dadosEnd[peCep], dadosEnd[peBairro], "", dadosEnd[peMun], dadosEnd[peEstado], "105",dadosEnd[peComp], dadosEnd[peTipo2])//Cadastra os demais endereços do Cliente
										 
				endif			  
			next			
			/*
			for j:=1 to len(::_DATA11:REGISTROS11)//CADASTRA OS TELEFONES
				if(ALLTRIM(::_DATA11:REGISTROS11[j]:DATA11)<>"")		
					dadosTel := StrTokArr(ALLTRIM(::_DATA11:REGISTROS11[j]:DATA11),";")
					u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw])//Insere os demais telefones do cliente
					
				endif	   
			next	      
			*/ 
		END TRANSACTION		
	endif	
RETURN .T. 