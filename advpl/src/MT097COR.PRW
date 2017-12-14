#include 'protheus.ch'
#include 'parmtype.ch'

/*
 Serve para alterar/criar a cor do GetDados.
*/
user function MT097COR()
 
	Local aCores :={;
		{ 'CR_STATUS== "01"', 'BR_MARRON_OCEAN' },;//Bloqueado p/ sistema(aguardando outros niveis)
		{ 'CR_STATUS== "02"', 'BR_LARANJA' },;//Aguardando Liberacao do usuario
		{ 'CR_STATUS== "03"', 'BR_VERDE' },;//Pedido Liberado pelo usuario
		{ 'CR_STATUS== "04"', 'BR_VERMELHO'},;//Pedido Bloqueado pelo usuario
		{ 'CR_STATUS== "05"', 'BR_VERDE_ESCURO'} }//Pedido Liberado por outro usuario
   
return  aCores