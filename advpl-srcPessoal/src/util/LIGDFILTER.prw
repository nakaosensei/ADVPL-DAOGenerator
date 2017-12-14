#include 'protheus.ch'
#include 'parmtype.ch'

user function LIGDFILTER()	
return

//Essa função retira a mascara de um CPF ou CNPJ,ex:
//in: 085.533.599-80 out:08553359980
user function LGFTUMSK(cpfcnpj)
	cpfcnpj := StrTran( cpfcnpj, ".", "" ) 
	cpfcnpj := StrTran( cpfcnpj, "-", "" ) 
	cpfcnpj := StrTran( cpfcnpj, "/", "" ) 
	cpfcnpj := StrTran( cpfcnpj, "(", "" ) 
	cpfcnpj := StrTran( cpfcnpj, ")", "" ) 
return cpfcnpj

//Essa funcao converte uma data no formato
// ano/mes/dia para dia/mes/ano.
//in: String da data no formato ano/mes/dia
//out: String da data no formato dia/mes/ano
user function cnvDtAMDtoDMA(strDate)
	split := StrTokArr(ALLTRIM(strDate),"/")	
return split[3]+"/"+split[2]+"/"+split[1]

//A funcao identifica o formato de uma data
//in: string no formato ano/mes/dia ou dia/mes/ano
//Se for ano/mes/dia, retorna AMD, se for dia/mes/ano, retorna DMA
user function idntDtFormat(strDate)
	split := StrTokArr(ALLTRIM(strDate),"/")	
	if split = nil .or. len(split) <> 3
		CONOUT("FORMATO DA DATA "+strDate+" E DESCONHECIDO")
		return "UNKNOW"
	endif	
	if len(ALLTRIM(split[1]))=2
		return "DMA"
	elseif len(ALLTRIM(split[1]))=4
		return "AMD"
	endif
return "UNKNOW"

//Recebe uma data do tipo Date e retorna uma string no formato AnoMesDia, 20170513
user function dateToStr(uDate)
	if VALTYPE(uDate) == "D"
		strDate := DTOS(uDate)
		
		split := StrTokArr(strDate,"/")
		return ALLTRIM(split[3])+ALLTRIM(split[2])+ALLTRIM(split[1])
	endif
return

//Funcao de conversao de uma string para data.
//IN: String de data no formato ano/mes/dia ou dia/mes/ano, ou uma variavel do tipo DATE
//OUT: Data convertida para o tipo DATE
user function strToDate(strDate)
	if VALTYPE(strDate) == "D"
		return strDate
	elseif VALTYPE(strDate) == "C"
		strDate := StrTran( strDate, "-", "/" )  
		format := u_idntDtFormat(strDate)
		if format=="AMD"
			strDate:=u_cnvDtAMDtoDMA(strDate)
		elseif format=="UNKNOW"
			return nil
		endif
		return CTOD(strDate)
	endif	
return strDate

//in: String no formato 04:30, que significa 4 horas e meia
//out: 4.5
user function hourMinuteToNum(strHour)
	if ALLTRIM(strHour)==""
		return 0
	endif
	split := StrTokArr(ALLTRIM(strHour),":")
	out := val(split[1])+(val(split[2])/60)
return out

//Verifica se uma string e numerica
user function strIsNumeric(numberString)
	if(VALTYPE(numberString)=='N')
		return numberString
	endif
	nkArray := StrTokArr(ALLTRIM(numberString),"")
	for i:=1 to len(nkArray)
		if (nkArray[i]<>"0" .AND.nkArray[i]<>"1" .AND. nkArray[i]<>"2" .AND. nkArray[i]<>"3" .AND. nkArray[i]<>"4" .AND. nkArray[i]<>"5" .AND. nkArray[i]<>"6" .AND. nkArray[i]<>"7" .AND. nkArray[i]<>"8" .AND. nkArray[i]<>"9" .AND. nkArray[i]<>"") 
		 	return .F.
		endif		
	next
return .T.

//Funcao avancada de conversao de uma string para numerico
user function LIGVAL(nkStrNum)
	if u_strIsNumeric(ALLTRIM(nkStrNum)) = .F.
		return nil
	endif	
return VAL(ALLTRIM(nkStrNum))