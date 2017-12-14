#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"


//ADICIONAR BASE DE ATENDIMENTO BASEADO NO MAC 
User Function LIGGEN05()
	Local _area := getarea()



	DBSELECTAREA("ADA")
	DBSETORDER(1)
	DBGoTop()
	//IF DBSEEK(xFilial() +"000221")
	while !eof()
		
			//	_aADA := ADA->(getarea())	
						
		_NNUMADA := ADA->ADA_NUMCTR
		_NUNRCOB := ADA->ADA_UNRCOB
		_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
		_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
							    
		_CQUERY := " SELECT ce.cd_equipamento as COD1, ce.ip_http as HTTP1, ce.login as LOGIN1, ce.senha as SENHA1, ce.mac as MAC1, ce.posicao_mxk as POSICAO1, ce.serial as SERIAL1,"
		_CQUERY += " ce.cd_modelo as MODELO, ce.cd_tipo_equipamento as TIPO_EQUIP, "
		_CQUERY += " e.nr_cep as CEP, e.ds_logradouro as ENDE, e.nr_numero as NUM, e.ds_bairro as BAIRRO, e.ds_complemento as COMPLEM"
		_CQUERY += " FROM integrador.cad_equipamento ce, integrador.equipamento_cliente ec, telefonia.numero n, integrador.endereco e"
		_CQUERY += " WHERE ce.cd_equipamento = ec.cd_equipamento and"
		_CQUERY += " ec.cd_cliente = n.cd_cliente and "
		_CQUERY += " e.cd_endereco = ce.cd_endereco and "
		_CQUERY += " n.numero = '"+_NUNRCOB+"' "
		
		IF SELECT("TRB0")!=0
			TRB0->(DBCLOSEAREA())
		ENDIF
		TCQUERY CHANGEQUERY(_CQUERY) NEW ALIAS "TRB0"
		DbSelectArea("TRB0")
				
	
		IF !TRB0->(eof())
			
			_NCEP := TRB0->CEP
			_NCEP := STRTRAN(_NCEP,"-","")
			_NENDE := TRB0->ENDE
			_NNUM := TRB0->NUM
			_NBAIRRO := TRB0->BAIRRO
			_NCOMPLEM := TRB0->COMPLEM
			
			_CMAC		:= TRB0->MAC1	
			_CSERIAL	:= TRB0->SERIAL1		
					
			_CHTTP 		:= TRB0->HTTP1
			_CLOGIN 	:= TRB0->LOGIN1
			_CSENHA 	:= TRB0->SENHA1
			_CPOSICAO	:= TRB0->POSICAO1
			
					
			TRB0->(DBCLOSEAREA())			
			TCUNLINK(_NCONNPTG)				
							
			DbSelectArea("ADB")
			DBSETORDER(1)					
			IF DBSEEK(xFilial() +_NNUMADA)
				while !eof() .AND. ADB->ADB_FILIAL + ADB->ADB_NUMCTR == xFilial("ADB") + _NNUMADA
							
					dbselectarea("AA3")
					DBSETORDER(1)//AA3_FILIAL+AA3_CODCLI+AA3_LOJA+AA3_CODPRO+AA3_NUMSER
					if !dbseek(xFilial()+ADB->ADB_CODCLI + ADB->ADB_LOJCLI + ADB->ADB_CODPRO+_CMAC)
					
						_cItemCtr := POSICIONE("SB1",1,XFILIAL("SB1")+ ADB->ADB_CODPRO,"B1_UITCONT")
					
						IF _cItemCtr = "S"
							RECLOCK("AA3",.T.)
							AA3->AA3_FILIAL := XFILIAL("AA3")
							AA3->AA3_CODCLI := ADB->ADB_CODCLI
							AA3->AA3_LOJA   := ADB->ADB_LOJCLI
							AA3->AA3_CODPRO := ADB->ADB_CODPRO
							AA3->AA3_NUMSER := _CMAC
							AA3->AA3_CHAPA  := _CSERIAL
							AA3->AA3_DTVEND := ddatabase
							AA3->AA3_DTGAR  := ddatabase
							AA3->AA3_STATUS  := "01"
							AA3->AA3_UNUCTR  := ADB->ADB_NUMCTR
							AA3->AA3_UITCTR  := ADB->ADB_ITEM
							
							AA3->AA3_UHTTP  := _CHTTP
							AA3->AA3_ULOGIN  := _CLOGIN
							AA3->AA3_USENHA  := _CSENHA
							AA3->AA3_UPOSIC  := _CPOSICAO
							
							AA3->AA3_CODFAB  := ADB->ADB_CODCLI
							AA3->AA3_LOJAFA  := ADB->ADB_LOJCLI
							MSUNLOCK()
						ENDIF
					endif
							
					dbselectarea("ADB")
					dbskip()
				ENDDO
			ENDIF
		ENDIF
				
													
			//	restarea(_aADA)
		dbselectarea("ADA")
		dbskip()
	enddo
	//ENDIF	

	restarea(_area)
Return

