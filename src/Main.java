import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        String in = "Group Ligue\n" +
                "   Version=7.0\n" +
                "   VSSDB=\n" +
                "   HasProperties=1\n" +
                "   Properties\n" +
                "      BeforeApply=\n" +
                "      AfterApply=\n" +
                "      Icon=\n" +
                "      ID=\n" +
                "      Version=\n" +
                "      PalmName=\n" +
                "      OutPut=\n" +
                "   End\n" +
                "   ProjectsCount=9\n" +
                "   Project Genericos\n" +
                "      FoldersCount=5\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Fontes\n" +
                "         FilesCount=21\n" +
                "         File \\TOTVS11\\my projects\\LIGCAD02.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAD01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN02.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGVAL01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\ZNOACENT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN03.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\IMPAA3.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN07.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN08.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN09.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN04.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN05.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN06.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN10.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN12.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCSA1.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LGFTUMSK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGITOSVLD.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LGITEMOSVLD.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGGEN13.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder PE\n" +
                "         VSSPath=Definições\n" +
                "         FilesCount=3\n" +
                "         File \\TOTVS11\\my projects\\MA030TOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MA020TDOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\M030INC.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=0\n" +
                "      End\n" +
                "      Folder Model\n" +
                "         VSSPath=Nova Pasta4\n" +
                "         FilesCount=5\n" +
                "         File \\TOTVS11\\my projects\\AGASA1_MVC.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AGBSA1_MVC.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AB6AB7_MVC.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AB9_MVC.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AB6AB7A_MVC.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder ws\n" +
                "         VSSPath=Nova Pasta5\n" +
                "         FilesCount=2\n" +
                "         File \\TOTVS11\\my projects\\LIGWS002.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGWS001.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "   End\n" +
                "   Project Faturamento\n" +
                "      FoldersCount=4\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=17\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT02.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT03.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT04.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT05.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT06.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT07.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT09.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT10.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT12.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT14.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\BIRT2.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\CADSZ8.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT16.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT17.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT20.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT22.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=5\n" +
                "         File \\TOTVS11\\my projects\\MS520DEL.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MS520VLD.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\FT400TOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\FT400MNU.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\M460FIM.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=6\n" +
                "         File \\TOTVS11\\my projects\\UFATR030.PRX\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT08.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT11.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT13.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT15.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFAT18.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder NFSe\n" +
                "         VSSPath=Nova Pasta4\n" +
                "         FilesCount=5\n" +
                "         File \\TOTVS11\\my projects\\NFSe\\NFSEXml001.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\NFSe\\NFSEXml002.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\NFSe\\NFSEXml003.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\NFSe\\NFSEXml102.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\NFSe\\nfsexmlenv.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "   End\n" +
                "   Project Financeiro\n" +
                "      FoldersCount=3\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=12\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN02.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN03.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN05.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN06.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN09.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN10.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN13.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN14.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN15.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN20.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN17.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=7\n" +
                "         File \\TOTVS11\\my projects\\FA070POS.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\FA040DEL.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\F200VAR.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\FI040ROT.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\F200IMP.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\M040SE1.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\M4601DUP.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=5\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN04.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN07.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN08.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN11.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIN12.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "   End\n" +
                "   Project Call Center\n" +
                "      FoldersCount=3\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=13\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL02.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\mBrwADA.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL04.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\mBrwADA2.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL05.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL06.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\mBrwADA3.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL08.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGNKUT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGATOSW.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL09.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL10.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=9\n" +
                "         File \\TOTVS11\\my projects\\TMKVPED.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TK271BOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TMKOUT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TMKVOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TK271FCPY.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TMKBARLA.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TK271ROTM.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TK271FIL.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TK271ABR.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=1\n" +
                "         File \\TOTVS11\\my projects\\LIGCAL03.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "   End\n" +
                "   Project Field Service\n" +
                "      FoldersCount=3\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=15\n" +
                "         File \\TOTVS11\\my projects\\AT450GRV.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TK271BOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TC450ROT.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT450BUT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT300GRV.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT310GRV.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT460BUT.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TC450COR.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\TC450LEG.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT300FIL.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT450TOK.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11TESTE\\my projects\\TK271ROTM.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT460GRV.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT300BUT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AT450LOK.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=20\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC02.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC01.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC04.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC05.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC06.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC07.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC08.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC09.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC10.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC11.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC12.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC14.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC17.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC18.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AB9TRCDAT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AB9TRCDCL.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\vldAB9Atd.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\FILTRAAA7.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGOSDES.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGOSOBS.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=2\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC03.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGTEC15.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "   End\n" +
                "   Project Compras\n" +
                "      FoldersCount=3\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=13\n" +
                "         File \\TOTVS11\\my projects\\SD1100I.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT110CFM.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT110COR.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT110LEG.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT097END.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\M130FIL.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MSC1110D.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT110ALT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT120ALT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT120LEG.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT120COR.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MT120BRW.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\AVALCOT.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=6\n" +
                "         File \\TOTVS11\\MY PROJECTS\\ALT_SF1.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCOM01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGCOM02.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\IMPIRPF.CH\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MATA097.CH\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MATA097.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=1\n" +
                "         File \\TOTVS11\\my projects\\Umatr110.prx\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "   End\n" +
                "   Project Fiscal\n" +
                "      FoldersCount=3\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=2\n" +
                "         File \\TOTVS11\\my projects\\GeraSFX.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\LIGFIS01.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=1\n" +
                "         File \\TOTVS11\\my projects\\CV115MUN.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=0\n" +
                "      End\n" +
                "   End\n" +
                "   Project Sped\n" +
                "      FoldersCount=3\n" +
                "      Folder Fontes\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=3\n" +
                "         File \\TOTVS11\\my projects\\nfesefaz.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\danfeiii.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\danfeii.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=0\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=0\n" +
                "      End\n" +
                "   End\n" +
                "   Project Estoque/Custos\n" +
                "      FoldersCount=3\n" +
                "      Folder PE\n" +
                "         VSSPath=Nova Pasta1\n" +
                "         FilesCount=3\n" +
                "         File \\TOTVS11\\my projects\\MA261IN.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\MA261D3.prw\n" +
                "             Type=T\n" +
                "         End\n" +
                "         File \\TOTVS11\\my projects\\ma261cpo.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Relatorios\n" +
                "         VSSPath=Nova Pasta2\n" +
                "         FilesCount=1\n" +
                "         File \\TOTVS11\\my projects\\LIGEST01.PRW\n" +
                "             Type=T\n" +
                "         End\n" +
                "      End\n" +
                "      Folder Rotinas\n" +
                "         VSSPath=Nova Pasta3\n" +
                "         FilesCount=0\n" +
                "      End\n" +
                "   End\n" +
                "End\n";

        String in2 = "LIGFAT05.prw\n" +
                "LIGFAT11.prw\n" +
                "LIGFAT04.PRW\n" +
                "LIGFAT12.prw\n" +
                "LIGFAT03.PRW\n" +
                "LIGFAT13.PRW\n" +
                "LIGFAT02.PRW\n" +
                "LIGFAT14.PRW\n" +
                "LIGFAT01.PRW\n" +
                "LIGFAT15.prw\n" +
                "LIGEST01.PRW\n" +
                "LIGFAT16.PRW\n" +
                "LIGFAT17.prw\n" +
                "LIGDFILTER.prw\n" +
                "LIGFAT18.PRW\n" +
                "LIGCSA1.PRW\n" +
                "LIGFAT20.PRW\n" +
                "LIGFAT22.prw\n" +
                "LIGCOM02.PRW\n" +
                "LIGFIN01.PRW\n" +
                "LIGCOM01.PRW\n" +
                "LIGFIN02.PRW\n" +
                "LIGFIN03.PRW\n" +
                "LIGCAL10.PRW\n" +
                "LIGFIN04.PRW\n" +
                "LIGCAL09.PRW\n" +
                "LIGFIN05.PRW\n" +
                "LIGCAL08.PRW\n" +
                "LIGFIN06.prw\n" +
                "LIGCAL06.prw\n" +
                "LIGFIN07.prw\n" +
                "LIGCAL05.prw\n" +
                "LIGFIN08.prw\n" +
                "LIGCAL04.prw\n" +
                "LIGFIN09.prw\n" +
                "LIGFIN10.prw\n" +
                "LIGCAL03.PRW\n" +
                "LIGCAL02_ALTERADO.PRW\n" +
                "ligfin111.PRW\n" +
                "LIGCAL02.PRW\n" +
                "LIGFIN12.prw\n" +
                "LIGCAL01.PRW\n" +
                "LIGFIN13.PRW\n" +
                "LIGCAD02.PRW\n" +
                "LIGFIN14.PRW\n" +
                "LIGFIN15.PRW\n" +
                "LIGFIN17.prw\n" +
                "LIGFIN20.prw\n" +
                "LIGFIS01.prw\n" +
                "LIGFLD01.prw\n" +
                "LIGCAD01.PRW\n" +
                "LIGFAT10.prw\n" +
                "LIGATOSW.PRW\n" +
                "LIGGEN02.PRW\n" +
                "LGSX3UT.prw\n" +
                "LIGGEN03.PRW\n" +
                "LIGGEN04.prw\n" +
                "LIGGEN05.prw\n" +
                "LGITEMOSVLD.prw\n" +
                "LIGGEN06.prw\n" +
                "LIGGEN07.prw\n" +
                "LIGGEN08.prw\n" +
                "LGFTUMSK.PRW\n" +
                "LIGGEN09.prw\n" +
                "LIGGEN10.prw\n" +
                "LGDAOSUB.prw\n" +
                "LIGGEN12.prw\n" +
                "LGDAOSUA.prw\n" +
                "LIGGEN13.prw\n" +
                "LGDAOSU5.prw\n" +
                "LIGITOSVLD.prw\n" +
                "LGDAOSD3.prw\n" +
                "LIGNKUT.PRW\n" +
                "LIGOSDES.prw\n" +
                "LGDAOSA1.prw\n" +
                "LIGOSOBS.prw\n" +
                "LGDAOAGB.prw\n" +
                "LIGTEC01.prw\n" +
                "LGDAOAGA.prw\n" +
                "LIGTEC02.prw\n" +
                "LGDAOAFU.prw\n" +
                "LIGTEC03.prw\n" +
                "LGDAOAC8.prw\n" +
                "LIGTEC04.PRW\n" +
                "LIGTEC05.prw\n" +
                "LIGTEC06.PRW\n" +
                "LGDAOABC.prw\n" +
                "LIGTEC07.prw\n" +
                "LGDAOAB9.prw\n" +
                "LIGTEC08.prw\n" +
                "LIGFAT06.prw\n" +
                "LIGTEC09.prw\n" +
                "IMPAA3.prw\n" +
                "LIGTEC10.prw\n" +
                "LIGFAT09.prw\n" +
                "LIGTEC11.prw\n" +
                "LIGFAT07.prw\n" +
                "LIGTEC12.prw\n" +
                "getNomeSolic.PRW\n" +
                "LIGTEC14.prw\n" +
                "GeraSFX.prw\n" +
                "LIGTEC15.prw\n" +
                "FT400TOK.PRW\n" +
                "LIGTEC17.PRW\n" +
                "FT400MNU.PRW\n" +
                "LIGTEC18.PRW\n" +
                "LIGGEN01.PRW\n" +
                "LIGVAL01.PRW\n" +
                "FILTRAAA7.PRW\n" +
                "LIGVCP.PRW\n" +
                "LIGWS001.PRW\n" +
                "LIGWS001VERSAOTESTE.PRW\n" +
                "FI040ROT.prw\n" +
                "LIGWS002.PRW\n" +
                "LIGWS003.prw\n" +
                "LIGWS005.prw\n" +
                "LIGWS006.prw\n" +
                "LIGWS007.prw\n" +
                "LIGWS010.prw\n" +
                "FA070POS.PRW\n" +
                "M030INC.PRW\n" +
                "M040SE1.prw\n" +
                "FA040GRV.PRW\n" +
                "M130FIL.PRW\n" +
                "FA040DEL.PRW\n" +
                "M4601DUP.prw\n" +
                "M460FIM.prw\n" +
                "MA020TDOK.PRW\n" +
                "F200VAR.prw\n" +
                "MA030TOK.PRW\n" +
                "ma261cpo.PRW\n" +
                "MA261D3.prw\n" +
                "MA261IN.prw\n" +
                "LIGFAT08.prw\n" +
                "MATA097.PRW\n" +
                "F200IMP.prw\n" +
                "mBrwADA.prw\n" +
                "mBrwADA2.prw\n" +
                "danfeiii.prw\n" +
                "mBrwADA3.prw\n" +
                "danfeii.prw\n" +
                "MS520DEL.PRW\n" +
                "MS520VLD.PRW\n" +
                "MSC1110D.PRW\n" +
                "MT097COR.PRW\n" +
                "CV115MUN.prw\n" +
                "MT097END.PRW\n" +
                "MT097LEG.PRW\n" +
                "CADSZA.prw\n" +
                "MT110ALT.PRW\n" +
                "CADSZ8.prw\n" +
                "MT110CFM.PRW\n" +
                "BIRT2.PRW\n" +
                "MT110COR.prw\n" +
                "MT110GRV.prw\n" +
                "AVALCOT.PRW\n" +
                "MT110LEG.prw\n" +
                "AT460GRV.PRW\n" +
                "MT120ALT.PRW\n" +
                "MT120BRW.PRW\n" +
                "AT460BUT.prw\n" +
                "MT120COR.PRW\n" +
                "AT450TOK.PRW\n" +
                "MT120LEG.PRW\n" +
                "AT450OKD.prw\n" +
                "vldAB9Atd.PRW\n" +
                "AT450GRV.PRW\n" +
                "nfesefaz.prw\n" +
                "AT450BUT.PRW\n" +
                "NFSEXml001.prw\n" +
                "NFSEXml002.prw\n" +
                "NFSEXml003.PRW\n" +
                "NFSEXml102.PRW\n" +
                "nfsexmlenv.prw\n" +
                "AT310GRV.prw\n" +
                "AT300GRV.prw\n" +
                "AT300FIL.prw\n" +
                "AT300BUT.PRW\n" +
                "SD1100I.PRW\n" +
                "Alt_Sf1.PRW\n" +
                "SF2460I.PRW\n" +
                "SZ8ROBSON.PRW\n" +
                "TC450COR.prw\n" +
                "TC450LEG.prw\n" +
                "ajustSFX.prw\n" +
                "TC450ROT.prw\n" +
                "TESTED01.PRW\n" +
                "AGBSA1_MVC.prw\n" +
                "TESTED02.PRW\n" +
                "AGASA1_MVC.prw\n" +
                "TK271ABR.PRW\n" +
                "AB9_MVC.prw\n" +
                "TK271BOK.PRW\n" +
                "TK271FCPY.PRW\n" +
                "AB9TRCDCL.PRW\n" +
                "TK271FIL.PRW\n" +
                "AB9TRCDAT.PRW\n" +
                "TK271ROTM.prw\n" +
                "AB6AB7_MVC.PRW\n" +
                "TMKBARLA.prw\n" +
                "AB6AB7A_MVC.PRW\n" +
                "TMKOUT.PRW\n" +
                "vldSB1.prw\n" +
                "TMKVOK.PRW\n" +
                "LIGFIN11.prw\n" +
                "TMKVPED.PRW\n" +
                "ZNOACENT.PRW";

        List<String> array1 = getFilterProjetFileTotvsStudio(in);
        List<String> array2 = new ArrayList<>();

        for(String s:array1){
            //System.out.println(s);
        }
        for(String s:in2.split("\n")){
            //System.out.println(s);
            if(!array1.contains(s.trim())){
                array2.add(s.trim());
            }
        }
        Collections.sort(array2);
        List<String> array3 = generateProjectScript(array2);
        for(String s:array2){
           System.out.println(s);
        }
        for(String s:array3){
            System.out.println(s);
        }
    }

    public static List<String> getFilterProjetFileTotvsStudio(String in){
        String split[]=in.split("\n");
        List<String> array = new ArrayList<>();
        String tmp = "";
        for(String s:split){
            if(s.contains("File \\")){
                tmp = s.replace(" File \\TOTVS11\\my projects\\","");
                array.add(tmp.trim());
            }
        }
        return array;
    }

    public static List<String> generateProjectScript(List<String> in){
        List<String> out = new ArrayList<>();
        String tmp = "";
        for(String s:in){
            tmp = "File \\TOTVS11\\my projects\\"+s;
            tmp = tmp+"\n             Type=T\n         End";
            out.add(tmp);
        }
        return out;
    }
}
