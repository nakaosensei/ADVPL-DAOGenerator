/**
 * Created by Desenvolvedor on 19/07/2017.
 */
public class WebServiceGenerator {

    public static String removeMasks(String in){
      in = in.replace("WSDATA","");
      in = in.replace("AS STRING", "");
      String split[] = in.split("\n");
      String out="";
      for (String s:split){
          out+=s.trim()+",";
      }
      return out;
    };

    public static String addMasks(String in){
        String split[] = in.split(",");
        String out="";
        for (String s:split){
            if(!s.trim().equals("")){
                out+="WSDATA "+s.trim()+" AS STRING\n";
            }
        }
        return out;
    };

    public static String generatePrintDefault(String camposCabecalho,String nomeRotina){
        String split[] = camposCabecalho.split(",");
        String out="\tRpcSetEnv(\"01\",\"LG01\",,,'FRT','Inicializacao',{\"SA1\"})\n" +
                "\t::cOk := \"OK\"\t\t\n" +
                "\tCONOUT(\"ENTROU "+nomeRotina+" DO NAKAO.\"+TIME())\t\n" +
                "\tCONOUT(\"VARIAVEIS QUE CHEGARAM NO CABECALHO:\")\n";
        out+="\tCONOUT(";
        for (String s:split){
            out+="\" "+s+":\""+" + ALLTRIM("+s+") + ";
        }
        out+=")";
        return out;
    }
}
