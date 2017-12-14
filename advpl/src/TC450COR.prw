#Include 'Protheus.ch'

User Function TC450COR()
//Local aCores := ParamIXBLocal 

aCores := {{ "AB6_STATUS 	==	'A'"  	,  'BR_VERDE'},;		
		    { "AB6_STATUS	 	==	'B'" 	,  "BR_AMARELO"},;  		 		
		    { "AB6_STATUS	 	==	'E'" 	,  "BR_VERMELHO"},;  		 		
		    { "AB6_STATUS	 	==	'C'" 	,  "BR_MARROM"},; 		 		
		    { "AB6_STATUS	 	==	'D'" 	,  "BR_AZUL"} } 	
			
Return aCores