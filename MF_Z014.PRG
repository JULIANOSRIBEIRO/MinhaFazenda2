*********************************************************************
****  Sistema......: MF-Minha Fazenda                            ****
****  Programa.....: MF_Z014.PRG                                 ****
****  Finalidade...: Cadastro de Troca de Pasto/Piquete          ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

***********************
function sc_TROCA_PASTO
***********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 03,01 say "Sequ"+chr(136)+"ncia.....:"
@ 05,01 say "Data..........:"
@ 07,01 say "Brinco........:"
@ 09,01 say "Pasto Atual...:    -"
@ 11,01 say "Novo Pasto....:    -"
@ 13,01 say "Observa"+chr(135)+chr(132)+"o....:"

return .t.

************************
function INC_TROCA_PASTO
************************

@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 10,26 prompt "  Troca de Pasto <Brinco>  "
@ 11,26 prompt "  Troca de Pasto <Total>   "
@ 12,26 prompt "  Retornar                 "
menu to OPC

if OPC == 1

   do while .t.
   
      sc_TROCA_PASTO()
      
      select TROCA_P
      ordsetfocus("SINC001")
      go bottom
   
      WSEQ = SEQ + 1
   
      setcolor(COR_TEXT)
      @ 03,17 say strzero(WSEQ,6)
   
      WDATA      = DATE()
      WBRINCO    = space(15) 
      WPASTO_ANT = 0
      WPASTO_NEW = 0
      WOBS1      = space(60)
   
      do while .t.
   
         setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
   
         @ 05,17 say WDATA
         @ 07,17 get WBRINCO    picture "@!"       valid busca3_BRINCO()
         @ 11,17 get WPASTO_NEW picture "@Z 999"   valid busca31_PASTO()
         @ 13,17 get WOBS1   
         read_f()
   
         if lastkey() == 27
            return .t.
         endif
   
         if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
    
            select TROCA_P
            ordsetfocus("SINC001")
            go bottom
   
            WSEQ = SEQ + 1
    
            set deleted off
            go top
            if deleted()
               if ! reglock()
                  loop
               endif
               recall
            else
               if ! iSEQUENCIAL()
                  loop
               endif
            endif
            set deleted on
   
            replace SEQ with WSEQ
            grava()
   
            save_TROCA_PASTO("INC")
   
            atualiza_TROCA_PASTO(1)
   
            exit
   
         endif
   
       enddo
    
   enddo

elseif OPC == 2

   do while .t.
   
      sc_TROCA_PASTO()
      
      select TROCA_P
      ordsetfocus("SINC001")
      go bottom
   
      WSEQ = SEQ + 1
   
      setcolor(COR_TEXT)
      @ 03,17 say strzero(WSEQ,6)
   
      WDATA      = DATE()
      WBRINCO    = "999999999999999" 
      WPASTO_ANT = 0
      WPASTO_NEW = 0
      WOBS1      = space(60)
   
      do while .t.
   
         setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
   
         @ 05,17 say WDATA
         @ 07,17 say WBRINCO    picture "@!" 
         @ 07,32 say "-GERAL" 

         @ 09,17 get WPASTO_ANT picture "@Z 999"   valid busca30_PASTO(9) 
         @ 11,17 get WPASTO_NEW picture "@Z 999"   valid busca31_PASTO(9)
         @ 13,17 get WOBS1   
         read_f()
   
         if lastkey() == 27
            return .t.
         endif
         
         if WPASTO_NEW == WPASTO_ANT
            MENSAGEM("AVISO!;C"+chr(162)+"digos de pastos devem ser diferentes!",0)
            loop
         endif 
  
         if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
                
            select PLANTEL
            ordsetfocus("SINC001")
            go top
   
            do while ! eof()
   
               if PASTO <> WPASTO_ANT
                  skip +1
                  loop
               endif
   
               if ! empty(SAIDA)
                  skip +1
                  loop
               endif
   
               WBRINCO = BRINCO

               select TROCA_P
               ordsetfocus("SINC001")
               go bottom
   
               WSEQ = SEQ + 1
       
               set deleted off
               go top
               if deleted()
                  if ! reglock()
                     select PLANTEL
                     loop
                  endif
                  recall
               else
                  if ! iSEQUENCIAL()
                     select PLANTEL
                     loop
                  endif
               endif
               set deleted on
   
               replace SEQ with WSEQ
               grava()
   
               save_TROCA_PASTO("INC")
   
               select PLANTEL
               skip +1

            enddo
            
            atualiza_TROCA_PASTO(9)
   
            exit
   
         endif
   
       enddo
    
   enddo

endif

return .t.


**********************
function busca3_BRINCO
**********************

if lastkey() == 27
   return .t.
endif

if empty(WBRINCO)
   help_BRINCO()
   return .f.
endif

select PLANTEL
ordsetfocus("SINC001")
seek WBRINCO

if ! found()
   mensagem("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado no plantel.")
   return .f.
endif

WPASTO_ANT = PASTO
@ 09,17 say WPASTO_ANT picture "999"

select PASTO
ordsetfocus("SINC001")
seek WPASTO_ANT 

if found()
   @ 09,21 say NOME
else
   @ 09,21 say space(30)
   @ 09,21 say "PASTO NAO CADASTRADO"
endif

return .t.

***************************
function busca30_PASTO(WID)
***************************

if lastkey() == 27
   return .t.
endif

if empty(WPASTO_ANT)
   help_PASTO()
   select PASTO 
   if WID <> 9
      WPASTO_NEW = CODIGO
   endif 
endif

select PASTO 
ordsetfocus("SINC001")
seek WPASTO_ANT

if ! found()
   MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 09,21 say NOME

if WID == 9

   WTOT = 0

   select PLANTEL
   ordsetfocus("SINC001")
   go top
   
   do while ! eof()
   
      if PASTO <> WPASTO_ANT
         skip +1
         loop
      endif
   
      if ! empty(SAIDA)
         skip +1
         loop
      endif
   
      WTOT++
      setcolor(COR_DEST)
      @ 10,21 clear to 10,79
      @ 10,21 say if(WTOT = 0,"sem animais",if(WTOT = 1,"1 animal",alltrim(str(WTOT,3))+" animais"))
 
      skip +1

   enddo

   setcolor(COR_DEST)
   @ 10,21 clear to 10,79
   @ 10,21 say if(WTOT = 0,"sem animais",if(WTOT = 1,"1 animal",alltrim(str(WTOT,3))+" animais"))
   setcolor(COR_TEXT)

endif

return .t.

***************************
function busca31_PASTO(WID)
***************************

if lastkey() == 27
   return .t.
endif

if empty(WPASTO_NEW)
   help_PASTO()
   select PASTO 
   WPASTO_NEW = CODIGO
endif

if WPASTO_NEW == WPASTO_ANT
   MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto deve ser diferente do atual!",0)
   return .f.
endif 

select PASTO 
ordsetfocus("SINC001")
seek WPASTO_NEW

if ! found()
   MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto n"+chr(132)+"o cadastrado!",0)
   return .f.
endif

@ 11,21 say NOME

if WID == 9

   WTOT = 0

   select PLANTEL
   ordsetfocus("SINC001")
   go top
   
   do while ! eof()
   
      if PASTO <> WPASTO_NEW
         skip +1
         loop
      endif
   
      if ! empty(SAIDA)
         skip +1
         loop
      endif
   
      WTOT++
      setcolor(COR_DEST)
      @ 12,21 clear to 12,79
      @ 12,21 say if(WTOT = 0,"sem animais",if(WTOT = 1,"1 animal",alltrim(str(WTOT,3))+" animais"))
 
      skip +1

   enddo

   setcolor(COR_DEST)
   @ 12,21 clear to 12,79
   @ 12,21 say if(WTOT = 0,"sem animais",if(WTOT = 1,"1 animal",alltrim(str(WTOT,3))+" animais"))
   setcolor(COR_TEXT)

endif

return .t.

**********************************
function atualiza_TROCA_PASTO(WID)
**********************************
LOCAL WAREA := alias()

if WID == 1

   select PLANTEL
   ordsetfocus("SINC001")
   seek WBRINCO
   
   if found()
      if reglock()
         replace PASTO with WPASTO_NEW
         grava()
      else
         mensagem("AVISO!;Troca de pasto n"+chr(132)+"o efetuada. Refa"+chr(135)+"a o processo.")   
      endif
   endif

elseif WID == 9

   select PLANTEL
   ordsetfocus("SINC001")
   go top
   
   do while ! eof()
   
      if PASTO <> WPASTO_ANT
         skip +1
         loop
      endif
   
      if ! empty(SAIDA)
         skip +1
         loop
      endif
   
      if ! reglock()
         loop
      endif

      replace PASTO with WPASTO_NEW
      grava()

      skip +1

   enddo
    
endif 

select &WAREA

return .t.

************************
function CON_TROCA_PASTO
************************
LOCAL WCOR := setcolor()
LOCAL WOPC 

do while .t.
   
   WOPC = 6

   sc_TROCA_PASTO()
     
   SOMBRA(08,14,17,67,8)

   setcolor(COR_CONS)
   @ 07,12 clear to 16,66
   @ 07,12 to 16,66 

   @ 08,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 09,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 10,14 say "Consulta a partir da sequ"+chr(136)+"ncia de controle......[3]"
   @ 11,14 say "Consulta a partir do n"+chr(163)+"mero do brinco...........[4]"
   @ 12,14 say "Consulta a partir da data de troca do pasto.....[5]"
   @ 13,14 say "Retorno ao menu principal.......................[6]"

   setcolor("W/N,W/N,,,W/N")
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 15,63 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 6 .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif

   WTRAVA = .f.

   sc_TROCA_PASTO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select TROCA_P
      ordsetfocus("SINC001")
      go top 

   elseif WOPC == 2   
      select TROCA_P
      ordsetfocus("SINC001")
      go bottom
      
      if eof()
         skip -1
      endif 

   elseif WOPC == 3   


      do while .t.

         WSEQ = 0
  
         @ 03,17 get WSEQ picture "@Z 999999"
         read_f()
 
         if empty(WSEQ) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif
   
         select TROCA_P
         ordsetfocus("SINC001")
         seek WSEQ 

         if ! found()
            MENSAGEM("AVISO!;Sequ"+chr(136)+"ncia de controle n"+chr(132)+"o cadastrada!",0)
            loop
         endif

      exit
      enddo

   elseif WOPC == 4

      do while .t.

         WBRINCO = space(15)

         @ 07,17 get WBRINCO picture "@!" valid busca3_BRINCO()                      
         read_f()           
  
         if empty(WBRINCO) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select TROCA_P
         ordsetfocus("SINC002")
         seek WBRINCO
          
         if ! found()
            MENSAGEM("AVISO!;N"+chr(132)+"o houve troca de pasto para o brinco informado!",0)
            loop
         endif

      exit 
      enddo

   elseif WOPC == 5
 
      do while .t.

         WDATA = DATE()
         
         @ 05,17 get WDATA
         read_f()           
  
         if empty(WDATA) .or. lastkey() == 27
            WTRAVA = .t.
            exit
         endif

         select TROCA_P
         ordsetfocus("SINC003")
         seek WDATA  
          
         if eof()
            skip -1
         endif 

      exit 
      enddo

   endif

   if WTRAVA
      loop
   endif

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo   PgUp-Anterior   ESC-FIM")

      @ 03,17 say strzero(SEQ,6)
      @ 05,17 say DATA
      @ 07,17 say BRINCO    picture "@!" 
      @ 09,17 say PASTO_ANT picture "999"   
      @ 11,17 say PASTO_NEW picture "999"   
      @ 13,17 say OBS1   
     
      WPASTO_ANT = PASTO_ANT
      WPASTO_NEW = PASTO_NEW
      
      select PASTO 
      ordsetfocus("SINC001")
      seek WPASTO_ANT 

      if found()   
         @ 09,21 say NOME
      else
         @ 09,21 say space(30)
         @ 09,21 say "PASTO NAO CADASTRADO"
      endif

      seek WPASTO_NEW

      if found()   
         @ 11,21 say NOME
      else
         @ 11,21 say space(30)
         @ 11,21 say "PASTO NAO CADASTRADO"
      endif

      select TROCA_P

      inkey(0)

      if lastkey() == 03
         skip +1
         if eof()
            skip -1
         endif
      elseif lastkey() == 18
         skip -1
      elseif lastkey() == 27
         exit
      endif

   enddo

enddo

return .t.

*********************************
function save_TROCA_PASTO(MODULO)
*********************************

if ! reglock()
   return .t.
endif

replace SEQ       with WSEQ,;
        BRINCO    with WBRINCO,;
        DATA      with WDATA,;
        PASTO_ANT with WPASTO_ANT,;
        PASTO_NEW with WPASTO_NEW,;
        OBS1      with WOBS1
        
if MODULO == "INC" 
   replace USER_INC with WPUSUARIO,;
           DATE_INC with DATE(),;
           TIME_INC with TIME()
endif  

grava()

return .t.
