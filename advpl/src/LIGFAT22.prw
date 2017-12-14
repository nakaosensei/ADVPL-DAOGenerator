#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "topconn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ExportaXML
Exportação XML

@author JOHNNY

@since 20/09/2017
@version 1.0
/*/
user function LIGFAT22()
	Local cArqLocal := ""
	Local cXML      := ""
	Local nHdl      := 0

	Private cPerg := "LIGFAT22A"

	validperg()

	if !pergunte(cPerg,.T.)
		return
	endif

	processa( {|| LIGFAT22() }, "Carregando", "Processando aguarde...", .f.)
return

STATIC FUNCTION LIGFAT22()
	procregua(1000)

	// Busca Caminho de pasta onde sera salvo
	_caminho := ""
	while _caminho == ""
		_caminho := cGetFile('Arquivo','Selecione Pasta',0,'Área de Trabalho',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)
		if _caminho == ""
			Alert("Você deve selecionar uma Pasta para salvar os Registros !")
		endif
	enddo

	cQuery := "	select F2_DOC,F2_SERIE,F2_VALBRUT,A1_PESSOA,A1_CGC,A1_NOME,A1_END,A1_CEP,A1_BAIRRO,A1_EMAIL from "+RetSqlName("SF2")+" SF2"
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA
	cQuery += "	WHERE SF2.D_E_L_E_T_ = ' ' AND F2_FILIAL = 'LT01'
	cQuery += " AND F2_EMISSAO >= '"+ DTOS(MV_PAR03)+ "' AND F2_EMISSAO <= '"+DTOS(MV_PAR04)+"'"
	cQuery += " AND F2_DOC >= '" + MV_PAR01 + "' AND F2_DOC <= '"+MV_PAR02+"'"
	TCQUERY cQuery NEW ALIAS "TEMP"
	dbselectarea("TEMP")

	aSub := {}
	while !eof()

		aAdd(aSub,{F2_DOC,F2_SERIE,F2_VALBRUT,A1_PESSOA,A1_CGC,A1_NOME,A1_END,A1_CEP,A1_BAIRRO,A1_EMAIL})
		incproc("Carregando dados....")
		dbselectarea("TEMP")
		dbskip()

	enddo

	TEMP->(dbclosearea())

	if len(aSub) = 0
		MessageBox("Não existe Registro para esta seleção!","ATENÇÃO",48)
		//alert("Não existe Registro para esta seleção!")
		return
	endif

	For i:=1 to Len(aSub)
		//Nome do Arquivo
		cArqLocal := alltrim(aSub[i,1])+alltrim(aSub[i,2])+".XML"//

		//Cria uma arquivo vazio em disco
		nHdl := Fcreate(_caminho+cArqLocal)

		//...Aqui fica o corpo do XML
		cXML :="<?xml version='1.0' encoding='iso-8859-1'?>"+ Chr(13) + Chr(10)
		cXML += '<nfse>' + Chr(13) + Chr(10)
		cXML += '<identificador>'+alltrim(aSub[i,1])+alltrim(aSub[i,2])+'</identificador>' + Chr(13) + Chr(10)
		cXML += '<nf>'+ Chr(13) + Chr(10)
		cXML += '<valor_total>'+ALLTRIM(STRTRAN(STR(aSub[i,3]),".",","))+'</valor_total>'+ Chr(13) + Chr(10)
		cXML += '<valor_desconto>0,00</valor_desconto>'+ Chr(13) + Chr(10)
		cXML += '<valor_ir>0,00</valor_ir>'+ Chr(13) + Chr(10)
		cXML += '<valor_inss>0,00</valor_inss>'+ Chr(13) + Chr(10)
		cXML += '<valor_contribuicao_social>0,00</valor_contribuicao_social>'+ Chr(13) + Chr(10)
		cXML += '<valor_rps>0,00</valor_rps>'+ Chr(13) + Chr(10)
		cXML += '<valor_pis>0,00</valor_pis>'+ Chr(13) + Chr(10)
		cXML += '<valor_cofins>0,00</valor_cofins>'+ Chr(13) + Chr(10)
		cXML += '<observacao/>'+ Chr(13) + Chr(10)
		cXML += '</nf>'+ Chr(13) + Chr(10)

		cXML += '<prestador>' + Chr(13) + Chr(10)
		cXML += '<cpfcnpj>8757117000126</cpfcnpj>' + Chr(13) + Chr(10)
		cXML += '<cidade>7483</cidade>' + Chr(13) + Chr(10)
		cXML += '</prestador>' + Chr(13) + Chr(10)

		cXML += '<tomador>' + Chr(13) + Chr(10)
		cXML += '<tipo>'+alltrim(aSub[i,4])+'</tipo>' + Chr(13) + Chr(10)
		cXML += '<cpfcnpj>'+ALLTRIM(aSub[i,5])+'</cpfcnpj>' + Chr(13) + Chr(10)
		cXML += '<ie/>' + Chr(13) + Chr(10)
		cXML += '<nome_razao_social>'+ALLTRIM(aSub[i,6])+'</nome_razao_social>'+ Chr(13) + Chr(10)
		cXML += '<sobrenome_nome_fantasia/>'+ Chr(13) + Chr(10)
		cXML += '<logradouro>'+ALLTRIM(aSub[i,7])+'</logradouro>'+ Chr(13) + Chr(10)
		cXML += '<email/>'+ Chr(13) + Chr(10)
		cXML += '<complemento/>'+ Chr(13) + Chr(10)
		cXML += '<ponto_referencia/>'+ Chr(13) + Chr(10)
		cXML += '<bairro>'+ALLTRIM(aSub[i,9])+'</bairro>'+ Chr(13) + Chr(10)
		cXML += '<cidade>7483</cidade>'+ Chr(13) + Chr(10)
		cXML += '<cep>'+ALLTRIM(aSub[i,8])+'</cep>'+ Chr(13) + Chr(10)
		cXML += '<ddd_fone_comercial/>'+ Chr(13) + Chr(10)
		cXML += '<fone_comercial/>'+ Chr(13) + Chr(10)
		cXML += '<ddd_fone_residencial/>'+ Chr(13) + Chr(10)
		cXML += '<fone_residencial/>'+ Chr(13) + Chr(10)
		cXML += '<ddd_fax/>'+ Chr(13) + Chr(10)
		cXML += '<fone_fax/>'+ Chr(13) + Chr(10)
		cXML += '</tomador>'+ Chr(13) + Chr(10)

		cXML += '<itens>'+ Chr(13) + Chr(10)
		cXML += '<lista>'+ Chr(13) + Chr(10)
		cXML += '<codigo_local_prestacao_servico>7483</codigo_local_prestacao_servico>'+ Chr(13) + Chr(10)
		cXML += '<codigo_item_lista_servico>1401</codigo_item_lista_servico>'+ Chr(13) + Chr(10)
		cXML += '<descritivo>SERVICOS TECNICOS, MANUTENÇÃO EQUIP.TELEF. COMP. E PERIFERICOS</descritivo>'+ Chr(13) + Chr(10)
		cXML += '<aliquota_item_lista_servico>2,79</aliquota_item_lista_servico>'+ Chr(13) + Chr(10)
		cXML += '<situacao_tributaria>00</situacao_tributaria>'+ Chr(13) + Chr(10)
		cXML += '<valor_tributavel>'+ALLTRIM(STRTRAN(STR(aSub[i,3]),".",","))+'</valor_tributavel>'+ Chr(13) + Chr(10)
		cXML += '<valor_deducao>0,00</valor_deducao>'+ Chr(13) + Chr(10)
		cXML += '<valor_issrf>0,00</valor_issrf>'+ Chr(13) + Chr(10)
		cXML += '<tributa_municipio_prestador>S</tributa_municipio_prestador>'+ Chr(13) + Chr(10)
		cXML += '<unidade_codigo/>'+ Chr(13) + Chr(10)
		cXML += '<unidade_quantidade/>'+ Chr(13) + Chr(10)
		cXML += '<unidade_valor_unitario/>'+ Chr(13) + Chr(10)
		cXML += '</lista>'+ Chr(13) + Chr(10)
		cXML += '</itens>'+ Chr(13) + Chr(10)
		cXML += '<produtos></produtos>'+ Chr(13) + Chr(10)
		cXML += '</nfse>'

		//Função escreve no arquivo TXT.
		FWRITE(nHdl,cXML)
		//Fecha o arquivo em disco
		FCLOSE(nHdl)
	next
return

STATIC FUNCTION VALIDPERG
	_SALIAS := ALIAS()
	AREGS := {}

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	cPerg := PADR(cPerg,10)

	//GRUPO/ORDEM/PERGUNTA/PERSPA/PERENG/VARIAVEL/TIPO/TAMANHO/DECIMAL/PRESEL/GSC/VALID/VAR01/DEF01/DEFSPA1/DEFENG1/CNT01/VAR02/DEF02/DEFSPA2/DEFENG2/CNT02/VAR03/DEF03/DEFSPA3/DEFENG3/CNT03/VAR04/DEF04/DEFSPA4/DEFENG4/CNT04/VAR05/DEF05/DEFSPA5/DEFENG5/CNT05/F3/GRPSXG
	AADD(AREGS,{cPerg,"01","NFSE DE      ?","","","MV_CH1","C",9,0,0, "G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"02","NFSE ATE     ?","","","MV_CH2","C",9,0,0, "G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"03","EMISSÃO DE ?             ","","","MV_CH3","D",10,0,0, "G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(AREGS,{cPerg,"04","EMISSÃO ATE ?             ","","","MV_CH4","D",10,0,0, "G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	FOR I:=1 TO LEN(AREGS)
		IF !DBSEEK(CPERG+AREGS[I,2])
			RECLOCK("SX1",.T.)
			FOR J:=1 TO FCOUNT()
				IF J <= LEN(AREGS[I])
					FIELDPUT(J,AREGS[I,J])
				ENDIF
			NEXT
			MSUNLOCK()
		ENDIF
	NEXT
	DBSELECTAREA(_SALIAS)
RETURN
