#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "TBICONN.CH"


//AJUSTAR ENDERECO
//AJUSTAR ENDERECO DO ADA COM BASE NO NUMERO DE COBRANCA
User Function LIGGEN04()
Local _area := getarea()



		DBSELECTAREA("ADA")
		DBGoTop()
		while !eof()
							
			//	_aADA := ADA->(getarea())	
						
				_NNUMADA := ADA->ADA_NUMCTR		
				_NUNRCOB := ADA->ADA_UNRCOB
		 		_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
				_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
							    
				_CQUERY := " SELECT e.nr_cep as CEP,e.ds_logradouro as ENDE,e.nr_numero as NUM,e.ds_bairro as BAIRRO,e.ds_complemento as COMPLEM,c.cd_vs COD_VS,n.numerocob NUMCOB "
				_CQUERY += " FROM INTEGRADOR.ENDERECO E, INTEGRADOR.CLIENTE C, TELEFONIA.NUMERO N "
				_CQUERY += " WHERE E.cd_pessoa = C.cd_pessoa"
				_CQUERY += " AND c.cd_cliente = n.cd_cliente  "
				_CQUERY += " AND e.cd_finalidade = 1  "
				_CQUERY += " AND n.numero = '"+_NUNRCOB+"' "
		
				IF SELECT("TRB0")!=0
					TRB0->(DBCLOSEAREA())
				ENDIF
				TCQUERY _CQUERY NEW ALIAS "TRB0" 
				
				IF !EMPTY(TRB0->ENDE)
					_NCEP := TRB0->CEP  
					_NCEP := STRTRAN(_NCEP,"-","")
					
					_NENDE := TRB0->ENDE  
					_NNUM := TRB0->NUM  
					_NBAIRRO := TRB0->BAIRRO  
					_NCOMPLEM := TRB0->COMPLEM  
					_NCOD_VS := TRB0->COD_VS  
					
					DBSELECTAREA("ADA")
				/*	DBSETORDER(1)
					IF DBSEEK(xFilial("ADA") +_NNUMADA)*/
						reclock("ADA",.F.)
							ADA->ADA_UEST := "PR"
							ADA->ADA_UCEP := _NCEP
							ADA->ADA_UEND := _NENDE
							ADA->ADA_UNUM := _NNUM
							ADA->ADA_UBAIRR := _NBAIRRO
							ADA->ADA_UCOMPL := _NCOMPLEM
							ADA->ADA_UCOD_M := "04303"
							ADA->ADA_UMUN := "CAMPO MOURAO"				
						msunlock()
				//	ENDIF
				ENDIF
				
			
							 	
				TRB0->(DBCLOSEAREA())
				
			//	restarea(_aADA)
			dbselectarea("ADA")
			dbskip()
		enddo
		

restarea(_area)		
Return

