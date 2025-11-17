*********************************************************************
****  Sistema......: SCF-Sistema de Controle Financeiro          ****
****  Versao.......: 4.0                                         ****
****  Programa.....: MFZ099.PRG                                 ****
****  Finalidade...: Modulo de Utilitarios                       ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

********************
function cad_USUARIO
********************

select LOGIN
ordsetfocus("SINC001")

@ 02,00 clear to 22,79
@ 24,00 clear to 24,79
CENTRO(24,"A~Z-Pesquisa   ENTER-Alterar   INS-Inserir   DEL-Deletar   ESC-FIM")

private CAMPO[1]
CAMPO[1] = "left(space(01)+HB_Decrypt(USUARIO,'$!nc0n@2012')+space(78),78)+space(01)"

select LOGIN
ordsetfocus("SINC001")
go top

keyboard(chr(65))

dbedit(02,00,22,79,CAMPO,"UDF_USER","","","","","","")

return .t.


*****************
function UDF_USER
*****************
CENTRO(24,"A~Z-Pesquisa   ENTER-Alterar   INS-Inserir   DEL-Deletar   ESC-FIM")

if (lastkey() >= 32 .and. lastkey() <= 254)
   seek Upper(Chr(lastkey()))
   return 1
endif

if lastkey() == 13 
   @ 24,00 clear to 24,79
   alt_USER()
   keyboard(chr(6))
   return 2
elseif lastkey() == 27 
   @ 24,00 clear to 24,79
   return 0
elseif lastkey() == 22
   @ 24,00 clear to 24,79
   inc_USER()
   keyboard(chr(6))
   return 2   

elseif lastkey() == 7
   @ 24,00 clear to 24,79
   exc_USER()
   keyboard(chr(6))
   return 2
endif

return 1


****************
function sc_USER
****************

@ 00,00 clear to 22,79

setcolor(COR_SUB)
@ 01,00 to 01,79 double
setcolor(COR_TEXT)

@ 00,36 say "ACESSO" 
@ 00,74 say "CRI" 

@ 02,01 say "Login....:"
@ 03,01 say "Depto....:"
@ 04,01 say "Fun"+chr(135)+chr(132)+"o...:"

@ 09,01 say "Senha....:"

@ 11,01 say "PERFIL...:"

@ 13,01 say "Celular..:"
@ 14,01 say "Email....:"

setcolor(COR_TEXT)

return .t.

*****************
function inc_USER
*****************
LOCAL cCOLOR_GET := COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_SUB

select LOGIN
ordsetfocus("SINC001")
  
WNOME       = space(50)
WUSUARIO    = space(50)
WSENHA      = space(10)
WDEPTO      = space(50)
WFUNCAO     = space(50)
WPERFIL     = space(50)
WCELULAR    = space(11)
WEMAIL      = space(50)
WTT_USUARIO = savescreen(00,00,22,79)

do while .t.

   sc_USER()

   @ 00,01 get WNOME      picture "@!@S30"  valid ! empty(WNOME)
   @ 02,12 get WUSUARIO   picture "@!@S30"  valid ! empty(WUSUARIO) .and. check_USER()
   @ 03,12 get WDEPTO     picture "@!@S30"
   @ 04,12 get WFUNCAO    picture "@!@S30"
   read_f()
   
   if lastkey() == 27
      restscreen(00,00,22,79,WTT_USUARIO)
      return .t.
   endif
   
   if (left(WUSUARIO,1) == "@")
      if left(WNOME,1) <> "@"
         WNOME = "@"+left(WNOME,29)
         @ 00,01 say WNOME   picture "@!" 
      endif
   endif
   
   @ 11,12 get WPERFIL       picture "@!@S30" valid check_PERFIL()
   
   if left(WUSUARIO,1) <> "@"   
      @ 09,12 get WSENHA     
      @ 13,12 get WCELULAR   picture "99999999999"
      @ 14,12 get WEMAIL                                               
   endif
   
   read_f()
   
   if lastkey() == 27
      restscreen(00,00,22,79,WTT_USUARIO)
      return .t.
   endif
   
   if confirma(24,"Confirma INCLUS"+chr(142)+"O DE "+if(left(WUSUARIO,1) == "@", "PERFIL", "USUARIO")+"...(S/N)?","N") == "S"

      select LOGIN

      set deleted off
      go top
      if deleted()
         if ! reglock()
            loop
         endif

         recall
      else
         if ! inc_reg()
            loop
         endif
      endif
      set deleted on

      save_USER()

      exit      

   endif
enddo

ACESSO(WPERFIL)

restscreen(00,00,22,79,WTT_USUARIO)

return .t.


*******************
function check_USER
*******************

if lastkey() = 27
   return .t.
endif

if empty(WUSUARIO)
   return .f.
endif

select LOGIN
ordsetfocus("SINC001")
seek HB_Decrypt(WUSUARIO,"$!nc0n@2012")

if found()
   MENSAGEM2('Login de usu�rio j� cadastrado.')
   return .f.
endif

return .t.
 
*********************
function check_PERFIL
*********************

if lastkey() = 27
   return .t.
endif

if empty(WPERFIL)
   return .t.
endif

select LOGIN
ordsetfocus("SINC001")

WREG = recno()

seek WPERFIL

if ! found()
   MENSAGEM2('Perfil de usu�rio n�o cadastrado.')
   go WREG
   return .f.
endif

go WREG

return .t.
 
*****************
function alt_USER   
*****************
LOCAL cCOLOR_GET := COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_SUB

WNOME       = HB_Decrypt(NOME   ,"$!nc0n@2012")
WUSUARIO    = HB_Decrypt(USUARIO,"$!nc0n@2012")
WDEPTO      = HB_Decrypt(DEPTO  ,"$!nc0n@2012")
WFUNCAO     = HB_Decrypt(FUNCAO ,"$!nc0n@2012")
WSENHA      = if(empty(alltrim(HB_Decrypt(SENHA,"$!nc0n@2012"))),space(10),HB_Decrypt(SENHA,"$!nc0n@2012"))
WPERFIL     = HB_Decrypt(PERFIL ,"$!nc0n@2012")
WCELULAR    = HB_Decrypt(CELULAR,"$!nc0n@2012")
WEMAIL      = HB_Decrypt(EMAIL  ,"$!nc0n@2012")
WTT_USUARIO = savescreen(00,00,22,79)

do while .t.

   sc_USER()

   @ 00,01 get WNOME        picture "@!@S30"                         valid ! empty(WNOME)
   @ 02,12 say WUSUARIO     picture "@!@S30"                             
   @ 03,12 get WDEPTO       picture "@!@S30"
   @ 04,12 get WFUNCAO      picture "@!@S30"

   if left(WUSUARIO,1) <> "@"    
      @ 09,12 get WSENHA                                             
      @ 11,12 get WPERFIL   picture "@!@S30"                         valid check_PERFIL()
      @ 13,12 get WCELULAR  picture "99999999999"
      @ 14,12 get WEMAIL                                              
   endif
   
   read_f()
   
   if lastkey() == 27
      restscreen(00,00,22,79,WTT_USUARIO)
      return .t.
   endif
   
   if (left(WUSUARIO,1) == "@")
      if left(WNOME,1) <> "@"
         WNOME = "@"+left(WNOME,49)
         @ 00,01 say WNOME      picture "@!" 
      endif
   endif
   
   if confirma(24,"Confirma ALTERA"+chr(128)+chr(142)+"O DE "+if(left(WUSUARIO,1) == "@", "PERFIL", "USUARIO")+"...(S/N)?","N") == "S"
      save_USER()
      exit      
   endif
   
enddo

if left(WUSUARIO,1) <> "@"    
   ACESSO(WPERFIL)
else
   ACESSO()
endif

restscreen(00,00,22,79,WTT_USUARIO)

return .t.


*****************
function exc_USER
*****************

WNOME       = HB_Decrypt(NOME   ,"$!nc0n@2012")
WUSUARIO    = HB_Decrypt(USUARIO,"$!nc0n@2012")
WDEPTO      = HB_Decrypt(DEPTO  ,"$!nc0n@2012")
WFUNCAO     = HB_Decrypt(FUNCAO ,"$!nc0n@2012")
WSENHA      = HB_Decrypt(SENHA  ,"$!nc0n@2012")
WPERFIL     = HB_Decrypt(PERFIL ,"$!nc0n@2012")
WCELULAR    = HB_Decrypt(CELULAR,"$!nc0n@2012")
WEMAIL      = HB_Decrypt(EMAIL  ,"$!nc0n@2012")
WTT_USUARIO = savescreen(00,00,22,79)

sc_USER()

@ 00,01 say WNOME       picture "@!@S30"                         
@ 02,12 say WUSUARIO    picture "@!@S30"                             
@ 03,12 say WDEPTO      picture "@!@S30"
@ 04,12 say WFUNCAO     picture "@!@S30"

if left(WUSUARIO,1) <> "@"    
   @ 09,12 say WSENHA   picture "@!"
   @ 11,12 say WPERFIL  picture "@!@S30"  
   @ 13,12 say WCELULAR picture "99999999999"
   @ 14,12 say WEMAIL                                     
endif
   
if lastkey() == 27
   restscreen(00,00,22,79,WTT_USUARIO)
   return .t.
endif

if left(WUSUARIO,1) == "@"    

   select LOGIN
   ordsetfocus("SINC002")
   seek WUSUARIO

   If found()
      MENSAGEM2("Perfil vinculado ao usu�rio "+alltrim(HB_Decrypt(NOME,"$!nc0n@2012")),2)
      
      select LOGIN
      ordsetfocus("SINC001")
      seek WUSUARIO
      
      restscreen(00,00,22,79,WTT_USUARIO)
      return .t.
   endif
   
   select LOGIN
   ordsetfocus("SINC001")
   seek WUSUARIO
   
endif

if confirma(24,"Confirma EXCLUS"+chr(142)+"O DE "+if(left(WUSUARIO,1) == "@", "PERFIL", "USUARIO")+"...(S/N)?","N") == "S"

   if ! reglock()
      return .f.
   endif

   replace USUARIO with HB_Crypt(space(50),"$!nc0n@2012"),;
           NOME    with HB_Crypt(space(50),"$!nc0n@2012"),;
           DEPTO   with HB_Crypt(space(50),"$!nc0n@2012"),;
           FUNCAO  with HB_Crypt(space(50),"$!nc0n@2012"),;
           SENHA   with HB_Crypt(space(10),"$!nc0n@2012"),;
           PERFIL  with HB_Crypt(space(50),"$!nc0n@2012"),;
           CELULAR with HB_Crypt(space(11),"$!nc0n@2012"),;
           EMAIL   with HB_Crypt(space(50),"$!nc0n@2012")
   delete
   grava()

   select ACESSO
   ordsetfocus("SINC001")
   seek WUSUARIO

   do while WUSUARIO == HB_Decrypt(USUARIO,"$!nc0n@2012") .and. ! eof()

      if ! reglock()
         loop
      endif

      replace USUARIO with HB_Crypt(space(20),"$!nc0n@2012"),;
              ACRI    with HB_Crypt(space(05),"$!nc0n@2012")
  
      delete
      grava()

      seek WUSUARIO
   enddo

   select LOGIN

endif

restscreen(00,00,22,79,WTT_USUARIO)

return .t.

******************
function save_USER
******************

if ! REGLOCK()
   return .f.
endif

replace USUARIO with HB_Crypt(WUSUARIO,"$!nc0n@2012"),;
        NOME    with HB_Crypt(WNOME   ,"$!nc0n@2012"),;
        DEPTO   with HB_Crypt(WDEPTO  ,"$!nc0n@2012"),;
        FUNCAO  with HB_Crypt(WFUNCAO ,"$!nc0n@2012"),;
        SENHA   with HB_Crypt(WSENHA  ,"$!nc0n@2012"),;
        CELULAR with HB_Crypt(WCELULAR,"$!nc0n@2012"),;
        EMAIL   with HB_Crypt(WEMAIL  ,"$!nc0n@2012")
        
if left(WUSUARIO,1) <> "@"    
   replace PERFIL  with HB_Crypt(WPERFIL,"$!nc0n@2012")
endif
        
GRAVA()

return .t.        

************************
function ACESSO(WPERFIL)
************************

if pcount() == 0
   WPERFIL = HB_Decrypt(USUARIO,"$!nc0n@2012")
endif

abre_tmp(201,"&WDIRE_TEMP\ACESSO\ACESSO","TMP",5)
index on ACRI tag SINC001

if alltrim(WPERFIL) ==  "@ADMINISTRADOR"
   replace OK with "X" all
else
   replace OK with " " all

   select ACESSO   
   ordsetfocus("SINC001")
   seek WPERFIL

   do while WPERFIL == HB_Decrypt(USUARIO,"$!nc0n@2012") .and. ! eof()
      WACRI = HB_Decrypt(ACRI,"$!nc0n@2012")

      select TMP
      ordsetfocus("SINC001")
      seek WACRI

      replace OK with "X"
   
      select ACESSO
      skip +1
   enddo
endif

WFILTRO1 = " "
WFILTRO2 = " "
WFILTRO3 = " "
WFILTRO4 = " "
WFILTRO5 = " "

select TMP
ordsetfocus(0)
SET FILTER TO LEN(ALLTRIM(ACRI)) == 1 .or. (left(ACRI,1) == WFILTRO1 .and. len(alltrim(ACRI)) == 2) .or.  (left(ACRI,2) == WFILTRO2 .and. len(alltrim(ACRI)) == 3) .or. (left(ACRI,3) == WFILTRO3 .and. len(alltrim(ACRI)) == 4) .or. (left(ACRI,4) == WFILTRO4 .and. len(alltrim(ACRI)) == 5) .or. (left(ACRI,5) == WFILTRO5 .and. len(alltrim(ACRI)) == 6)
GO TOP

private aCAMPO:={{"acesso","",""},;
                 {"acri","",""}}

brw_acesso(0,35,22,79,aCAMPO)

if left(WUSUARIO,1) <> "@" .or. confirma(24,"Confirma CONFIGURA"+chr(128)+chr(142)+"O DE ACESSOS...(S/N)?","N") == "N"
   select 201
   DBCLOSEAREA()
   select LOGIN
   return .t.
endif

select ACESSO
ordsetfocus("SINC001")
seek WUSUARIO

do while WUSUARIO == HB_Decrypt(USUARIO,"$!nc0n@2012") .and. ! eof()

   if ! reglock()
      loop
   endif

   replace USUARIO with HB_Crypt(space(50),"$!nc0n@2012"),;
           ACRI    with HB_Crypt(space(05),"$!nc0n@2012")
  

   delete
   grava()

   seek WUSUARIO
enddo

select TMP
ordsetfocus(0)
SET FILTER TO 
go top

do while ! eof()
   if empty(OK)
      skip +1
      loop
   endif

   WACRI = ACRI

   select ACESSO
   ordsetfocus("SINC001")

   set deleted off
   go top
   if deleted()
      if ! reglock()
         loop
      endif

      recall
   else
      if ! inc_reg()
         loop
      endif
   endif
   set deleted on

   replace USUARIO with HB_Crypt(WUSUARIO,"$!nc0n@2012"),;
           ACRI    with HB_Crypt(WACRI,"$!nc0n@2012")


   grava()
   
   select TMP
   skip +1
enddo

select 201
DBCLOSEAREA()

select LOGIN

return .t.

***************************************************************
function BRW_ACESSO(BRW_LS, BRW_CS, BRW_LI, BRW_CI, BRW_CAMPOS)
***************************************************************
LOCAL oTBrowse, oTBColumn
LOCAL bFieldBlock, cFieldName, i, nKey 

// create TBrowse object
oTBrowse := TBrowse():new( BRW_LS+1, BRW_CS+1, BRW_LI-1, BRW_CI-1)
oTBrowse:headSep := chr(205)+chr(205)+chr(205)
oTBrowse:colsep:=" "+chr(179)+" "
oTBrowse:colorSpec := COR_SUB+","+COR_TEXT+","+COR_GETS

// add code blocks for navigating the record pointer
oTBrowse:goTopBlock := {|| DbGoTop() }
oTBrowse:goBottomBlock := {|| DbGoBottom() }
oTBrowse:skipBlock := {|nSkip| DbSkipper(nSkip) }

// create TBColumn objects and add them to TBrowse object
FOR i:=1 TO len(BRW_CAMPOS)
    cp_titu:=brw_campos[i,3]
    cp_masc:=brw_campos[i,2]
    cp_:=brw_campos[i,1]
    
    oTBColumn := TBColumn():new(cp_titu,&("{||transform("+cp_+",["+cp_masc+"])}"))
    oTBrowse:addColumn( oTBColumn )
    oTBrowse:getcolumn(i):width := len(transform(&cp_.,cp_masc))
    oTBrowse:getcolumn(i):colorblock=&("{||if(OK == ' ', {1,3}, {2,3})}")
NEXT

// display browser and process user input 
do while .T.
   oTBrowse:forceStable()
   
   nKEY := Inkey(0)

   if oTBrowse:applyKey( nKEY ) == TBR_EXIT  
      exit
   endif
   
   if nKEY == K_ENTER   
      acesse()
      oTBrowse:refreshAll()
   elseif chr(nKEY) == "+"
      WWFILTRO  = "WFILTRO"+str(len(alltrim(ACRI)),1)
      &WWFILTRO = alltrim(ACRI)

      for XX = (len(alltrim(ACRI))+1) to 5
         WWFILTRO  = "WFILTRO"+str(XX,1)
         &WWFILTRO = " "
      next          

      select TMP
      ordsetfocus(0)
      SET FILTER TO LEN(ALLTRIM(ACRI)) == 1 .or. (left(ACRI,1) == WFILTRO1 .and. len(alltrim(ACRI)) == 2) .or.  (left(ACRI,2) == WFILTRO2 .and. len(alltrim(ACRI)) == 3) .or. (left(ACRI,3) == WFILTRO3 .and. len(alltrim(ACRI)) == 4) .or. (left(ACRI,4) == WFILTRO4 .and. len(alltrim(ACRI)) == 5) .or. (left(ACRI,5) == WFILTRO5 .and. len(alltrim(ACRI)) == 6)

      oTBrowse:refreshAll()
   elseif chr(nKEY) == "-"
      WWFILTRO  = "WFILTRO"+str(len(alltrim(ACRI)),1)
      &WWFILTRO = " " 

      for XX = (len(alltrim(ACRI))+1) to 5
         WWFILTRO  = "WFILTRO"+str(XX,1)
         &WWFILTRO = " "
      next          

      select TMP
      ordsetfocus(0)
      SET FILTER TO LEN(ALLTRIM(ACRI)) == 1 .or. (left(ACRI,1) == WFILTRO1 .and. len(alltrim(ACRI)) == 2) .or.  (left(ACRI,2) == WFILTRO2 .and. len(alltrim(ACRI)) == 3) .or. (left(ACRI,3) == WFILTRO3 .and. len(alltrim(ACRI)) == 4) .or. (left(ACRI,4) == WFILTRO4 .and. len(alltrim(ACRI)) == 5) .or. (left(ACRI,5) == WFILTRO5 .and. len(alltrim(ACRI)) == 6)

      oTBrowse:refreshAll()
   endif

enddo

return .t.


***************
function ACESSE
***************

if left(WUSUARIO,1) <> "@" .or. alltrim(WUSUARIO) == "@ADMINISTRADOR" 
   return .t.
endif

replace OK with if(OK == "X"," ","X")

WREC  = recno()

SET FILTER TO 

if OK == "X"
   WACRI = ACRI
   do while ! bof()
      skip -1
      if len(alltrim(ACRI)) == (len(alltrim(WACRI))-1)
         if left(WACRI,len(alltrim(ACRI))) == alltrim(ACRI)
            replace OK with "X"

            WACRI = ACRI
         endif
     endif              
   enddo
else
   WACRI = ACRI
   do while ! eof()
      skip +1
      if len(alltrim(ACRI)) > len(alltrim(WACRI))
         if alltrim(WACRI) == left(ACRI,len(alltrim(WACRI)))
            replace OK with " "
         endif
     endif              
   enddo
endif

SET FILTER TO LEN(ALLTRIM(ACRI)) == 1 .or. (left(ACRI,1) == WFILTRO1 .and. len(alltrim(ACRI)) == 2) .or.  (left(ACRI,2) == WFILTRO2 .and. len(alltrim(ACRI)) == 3) .or. (left(ACRI,3) == WFILTRO3 .and. len(alltrim(ACRI)) == 4) .or. (left(ACRI,4) == WFILTRO4 .and. len(alltrim(ACRI)) == 5) .or. (left(ACRI,5) == WFILTRO5 .and. len(alltrim(ACRI)) == 6)
go WREC

return .t.

******************
function alt_SENHA
******************
LOCAL cCOLOR_GET := COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_SUB

select LOGIN
ordsetfocus("SINC001")
seek WPUSUARIO

WNOME       = HB_Decrypt(NOME   ,"$!nc0n@2012")
WUSUARIO    = HB_Decrypt(USUARIO,"$!nc0n@2012")
WDEPTO      = HB_Decrypt(DEPTO  ,"$!nc0n@2012")
WFUNCAO     = HB_Decrypt(FUNCAO ,"$!nc0n@2012")
WSENHA      = if(empty(alltrim(HB_Decrypt(SENHA,"$!nc0n@2012"))),space(10),HB_Decrypt(SENHA,"$!nc0n@2012"))
WPERFIL     = HB_Decrypt(PERFIL ,"$!nc0n@2012")
WCELULAR    = HB_Decrypt(CELULAR,"$!nc0n@2012")
WEMAIL      = HB_Decrypt(EMAIL  ,"$!nc0n@2012")
WTT_USUARIO = savescreen(00,00,22,79)

do while .t.

   sc_USER()

   @ 00,01 say WNOME     picture "@!@S30"                          
   @ 02,12 say WUSUARIO  picture "@!@S30"                             
   @ 03,12 say WDEPTO    picture "@!@S30"
   @ 04,12 say WFUNCAO   picture "@!@S30"
   @ 11,12 say WPERFIL   picture "@!@S30"                          
   @ 13,12 say WCELULAR  picture "99999999999"
   @ 14,12 say WEMAIL                                              

   @ 09,12 get WSENHA                                             
   read_f()
   
   if lastkey() == 27
      restscreen(00,00,22,79,WTT_USUARIO)
      return .t.
   endif
   
   if confirma(24,"Confirma ALTERA"+chr(128)+chr(142)+"O DE SENHA...(S/N)?","N") == "S"
      
      if ! REGLOCK()
         return .f.
      endif
      
      replace SENHA with HB_Crypt(WSENHA,"$!nc0n@2012")
                 
      GRAVA()
      
      exit      
      
   endif
   
enddo

restscreen(00,00,22,79,WTT_USUARIO)

return .t.


*************************
function dados_da_EMPRESA
*************************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,02 say "Empresa.....:"
@ 05,02 say "Endere"+chr(135)+"o....:"
@ 07,02 say "N"+chr(163)+"mero......:" 
@ 09,02 say "Bairro......:" 
@ 09,42 say "Insc.Mun....:"
@ 11,02 say "Cidade......:      -"
@ 13,02 say "Estado......:          IBGE:   "
@ 13,42 say "Cep.........:"
@ 15,02 say "Telefone....:"
@ 15,42 say "Fax.........:"
@ 17,02 say "CNPJ........:" 
@ 17,42 say "Insc.Est....:"
@ 19,02 say "CRT.........:" 
@ 19,42 say "CNAE........:" 

do while .t.

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 03,16 get CFG_EMPRES    
   @ 05,16 get CFG_ENDERE    
   @ 07,16 get CFG_NUMERO    
   @ 09,16 get CFG_BAIRRO
   @ 09,56 get CFG_MUN       picture "999999999999999"
   @ 11,16 get CFG_CIDADE    picture "@!"                    valid busca_IBGE()     
   @ 13,16 get CFG_ESTADO
   @ 13,31 get CFG_IBGE_U    picture "99"                    valid ! empty(CFG_IBGE_U)
   @ 13,56 get CFG_CEP       picture "@R 99999-999"
   @ 15,16 get CFG_TEL                                     
   @ 15,56 get CFG_FAX                                     
   @ 17,16 get CFG_CGC       picture "@R 99.999.999/9999-99"                                
   @ 17,56 get CFG_INSC   
   @ 19,16 get CFG_CRT       picture "9"                     valid cod_CRT()
   @ 19,56 get CFG_CNAE      picture "9999999"

   select CIDADE
   ordsetfocus("SINC001")
   seek CFG_CIDADE
   
   if found()
      @ 11,22 say CIDADE
      CFG_ESTADO = ESTADO
   else
      @ 11,22 say space(20)
   endif

   read_f()
 
   if lastkey() = 27
      WDIR2 = WDIRE_AUX+"\EMPRESA."+SIR
      @ 24,00 clear to 24,79
      restore from &WDIR2 additive      
      setcolor(COR_TEXT)  
      @ 00,01 say alltrim(CFG_EMPRES)
      return .t.
   endif

   if confirma(24,"Dados corretos...(S/N)?","S") == "S"
      WDIR2 = WDIRE_AUX+"\EMPRESA."+SIR
      save all like CFG_* to &WDIR2 
      @ 24,00 clear to 24,79
      setcolor(COR_TEXT)  
      @ 00,01 say alltrim(CFG_EMPRES)
      return .t.
   endif

enddo

return .t.


*******************
function busca_IBGE
*******************
LOCAL WAREA := alias()
LOCAL WROW  := row()

VAR = readvar()

if empty(&VAR)
   help_CIDADE()
   return .f.
endif

select CIDADE
ordsetfocus("SINC001")
seek &VAR

if ! found()
   MENSAGEM2('C'+chr(162)+'digo de cidade n'+chr(132)+'o cadastrado.')
   select &WAREA
   @ 11,22 say space(20)
   @ 13,16 say space(02)
   @ 13,56 say space(09)
   return .f.
endif

@ 11,22 say CIDADE   
@ 13,16 say ESTADO picture "@!"

if ! empty(CEP)
   @ 13,56 say CEP picture "@R 99999-999"
endif

CFG_ESTADO = ESTADO

if ! empty(CEP)
   CFG_CEP = CEP        
endif

select &WAREA

return .t.


****************
function cod_CRT
****************

if CFG_CRT = "1"
   @ 19,17 Say "-Simples Nacional"
elseif CFG_CRT = "3"
   @ 19,17 Say "-Regime Normal   "
else
   @ 19,17 Say "                 "
   MENSAGEM2('C'+chr(162)+'d.Reg.Tribut'+chr(160)+'rio: 1-Simples Nacional ou 3-Regime Normal')
   return .f.
endif

return .t.
