*********************************************************************
****  Sistema......: SCF-Sistema de Controle Financeiro          ****
****  Versao.......: 4.0                                         ****
****  Programa.....: MFM099.PRG                                  ****
****  Finalidade...: Menu de Utilitarios                         ****
****                                                             ****
*********************************************************************

*************
function UTIL
*************
OPC1 = 1

do while .t.

   private OPCAO[4]
   OPCAO[1] = " Usu"+chr(160)+"rios "
   OPCAO[2] = " Altera"+chr(135)+chr(132)+"o de Senha "            
   OPCAO[3] = " Dados da Empresa "                  
   OPCAO[4] = " Fim " 

   private LETRA[4]
   LETRA[1] = "U"  
   LETRA[2] = "A"
   LETRA[3] = "D"
   LETRA[4] = "F"
 
   private ACESSO[4]
   for I=1 to 3
      ACESSO[I] = ver_SENHA(left(CRI,1)+LETRA[I])
   next
   ACESSO[4] = .t.

   OPC1 = ACHOISE(OPC1,1,OPCAO,ACESSO,LETRA,.T.)
   
   if OPC1 == 0 .or. OPC1 == 4         
      return .t.
   elseif OPC1 == 1  
      cad_USUARIO()
   elseif OPC1 == 2
      alt_SENHA()
   elseif OPC1 == 3
      dados_da_EMPRESA()
   endif
   
enddo

return .t.
