#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLIGWS001  บAutor Daniel Gouvea           Data ณ 13/02/2017  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWS para gravar dados do cliente                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LIGUE TELECOM                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Editador por:
author: @nakao
Altera็๕es:
1 - Inser็ใo de campos para celular/telefone do contato
*/

WSSERVICE LIGWS001 Description "WS Cadastro Cliente"

WSDATA CPESSOA  AS STRING OPTIONAL
WSDATA CCGC		AS STRING OPTIONAL
WSDATA CNOME	AS STRING OPTIONAL
WSDATA CFANTAS  AS STRING OPTIONAL
WSDATA CEMAIL   AS STRING OPTIONAL
WSDATA CDTNASC  AS STRING OPTIONAL
WSDATA CINSCR   AS STRING OPTIONAL
WSDATA CRG		AS STRING OPTIONAL
WSDATA CCONTAT  AS STRING OPTIONAL
WSDATA CCPFCON  AS STRING OPTIONAL
WSDATA CTIPO    AS STRING OPTIONAL
WSDATA COK      AS STRING
WSDATA DDDCONT  AS STRING OPTIONAL
WSDATA TELCONT  AS STRING OPTIONAL
WSDATA DDDCELCT AS STRING OPTIONAL
WSDATA CELCONT  AS STRING OPTIONAL
WSDATA ISNOVO   AS STRING OPTIONAL
WSDATA CODSU5   AS STRING OPTIONAL
WSDATA CODCELCT AS STRING OPTIONAL
WSDATA CODTELCT AS STRING OPTIONAL
WSDATA CDLJCLI  AS STRING OPTIONAL

WSDATA _DADOS1 AS ITENSLIST1 OPTIONAL // altera็ใo realizada aqui - estava ITENSLIST
WSDATA _DADOS2 AS ITENSLIST2 OPTIONAL // altera็ใo realizada aqui - estava ITENSLIST

WSMETHOD LIGWS1GR DESCRIPTION "Grava Dados Do Cliente" 

ENDWSSERVICE

// inicio das altera็๕es 

WSSTRUCT LISTA1
  WSDATA DADOS1 AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST1
  WSDATA REGISTROS1 AS ARRAY OF LISTA1
ENDWSSTRUCT

WSSTRUCT LISTA2
  WSDATA DADOS2 AS STRING
ENDWSSTRUCT

WSSTRUCT ITENSLIST2
  WSDATA REGISTROS2 AS ARRAY OF LISTA2
ENDWSSTRUCT

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLIGWS1GR  บAutor Daniel Gouvea         บ Data ณ 13/02/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสออออ
ออออออออออออออออออออออออสออออออฯอออออออออออออน							   ฑฑ
ฑฑบDesc.     ณ Grava dados Cliente                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ligue                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

Editador por:
author: @nakao
Altera็๕es:
1 - Inser็ใo realizada pelos fontes de DAO das entidades.
2 - Agora podem existir varios endere็os/telefones adicionais para um cliente.
3 - Diversas valida็๕es manuais, para tarefa foram criados os LGDAOAGA, LGDAOAGB, LGDAOSA1 e LGDAOSU5
PROCESSO:
1) Mapeamento das posicoes dos arrays dados1 e dados2, que sใo os arrays de telefone e endereco, isso ้ apenas um a็ucar-sintatico.
2) Retirada de filtro de alguns campos - TRIM, remo็ใo de tra็os, etc..
3) Se for pessoa juridica, a fantasia recebe o nome
4.1) Escolha do telefone padrao, telefone comercial padrao, telefone celular padrao, isso pois no cadastro de cliente deve existir um telefone na tabela SA1, isso apenas serve para definir, o telefone padrใo escolhido ้ o primeiro encontrado na lista
4.2) Escolha do endereco padrao, ้ escolhido simplesmente o primeiro endere็o da lista de endere็os para ser salvo em SA1
5) Valida็ใo dos campos, repare que para cada entidade ้ usado o metodo de validacao do seu respectivo DAO
6) Busque pelo codigo cliente passado por parametro, se achou:
6.1)Altere os endere็os, quando o vetor na posicao peOp for diferente de Altera็ใo, o endere็o ้ cadastrado, se nao alterado
6.2)Altere os telefones, quando o vetor na posicao ptOp for diferente de Altera็ใo, o telefone ้ cadastrado, se nao alterado
6.3)Altere o cliente.
6.4)Altere o telefone do contato do cliente
6.5)Altere o celular do contato do cliente
6.6)Altere o contato do cliente, se for criado atualize AC8
7)Se nao achou o codigo do cliente, cadastre-o

IMPORTANTE: PARA TODOS OS ITEMS DO PASSO 6, ษ FEITO UMA BUSCA NO BANCO PELO CODIGO PASSADO POR PARAMETRO, SE NAO
ACHOU ษ CADASTRADO, SE ACHOU ษ ALTERADO
7)
*/
WSMETHOD LIGWS1GR WSRECEIVE CPESSOA,CCGC,CNOME,CEMAIL,CDTNASC,CINSCR,CRG,CCONTAT,CCPFCON,CTIPO,DDDCONT,TELCONT,DDDCELCT,CELCONT,ISNOVO,CODSU5,CDLJCLI,_DADOS1,_DADOS2 WSSEND COK WSSERVICE LIGWS001	
	Local codCont := ""
	//Abaixo, o mapeamento das posicoes de chegada do array _DADOS2, array de endere็os
	//Mas pra qu๊ isso? Nใo era s๓ acessar diretamente as posi็๕es? -Programador do futuro
	//Eu: Isso porqu๊ a ordem dos parametros do array estava passando por muitas mudan็as
	// quando eu estava desenvolvendo, e toda vez que mudava eu tinha que ir elemento por elemento
	// para atualizar, dessa forma caso seja preciso atualizar os vetores DADOS1 e DADOS2 serแ bem mais facil.
	Local peCep := 1     //CEP
	Local peEstado := 2  //ESTADO
	Local peMun := 3     //Descricao Municipio
	Local peEnd := 4     //Endereco
	Local peEndNum := 5  //Num Endereco
	Local peBairro := 6  //Bairro
	Local peTipo := 7    //Tipo(1=COMERCIAL;2=RESIDENCIAL)
	Local pePadrao := 8  //Padrao(1=SIM;2=NAO)
	Local peComp := 9    //Complemento
	Local peTipo2 := 10  //Tipo(instala็ใo, cobran็a, ou instala็ใo e cobran็a)
	Local peOp := 11     //Operacao, A = ALTERACAO
	Local cdEnd := 12    //Codigo do endere็o quando for atualiza็ใo
	
	//Abaixo, o mapeamento das posicoes de chegada do array _DADOS1, array de telefones
	Local ptTipo2 := 1    //Linha Nova, Telefone, Portabilide
	Local ptDDDI := 2    //DDI
   	Local ptDDD  := 3    //DDD
   	Local ptTel  := 4    //Telefone
   	Local ptTipo := 5    //Tipo(1=Comercial;2=Residencial;3=Fax comercial;4=Fax residencial;5=Celular)                                                         )
   	Local ptPadrao := 6  //Padrao(1=Sim;2=Nao)
   	Local ptComp := 7    //Complemmento
	Local ptOwner := 8   //Titular da linha, nome do cliente
	Local ptCpfOw  := 9  //Cpf do titular da linha
	Local ptOp := 10     //Operacao, A=ALTERACAO, N=NOVO
	Local cdTel := 11    //Codigo do telefone quando for atualiza็ใo
	
	//As variaveis abaixo serใo usadas para salvar pelo menos um endere็o/telefone de cada das listas no cliente principal, e sim, o banco infelizmente tem redundancias, apenas tive que manter isso.
	endPadrao := {}        // Sequencia: CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CMUN, serแ usado para gravar o cliente o end padrao, que sempre serแ o primeiro end da lista
	celPadrao := {}        // Sequencia: DDD, CELULAR, serแ usado pra gravar um celular no cliente
	telPadrao := {}        // Sequencia: DDD, TELEFONE, serแ usado pra gravar um telefone no cliente
	comercialPadrao := {}  // Sequencia: DDD, TELEFONE, serแ usado pra gravar um fone comercial no cliente
	CPESSOA := ALLTRIM(CPESSOA)
	CCONTAT := ALLTRIM(CCONTAT)
	CCGC := u_LGFTUMSK(CCGC) //Desmascara o CPF - Retira tra็os e pontos
	CCGC := ALLTRIM(CCGC)    
	CODSU5:= ALLTRIM(CODSU5)
	CDLJCLI := ALLTRIM(CDLJCLI)
	CDLJCLI :=  if((CDLJCLI = nil .OR. CDLJCLI==""), "-5", CDLJCLI)	
	
	tmpAgb1 := CODTELCT
	tmpAgb2 := CODCELCT
	tmpAgb1 := ALLTRIM(tmpAgb1)
	tmpAgb2 := ALLTRIM(tmpAgb2)
	RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})
	::cOk := "OK"	
		
	CONOUT("ENTROU LIGWS1GR DO NAKAO."+CCGC+"."+TIME()+" - "+CCGC)	
	CONOUT("VARIAVEIS QUE CHEGARAM:")
	CONOUT("CPESSOA:"+CPESSOA+",CGC:"+CCGC+",NOME:"+CNOME+",FANT:"+CFANTAS+",EMAIL:"+CEMAIL+",DTNAS:"+CDTNASC+",INSCR:"+CINSCR+",RG:"+CRG+",NMCONT:"+CCONTAT+",CPFCONT:"+CCPFCON+",TIPO:"+CTIPO+",DDDCNT:"+DDDCONT+",TELCNT:"+TELCONT+",DDDCELCT:"+DDDCELCT+",CELCT:"+CELCONT+",ISNOVO:"+ISNOVO+",CODCONT:"+CODSU5+"CELCONT:"+CODCELCT+",TELCONT:"+CODTELCT+",CODCLI+LOJCLI:"+CDLJCLI)
	CFANTAS := CNOME
				
	//Os dois la็os abaixo validam os campos envolvidos nos arrays dados1 e dados2.
	CONOUT("AGB")		
	for j:=1 to len(::_dados1:Registros1)
		if(ALLTRIM(::_dados1:Registros1[j]:dados1)<>"")	
			dadosTel := StrTokArr(ALLTRIM(::_dados1:Registros1[j]:dados1),";")
			CONOUT(::_dados1:Registros1[j]:dados1)
			if(len(telPadrao)=0 .AND. ALLTRIM(dadosTel[ptTipo])=="2")//Se tel padrao ้ vazio e se o telefone ้ residencial, fa็a-o ser o tel padrao(Que serแ replicado nos dados do cliente)
			   	aAdd(telPadrao, dadosTel[ptDDD])
			   	aAdd(telPadrao, dadosTel[ptTel])				     	
			endif
			if(len(celPadrao)=0 .AND. ALLTRIM(dadosTel[ptTipo])=="5")//Se tel padrao ้ vazio e se o telefone ้ celular, fa็a-o ser o cel padrao(Que serแ replicado  nos dados do cliente)
			   	aAdd(celPadrao, dadosTel[ptDDD])
			   	aAdd(celPadrao, dadosTel[ptTel])
			endif				     
			if(len(comercialPadrao)=0 .AND. ALLTRIM(dadosTel[ptTipo])=="1")//Se o tipo ้ comercial 
			   	aAdd(comercialPadrao, dadosTel[ptDDD])
			   	aAdd(comercialPadrao, dadosTel[ptTel])
			endif
			if( len( u_DAgbVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo], dadosTel[ptPadrao] , dadosTel[ptDDD] ,dadosTel[ptTel]))>0) //Chama a funcao de valida็ใo de telefone, LGDAOAGB.prw
				CONOUT("LISTA DE TELEFONES CONTEM PELO MENOS UM REGISTRO NAO VALIDO")
				return .F.
			endif
		endif
	next		
	
	CONOUT("AGA")					
	for i:=1 to len(::_dados2:Registros2)
		if ALLTRIM(::_dados2:Registros2[i]:dados2)<>""
			dadosEnd := StrTokArr(ALLTRIM(::_dados2:Registros2[i]:dados2),";")
			CONOUT(::_dados2:Registros2[i]:dados2)
			if(len(endPadrao)=0)
				aAdd(endPadrao,dadosEnd[peEstado])
				aAdd(endPadrao,dadosEnd[peCep])
				aAdd(endPadrao,ALLTRIM(dadosEnd[peEnd])+","+ALLTRIM(dadosEnd[peEndNum]))
				aAdd(endPadrao,dadosEnd[peComp])
				aAdd(endPadrao,dadosEnd[peBairro])
				aAdd(endPadrao,dadosEnd[peMun])
				aAdd(endPadrao,dadosEnd[peTipo2])
			endif	
			if( len(u_dAgaVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)),dadosEnd[peEstado],dadosEnd[peTipo], dadosEnd[pePadrao] ,dadosEnd[peBairro],"",dadosEnd[peMun], dadosEnd[peTipo2] ) )>0) //Chama a fun็ใo de valida็ใo de endereco, LGDAOAGA.prw
				CONOUT("LISTA DE ENDERECOS CONTEM PELO MENOS UM ENDERECO INVALIDO")
				return .F.
			endif
		endif
	next
	
	if len(telPadrao)=0 .AND. len(comercialPadrao)>0
		telPadrao := comercialPadrao
	endif
	ivld := 0
	if len(telPadrao)=0 
		CONOUT("SEM TELEFONE RESIDENCIAL E COMERCIAL")		
		//ivld:=1
		aAdd(telPadrao,"")
		aAdd(telPadrao,"")
	endif
	if len(celPadrao)=0
		CONOUT("SEM CELULAR PADRAO")		
		aAdd(celPadrao,"")
		aAdd(celPadrao,"")
		//ivld := 1
	endif
	if len(endPadrao)=0
		CONOUT("SEM ENDEREวO PADRAO")		
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
	if (len(  u_DSa1Vld(CCGC, CNOME, endPadrao[3], endPadrao[5], endPadrao[1], CEMAIL, "", endPadrao[6], endPadrao[2], telPadrao[1],telPadrao[2] , celPadrao[1], celPadrao[2], "1030001", "105", CDTNASC, CTIPO, CPESSOA )  )>0)
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
	
	//Agora que passou a etapa de valida็ใo, vamos ao cadastro/atualiza็ใo.
	DBSELECTAREA("SA1")
	DBSETORDER(1)//FILIAL+CODCLI+LOJA
	dbgotop()
	IF DBSEEK(xFilial("SA1")+CDLJCLI) //Se o cliente jแ for cadastrado, entramos no caso da altera็ใo
		//Atribui็ใo de variaveis para uso temporario
		cli := ""
		tcodAga  := ""
		tcodAgb1 := "" 
		tcodAgb2 := ""			
		tcodSu5  := ""		
		BEGIN TRANSACTION			
			//Primeiro, serใo atualizados os endere็os e telefones do cliente			
			CONOUT("ALTER AGA - ENDERECOS")
			for i:=1 to len(::_dados2:Registros2) //ALTERA/CADASTRA OS ENDERECOS
				if ALLTRIM(::_dados2:Registros2[i]:dados2)<>""
					dadosEnd := StrTokArr(ALLTRIM(::_dados2:Registros2[i]:dados2),";")
					CONOUT(::_dados2:Registros2[i]:dados2)						
					if (ALLTRIM(dadosEnd[peOp])=="A")//O decimo elemento indica se ้ uma altera็ใo ou inclusao, se altera็ใo, procure o registro em questใo na tabela de endere็os
						u_DAgaAlter(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[peTipo], dadosEnd[pePadrao],dadosEnd[peEnd]+","+dadosEnd[peEndNum], dadosEnd[peCep], dadosEnd[peBairro], "", dadosEnd[peMun], dadosEnd[peEstado], "105",dadosEnd[peComp] , dadosEnd[peTipo2], dadosEnd[cdEnd])											
					else
					 	u_DAgaCad(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[peTipo], dadosEnd[pePadrao],dadosEnd[peEnd]+","+dadosEnd[peEndNum], dadosEnd[peCep], dadosEnd[peBairro], "", dadosEnd[peMun], dadosEnd[peEstado], "105",dadosEnd[peComp], dadosEnd[peTipo2])
					endif			    							 
				 endif			  
			next		
			CONOUT("ALTER AGB - TELEFONES")
			for j:=1 to len(::_dados1:Registros1)//ALTERA/CADASTRA OS TELEFONES
				if(ALLTRIM(::_dados1:Registros1[j]:dados1)<>"")		
				    dadosTel := StrTokArr(ALLTRIM(::_dados1:Registros1[j]:dados1),";")
				    if(ALLTRIM(dadosTel[ptOp])=="A")//Se ้ uma altera็ใo de endereco
				    	u_DAgbAlter(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw],dadosTel[cdTel])								    	
				    else
				    	u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw])
				    endif
				endif	   
			next			
			cli := u_DSa1Alter(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,endPadrao[1],endPadrao[2],endPadrao[3],endPadrao[4],endPadrao[5],"",endPadrao[6],telPadrao[1],telPadrao[2],celPadrao[1],celPadrao[2],CDTNASC,CINSCR,CRG,"105",CCONTAT,CCPFCON,CTIPO,"1030001")//Altera o cliente
			//Busque na base de dados pelo contato desse cliente, isso para que possamos edita-lo
			dbSelectArea("SU5")
			dbSetOrder(1)//Filial+Cod			
			if dbSeek(xFilial("SU5")+CODSU5) .AND. CODSU5 <> "" //Se achou o contato do cliente
				dbSelectArea("AGB")		 
				dbSetOrder(2)	
				//Altera็ใo do telefone fixo do contato em AGB
				if dbSeek(xFilial("AGB")+tmpAgb1) .AND. tmpAgb1 <> "" //Procura pelo telefone, se nao achar com o codigo passado cadastre-o
					u_DAgbAlter(XFILIAL("AGB"), "SU5", CODSU5, "5", "1",DDDCONT,TELCONT, "55","","", CCONTAT,CCPFCON,tmpAgb1)//Altera o celular padrใo do contato		
				else//Nao achou, cadastre
					tmpAgb1 = GetSXENum("AGB","AGB_CODIGO") 
					u_DAgbCad(XFILIAL("AGB"), "SU5", CODSU5, "2", "1",DDDCONT,TELCONT, "55","","", CCONTAT,CCPFCON, tmpAgb1) //Cadastra o telefone padrao do contato
					ConfirmSx8()
				endif
				//Altera็ใo do celular do contato em AGB
				if dbSeek(xFilial("AGB")+tmpAgb2) .AND. tmpAgb2 <> ""
					u_DAgbAlter(XFILIAL("AGB"), "SU5", CODSU5, "5", "1",DDDCELCT,CELCONT, "55","","", CCONTAT,CCPFCON,tmpAgb2)//Altera o celular padrใo do contato	
				else
					tmpAgb2 := GetSXENum("AGB","AGB_CODIGO") 
					u_DAgbCad(XFILIAL("AGB"), "SU5", CODSU5, "5", "1",DDDCELCT,CELCONT, "55","","", CCONTAT,CCPFCON, tmpAgb2)//Cadastra o celular padrใo do contato	
					ConfirmSx8()
				endif				
				u_DSu5Alter(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCONT, TELCONT, CELCONT,"", "","",tmpAgb1,tmpAgb2,CODSU5)//Altere o contato					
			else//Se nใo achou o contato, cadastre-o
				tcodAgb1 := GetSXENum("AGB","AGB_CODIGO") 
				ConfirmSx8()
				tcodAgb2 := GetSXENum("AGB","AGB_CODIGO") 
				ConfirmSx8()
				tcodSu5  := GetSXENum("SU5","U5_CODCONT")
				ConfirmSx8()
				u_DSu5Cad(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCONT, TELCONT, CELCONT,"", "","",tcodAgb1,tcodAgb2,tcodSu5)
				u_DAgbCad(XFILIAL("AGB"), "SU5", tcodSu5, "2", "1",DDDCONT,TELCONT, "55","","", CCONTAT,CCPFCON, tcodAgb1) //Cadastra o telefone padrao do contato
				u_DAgbCad(XFILIAL("AGB"), "SU5", tcodSu5, "5", "1",DDDCELCT,CELCONT, "55","","", CCONTAT,CCPFCON, tcodAgb2)//Cadastra o celular padrใo do contato	
				u_NkUAC8(cli,tcodSu5)//Vincula o cliente ao contato em AC8
			endif			
		END TRANSACTION		
	else // Se nใo, cadastre um novo cliente, com seus respectivos endere็os/telefone
		//CADASTRO		
		BEGIN TRANSACTION
			cli := ""
			tcodAga  := ""
			tcodAgb1 := "" 
			tcodAgb2 := ""							
			if CPESSOA=="F" //Se ้ pessoa fisica, cadastre um contato identico ao cliente, e o cliente com esse contato
				cli := u_DSa1Cad(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,endPadrao[1],endPadrao[2],endPadrao[3],endPadrao[4],endPadrao[5],"",endPadrao[6],telPadrao[1],telPadrao[2],celPadrao[1],celPadrao[2],CDTNASC,CINSCR,CRG,"105",CNOME,CCGC,CTIPO,"1030001") //Cadastra o cliente
				codCont  := GetSXENum("SU5","U5_CODCONT")//Codigo do contato, depois do cadastro de um cliente sempre se cadastra um contato(SU5)
				ConfirmSx8()
				if endPadrao[1]<>"" .or. endPadrao[2]<>"" .or. endPadrao[3]<>"" .or. endPadrao[4]<>"" .or. endPadrao[5]=="" .or. endPadrao[6]==""
					tcodAga  := u_DAgaCad(xFILIAL("AGA"), "SU5", codCont, "2", "1", endPadrao[3], endPadrao[2], endPadrao[5], SA1->A1_COD_MUN, endPadrao[6], endPadrao[1], "105","", endPadrao[7])	//Cadastra o endere็o do contato
				endif
				if celPadrao[1]<>"" .or. celPadrao[2]<>""
					tcodAgb1 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "2", "1",celPadrao[1],celPadrao[2], "55","","", CNOME,CCGC,"")//Cadastra o telefone padrใo do contato
				endif
				if telPadrao[1]<>"" .or. telPadrao[2]<>""
					tcodAgb2 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "5", "1",telPadrao[1],telPadrao[2], "55","","", CNOME,CCGC,"")//Cadastra o celular padrใo do contato		
				endif				
				u_DSu5Cad(XFILIAL("SU5"), CNOME, CCGC, endPadrao[3], endPadrao[5], CRG, endPadrao[6], endPadrao[1], endPadrao[2], telPadrao[1], telPadrao[2], celPadrao[2],CEMAIL, CDTNASC,tcodAga,tcodAgb1,tcodAgb2,codCont)
				u_NkUAC8(cli,codCont)
			else //Se nao, ccadastre um contato com base no passado por parametro
				cli := u_DSa1Cad(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,endPadrao[1],endPadrao[2],endPadrao[3],endPadrao[4],endPadrao[5],"",endPadrao[6],telPadrao[1],telPadrao[2],celPadrao[1],celPadrao[2],CDTNASC,CINSCR,CRG,"105",CCONTAT,CCPFCON,CTIPO,"1030001") //Cadastra o cliente
				if CCONTAT<>""
					codCont := GetSXENum("SU5","U5_CODCONT")
					ConfirmSx8()
					tcodAgb1 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "2", "1",DDDCONT,TELCONT, "55","","", CCONTAT,CCPFCON,"")//Cadastra o telefone padrใo do contato
					tcodAgb2 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "5", "1",DDDCELCT,CELCONT, "55","","", CCONTAT,CCPFCON,"")//Cadastra o celular padrใo do contato		
					u_DSu5Cad(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCONT, TELCONT, CELCONT,"", "","",tcodAgb1,tcodAgb2,codCont)
					u_NkUAC8(cli,codCont)
				endif				
			endif						
					
			for i:=1 to len(::_dados2:Registros2)//CADASTRA OS ENDERECOS
				if ALLTRIM(::_dados2:Registros2[i]:dados2)<>""
				    dadosEnd := StrTokArr(ALLTRIM(::_dados2:Registros2[i]:dados2),";")
				    u_DAgaCad(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[peTipo], dadosEnd[pePadrao],dadosEnd[peEnd]+","+dadosEnd[peEndNum], dadosEnd[peCep], dadosEnd[peBairro], "", dadosEnd[peMun], dadosEnd[peEstado], "105",dadosEnd[peComp], dadosEnd[peTipo2])//Cadastra os demais endere็os do Cliente
					CONOUT("AGA DO NAKAO"+CVALTOCHAR(i)+" "+::_dados2:Registros2[i]:dados2)					 
				endif			  
			next			
			for j:=1 to len(::_dados1:Registros1)//CADASTRA OS TELEFONES
				if(ALLTRIM(::_dados1:Registros1[j]:dados1)<>"")		
					dadosTel := StrTokArr(ALLTRIM(::_dados1:Registros1[j]:dados1),";")
					u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[ptTipo],dadosTel[ptPadrao],dadosTel[ptDDD],dadosTel[ptTel],dadosTel[ptDDDI],dadosTel[ptTipo2],dadosTel[ptComp],dadosTel[ptOwner],dadosTel[ptCpfOw])//Insere os demais telefones do cliente
					CONOUT("AGB DO NAKAO"+CVALTOCHAR(j)+" "+::_dados1:Registros1[j]:dados1)	
				endif	   
			next	       
		END TRANSACTION		
	endif	
RETURN .T. 