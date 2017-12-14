#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOTVS.ch'

user function MT097END()

Local cDocto  := PARAMIXB[1] //NÚMERO DA SOLICITAÇÃO
Local nOpc  := PARAMIXB[3] //STATUS DA SOLICITAÇÃO

	if nOpc == 2 .or. nOpc == 3
		u_StatusCONAPRO(cDocto)
		
	endif

return

user function StatusCONAPRO(cDocto)

dbSelectArea("SC7")
dbsetorder(1)
dbGoTop()

if dbseek(xFilial("SC7")+ALLTRIM(cDocto))
	MV_UEmailCot := GETMV("MV_UEMLCOT")
	_data := Dtoc(Date())

	IF  (SC7->C7_CONAPRO = 'L')

		u_enviaEMAIL("Liberação do pedido de compra", "liberado", "liberação")

	ELSEIF  (SC7->C7_CONAPRO = 'B')

		u_enviaEMAIL("Reprovação do pedido de compra", "reprovado", "reprovação")
		WHILE !EOF() .AND. SC7->C7_NUM = ALLTRIM(cDocto)
			if reclock("SC7",.F.)
					SC7->C7_UBLO := 'S'
					msunlock()
				endif
				dbskip()
			ENDDO
		ENDIF
	endif

return

user function enviaEMAIL(string1, string2, string3)

	dbSelectArea("SC1")
	dbsetorder(1)
	dbGoTop()

	if dbseek(xFilial("SC1")+SC7->C7_NUMSC)

		emailC1 := UsrRetMail(C1_USER)

		//Envia e-mail para quem solicitou a compra
		U_LIGGEN03(emailC1,"","",string1, u_msgHTML(string2, string3,USRFULLNAME(SC1->C1_USER)),.T.,"")

		//Envia e-mail para o setor de Compras
		U_LIGGEN03(MV_UEmailCot,"","",string1, u_msgHTML(string2, string3,USRFULLNAME(SC1->C1_USER)),.T.,"")

	endif

return

user function msgHTML(str1, str2,_solic)
	Local _area := getarea()
	Local _ASC7 := SC7->(getarea())
	_cMSG1 := "<p>O pedido de compra nº: <b>" +  SC7->C7_NUM + "</b>, foi " + str1 + " na data : " + _data +  ".</p>"
	_cMSG1 += "<p>Responsável pela " + str2 + ": <b>" + UsrRetName(RetCodUsr()) + ".</b></p>"
	_ped := SC7->C7_NUM
	_sta := SC7->C7_CONAPRO
	dbselectarea("SC7")
	dbsetorder(1)
	dbgotop()
	if dbseek(xFilial()+_ped)
		while !eof() .and. xFilial()+_ped==SC7->C7_FILIAL+SC7->C7_NUM
			if _sta==SC7->C7_CONAPRO
				_cMSG1 += "<p><b>PRODUTO :</b> " + SC7->C7_DESCRI + ".</p>"
				_cMSG1 += "<p><b>QUANTIDADE :</b> " + STR(SC7->C7_QUANT) + ".</p>"     
				_cMSG1 += "<p>OBS : " + SC7->C7_OBS + ".</p>"
				IF  (SC7->C7_CONAPRO = 'L')
					_cMSG1 += "<p><b>PREVISAO ENTREGA :</b> " + DTOC(SC7->C7_DATPRF) + ".</p><BR>"
				ENDIF
			endif
			dbselectarea("SC7")
			dbskip()
		enddo
	endif
	_cMSG1 += "<p>Solicitante:" + _solic + "</p>"
	_cMSG1 += "<p>E-mail enviado automaticamente pelo Microsiga Protheus.</p>"

	restarea(_aSC7)
	restarea(_area)
return _cMSG1

