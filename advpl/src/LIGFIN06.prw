#Include "PROTHEUS.ch"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#include "TOTVS.CH"
//#INCLUDE "TBICONN.CH"
//#INCLUDE "TBICODE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �LIGFIN06 �AUTOR  �ROBSON ADRIANO 		   �DATA � 22/07/14   ���
�������������������������������������������������������������������������͹��
���DESC.     � ROTINA PARA AGENDA NO SCHEDULE, PARA VERIFICAR DUPLICATAS  ���
���          � EM ABERTO E ENVIAR NOTIFICACOES E BLOQUEIOS DE SERVICOS    ���
�������������������������������������������������������������������������͹��
���USO       � LIGUE                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function LIGFIN06()
	Local _area := getarea()
	Local _aSE1 := SE1->(getarea()) 
	Local _codAnt := ""
	Local _lojaAnt := ""
	Local _situa := "A"
	Local _email := "financeiro@liguetelecom.com.br"
	Local _email2 := "financeiro@liguetelecom.com.br,robson.adriano@liguetelecom.com.br,johnny.santos@ligue.net"
	Local _email3 := "financeiro@liguetelecom.com.br,maicon@liguetelecom.com.br,robson.adriano@liguetelecom.com.br"
	Local _cCemail := "suporte.ftth@liguetelecom.com.br"
	Local _cAssunto1 := "Fatura Ligue Telecom"
	Local _cAssunto2 := "Fatura Ligue Telecom: Email de Notifica��o"
	Local _cImg1 := "http://portal.liguetelecom.com.br/faturaLigue.png" 
	Local _cImg2 := "http://portal.liguetelecom.com.br/faturaLigue1.png"
	Local _cImg3 := "http://portal.liguetelecom.com.br/faturaLigue2.png"
	Local _cNum	:= ""
//	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "LG01" MODULO "FAT"
	
    _cOcoDes := getmv("MV_UOCODES")
    _cOcoDet := getmv("MV_UOCODET")
    _cAtReti := getmv("MV_UATRETI") // COD ATENDENTE DE RETIRADA DE EQUIPAMENTO	
    
    _nPriNot := getmv("MV_UPRINOT")
    _nSecNot := getmv("MV_USECNOT")
    _nTerNot := getmv("MV_UTERNOT")
    _nQuaNot := getmv("MV_UQUANOT")
    _nQuiNot := getmv("MV_UQUINOT")  //30 dias
    _nSexNot := getmv("MV_USEXNOT")  //60 dias  
    _nSetNot := getmv("MV_USETNOT")  //65 dias 
    _nOitNot := getmv("MV_UOITNOT")  //90 dias
    
    _nAtVct1 := getmv("MV_UATVCT1")
    _nAtVct2 := getmv("MV_UATVCT2")
    
    _nDiaBlq := getmv("MV_UDIABLQ")
    
    _cMsgDesP := "Desligamento parcial por falta de pagamento de servi�o"
    _cMsgDesT := "Desligamento total por falta de pagamento de servi�o"
    
	_NImprimi := "" 
	_CMsgSPC := ""
	_CMsg60Dias := ""
	_CMsgCanc := ""
	_CMsgBloq := ""
	_CMsgSYate := ""
   
	DbSelectArea("SE1")
		cQuery := "SELECT E1_OK, E1_STATUS, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, E1_CLIENTE, E1_NOMCLI, E1_LOJA, E1_EMISSAO,"
		cQuery += " E1_VENCTO,E1_VENCREA, E1_VALOR, E1_HIST, E1_UFILNF1, E1_UNUMNF1, E1_USERNF1, E1_UFILNF2, E1_UNUMNF2, E1_USERNF2,"
		cQuery += " E1_UFILNF3, E1_UNUMNF3, E1_USERNF3,E1_UBLQYAT, E1_FATPREF, E1_FATURA,"
		cQuery += " E1_USITUA1, E1_UDTBLS, E1_ORIGEM, A1_EMAIL"
		cQuery += " FROM " + RetSqlName("SE1") + " SE1 , " + RetSqlName("SA1") + " SA1" 
		cQuery += " WHERE SE1.D_E_L_E_T_ = ' ' "
		cQuery += " AND SA1.D_E_L_E_T_ = ' ' " 
		cQuery += " AND SE1.E1_CLIENTE = SA1.A1_COD "
		cQuery += " AND SE1.E1_LOJA = SA1.A1_LOJA "
		cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
		cQuery += " AND SE1.E1_SALDO > 0 "
		cQuery += " AND SE1.E1_BAIXA = ' '"
	    cQuery += " AND SE1.E1_TIPO <> 'RA'"
		cQuery += " AND (SE1.E1_PREFIXO = 'CTR' OR SE1.E1_PREFIXO = 'ACO' OR SE1.E1_PREFIXO = 'DES' OR SE1.E1_PREFIXO = 'MUL')"
//		cQuery += " AND SE1.E1_ULIBFAT = 'S'"
		cQuery += " ORDER BY SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_CLIENTE, SE1.E1_LOJA, E1_NUM,SE1.E1_VENCTO"
	
	IF SELECT("TSE1")!=0
		TSE1->(DBCLOSEAREA())
	ENDIF
	TCQUERY cQuery NEW ALIAS "TSE1"
	DbSelectArea("TSE1")
	DbGoTop()
	_nCount := 1
	
	WHILE !EOF() 
		
		//BLOQUEAR CLIENTES
   		IF  DATE() - (STOD(TSE1->E1_VENCTO)) > _nDiaBlq
   			IF TSE1->E1_PREFIXO == "CTR"
   				FIN06B(TSE1->E1_NUM)	
   			ELSEIF TSE1->E1_PREFIXO == "MUL"
   				IF LEN(ALLTRIM(TSE1->E1_NUM)) == 6
   					FIN06B(TSE1->E1_NUM)	
   				ENDIF	   				
   			ELSE
   				DbSelectArea("SE1")
				DBGOTOP()
				DBSetOrder(10) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_FATPREF+E1_FATURA
				IF DBSEEK(xFilial("SE1") + TSE1->E1_CLIENTE + TSE1->E1_LOJA + TSE1->E1_PREFIXO + TSE1->E1_NUM)
					IF SE1->E1_PREFIXO == "CTR"
						FIN06B(SE1->E1_NUM)	
					ENDIF
				ENDIF
				
			 	DbSelectArea("TSE1") 
   			ENDIF
  		ENDIF
	
   		//ENVIAR EMAIL PARA TITULO 5 DIAS ANTES DO VENCIMENTO
   		IF  STOD(TSE1->E1_VENCTO) - DATE() = _nAtVct1 
   			_msgIni := msg1Inicio(TSE1->E1_VENCTO)
   			_msgFim := msg1Fim()
   			_MSG := msgNotificacao(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_NOMCLI,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,TSE1->E1_VALOR,_msgIni,_msgFim,_cImg1)

   		   FIN06A(TSE1->A1_EMAIL,_cAssunto1,_MSG,0)
  		ENDIF
   		
   		//ENVIAR EMAIL PARA TITULO 1 DIA ANTES DO VENCIMENTO
   		IF  STOD(TSE1->E1_VENCTO) - DATE() = _nAtVct2 
   			_msgIni := msg1Inicio(TSE1->E1_VENCTO)
   			_msgFim := msg1Fim()
   			
   			_MSG := msgNotificacao(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_NOMCLI,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,TSE1->E1_VALOR,_msgIni,_msgFim,_cImg1)
   		    FIN06A(TSE1->A1_EMAIL,_cAssunto1,_MSG,0)
  		ENDIF
   		

   		//ENVIAR EMAIL PARA TITULO 1 APOS O VENCIMENTO
   		IF  DATE() - STOD(TSE1->E1_VENCTO) = _nPriNot
   			_msgIni := "<p>Fatura:</p>"
   			_msgFim := " "
   			IF (TSE1->E1_PREFIXO = 'CTR')
   				_msgFim := msg2Fim()
   			ELSE
   				_msgFim += "<p>Se o pagamento j� foi efetivado desconsidere essa mensagem.</p>"
   			ENDIF
   			
   			_MSG := msgNotificacao(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_NOMCLI,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,TSE1->E1_VALOR,_msgIni,_msgFim,_cImg2)
   			FIN06A(TSE1->A1_EMAIL,_cAssunto2,_MSG,1)
  		ENDIF
  		
  		//ENVIAR EMAIL PARA TITULO 5 APOS O VENCIMENTO
   		IF  DATE() - STOD(TSE1->E1_VENCTO) = _nSecNot
   			_msgIni := "<p>Fatura:</p>"
   			_msgFim := " "
   			IF (TSE1->E1_PREFIXO = 'CTR')
   				_msgFim := msg2Fim()
   			ELSE
   				_msgFim += "<p>Se o pagamento j� foi efetivado desconsidere essa mensagem.</p>"
   			ENDIF
   			
   			_MSG := msgNotificacao(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_NOMCLI,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,TSE1->E1_VALOR,_msgIni,_msgFim,_cImg2)
   			FIN06A(TSE1->A1_EMAIL,_cAssunto2,_MSG,2)
  		ENDIF
  		
  		//ENVIAR EMAIL PARA 1 DIA ANTES DO BLOQUEIO
   		IF  DATE() - (STOD(TSE1->E1_VENCTO) + _nDiaBlq) = _nTerNot .AND. TSE1->E1_PREFIXO = 'CTR'	
   			_msgIni := "<p>Fatura:</p>"
   			_msgFim := msg2Fim()
   			_MSG := msgNotificacao(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_NOMCLI,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,TSE1->E1_VALOR,_msgIni,_msgFim,_cImg2)
   	
   			FIN06A(TSE1->A1_EMAIL,_cAssunto2,_MSG,3)
  		ENDIF
  		
  		
  		//ENVIAR EMAIL DE 5 EM 5 DIAS AP�S O BLOQUEIO DO CLIENTE
   		IF   DATE() - (STOD(TSE1->E1_VENCTO) + _nDiaBlq) > 0 .AND. MOD(DATE() - (STOD(TSE1->E1_VENCTO) + _nDiaBlq), _nQuaNot) = 0 .AND. TSE1->E1_PREFIXO = 'CTR'
   				_msgIni := "<p>Fatura:</p>"
   				_msgFim := msg3Fim()
   				_MSG := msgNotificacao(TSE1->E1_PREFIXO,TSE1->E1_NUM,TSE1->E1_PARCELA,TSE1->E1_NOMCLI,TSE1->E1_EMISSAO,TSE1->E1_VENCTO,TSE1->E1_VALOR,_msgIni,_msgFim,_cImg3)
   				
   				FIN06A(TSE1->A1_EMAIL,_cAssunto2,_MSG,4)
  		ENDIF
  		
  		
   		//ENVIAR EMAIL 30 AP�S VENCIMENTO
   		IF DATE() - STOD(TSE1->E1_VENCTO) >= _nQuiNot .AND. DATE() - STOD(TSE1->E1_VENCTO) <= _nQuiNot + 3
   				_MSG := "<p>Aviso para acionamento do SPC.</p>"
   				_MSG += "<p>C�digo : " + TSE1->E1_CLIENTE + " Nome : " + TSE1->E1_NOMCLI + " Fatura : " + TSE1->E1_PREFIXO + " " + TSE1->E1_NUM + " "+ TSE1->E1_PARCELA + "</p>"
   				_MSG += "<p>Vencimento : "+Transform(STOD(TSE1->E1_VENCTO),"@E") +"</p>"
   				_MSG += "<p>Valor : "+Transform(TSE1->E1_VALOR,"@E 9,999,999.99",) +"</p><hr>"  
   				
   				_CMsgSPC += _MSG
   			    //U_LIGGEN03(_email2,"","","Fatura vencida � 30 dias. SPC",_MSG,.T.,"")
   				U_SaveSE1(5)
  		ENDIF  
  		           
  		//ENVIAR EMAIL 60 AP�S VENCIMENTO
   		IF DATE() - STOD(TSE1->E1_VENCTO) >= _nSexNot .AND. DATE() - STOD(TSE1->E1_VENCTO) <= _nSexNot + 5
   				_MSG := "<p>Aviso para acionamento do SPC.</p>"
   				_MSG += "<p>C�digo : " + TSE1->E1_CLIENTE + " Nome : " + TSE1->E1_NOMCLI + " Fatura : " + TSE1->E1_PREFIXO + " " + TSE1->E1_NUM + " "+ TSE1->E1_PARCELA + "</p>"
   				_MSG += "<p>Vencimento : "+Transform(STOD(TSE1->E1_VENCTO),"@E") +"</p>"
   				_MSG += "<p>Valor : "+Transform(TSE1->E1_VALOR,"@E 9,999,999.99",) +"</p><hr>"  
   				
   				_CMsg60Dias += _MSG
   			    //U_LIGGEN03(_email2,"","","Fatura vencida � 30 dias. SPC",_MSG,.T.,"")
   				U_SaveSE1(6)
  		ENDIF  
  		
  	          		          
  		                      
  		//ENVIAR EMAIL 90 AP�S VENCIMENTO
  		IF DATE() - STOD(TSE1->E1_VENCTO) >= _nOitNot .AND. DATE() - STOD(TSE1->E1_VENCTO) <= _nOitNot + 3
   				_MSG := "<p>Aviso de cancelamento e retirada de equipamento.</p>"
   				_MSG += "<p>C�digo : " + TSE1->E1_CLIENTE + " Nome : " + TSE1->E1_NOMCLI + " Fatura : " + TSE1->E1_PREFIXO + " " + TSE1->E1_NUM + " "+ TSE1->E1_PARCELA + "</p>"
   				_MSG += "<p>Vencimento : "+Transform(STOD(TSE1->E1_VENCTO),"@E") +"</p>"
   				_MSG += "<p>Valor : "+Transform(TSE1->E1_VALOR,"@E 9,999,999.99",) +"</p><hr>"   
   			   
   				_CMsgCanc += _MSG
   			   //U_LIGGEN03(_email3,"","","Fatura vencida � 90 dias. Cancelamento",_MSG,.T.,"")
   				U_SaveSE1(8)	
  		ENDIF
  		
  		IF _cNum == E1_NUM
			_nCount++
		ELSE
			_nCount:= 1
		ENDIF
		
		IF _nCount >= 3
			U_FIN06D(TSE1->E1_NUM)//Marcar Ctr para Cancelamento de contrato por 3 Faturas em Aberto.
		ENDIF
   		
   		
   		/*
   		//Verificar se a data de operacao ta vazia e ainda nao foi feita nenhuma operacao e notificacao 
   		//Caso tenha feito notificacao comparar datas e situacao para mandar Bloqueio parcial ou Total
   		IF !EMPTY(TSE1->E1_UDTBLS)	
   		
   			// Se o Titulo a receber tiver sido enviado notificacao e passado 15 dias
   			// abrir chamado tecnico para bloqueio parcial de servico	
	   		IF  DATE() - STOD(TSE1->E1_UDTBLS) > _nSecNot .AND. TSE1->E1_USITUA1 == 1
	   		
	   			// Verificar se o mesmo cliente, para nao permitir abrir 2 chamados de bloqueio de servico para o mesmo cliente
	   			IF ! _codAnt == TSE1->E1_CLIENTE .AND. _lojaAnt == TSE1->E1_LOJA
	   				 U_GerarChamando(_cOcoDes)
	   			ENDIF
	   			
	   			U_SaveSE1(2)
	   		ENDIF
	   			
	   		// Enviar email 1 dia antes do servi�o ser bloqueado.
   			// abrir chamado tecnico para bloqueio total de servico		
	   		IF  DATE() - STOD(TSE1->E1_UDTBLS) > _nTerNot .AND. TSE1->E1_USITUA1 == 2
	   		
	   			// Verificar se o mesmo cliente, para nao permitir abrir 2 chamados de bloqueio de servico para o mesmo cliente
	   			IF ! _codAnt == TSE1->E1_CLIENTE .AND. _lojaAnt == TSE1->E1_LOJA
	   				U_GerarChamando(_cOcoDet)
	   			ENDIF
	   			
	   			U_SaveSE1(3)
	   		ENDIF
	   	ENDIF
   		_codAnt := TSE1->E1_CLIENTE
   		_lojaAnt := TSE1->E1_LOJA
   		*/    
   		
   		_cNum := TSE1->E1_NUM
   		                             
   		DbSelectArea("TSE1")
   		DBSKIP()
	ENDDO
	
	DbSelectArea("TSE1")
	DbCloseArea()	
	
	IF !EMPTY (_CMsgSPC)
   		U_LIGGEN03(_email2,"","","Fatura vencida � 30 dias.",_CMsgSPC,.T.,"")
	ENDIF 
	
	IF !EMPTY (_CMsg60Dias)
   		U_LIGGEN03(_email2,"","","Fatura vencida � 60 dias.",_CMsgSPC,.T.,"")
	ENDIF 
	
	IF !EMPTY (_CMsgCanc)
	   U_LIGGEN03(_email3,"","","Fatura vencida � 90 dias. Cancelamento",_CMsgCanc,.T.,"")
	ENDIF  
	
	IF !EMPTY (_NImprimi)
		U_LIGGEN03(_email2,"","","Clientes sem email no Totvs",_NImprimi,.T.,"")
	ENDIF 	 
	
	IF !EMPTY (_CMsgBloq)
	   U_LIGGEN03(_email2,"","","Clientes bloqueados pela rotina Autom�tica",_CMsgBloq,.T.,"")
	ENDIF 
	  
	IF !EMPTY (_CMsgSYate)
	   U_LIGGEN03(_email2,"","","Clientes sem c�digo do yate",_CMsgSYate,.T.,"")
	ENDIF   
	
	MSGINFO("Fim da rotina","Rotina executada")
	
	restarea(_aSE1)
	restarea(_area)
	
//	RESET ENVIRONMENT
Return

Static Function FIN06A(_pEmail,_pAssunto,_pMsg,_Situ)   
 		_pEmail := ALLTRIM(_pEmail)
 		IF EMPTY(_pEmail) .OR. !ISEMAIL(_pEmail)
 			_NImprimi  +="<p>Codigo : "+ TSE1->E1_CLIENTE+" - "+TSE1->E1_LOJA+" - Nome : "+TSE1->E1_NOMCLI+" </p>"	
 		ELSE
 			//1 DESTINATARIO, 2 CPOIA, 3 CCONHCOPIA, 4 ASSUNTO, 5 TEXTO, 6 HTLML, 7 ANEXO 		
 			U_LIGGEN03(_pEmail,"","",_pAssunto,_pMsg,.T.,"")
 			IF EMPTY(_Situ)
 				U_SaveSE1(_Situ)	
 			ENDIF
 		ENDIF
Return 

//Atualizar SE1 de acordo com a situacao passada como parametro e data atual
User Function SaveSE1(_situ)
	DbSelectArea("SE1")
	DBGOTOP()
	DBSetOrder(2) //FILIAL + COD CLIENTE + LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
	IF DBSEEK(xFilial("SE1") + TSE1->E1_CLIENTE + TSE1->E1_LOJA + TSE1->E1_PREFIXO + TSE1->E1_NUM + TSE1->E1_PARCELA + TSE1->E1_TIPO)
		RecLock("SE1",.F.)
			SE1->E1_USITUA1 := _situ
			SE1->E1_UDTBLS := DATE()
		MsUnLock()	
	ENDIF
	
 	DbSelectArea("TSE1") 
RETURN

User Function SaveSE1BLQ()
	DbSelectArea("SE1")
	DBGOTOP()
	DBSetOrder(2) //FILIAL + COD CLIENTE + LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
	IF DBSEEK(xFilial("SE1") + TSE1->E1_CLIENTE + TSE1->E1_LOJA + TSE1->E1_PREFIXO + TSE1->E1_NUM + TSE1->E1_PARCELA + TSE1->E1_TIPO)
		RecLock("SE1",.F.)
			SE1->E1_UBLQYAT := "S"
			SE1->E1_UDTBLOQ := DATE()
		MsUnLock()	
	ENDIF
	
 	DbSelectArea("TSE1") 
RETURN


Static Function msgNotificacao(_NPrefixo, _NNUM,_NParcela, _CNome,_DEmissao,_DVenc ,_NValor, _CTextoIni,_CTextoFim,_CImg)
Local _cMsg := ""
_cMsg += "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
_cMsg += "<html xmlns='http://www.w3.org/1999/xhtml'>"
_cMsg += "<head><meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
_cMsg += "<title>Ligue Telecom</title>"
_cMsg += "<style type='text/css'>"
_cMsg += "body {margin: auto; height: auto; min-height: 100%;font-size: 20px;font-family: 'Trebuchet MS', Verdana, Arial, Helvetica, sans-serif;}"
_cMsg += "a:link {text-decoration:none;} "
_cMsg += "th {text-align: rigth;}"
_cMsg += "</style>"
_cMsg += "</head>" 
_cMsg += "<body>"
_cMsg += "<div style='min-width: 600px;'>"
_cMsg += "<img src='"+_CImg+"' width='1000' height='214' border='0' align='top' usemap='#Ligue'/>"
_cMsg += "<br/>"
_cMsg += _CTextoIni
_cMsg += "<table border=1 style='min-width:1000px;'><tr>"
_cMsg += "<th>Prefixo</th>"
_cMsg += "<th>Titulo</th>"
_cMsg += "<th>Parcela</th>" 
_cMsg += "<th>Emiss�o</th>" 
_cMsg += "<th>Vencimento</th>" 
_cMsg += "<th>Valor</th>" 
_cMsg += "<th>Portal</th></tr>" 
_cMsg += "<tr><td>"+_NPrefixo+"</td>"
_cMsg += "<td>"+_NNUM+"</td>"
_cMsg += "<td>"+_NParcela+"</td>"
_cMsg += "<td>"+Transform(STOD(_DEmissao),"@E")+"</td>"
_cMsg += "<td>"+Transform(STOD(_DVenc),"@E")+"</td>"
_cMsg += "<td>R$"+Transform(_NValor,"@E 9,999,999.99",)+"</td>"
_cMsg += "<td><a href='http://portal.liguetelecom.com.br/'>Acessar</a></td>"
_cMsg += "</tr></table>"
_cMsg += "</br><p>Para retirar a segunda via acesse o portal do cliente: <a href='http://portal.liguetelecom.com.br/'>portal.liguetelecom.com.br</a></p>"
_cMsg += _CTextoFim
_cMsg += "<br/><p>Mensagem enviada automaticamente pelo sistema da Ligue Telecom.</p>"
_cMsg += "</div>"
_cMsg += "</body>"
_cMsg += "</html>"
RETURN _cMsg

Static Function msg1Inicio(_DVenc)
Local _cMsg := ""
_cMsg += "<p>Prezado Cliente,</p>"
_cMsg += "<p>Informamos que em " + Transform(STOD(_DVenc),"@E") + " vencer�/vencer�o o(s) t�tulo(s) originado(s) pelo(s) servi�o(s) prestado(s) � V.Sa</p>"
return _cMsg

Static Function msg1Fim()
Local _cMsg := ""
_cMsg += "<p>Caso n�o tenha recebido os documentos necess�rios para programa��o do(s) pagamento(s),"
_cMsg += "	 favor entrar em contato conosco pelo telefone (44) 3523-8565 e/ou e-mail indicado abaixo:</p>"
_cMsg += "<p>Email: financeiro@liguetelecom.com.br</p>"
_cMsg += "<p>Se necess�rio, favor informar abaixo novos contatos para recebimento do faturamento:</p>"
_cMsg += "<p>Nome: </p>"
_cMsg += "<p>Departamento: </p>"
_cMsg += "<p>Contato: </p>"
_cMsg += "<p>Email: </p>"
_cMsg += "<p>Caso j� tenha recebido os devidos documentos (nota e boleto) e tais valores j� estejam em vossa programa��o de pagamento, por favor desconsiderar este comunicado</p>"
_cMsg += "<p>Colocamo-nos � disposi��o para solucionar quaisquer d�vidas.</p>"
return _cMsg


Static Function msg2Inicio()
Local _cMsg := ""
_cMsg += "<p>Prezado cliente sua fatura encontra-se vencida.</p>"
return _cMsg

Static Function msg2Fim()
Local _cMsg := ""
_cMsg += "<p>Efetue o pagamento evite a suspens�o de seu(s) servi�o(s), transcorrido o prazo de 10 (DEZ) dias do vencimento da fatura original, 
_cMsg += " ir� ocorrer a suspens�o do(s) servi�o(s) contratado(s).</p>"
_cMsg += "<p><b>Observa��es: </b></p>"
_cMsg += "<p>Se o pagamento j� foi efetivado desconsidere essa mensagem.</p>"
_cMsg += "<p>Caso n�o tenha recebido os documentos necess�rios para programa��o do(s) pagamento(s),"
_cMsg += "	 favor entrar em contato conosco pelo telefone (44) 3810-0000 e/ou e-mail indicado abaixo:</p>"
_cMsg += "<p>Email: financeiro@liguetelecom.com.br</p>"
return _cMsg

Static Function msg3Fim()
Local _cMsg := ""
_cMsg += "<p><b>SOLICITAMOS, que atrav�s da presente notifica��o quite integralmente suas pend�ncia. 
_cMsg += " Transcorrido o prazo de 10 (DEZ) dias do vencimento da fatura original, ir� ocorrer a suspens�o dos servi�os contratados.</b></p>"
_cMsg += "<p><b>Observa��es: </b></p>"
_cMsg += "<p>Se o pagamento j� foi efetivado desconsidere essa mensagem.</p>"
_cMsg += "<p>Caso n�o tenha recebido os documentos necess�rios para programa��o do(s) pagamento(s),"
_cMsg += "	 favor entrar em contato conosco pelo telefone (44) 3810-0000 e/ou e-mail indicado abaixo:</p>"
_cMsg += "<p>Email: financeiro@liguetelecom.com.br</p>"
return _cMsg

//ATUALIZAR TABELA DE INTERNET E RADUSERGROUP PARA BLOQUEAR CLIENTES
Static Function FIN06B(_pCtr)  
Local _area := getarea()
Local _nCtr := ALLTRIM(_pCtr)
Local _aADA := ADA->(getarea())  
Local _cIdYate := ""

dbselectarea("ADA")
dbsetorder(1)
IF dbseek(xFilial("ADA")+ _nCtr) .and. len(_nCtr) < 7		
	_cIdYate := ADA->ADA_UIDYAT
ENDIF

IF !EMPTY(ALLTRIM(_cIdYate))

	_NCONNSQL  := ADVCONNECTION() //PEGA CONEXAO MSSQL
	_NCONNPTG  := TCLINK("POSTGRES/PostGreLigue","10.0.1.98",7890) //CONECTA AO POSTGRES
	
	_CQUERY := " SELECT * "
	_CQUERY += " FROM integrador.internet i"
	_CQUERY += " WHERE i.cd_cliente = " + _cIdYate
			
	IF SELECT("TRB0")!=0
		TRB0->(DBCLOSEAREA())
	ENDIF
	TCQUERY CHANGEQUERY(_CQUERY) NEW ALIAS "TRB0"
	
	DbSelectArea("TRB0")	
	while !eof()
			IF !EMPTY(TRB0->CD_RADUSERGROUP)
				//ALERT(TRB0->CD_CLIENTE)
				//caixas := {TRB0->CD_CAIXA,TRB0->DS_CAIXA}
				_CQUERY := " UPDATE integrador.internet"
				_CQUERY += " SET in_situacao = 'B'" 
				_CQUERY += " WHERE cd_cliente = " + _cIdYate
				TCSQLEXEC(_CQUERY) 				
			
				_CQUERY := " UPDATE internet.radusergroup"
				_CQUERY += " SET groupname = 'BLOQUEADO'" 
				_CQUERY += " WHERE id = " + CVALTOCHAR(TRB0->CD_RADUSERGROUP)
				TCSQLEXEC(_CQUERY) 
			ENDIF
			//AADD(aItems, CVALTOCHAR(TRB0->CD_CAIXA) + " : " + TRB0->DS_CAIXA)
		dbselectarea("TRB0")
		dbskip()
	enddo
			
	TRB0->(DBCLOSEAREA())	
	TCUNLINK(_NCONNPTG)  //FECHA CONEXAO POSTGRES
	TCSETCONN(_NCONNSQL) //RETORNA CONEXAO MSSQL
		
	U_SaveSE1BLQ()
	
	_MSG := "<p>Clientes Bloqueados</p>"
   	_MSG += "<p>C�digo : " + TSE1->E1_CLIENTE + " Nome : " + TSE1->E1_NOMCLI + " Fatura : " + TSE1->E1_PREFIXO + " " + TSE1->E1_NUM + " "+ TSE1->E1_PARCELA + "</p>"
   	_MSG += "<p>YATE : "+ _cIdYate +"</p>"
   	_MSG += "<p>Vencimento : "+Transform(STOD(TSE1->E1_VENCTO),"@E") +"</p>"
   	_MSG += "<p>Valor : "+Transform(TSE1->E1_VALOR,"@E 9,999,999.99",) +"</p><hr>"  
  		
   	_CMsgBloq += _MSG
ELSE
	_MSG := "<p>Cliente sem c�digo no yate.</p>"
   	_MSG += "<p>C�digo : " + TSE1->E1_CLIENTE + " Nome : " + TSE1->E1_NOMCLI + " Fatura : " + TSE1->E1_PREFIXO + " " + TSE1->E1_NUM + " "+ TSE1->E1_PARCELA + "</p>"
   	_MSG += "<p>Vencimento : "+Transform(STOD(TSE1->E1_VENCTO),"@E") +"</p>"
   	_MSG += "<p>Valor : "+Transform(TSE1->E1_VALOR,"@E 9,999,999.99",) +"</p><hr>" 
	
	_CMsgSYate += _MSG
ENDIF					
							    	
restarea(_aADA)
restarea(_area)
return

//ABRIR CHAMADO TECNICO PARA CANCELAMENTO DO SERVICO
User Function FIN06C(pCliente,pLoja,pOcor,_pAtReti,pCtr,_pMsg)//Paramentro de Ocorrencia: Cancelamento Parcial ou Total   
Local _ch := ""
	aItens := U_LIGTEC08(pCliente,pLoja,pOcor,ALLTRIM(pCtr))
	IF !EMPTY(aItens)
		_ch := U_LIGTEC07(pCliente, pLoja,"100",_pMsg,aItens,_pAtReti,"9",ALLTRIM(pCtr))
		if empty(_ch)
		   	 memowrite("\logerro\ERRO_"+strtran(time(),":","")+".log","ERRO AO TENTAR INCLUIR UMA OS DE RETIRADA "+pCliente+ pLoja+" NA ROTINA LIGFIN06 - FIN06C")													   		
		endif
	ELSE
		U_LIGGEN03("robson.adriano@liguetelecom.com.br","","","Erro na O.S LigFin06","Cliente: " + pCliente + " Loja " + pLoja + " Ctr: " + pCtr,.T.,"")
	ENDIF						
RETURN _ch 


User Function FIN06D(_nCtr)
Local _area := getarea()
Local _aADA := ADA->(getarea())  


dbselectarea("ADA")
dbsetorder(1)
IF dbseek(xFilial("ADA")+ _nCtr)	
	IF ADA->ADA_MSBLQL == '2' .AND. ADA->ADA_UCANCE <> '3'
		RECLOCK("ADA",.F.)
			ADA->ADA_UCANCE := '3'		
			ADA->ADA_UDSCAN := "Contrato cancelado devido a falta de pagamento. Via rotina de retorno banc�rio."	
		MSUNLOCK()
	ENDIF
ENDIF

restarea(_aADA)
restarea(_area)
Return