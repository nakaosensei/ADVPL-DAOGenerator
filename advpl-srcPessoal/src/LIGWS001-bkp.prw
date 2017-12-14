#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVSWEBSRV.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIGWS001  ºAutor Daniel Gouvea           Data ³ 13/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³WS para gravar dados do cliente                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LIGUE TELECOM                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


Editador por:
author: @nakao
Alterações:
1 - Inserção de campos para celular/telefone do contato
*/

WSSERVICE LIGWS001 Description "WS Cadastro Cliente"

WSDATA CPESSOA  AS STRING OPTIONAL
WSDATA CCGC		AS STRING OPTIONAL
WSDATA CNOME	AS STRING OPTIONAL
WSDATA CFANTAS  AS STRING OPTIONAL
WSDATA CEMAIL   AS STRING OPTIONAL
WSDATA CESTADO  AS STRING OPTIONAL
WSDATA CCEP		AS STRING OPTIONAL 
WSDATA CEND     AS STRING OPTIONAL
WSDATA CCOMPLE  AS STRING OPTIONAL
WSDATA CBAIRRO  AS STRING OPTIONAL
WSDATA CCODMUN  AS STRING OPTIONAL
WSDATA CMUN	    AS STRING OPTIONAL
WSDATA CDDD     AS STRING OPTIONAL
WSDATA CTEL     AS STRING OPTIONAL
WSDATA CDDDC    AS STRING OPTIONAL
WSDATA CCEL     AS STRING OPTIONAL
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
WSDATA _DADOS1 AS ITENSLIST1 OPTIONAL // alteração realizada aqui - estava ITENSLIST
WSDATA _DADOS2 AS ITENSLIST2 OPTIONAL // alteração realizada aqui - estava ITENSLIST

WSMETHOD LIGWS1GR DESCRIPTION "Grava Dados Do Cliente" 

ENDWSSERVICE

// inicio das alterações 

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

// fim das alterações

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIGWS1GR  ºAutor Daniel Gouvea         º Data ³ 13/02/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍ
ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava dados Cliente                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ligue                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Editador por:
author: @nakao
Alterações:
1 - Inserção realizada pelos fontes de DAO das entidades.
2 - Agora podem existir varios endereços/telefones adicionais para um cliente.
3 - Diversas validações manuais, para tarefa foram criados os LGDAOAGA, LGDAOAGB, LGDAOSA1 e LGDAOSU5
*/
WSMETHOD LIGWS1GR WSRECEIVE CPESSOA,CCGC,CNOME,CFANTAS,CEMAIL,CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CCODMUN,CMUN,CDDD,CTEL,CDDDC,CCEL,CDTNASC,CINSCR,CRG,CCONTAT,CCPFCON,CTIPO,DDDCONT,TELCONT,DDDCELCT,CELCONT,ISNOVO,_DADOS1,_DADOS2 WSSEND COK WSSERVICE LIGWS001	
	Local NCAMPOS := 0
	Local CCAMPO  := ""
	Local ACAMPOS := {}
	Local NCONT   := 0	
	Local tmp1 := {}	
	Local tmp2 := {}
	Local codCont := ""
	CCGC := u_LGFTUMSK(CCGC)
	CCGC := ALLTRIM(CCGC)
	RpcSetEnv("01","LG01",,,'FRT','Inicializacao',{"SA1"})
	::cOk := "OK"		
	CONOUT("ENTROU LIGWS1GR DO NAKAO."+CCGC+"."+TIME()+" - "+CCGC)	
	CONOUT("VARIAVEIS QUE CHEGARAM:")
	CONOUT(CPESSOA+" - "+CCGC+" - "+CNOME+" - "+CFANTAS+" - "+CEMAIL+" - "+CESTADO+" - "+CCEP+" - "+CEND+" - "+CCOMPLE+" - "+CBAIRRO+" - "+CCODMUN+" - "+CMUN+" - "+CDDD+" - "+CTEL+" - "+CDDDC+" - "+CCEL+" - "+CDTNASC+" - "+CINSCR+" - "+CRG+" - "+CCONTAT+" - "+CCPFCON+" - "+CTIPO+" - "+DDDCONT+" - "+TELCONT+" - "+DDDCELCT+" - "+CELCONT+" - "+ISNOVO)
	CONOUT(CDTNASC+" TIPO: "+VALTYPE(CDTNASC))
	
	//VALIDACAO
	if(len(u_DSa1Vld(CCGC, CNOME, CEND, CBAIRRO, CESTADO, CEMAIL, CCODMUN, CMUN, CCEP, "44","35233333" , "44", "99999999", "1030001", "105", CDTNASC, CTIPO ))>0/* .OR. len(u_DAgaVld("SA1",SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)),CESTADO,"2","1",CBAIRRO,CCODMUN,CMUN))>0 .OR. len(u_DAgbVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), "2", "1", CDDD,CTEL))>0 .OR. len(u_DAgbVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), "5", "1", CDDDC,CCEL))>0*/)
		return .F.
	endif
	//Os dois laços abaixo validam os campos envolvidos.
	CONOUT("AGB") 
	for j:=1 to len(::_dados1:Registros1)
		if(ALLTRIM(::_dados1:Registros1[j]:dados1)<>"")	
			dadosTel := StrTokArr(ALLTRIM(::_dados1:Registros1[j]:dados1),";")
			CONOUT(::_dados1:Registros1[j]:dados1)
			if( len( u_DAgbVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[5], dadosTel[6] , dadosTel[3] ,dadosTel[4]))>0) //Chama a funcao de validação de telefone, LGDAOAGB.prw
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
			if( len(u_dAgaVld("SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)),dadosEnd[2],dadosEnd[6], dadosEnd[7] ,dadosEnd[5],"",dadosEnd[3] ) )>0) //Chama a função de validação de endereco, LGDAOAGA.prw
				CONOUT("LISTA DE ENDERECOS CONTEM PELO MENOS UM ENDERECO INVALIDO")
				return .F.
			endif
		endif
	next
	
	DBSELECTAREA("SA1")
	DBSETORDER(3)
	dbgotop()
	IF DBSEEK(xFilial()+CCGC) //Se o cliente já for cadastrado			
		/*
			TO DO no sábado:
			
			3)Ainda é um mistério a forma como irei retornar as exceções para o fluig, embora para
			cada tipo de campo faltante eu consiga informar que ele quem deu erro, isso esta morrendo
			no back-end.					
		*/
		cli := ""
		tcodAga  := ""
		tcodAgb1 := "" 
		tcodAgb2 := ""			
		tcodSu5 := ""
		cAliasAga := GetNextAlias()
		cQuery := "SELECT AGA_CODIGO FROM "+ RetSqlName( "AGA" ) + " AGA WHERE AGA.AGA_ENTIDA = 'SA1' AND AGA.AGA_CODENT='"+SA1->A1_COD+SA1->A1_LOJA+"' AND AGA_END='"+SA1->A1_END+"' AND AGA_CEP='"+SA1->A1_CEP+"' AND AGA.D_E_L_E_T_=''"
		cQuery := ChangeQuery(cQuery)
		DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasAga, .F., .T. )		
		tcodAga := (cAliasAga)->AGA_CODIGO

		cAlsAgb1 := getNextAlias()
		cQuery := "SELECT AGB_CODIGO FROM "+ RetSqlName( "AGB" ) + " AGB WHERE AGB.AGB_ENTIDA = 'SA1' AND AGB.AGB_CODENT='"+SA1->A1_COD+SA1->A1_LOJA+"' AND AGB_TELEFO='"+SA1->A1_TEL+"' AND AGB.D_E_L_E_T_=''"
		cQuery := ChangeQuery( cQuery )
		DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAlsAgb1, .F., .T. )		
		tcodAgb1 := (cAlsAgb1)->AGB_CODIGO
		
		cAlsAgb2 := getNextAlias()
		cQuery := "SELECT AGB_CODIGO FROM "+ RetSqlName( "AGB" ) + " AGB WHERE AGB.AGB_ENTIDA = 'SA1' AND AGB.AGB_CODENT='"+SA1->A1_COD+SA1->A1_LOJA+"' AND AGB_TELEFO='"+SA1->A1_CEL+"' AND AGB.D_E_L_E_T_=''"
		cQuery := ChangeQuery( cQuery )
		DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAlsAgb2, .F., .T. )		
		tcodAgb2 := (cAlsAgb2)->AGB_CODIGO
		
		cAlsSu5 := getNextAlias()
		cQuery := "SELECT U5_CODCONT FROM "+ RetSqlName("SU5")+ " SU5 INNER JOIN "+ RetSqlName("AC8") +" AC8 ON SU5.U5_CONTAT='"+SA1->A1_CONTATO+"' AND AC8.AC8_CODCON=SU5.U5_CODCONT AND AC8.AC8_ENTIDA='SA1' AND AC8_CODENT='"+SA1->A1_COD+SA1->A1_LOJA+"'"
		cQuery := ChangeQuery( cQuery )
		DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAlsSu5, .F., .T. )
		tcodSu5 := (cAlsSu5)->U5_CODCONT		
		BEGIN TRANSACTION
			cli := u_DSa1Alter(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CCODMUN,CMUN,CDDD,CTEL,CDDDC,CCEL,CDTNASC,CINSCR,CRG,"105",CCONTAT,CCPFCON,CTIPO,"1030001")//Altera o cliente
			if(tcodAga <> nil .AND. tcodAga<>"")
				u_DAgaAlter(xFILIAL("AGA"),"SA1", SA1->A1_COD+SA1->A1_LOJA, "2", "1", SA1->A1_END, SA1->A1_CEP, SA1->A1_BAIRRO, SA1->A1_COD_MUN, SA1->A1_MUN, SA1->A1_EST, "105",tcodAga)
			else
				u_DAgaCad(xFILIAL("AGA"),"SA1", SA1->A1_COD+SA1->A1_LOJA, "2", "1", SA1->A1_END, SA1->A1_CEP, SA1->A1_BAIRRO, SA1->A1_COD_MUN, SA1->A1_MUN, SA1->A1_EST, "105")
			endif
			
			if(tcodAgb1 <> nil .AND. tcodAgb1<>"")
				u_DAgbAlter(XFILIAL("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, "2", "1",CDDD,CTEL, "55","","", CNOME,CCGC,tcodAgb1)//Cadastra o telefone padrão do cliente
			else
				u_DAgbCad(XFILIAL("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, "2", "1",CDDD,CTEL, "55","","", CNOME,CCGC,"")//Cadastra o telefone padrão do cliente
			endif
			
			if(tcodAgb2 <> nil .AND. tcodAgb2<>"")
				u_DAgbAlter(XFILIAL("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, "5", "1",CDDDC,CCEL, "55","","", CNOME,CCGC,tcodAgb2)//Cadastra o celular padrão do cliente
			else
				u_DAgbCad(XFILIAL("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, "5", "1",CDDDC,CCEL, "55","","", CNOME,CCGC,"")//Cadastra o celular padrão do cliente
			endif			
			if(tcodSu5 <> nil .AND. tcodSu5<>"")
				u_DSu5Alter(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCONT, TELCONT, CELCONT,"", "","",tcodAgb1,tcodAgb2,tcodSu5)
				cAlsAgb1 := getNextAlias()
				cQuery := "SELECT AGB_CODIGO FROM "+ RetSqlName( "AGB" ) + " AGB WHERE AGB.AGB_ENTIDA = 'SU5' AND AGB.AGB_CODENT='"+tcodSu5+"' AND AGB_TELEFO='"+TELCONT+"' AND AGB.D_E_L_E_T_=''"
				cQuery := ChangeQuery( cQuery )
				DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAlsAgb1, .F., .T. )		
				tcodAgb1 := (cAlsAgb1)->AGB_CODIGO
				u_DAgbAlter(XFILIAL("AGB"), "SU5", codCont, "2", "1",DDDCONT,TELCONT, "55","","", CCONTAT,CCPFCON,tcodAgb1)//Cadastra o telefone padrão do contato
				cAlsAgb1 := getNextAlias()
				cQuery := "SELECT AGB_CODIGO FROM "+ RetSqlName( "AGB" ) + " AGB WHERE AGB.AGB_ENTIDA = 'SU5' AND AGB.AGB_CODENT='"+tcodSu5+"' AND AGB_TELEFO='"+CELCONT+"' AND AGB.D_E_L_E_T_=''"
				cQuery := ChangeQuery( cQuery )
				DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAlsAgb1, .F., .T. )		
				tcodAgb2 := (cAlsAgb1)->AGB_CODIGO
				u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "5", "1",DDDCELCT,CELCONT, "55","","", CCONTAT,CCPFCON,tcodAgb2)//Cadastra o celular padrão do contato			
			else
				u_DSu5Cad(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCONT, TELCONT, CELCONT,"", "","",tcodAgb1,tcodAgb2,"")
			endif		
			
			
			//Os laços abaixo atualizam ou cadastram os endereços e telefones
			CONOUT("ALTER AGA")
			for i:=1 to len(::_dados2:Registros2) //ALTERA/CADASTRA OS ENDERECOS
				if ALLTRIM(::_dados2:Registros2[i]:dados2)<>""
					CONOUT(::_dados2:Registros2[i]:dados2)
					dadosEnd := StrTokArr(ALLTRIM(::_dados2:Registros2[i]:dados2),";")
					if (ALLTRIM(dadosEnd[9])=="A")//O decimo elemento indica se é uma alteração ou inclusao, se alteração, procure o registro em questão na tabela de endereços
						cAliasAga := GetNextAlias()
						cQuery := "SELECT AGA_CODIGO FROM "+ RetSqlName( "AGA" ) + " AGA WHERE AGA.AGA_ENTIDA = 'SA1' AND AGA.AGA_CODENT='"+SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3))+"' AND AGA_END='"+dadosEnd[1]+"' AND AGA_CEP='"+dadosEnd[4]+"' AND AGA.D_E_L_E_T_=''"
						cQuery := ChangeQuery( cQuery )
						DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasAga, .F., .T. )		
						tcodAga := (cAliasAga)->AGA_CODIGO
						if(tcodAga <> nil .AND. tcodAga<>"")
							u_DAgaAlter(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[7], dadosEnd[8],dadosEnd[1]+","+dadosEnd[9], dadosEnd[4], dadosEnd[3], "", dadosEnd[5], dadosEnd[6], "105", tcodAga)
						else
							u_DAgaCad(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[7], dadosEnd[8],dadosEnd[1]+","+dadosEnd[9], dadosEnd[4], dadosEnd[3], "", dadosEnd[5], dadosEnd[6], "105")
						endif					
					else
					 	u_DAgaCad(xFilial("AGA"),"SA1", SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosEnd[7], dadosEnd[8],dadosEnd[1]+","+dadosEnd[9], dadosEnd[4], dadosEnd[3], "", dadosEnd[5], dadosEnd[6], "105")
					endif			    							 
				 endif			  
			next		
			
			for j:=1 to len(::_dados1:Registros1)//ALTERA/CADASTRA OS TELEFONES
				if(ALLTRIM(::_dados1:Registros1[j]:dados1)<>"")		
				    dadosTel := StrTokArr(ALLTRIM(::_dados1:Registros1[j]:dados1),";")
				    if(ALLTRIM(dadosTel[10])=="A")
				    	cAlsAgb1 := getNextAlias()
						cQuery := "SELECT AGB_CODIGO FROM "+ RetSqlName( "AGB" ) + " AGB WHERE AGB.AGB_ENTIDA = 'SA1' AND AGB.AGB_CODENT='"+SUBSTR(CCGC,1,9)+IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3))+"' AND AGB_TELEFO='"+dadosTel[4]+"' AND AGB.D_E_L_E_T_=''"
						cQuery := ChangeQuery( cQuery )
						DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAlsAgb1, .F., .T. )		
						tcodAgb1 := (cAlsAgb1)->AGB_CODIGO
						if(tcodAgb1 <> nil .AND. tcodAgb1<>"")
							u_DAgbAlter(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[5],dadosTel[6],dadosTel[3],dadosTel[4],dadosTel[2],dadosTel[1],dadosTel[7],dadosTel[8],dadosTel[9],tcodAgb1)
						else
							u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[5],dadosTel[6],dadosTel[3],dadosTel[4],dadosTel[2],dadosTel[1],dadosTel[7],dadosTel[8],dadosTel[9])
						endif			    	
				    else
				    	u_DAgbCad(xFilial("AGB"), "SA1", SUBSTR(CCGC,1,9) + IF((len(CCGC)=11), "001", SUBSTR(CCGC,10,3)), dadosTel[5],dadosTel[6],dadosTel[3],dadosTel[4],dadosTel[2],dadosTel[1],dadosTel[7],dadosTel[8],dadosTel[9])
				    endif
				endif	   
			next
		END TRANSACTION		
	else // Se não, cadastre um novo cliente, com seus respectivos endereços/telefone
		//CADASTRO		
		BEGIN TRANSACTION
			cli := ""
			tcodAga  := ""
			tcodAgb1 := "" 
			tcodAgb2 := ""			
			cli := u_DSa1Cad(xFilial("SA1"), CCGC, CPESSOA,CNOME,CFANTAS,CEMAIL,CESTADO,CCEP,CEND,CCOMPLE,CBAIRRO,CCODMUN,CMUN,CDDD,CTEL,CDDDC,CCEL,CDTNASC,CINSCR,CRG,"105",CCONTAT,CCPFCON,CTIPO,"1030001") //Cadastra o cliente
			u_DAgaCad(xFILIAL("AGA"),"SA1", SA1->A1_COD+SA1->A1_LOJA, "2", "1", SA1->A1_END, SA1->A1_CEP, SA1->A1_BAIRRO, SA1->A1_COD_MUN, SA1->A1_MUN, SA1->A1_EST, "105","")	//Cadastra o endereço do cliente	
			u_DAgbCad(XFILIAL("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, "2", "1",CDDD,CTEL, "55","","", CNOME,CCGC,"")//Cadastra o telefone padrão do cliente
			u_DAgbCad(XFILIAL("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, "5", "1",CDDDC,CCEL, "55","","", CNOME,CCGC,"")//Cadastra o celular padrão do cliente
			if(ALLTRIM(CPESSOA)=="F")//Se for pessoa física, cadastre um contato identico ao cliente				
				codCont := GetSXENum("SU5","U5_CODCONT")//Codigo do contato, depois do cadastro de um cliente sempre se cadastra um contato(SU5)
				tcodAga := u_DAgaCad(xFILIAL("AGA"), "SU5", codCont, "2", "1", SA1->A1_END, SA1->A1_CEP, SA1->A1_BAIRRO, SA1->A1_COD_MUN, SA1->A1_MUN, SA1->A1_EST, "105","")	//Cadastra o endereço do contato
				tcodAgb1 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "2", "1",CDDD,CTEL, "55","","", CNOME,CCGC,"")//Cadastra o telefone padrão do contato
				tcodAgb2 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "5", "1",CDDDC,CCEL, "55","","", CNOME,CCGC,"")//Cadastra o celular padrão do contato		
				u_DSu5Cad(XFILIAL("SU5"), CNOME, CCGC, CEND, CBAIRRO, CRG, CMUN, CESTADO, CCEP, CDDD, CTEL, CCEL,CEMAIL, CDTNASC,tcodAga,tcodAgb1,tcodAgb2,codCont)
				u_NkUAC8(cli,codCont)
			endif			
			if(ALLTRIM(CCONTAT) <> "") //Se veio um contato, cadatre-o
				codCont := GetSXENum("SU5","U5_CODCONT")
				tcodAgb1 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "2", "1",DDDCONT,TELCONT, "55","","", CCONTAT,CCPFCON,"")//Cadastra o telefone padrão do contato
				tcodAgb2 := u_DAgbCad(XFILIAL("AGB"), "SU5", codCont, "5", "1",DDDCELCT,CELCONT, "55","","", CCONTAT,CCPFCON,"")//Cadastra o celular padrão do contato		
				u_DSu5Cad(XFILIAL("SU5"), CCONTAT, CCPFCON, "", "", "", "", "", "", DDDCONT, TELCONT, CELCONT,"", "","",tcodAgb1,tcodAgb2,codCont)
				u_NkUAC8(cli,codCont)
			endif						
			for i:=1 to len(::_dados2:Registros2)//CADASTRA OS ENDERECOS
				if ALLTRIM(::_dados2:Registros2[i]:dados2)<>""
				    dadosEnd := StrTokArr(ALLTRIM(::_dados2:Registros2[i]:dados2),";")
				    u_DAgaCad(xFilial("AGA"),"SA1", SA1->A1_COD+SA1->A1_LOJA, IF((ALLTRIM(dadosEnd[7])=="C"), "1", IF((ALLTRIM(dadosEnd[7])=="R"), "2", "") ), IF((ALLTRIM(dadosEnd[8])=="SIM"), "1", IF((ALLTRIM(dadosEnd[8])=="NAO"), "2", "") ),dadosEnd[1]+","+dadosEnd[9], dadosEnd[4], dadosEnd[3], "", dadosEnd[5], dadosEnd[6], "105")//Cadastra os demais endereços do Cliente
					CONOUT("AGA DO NAKAO"+CVALTOCHAR(i)+" "+::_dados2:Registros2[i]:dados2)					 
				endif			  
			next			
			for j:=1 to len(::_dados1:Registros1)//CADASTRA OS TELEFONES
				if(ALLTRIM(::_dados1:Registros1[j]:dados1)<>"")		
					dadosTel := StrTokArr(ALLTRIM(::_dados1:Registros1[j]:dados1),";")
					u_DAgbCad(xFilial("AGB"), "SA1", SA1->A1_COD+SA1->A1_LOJA, IF((ALLTRIM(dadosTel[5])=="C"), "5", IF((ALLTRIM(dadosTel[5])=="R"), "2", "") ),IF((ALLTRIM(UPPER(dadosTel[6]))=="SIM"), "1", IF((ALLTRIM(UPPER(dadosTel[6]))=="NAO"), "2", "") ),dadosTel[3],dadosTel[4],dadosTel[2],IF( (ALLTRIM(dadosTel[1])=="L") , "N", (IF( (ALLTRIM(dadosTel[1])=="P") , "P", ""))),dadosTel[7],dadosTel[8],dadosTel[9])//Insere os demais telefones do cliente
					CONOUT("AGB DO NAKAO"+CVALTOCHAR(j)+" "+::_dados1:Registros1[j]:dados1)	
				endif	   
			next	       
		END TRANSACTION		
	endif
RETURN .T. 