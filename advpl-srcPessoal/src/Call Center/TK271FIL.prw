#include 'protheus.ch'
#include 'parmtype.ch'

/*	
	@Author: nakao 
	Descri��o: Ponto de Entrada - Filtro no browse da tela Call Center
	A partir do codigo do usuario logado, procura-se na tabela de operadores por
	um operador com aquele c�digo e � obtido o seu tipo de usuario, que pode ser(1=Vendedor, 2=Supervisor),
	depois, caso seja um vendedor, � retornado um filtro para mostrar apenas os registros do vendedor logado.
	
	in: O alias em qest�o, para o caso do call ceter ser� SUA
	out: Uma string com o filtro aplicado sobre o browse
*/
user function TK271FIL( cAlias )
	Local cFiltra := ''
	Local codUsr := ALLTRIM(RetCodUsr())
	Local tpUsr	
			
	tpUsr := POSICIONE("SU7",4,xFilial("SU7")+codUsr,"U7_TIPO")		
	if(AllTRIM(tpUsr)=="1" .AND. cAlias == 'SUA' )						
		dbSelectArea("SA3")												
		dbSetOrder(7)														
		if(dbSeek(xFilial("SA3")+codUsr))								
			cFiltra+="SUA->UA_VEND == '"+SA3->A3_COD+"' .AND. SUA->UA_STATUS == 'ORC'"				
		endif															
	endif																	
Return (cFiltra)