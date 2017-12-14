/**
 * Created by Desenvolvedor on 17/07/2017.
 */
public class MainDAOGenerator {

    public static void main(String[] args) {
        String campos = "FILIAL,ITEM,NUM,PRODUTO,SITPROD,QUANT,VRUNIT,UVLCHE,VALDESC,VLRITEM,DESC,UMESINI,UMESCOB,UIDAGA,UCTR,UITTROC,UMSG,ACRE,VALACRE,TES,CF,PRCTAB,BASEICM,NUMPV,ITEMPV,TABELA,LOCAL,UM,EMISSAO,DTENTRE,LOTE,SUBLOTE,DTVALID,OPC,VLIMPOR,FCICOD";
        String dateFields = "EMISSAO,DTENTRE,DTVALID";//campos do tipo date
        String descFields = "";//Campos string, para que sejam passados pra maisculo
        String numericFields = "QUANT,VRUNIT,UVLCHE,VALDESC,VLRITEM,DESC,UMESINI,UMESCOB,ACRE,VALACRE,PRCTAB,BASEICM,VLIMPOR";//Campos numericos
        String cpfFields = "";//Campos que precisam ser desmascarados antes de gravar, como de cpf, rg
        String validateFields = "ITEM,NUM,PRODUTO,QUANT,LOCAL,UM";//Campos obrigatorios
        String fkValidateFields = "NUM,PRODUTO,LOCAL";//Campos que se deseja fazer uma busca em outra tabela, por exemplo, item do contrato(ADB) tem codigo do produto, entao e bom fazer uma busca em SB1 para verificar se tal produto existe antes de cadastrar
        String tabela = "SUB";
        String prefixo = "UB";
        System.out.println(DAOGenerator.generateDaoScript(tabela,prefixo,campos,dateFields,descFields,cpfFields,validateFields,numericFields,fkValidateFields));
    }
}