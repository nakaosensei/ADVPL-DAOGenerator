#include "rwmake.ch"
user function LIGCAL02()
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Incluir","U_LIGCAL2C",0,3} ,;
{"Televendas","U_LIGCAL2A",0,3},;
{"Chamado Técnico","U_LIGCAL2B",0,3},;
{"Legenda","U_LIGCAL2D",0,3}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ADE"

Private cCadastro := "Opções de Teleatendimento"

aCORES := {}
AAdd(aCORES, {"ADE_USITUA == ' '", "BR_BRANCO"} )
AAdd(aCORES, {"ADE_USITUA == '1'", "BR_VERDE"  } )
AAdd(aCORES, {"ADE_USITUA == '2'", "BR_AMARELO"} )
AAdd(aCORES, {"ADE_USITUA == '3'", "BR_AZUL"} )
AAdd(aCORES, {"ADE_USITUA == '4'", "BR_MARROM"} )

dbSelectArea("ADE")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCORES)

Return

User Function LIGCAL2A()
//funcao pra chamar o call center
Local _area := getarea()

Private aTELA[0][0]													// Vetor com informacoes genericas para a enchoice
Private aGETS[0]													// Vetor com informacoes genericas para a enchoice
Private aHeader[0]													// Cabecalho dos itens da getdados
Private aCols														// Itens da getdados
Private nUsado      := 0											// Contador de campos utilizados
Private aValores    := {0,0,0,0,0,0}         						// Array com os valores dos objetos utilizados no Folder do rodape         

//trecho pra transformar o prospect em cliente, se necessario
if ADE->ADE_ENTIDA=='SUS' //se for prospect
	dbselectarea("SUS")
	dbsetorder(1)       //US_FILIAL+US_COD+US_LOJA
	if dbseek(xFilial()+SUBSTR(ADE->ADE_CHAVE,1,12))
		if empty(alltrim(SUS->US_CGC))
			alert("Prospect "+ALLTRIM(SUS->US_NOME)+" está sem CNPJ/CPF, impossivel continuar. Atualize o contato e prossiga. Codigo do contato:"+SUS->US_COD+SUS->US_LOJA)
			restarea(_area)
			return
		endif 

		dbselectarea("SA1")      
		dbsetorder(1)
		if dbseek(xFilial()+SUBSTR(ADE->ADE_CHAVE,1,12))
			reclock("SUS",.f.)
			SUS->US_STATUS  := "6" 
			SUS->US_CODCLI  := SA1->A1_COD
			SUS->US_LOJACLI := SA1->A1_LOJA
			msunlock()		
			reclock("ADE",.f.)
			ADE->ADE_ENTIDA := "SA1"
			ADE->ADE_CHAVE  := SA1->A1_COD+SA1->A1_LOJA
			msunlock()
		else
			reclock("SA1",.T.)
			SA1->A1_FILIAL := xFilial("SA1")           
			SA1->A1_CGC    := SUS->US_CGC
			SA1->A1_COD    := SUBSTR(SUS->US_CGC,1,9)
			if LEN(alltrim(SUS->US_CGC))==11 //CPF
				SA1->A1_LOJA := "001"     
				SA1->A1_PESSOA := "F"
			else
				SA1->A1_LOJA := SUBSTR(SUS->US_CGC,10,3)
				SA1->A1_PESSOA := "J"
			endif                                    
			SA1->A1_NOME   := SUS->US_NOME
			SA1->A1_NREDUZ := SUS->US_NREDUZ
			SA1->A1_EMAIL  := SUS->US_EMAIL
			SA1->A1_END    := SUS->US_END
			SA1->A1_EST    := SUS->US_EST
			SA1->A1_BAIRRO := SUS->US_BAIRRO
			SA1->A1_CEP    := SUS->US_CEP
			SA1->A1_TIPO   := SUS->US_TIPO
			SA1->A1_DDD    := SUS->US_DDD
			SA1->A1_TEL    := SUS->US_TEL
			SA1->A1_FAX    := SUS->US_FAX
			SA1->A1_HPAGE  := SUS->US_URL
			SA1->A1_MUN    := SUS->US_MUN
			SA1->A1_NATUREZ:= "103001    "
			dbselectarea("CC2")
			dbsetorder(4) //CC2_FILIAL+CC2_EST+CC2_MUN
			if dbseek(xFilial()+SUS->US_EST+ALLTRIM(SUS->US_MUN))
				SA1->A1_COD_MUN := CC2->CC2_CODMUN
			endif	
			msunlock()
			
			reclock("SUS",.f.)
			SUS->US_STATUS  := "6" 
			SUS->US_CODCLI  := SA1->A1_COD
			SUS->US_LOJACLI := SA1->A1_LOJA
			msunlock()		
			
			reclock("ADE",.f.)
			ADE->ADE_ENTIDA := "SA1"
			ADE->ADE_CHAVE  := SA1->A1_COD+SA1->A1_LOJA
			msunlock()         
			
			msginfo("Prospect alterado pra cliente com sucesso.")
		endif //IF DO Dbseek do SA1
	else
		alert("Prospect "+ALLTRIM(SUS->US_NOME)+" não foi encontrado. Impossivel continuar. Codigo do contato:"+SUS->US_COD+SUS->US_LOJA)
		restarea(_area)
		return
	endif		
endif   
       /*
MaFisIni(SUA->UA_CLIENTE,;								// 1-Codigo Cliente/Fornecedor
				 SUA->UA_LOJA,;									// 2-Loja do Cliente/Fornecedor
				 "C",;											// 3-C:Cliente , F:Fornecedor
				 "N",;											// 4-Tipo da NF
				 cTipo,;										// 5-Tipo do Cliente/Fornecedor
				 Nil,;											// 6-Relacao de Impostos que suportados no arquivo
				 Nil,;											// 7-Tipo de complemento
				 Nil,;											// 8-Permite Incluir Impostos no Rodape .T./.F.
				 Nil,;											// 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
				 "MATA461",;									// 10-Nome da rotina que esta utilizando a funcao
				 Nil,;											// 11-Tipo de documento
				 Nil,;  										// 12-Especie do documento 
			     IIF(lProspect,SUA->UA_CLIENTE+SUA->UA_LOJA,""))// 13- Codigo e Loja do Prospect                    
       */                                                                           
//mafisini(SA1->A1_COD,SA1->A1_LOJA,"C","N",SA1->A1_TIPO,nil,nil,nil,nil,"TMKA271")
//comentado porque estava dando erro 

dbselectarea("SUB")
dbselectarea("SUA")
TK271CallCenter("SUA",SUA->(RECNO()),3)
restarea(_area)

if type('_lFechou')=="L"
	if !_lFechou
		reclock("ADE",.f.)
		if ADE->ADE_USITUA=="3"
			ADE->ADE_USITUA := "4"
		else
			ADE->ADE_USITUA := "2"
		endif
		msunlock()
	endif
else
	reclock("ADE",.f.)
	if ADE->ADE_USITUA=="3"
		ADE->ADE_USITUA := "4"
	else
		ADE->ADE_USITUA := "2"
	endif
	msunlock()
endif
return

User Function LIGCAL2B()
//funcao pra chamar o chamado tecnico
Local _area := getarea()
IF ADE->ADE_ENTIDA=="SA1"
	dbselectarea("AB1")
	_aret := At300Inclu("AB1",AB1->(RECNO()),3)
	
	if _aret[1]
		restarea(_area)
		reclock("ADE",.f.)
		if ADE->ADE_USITUA=="2"
			ADE->ADE_USITUA := "4"
		else
			ADE->ADE_USITUA := "3"
		endif
		msunlock()
	endif
else
	alert("Somente para clientes.")
endif
return

User Function LIGCAL2C()       
Local cAliasUser	:= "" 		// Alias da tabela Master (a partir do configurador)
Local cAt503Fil		:= ""		// Filtro fornecido pelo ponto de entrada
Local bFiltraBrw	:= {||}		// Bloco de código para execução do filtro
Local aIndex		:= {}		// Indice da tabela
Local cFiltra		:= ""		// Filtro utilizado no bloco de código executado para ativar o filtro
Local cTeleServID	:= ""		// Armazena o codigo do TeleAtendimento associado ao Grupo do Operador.

Private aRecList   := {}	// vetor de recursos adicionais utilizada na funcao QAlocPMS no fonte QNCXFUN
Private lTmk503Auto:= .F.

//funcao pra incluir o teleatendimento
//Local _area := getarea()
dbselectarea("ADE")
TK503AOpc("ADE",ADE->(recno()),3)
if reclock("ADE",.f.)
	if ADE->ADE_ENTIDA=="SUS" //PROSPECT
		ADE->ADE_USITUA := "1"
	endif
	msunlock()
endif
return

User Function LIGCAL2D()
Local aLeg 		:= {}
Aadd(aLeg,{"BR_BRANCO"   , OemToAnsi( "Sem vinculo")})
Aadd(aLeg,{"BR_VERDE"   , OemToAnsi( "Atendimento")})
Aadd(aLeg,{"BR_AMARELO"   , OemToAnsi( "Venda")})
Aadd(aLeg,{"BR_AZUL"   , OemToAnsi( "Chamado Técnico")})
Aadd(aLeg,{"BR_MARROM"   , OemToAnsi( "Venda e Chamado")})
BrwLegenda( cCadastro   , "Legendas",aLeg)
Return(Nil)
