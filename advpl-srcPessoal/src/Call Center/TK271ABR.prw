#include 'protheus.ch'
#include 'parmtype.ch'
/*	
	@Author: nakao 
	Descrição: Ponto de Entrada - Chamado quando é clicado em alterar/incluir/excluir,
	no entanto pode-se controlar o que se quer por paramixb.
	A partir do codigo do usuario logado, procura-se na tabela de operadores por
	um operador com aquele código e é obtido o seu tipo de usuario, que pode ser(1=Vendedor, 2=Supervisor),
	depois, caso seja um vendedor e ele esteja tentando incluir, é exibida uma mensagem impedindo-o;
	
	in: 
	out:.T. ou .F., se .F. a tela de cadastro/alteraçao nao abre
*/
User Function TK271ABR()
	Local lRet := .T.
	Local codUsr := ALLTRIM(RetCodUsr())
	Local _area   := getArea()	  
			
	If Paramixb[1] == 3 //Se é inclusão	  
		IF ALLTRIM(FUNNAME())=="TMKA271"			
			tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")		
			if(AllTRIM(tpUsr)=="1")						
				dbSelectArea("SA3")												
				dbSetOrder(7)														
				if(dbSeek(xFilial("SA3")+codUsr))								
					MsgAlert('Vendedor, você deve inserir atendimentos pelo processo padrão.')
					lRet := .F.
				endif															
			endif	
		ENDIF	
	EndIf 
	restArea(_area)
Return(lRet)