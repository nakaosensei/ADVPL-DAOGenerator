import java.util.ArrayList;

/**
 * Created by Desenvolvedor on 17/07/2017.
 */
public class DAOGenerator {


    public static String generateDaoScript(String tabela,String prefixo,String campos,String dateFields,String descFields,String cpfFields,String validateFields,String numericFields,String fkValidateFields){
        String out = generateCadastroScript(tabela,prefixo,campos,dateFields,descFields,cpfFields,validateFields,numericFields)+"\n\n";
        out +=generateAlterScript(tabela,prefixo,campos,dateFields,descFields,cpfFields,validateFields,numericFields)+"\n\n";
        String numFields[] = numericFields.split(",");
        String allValidateFields[] = validateFields.split(",");
        String numValidateFields[] = getEqualFieldsFromArrays(numFields,allValidateFields);
        String strValidateFields[] = removeFrom(allValidateFields,numFields);
        String fkVldtFields[] = fkValidateFields.split(",");
        out+=generateValidateScript(tabela,strValidateFields,numValidateFields,fkVldtFields);
        return out;
    };

    public static String generateCadastroScript(String tabela,String prefixo,String campos,String dateFields,String descFields,String cpfFields,String validateFields,String numericFields){
        String out = "";
        String inSplit[] = campos.split(",");
        String inSplitVariables[] = addUOnStartToFields(campos.split(","));
        String inSplitDate[] =addUOnStartToFields(dateFields.split(","));
        String inSplitDesc[] = addUOnStartToFields(descFields.split(","));
        String inSplitCpf[] = addUOnStartToFields(cpfFields.split(","));
        String inSplitNum[] = addUOnStartToFields(numericFields.split(","));
        String inSplitNonNumericNonDate[] = addUOnStartToFields(campos.split(","));
        String inSplitNonNumeric[] = addUOnStartToFields(campos.split(","));
        String inSplitValidate[] = addUOnStartToFields(validateFields.split(","));

        inSplit = trimAllFromSource(inSplit);
        inSplitDate = trimAllFromSource(inSplitDate);
        inSplitDesc = trimAllFromSource(inSplitDesc);
        inSplitCpf = trimAllFromSource(inSplitCpf);
        inSplitNum = trimAllFromSource(inSplitNum);
        inSplitValidate = trimAllFromSource(inSplitValidate);
        inSplitVariables = trimAllFromSource(inSplitVariables);
        inSplitNonNumericNonDate = trimAllFromSource(inSplitNonNumericNonDate);

        inSplitNonNumericNonDate = removeFrom(inSplitNonNumericNonDate,inSplitNum);
        inSplitNonNumericNonDate = removeFrom(inSplitNonNumericNonDate,inSplitDate);
        inSplitNonNumeric = removeFrom(inSplitNonNumeric,inSplitNum);

        out+="#include 'protheus.ch'\n#include 'parmtype.ch'\n\n";
        out+="//ATENCAO: ESSA TABELA CONTEM OS SEGUINTES CAMPOS NUMERICOS: "+numericFields+", esses campos devem ser passados como tipo numerico ou nulo\n//Para facilitar a sua vida como programador, troque a ordem dos parametros da funcao, coloque todos os parametros que voce vai usar na sua atividade primeiro, deixando os campos numericos para o final, depois dos numericos deixe na assinatura da funcao todos os campos que voce nao ira usar agora.\n//Tome cuidado com os campos de MEMO, voce tera que identificar manualmente qual o campo de memo adequado para usar a funcao MSMM.\n";
        out+="user function D"+tabela+"Cad("+toString(inSplitVariables)+")\n";
        out+=eraseNullsFromStrings(inSplitNonNumeric)+"\n";
        out+=applyTrim(inSplitNonNumeric)+"\n";
        out+=applyUnmask(inSplitCpf)+"\n";
        out+=applyUpper(inSplitDesc)+"\n";
        out+="\t"+"exceptionList := {}\n";
        out+="\t"+"exceptionList := u_D"+tabela+"Vld("+toString(inSplitValidate)+")\n";
        out+="\tif len(exceptionList)>0\n" +
                "\t\tCONOUT(\"PROBLEMA DE VALIDACAO NA TABELA "+tabela+"\")\n" +
                "\t\treturn \"0\"\n" +
                "\tendif\n\n";
        out+=applyDateConvert(inSplitDate)+"\n";
        out+=applyBackToNull(inSplitNonNumericNonDate)+"\n";
        out+="\tDBSELECTAREA(\""+tabela+"\")\n";
        out+="\tRECLOCK(\""+tabela+"\",.T.)\n";
        for(int i = 0;i<inSplit.length;i++){
            out+="\t"+tabela+"->"+prefixo+"_"+inSplit[i]+" := "+inSplitVariables[i]+"\n";
        }
        out+="\tMSUNLOCK()\n";
        out+="return ";
        return out;
    };



    public static String generateValidateScript(String tabela,String camposString[],String camposNumericos[],String camposChaveEstrangeira[]){
        String out="//Funcao de validacao, amigo programador,tome os seguintes cuidados se existirem campos de chave estrangeira a serem validados:\n//1)Substitua os ALIAS pelo alias correto nos getareas\n//2)Nos DBSELECTAREA, troque os CHANGE e CHANGEAlias pela informacao correta\n";
        camposString = addUOnStartToFields(camposString);
        camposNumericos = addUOnStartToFields(camposNumericos);
        out+="user function D"+tabela+"Vld("+toString(camposString)+","+toString(camposNumericos)+")\n";
        out+="\tLocal _area := getarea()\n";
        out+=generateAreaInstanceScript(camposChaveEstrangeira);
        out+="\texceptionList := {}\n";
        out+=applyTrim(camposString)+"\n";
        out+=applyAddExceptionListStringCase(camposString)+"\n";
        out+=applyAddExceptionListNumericCase(camposNumericos)+"\n";
        out+=applyAddExceptionFK(camposChaveEstrangeira)+"\n";
        out+="\tif(len(exceptionList)>0)\n" +
                "\t\tCONOUT(\"PROBLEMA DE VALIDACAO NA TABELA "+tabela+", CAMPOS:\")\n" +
                "\t\tfor i:=1 to len(exceptionList)\n" +
                "\t\t \tCONOUT(exceptionList[i])\n" +
                "\t\tnext        \n" +
                "\tendif\t\n";
        out+=generateRestAreaScript(camposChaveEstrangeira)+"\n";
        out+="\trestArea(_area)\n";
        out+="return exceptionList";
        return out;
    };

    public static String generateAlterScript(String tabela,String prefixo,String campos,String dateFields,String descFields,String cpfFields, String validateFields, String numericFields){
        String out = "";
        String inSplit[] = campos.split(",");
        String inSplitVariables[] = addUOnStartToFields(campos.split(","));
        String inSplitDate[] =addUOnStartToFields(dateFields.split(","));
        String inSplitDesc[] = addUOnStartToFields(descFields.split(","));
        String inSplitCpf[] = addUOnStartToFields(cpfFields.split(","));
        String inSplitNum[] = addUOnStartToFields(numericFields.split(","));
        String inSplitNonNumericNonDate[] = addUOnStartToFields(campos.split(","));
        String inSplitNonNumeric[] = addUOnStartToFields(campos.split(","));
        String inSplitValidate[] = addUOnStartToFields(validateFields.split(","));

        inSplit = trimAllFromSource(inSplit);
        inSplitDate = trimAllFromSource(inSplitDate);
        inSplitDesc = trimAllFromSource(inSplitDesc);
        inSplitCpf = trimAllFromSource(inSplitCpf);
        inSplitNum = trimAllFromSource(inSplitNum);
        inSplitValidate = trimAllFromSource(inSplitValidate);
        inSplitVariables = trimAllFromSource(inSplitVariables);
        inSplitNonNumericNonDate = trimAllFromSource(inSplitNonNumericNonDate);
        inSplitNonNumericNonDate = removeFrom(inSplitNonNumericNonDate,inSplitNum);
        inSplitNonNumericNonDate = removeFrom(inSplitNonNumericNonDate,inSplitDate);
        inSplitNonNumeric = removeFrom(inSplitNonNumeric,inSplitNum);

        out+="//ATENCAO: ESSA TABELA CONTEM OS SEGUINTES CAMPOS NUMERICOS: "+numericFields+", esses campos devem ser passados como tipo numerico ou nulo\n//Para facilitar a sua vida como programador, troque a ordem dos parametros da funcao, coloque todos os parametros que voce vai usar na sua atividade primeiro, deixando os campos numericos para o final, depois dos numericos deixe na assinatura da funcao todos os campos que voce nao ira usar agora.\n//Tome cuidado com os campos de MEMO, voce tera que identificar manualmente qual o campo de memo adequado para usar a funcao MSMM, voce tambem tera que adicionar a ordem e chave de busca no dbSeek.\n";
        out+="user function D"+tabela+"Alter("+toString(inSplitVariables)+")\n";
        out+=eraseNullsFromStrings(inSplitNonNumeric)+"\n";
        out+=applyTrim(inSplitNonNumeric)+"\n";
        out+=applyUnmask(inSplitCpf)+"\n";
        out+=applyUpper(inSplitDesc)+"\n";
        out+="\t"+"exceptionList := {}\n";
        out+="\t"+"exceptionList := u_D"+tabela+"Vld("+toString(inSplitValidate)+")\n";
        out+="\tif len(exceptionList)>0\n" +
                "\t\tCONOUT(\"PROBLEMA DE VALIDACAO NA TABELA "+tabela+"\")\n" +
                "\t\treturn \"0\"\n" +
                "\tendif\n\n";
        out+=applyDateConvert(inSplitDate)+"\n";
        out+=applyBackToNull(inSplitNonNumericNonDate)+"\n";
        out+="\tDBSELECTAREA(\""+tabela+"\")\n";
        out+="\tDBSETORDER(INSIRA_MANUALMENTE)\n";
        out+="\tIF DBSEEK(INSIRA_MANUALMENTE)\n";
        out+="\t\tRECLOCK(\""+tabela+"\",.F.)\n";
        for(int i = 0;i<inSplit.length;i++){
            out+="\t\t"+tabela+"->"+prefixo+"_"+inSplit[i]+" := "+inSplitVariables[i]+"\n";
        }
        out+="\t\tMSUNLOCK()\n";
        out+="\tendif\n";
        out+="return ";
        return out;
    }

    public static String eraseNullsFromStrings(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\tif("+s+" = nil, \"\", "+s+")\n";
            }
        }
        return out;
    }

    public static String eraseNullsFromNums(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\tif("+s+" = nil, 0, "+s+")\n";
            }
        }
        return out;
    }

    public static String convertNumericsToString(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := if(VALTYPE("+s+") == \"N\", CVALTOCHAR("+s+"), "+s+")\n";
            }
        }
        return out;
    }

    public static String applyTrim(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := ALLTRIM("+s+")\n";
            }
        }
        return out;
    }

    public static String applyUpper(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := UPPER("+s+")\n";
            }
        }
        return out;
    }

    public static String applyUnmask(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := u_LGFTUMSK("+s+") //Remove . - / ( ) , funcao no LIGDFILTER.prw\n";
            }
        }
        return out;
    }

    public static String applyDateConvert(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := u_strToDate("+s+") //Funcao de conversao avancada no LIGDFILTER.prw\n";
            }
        }
        return out;
    }


    public static String applyIntConvert(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := if( "+s+" <> \"\" , VAL("+s+"), 0 )\n";
            }
        }
        return out;
    }

    public static String applyAddExceptionListStringCase(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+"if(("+s+" = nil .or. "+s+"==\"\"), aAdd(exceptionList,\""+s+"\"), .F.)\n";
            }
        }
        return out;
    }

    public static String applyAddExceptionListNumericCase(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+"if(("+s+" = nil), aAdd(exceptionList,\""+s+"\"), .F.)\n";
            }
        }
        return out;
    }

    public static String generateRestAreaScript(String campos[]){
        String out = "";
        for(String s:campos){
            if(!s.equals("")){
                out+="\trestArea(_ar"+s+")\n";
            }
        }
        return out;
    }

    public static String applyAddExceptionFK(String campos[]){
        String out="";
        for(String s:campos)
            if(!s.equals("")){{
                out+="\tDBSELECTAREA(CHANGEAlias"+s+")\n";
                out+="\tDBSETORDER(CHANGEME)\n";
                out+="\tif ( dbSeek(CHANGEME) = .F.)\n";
                out+="\t\t"+"aAdd(exceptionList,\" O seguinte campo nao foi encontrado na tabela dona da chave estrangeira, campo: "+s+"\", .F.)\n";
                out+="\tendif\n";
            }
        }
        return out;
    }



    public static String applyBackToNull(String campos[]){
        String out="";
        for(String s:campos){
            if(!s.equals("")){
                out+="\t"+s+" := if("+s+" == \"\", nil, "+s+")\n";
            }
        }
        return out;
    }

    private static String[] trimAllFromSource(String campos[]){
        String out[] = new String[campos.length];
        for(int i = 0;i<campos.length;i++){
            out[i]=campos[i].trim();
        }
        return out;
    }

    private static String[] getEqualFieldsFromArrays(String v1[],String v2[]){
        ArrayList<String> out = new ArrayList<String>();
        for(String s1:v1){
            for(String s2:v2){
                if(s1.equals(s2)){
                    out.add(s1);
                }
            }
        }
        return out.toArray(new String[out.size()]);
    }

    private static String[] removeFrom(String v1[],String v2[]){
        for(int i = 0;i<=v1.length-1;i++){
            for(String s2:v2){
                if(v1[i].equals(s2)){
                    v1[i] = "";
                }
            }
        }
        ArrayList<String> out = new ArrayList<>();
        for(String s:v1){
            if(!s.equals("")){
                out.add(s);
            }
        }
        return out.toArray(new String[out.size()]);
    }

    private static String[] addUOnStartToFields(String v1[]){
        for(int i = 0;i<v1.length;i++){
            if(!v1[i].trim().equals("")){
                v1[i] = "U"+v1[i];
            }
        }
        return v1;
    }

    public static String generateAreaInstanceScript(String[] array){
        String out = "";
        for(String s:array){
            out+="\tLocal _ar"+s+" := getarea(ALIAS"+s+")\n";
        }
        return out;
    };

    public static String toString(String v1[]){
        String out="";
        for(int i = 0;i<v1.length;i++){
            if(i==v1.length-1){
                out+=v1[i];
            }else{
                out+=v1[i]+",";
            }
        }
        return out;
    }
}
