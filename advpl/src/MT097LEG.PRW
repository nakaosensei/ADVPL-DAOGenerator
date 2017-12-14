#include 'protheus.ch'
#include 'parmtype.ch'

/*
Alterar legenda da Liberação de Pedidos
AUTOR: Noemi Scherer
DATA: 01/03/17
*/

/*
 AlterarCriar a Legenda da Liberação de Documentos
*/
user function MT097LEG()
	local aLegenda :=Paramixb[1]   //Modificações Necessárias 	
	aLegenda := {{ "BR_VERDE"	,  		"Liberado pelo usuário"  },;
				{ "BR_LARANJA"	,  		"Aguardando liberação do usuário"  },;
				{ "BR_MARRON_OCEAN" 	, 	"Bloqueado (Aguardando outros niveis)" },;		
				{ "BR_VERMELHO"	,  		"Bloqueado pelo usuário"  },;
				{ "BR_VERDE_ESCURO"	, 	"Documento liberado por outro usuário"  }}

return aLegenda