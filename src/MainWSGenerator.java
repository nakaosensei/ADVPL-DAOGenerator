/**
 * Created by Desenvolvedor on 19/07/2017.
 */
public class MainWSGenerator {

    public static void main(String[] args) {
        String in = "WSDATA COBS           AS STRING   \n" +
                "WSDATA CSOLICITACAO   AS STRING   \n"     +
                "WSDATA CPROJETO       AS STRING   \n"     +
                "WSDATA CVERSAO\t      AS STRING  \n"      +
                "WSDATA CTAREFA  \t  AS STRING  \n"        +
                "WSDATA CDATA  \t      AS STRING   \n"     +
                "WSDATA CHRINI \t      AS STRING   \n"     +
                "WSDATA CHRFIM\t      AS STRING  \n"       +
                "WSDATA CRECURSO\t      AS STRING   \n"    +
                "WSDATA CPERCENTOCORR  AS STRING   \n"     +
                "WSDATA CCUSTO         AS STRING  \n"      +
                "WSDATA CTPMOVIMENTAC  AS STRING  \n"      +
                "WSDATA CDTEMISSAO     AS STRING ";
        System.out.println(WebServiceGenerator.removeMasks(in));
        System.out.println(WebServiceGenerator.generatePrintDefault("filial, CCGC, pessoa, nome, fantasia, email, estado, cep, endereco, complemento, bairro, cdMun, munDes, ddd, telefone, dddCel, celular, dataNasc, inscricao, rg, pais, contato, cpfContato, tipo, cdNaturza","afu"));
        System.out.println(WebServiceGenerator.addMasks("CPROJETO,CVERSAO,CTAREFA,CDATA,CHRINI,CHRFIM,CQTDHRS,CRECURSO,CPERCENTOCORR,CCUSTO,COBS,CTPMOVIMENTAC,CDTEMISSAO"));
    }
}
