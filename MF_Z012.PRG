*********************************************************************
****  Sistema......: MF-Minha Fazenda                            ****
****  Programa.....: MFZ012.PRG                                  ****
****  Finalidade...: Movimentação de Estoque                     ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************
#include "TBrowse.ch"
#include "inkey.ch"

*******************
function sc_PRODUTO 
*******************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

@ 02,01 say "C"+chr(162)+"digo.......:"

@ 04,01 say "Produto......:"
@ 05,01 say "Refer"+chr(136)+"ncia...:"
@ 06,01 say "Unidade......:"
@ 07,01 say "Volume.......:"

@ 09,01 say "Grupo........:     -"

@ 11,01 say "Sd.Anterior..:"
@ 12,01 say "Aquisi"+chr(135)+chr(132)+"o....:"
@ 13,01 say "Baixas.......:"
@ 14,01 say "Sd.Atual.....:"

@ 16,01 say "M"+chr(161)+"nimo.......:"
@ 17,01 say "Ressuprimento:"

@ 19,01 say "Custo M"+chr(130)+"dio..:"

return .t.


*********************
function INC_PRODUTOS
*********************

do while .t.

   sc_PRODUTO ()      

   WCODIGO  = space(08)
   WPRODUTO = space(40)  
   WREF     = space(20)
   WUN      = space(03)
   WVOLUME  = 1 
   WCOD_GRP = space(03)
   WSDANT   = 0 
   WAQUIS   = 0
   WBAIXAS  = 0 
   WMINIMO  = 0
   WRESSUP  = 0
   WCUSTO   = 0

   select PRODUTOS
   ordsetfocus('SINC004')
   go bottom

   WCODIGO = left(alltrim(str(val(CODIGO)+1,8))+space(08),8)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 02,16 say WCODIGO  picture "99999999"

      @ 04,16 get WPRODUTO  
      @ 05,16 get WREF                     
      @ 06,16 get WUN      picture "!!"   
      @ 07,16 get WVOLUME  picture "@Z 999"

      @ 09,16 get WCOD_GRP picture "999"        valid view_GRP()

      @ 11,16 get WSDANT   picture "999999.99"  valid sd_ATUAL()
      @ 12,16 get WAQUIS   picture "999999.99"  valid sd_ATUAL()
      @ 13,16 get WBAIXAS  picture "999999.99"  valid sd_ATUAL()

      @ 16,16 get WMINIMO  picture "999999.99"
      @ 17,16 get WRESSUP  picture "999999.99"

      @ 19,16 get WCUSTO   picture "@R@E 999,999.99"
      read_f()

      if empty(WPRODUTO) .or. lastkey() == 27
         return .t.
      endif

      setcolor(COR_CONS)
      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
                       
         select PRODUTOS
         ordsetfocus('SINC004')
         go bottom

         WCODIGO = left(alltrim(str(val(CODIGO)+1,8))+space(08),8)
         @ 02,16 say WCODIGO  picture "99999999"

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

         WCODIGO = isUNIQUE(WCODIGO, "CODIGO")
 
         if empty(WCODIGO)
           MENSAGEM("ERRO AO INCLUIR O REGISTRO.",0)
           if reglock()
              delete()
              grava()
           endif
           return .f.
         endif
         
         select PRODUTOS
         save_PRODUTOS()

         exit
    
      endif

    enddo

enddo

return .t.


*****************
function view_GRP
*****************

if empty(WCOD_GRP)
   help_GRP() 
   return .t. 
endif

select GRUPO
ordsetfocus('SINC001')
seek WCOD_GRP

if ! found()
   mensagem("C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!")
   return .f.
endif

setcolor(COR_TEXT)

@ 09,22 say space(32)
@ 09,22 say "<"+alltrim(GRUPO)+">"

return .t.


*****************
function sd_ATUAL
*****************

@ 14,16 say ((WSDANT + WAQUIS) - WBAIXAS) picture "999999.99"

return .t.


*********************
function ALT_PRODUTOS
*********************

do while .t.

   sc_PRODUTO ()     

   WCODIGO = space(08)

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 02,16 get WCODIGO picture "99999999"
   read_f()

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select PRODUTOS
   ordsetfocus('SINC001')
   seek val(WCODIGO)

   if ! found()
      mensagem("C"+chr(162)+"digo de produto n"+chr(132)+"o cadastrado!")
      loop
   endif

   WPRODUTO = PRODUTO 
   WREF     = REF            
   WUN      = UN      
   WVOLUME  = VOLUME 
   WCOD_GRP = COD_GRP 
   WSDANT   = SDANT   
   WAQUIS   = AQUIS   
   WBAIXAS  = BAIXAS  
   WMINIMO  = MINIMO  
   WRESSUP  = RESSUP  
   WCUSTO   = CUSTO   

   setcolor(COR_TEXT)
   @ 14,16 say ((WSDANT + WAQUIS) - WBAIXAS) picture "99999"

   select GRUPO  
   ordsetfocus('SINC001')
   seek WCOD_GRP

   @ 09,22 say space(32)
   @ 09,22 say "<"+alltrim(GRUPO)+">" 

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 04,16 get WPRODUTO 
      @ 05,16 get WREF                     
      @ 06,16 get WUN           picture "!!"    
      @ 07,16 get WVOLUME       picture "@Z 999"
 
      @ 09,16 get WCOD_GRP      picture "999"          valid view_GRP()

      @ 11,16 get WSDANT        picture "999999.99"    valid sd_ATUAL()
      @ 12,16 get WAQUIS        picture "999999.99"    valid sd_ATUAL()
      @ 13,16 get WBAIXAS       picture "999999.99"    valid sd_ATUAL()

      @ 16,16 get WMINIMO       picture "999999.99"
      @ 17,16 get WRESSUP       picture "999999.99"

      @ 19,16 get WCUSTO        picture "@R@E 999,999.99"
      read_f()                                                         

      if empty(WPRODUTO) .or. lastkey() == 27
         return .t.
      endif

      setcolor(COR_CONS)
      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"
                       
         select PRODUTOS
         if ! reglock()
            loop
         endif

         save_PRODUTOS()

         grava()

         exit
    
      endif

   enddo                                                                             

enddo

return .t.

*********************
function CON_PRODUTOS
*********************
LOCAL WOPC

do while .t.

   WOPC   = 6
   WTRAVA = .f.

   sc_PRODUTO ()     

   SOMBRA(08,14,17,70,8)

   setcolor(COR_CONS)
   @ 07,12 clear to 16,69
   @ 07,12 to 16,69

   @ 08,14 say "Consulta a partir do inicio do arquivo.............[1]"
   @ 09,14 say "Consulta a partir do final do arquivo..............[2]"
   @ 10,14 say "Consulta a partir do c"+chr(162)+"digo do produto.............[3]"
   @ 11,14 say "Consulta a partir da descri"+chr(135)+chr(132)+"o do produto..........[4]" 
   @ 12,14 say "Consulta a partir da refer"+chr(136)+"ncia do produto.........[5]" 
   @ 13,14 say "Retorno ao menu principal..........................[6]" 

   setcolor(COR_GETS)
   @ 15,14 say "Escolha sua op"+chr(135)+chr(132)+"o..................................[ ]"
   @ 15,66 get WOPC picture "9" range 1,6
   read_f()   

   setcolor(COR_TEXT)

   if WOPC == 6 .or. lastkey() == 27
      return .t.
   endif

   sc_PRODUTO()     

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   if WOPC == 1
      select PRODUTOS
      ordsetfocus('SINC001')
      go top

   elseif WOPC == 2
      select PRODUTOS
      ordsetfocus('SINC001')
      go bottom

      if eof()
         skip -1
      endif 

   elseif WOPC == 3

      do while .t.

         WCODIGO = space(08)

         @ 02,16 get WCODIGO picture "99999999"
         read_f()

         if ! empty(WCODIGO) .or. lastkey() <> 27

            select PRODUTOS
            ordsetfocus('SINC001')
            seek val(WCODIGO)

            if ! found()
               mensagem("C"+chr(162)+"digo de produto n"+chr(132)+"o cadastrado!")
               loop
            endif

         else
            WTRAVA = .t.
         endif

      exit
      enddo

   elseif WOPC == 4

      WPRODUTO = space(40)

      @ 04,16 get WPRODUTO 
      read_f()

      if ! empty(WPRODUTO) .or. lastkey() <> 27
         
         select PRODUTOS
         ordsetfocus('SINC002')
         seek upper(WPRODUTO)
          
         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   elseif WOPC == 5

      WREF = space(20)

      @ 05,16 get WREF 
      read_f()

      if ! empty(WREF) .or. lastkey() <> 27
          
         select PRODUTOS
         ordsetfocus('SINC003')
         seek WREF 
         
         if ! found()
            mensagem("Refer"+chr(136)+"ncia de produto n"+chr(132)+"o cadastrado!")
            loop
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   sc_PRODUTO()     

   do while .t.

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    ESC-Retornar")

      @ 02,16 say CODIGO                     picture "99999999"
      @ 04,16 say PRODUTO 
      @ 05,16 say REF                    
      @ 06,16 say UN        
      @ 07,16 say VOLUME                     picture "@Z 999"        

      @ 09,16 say COD_GRP                    picture "999"

      @ 11,16 say SDANT                      picture "999999.99"   
      @ 12,16 say AQUIS                      picture "999999.99"   
      @ 13,16 say BAIXAS                     picture "999999.99"   
      @ 14,16 say ((SDANT + AQUIS) - BAIXAS) picture "999999.99"

      @ 16,16 say MINIMO                     picture "999999.99"
      @ 17,16 say RESSUP                     picture "999999.99"

      @ 19,16 say CUSTO                      picture "@R@E 999,999.99"

      WCOD_GRP = COD_GRP 

      select GRUPO  
      ordsetfocus('SINC001')
      seek WCOD_GRP

      @ 09,22 say space(32)
      @ 09,22 say "<"+alltrim(GRUPO)+">" 

      select PRODUTOS

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
                         
*********************
function EXC_PRODUTOS
*********************

do while .t.

   sc_PRODUTO ()     

   WCODIGO = space(08)

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 02,16 get WCODIGO picture "99999999"
   read_f()

   if empty(WCODIGO) .or. lastkey() == 27
      return .t.
   endif

   select PRODUTOS
   ordsetfocus('SINC001')
   seek val(WCODIGO)

   if ! found()
      mensagem("C"+chr(162)+"digo de produto n"+chr(132)+"o cadastrado!")
      loop
   endif

   setcolor(COR_TEXT)

   @ 04,16 say PRODUTO 
   @ 05,16 say REF
   @ 06,16 say UN      
   @ 07,16 say VOLUME                     picture "@Z 999"  

   @ 09,16 say COD_GRP                    picture "999"

   @ 11,16 say SDANT                      picture "999999.99"   
   @ 12,16 say AQUIS                      picture "999999.99"   
   @ 13,16 say BAIXAS                     picture "999999.99"   
   @ 14,16 say ((SDANT + AQUIS) - BAIXAS) picture "999999.99"

   @ 16,16 say MINIMO                     picture "999999.99"
   @ 17,16 say RESSUP                     picture "999999.99"

   @ 19,16 say CUSTO                      picture "@R@E 999,999.99"

   WCOD_GRP = COD_GRP

   select GRUPO   
   ordsetfocus('SINC001')
   seek WCOD_GRP

   @ 09,22 say space(32)
   @ 09,22 say "<"+alltrim(GRUPO)+">" 

   setcolor(COR_CONS)
   if CONFIRMA(24,"Excluir este produto...(S/N)?","N") == "S"

      select PRODUTOS

      if ! reglock()
         loop
      endif
                       
      replace CODIGO  with space(08),;   
              PRODUTO with space(40),;   
              REF     with space(20),;   
              UN      with space(02),;   
              VOLUME  with 0,;
              COD_GRP with space(03),;   
              SDANT   with 0,;   
              AQUIS   with 0,;   
              BAIXAS  with 0,;  
              MINIMO  with 0,;   
              RESSUP  with 0,;   
              CUSTO   with 0        
      delete
      grava()
  
   endif

enddo

return .t.
	
**********************
function save_PRODUTOS
**********************

select PRODUTOS

if ! reglock()
   return .f.
endif

replace CODIGO  with WCODIGO,;
        PRODUTO with WPRODUTO,;
        REF     with WREF,;
        UN      with WUN,;
        VOLUME  with WVOLUME,;
        COD_GRP with WCOD_GRP,;
        SDANT   with WSDANT,;
        AQUIS   with WAQUIS,;
        BAIXAS  with WBAIXAS,;
        MINIMO  with WMINIMO,;
        RESSUP  with WRESSUP,;
        CUSTO   with WCUSTO
grava()

return .t.

**************
function sc_OE
**************

setcolor(COR_CONS)
@ 00,00 clear to 00,79
@ 00,22 say "REQUISI"+chr(128)+chr(142)+"O DE ENTRADA DE ESTOQUE"

setcolor(COR_TEXT)
@ 01,00 clear to 22,79
@ 24,00 clear to 24,79

@ 01,01 say "Requisi"+chr(135)+chr(132)+"o.:                   Documento:                  Entrada:"
@ 02,01 say "Fornecedor.:     -"
@ 03,01 say "C.Custo....:     -"
@ 04,01 say "Observa"+chr(135)+chr(132)+"o.:"

SOMBRA(07,03,22,79,8)

setcolor(COR_CONS)
@ 07,01 clear to 21,78

setcolor(COR_NEG)
@ 06,01 clear to 06,78
@ 06,01 say "CODIGO"
@ 06,10 say "PRODUTO"
@ 06,43 say "UN"
@ 06,51 say "QTDE"
@ 06,59 say "UNITARIO"
@ 06,74 say "TOTAL"

setcolor(COR_TEXT)

return .t.


*******************
function PRODUTOS_A
*******************
PUBLIC vCODIGO[99] 
PUBLIC vQTDE[99] 
PUBLIC vUNITARIO[99] 

afill(vCODIGO,space(08))
afill(vQTDE,0)
afill(vUNITARIO,0)

return .t.


****************************
function CARREGA_PROD(WTIPO)
****************************  
LOCAL X := 1

if WTIPO == "E"
   select ITENS_E
elseif WTIPO == "S"
   select ITENS_S
endif
ordsetfocus('SINC001')
seek WSEQ

do while SEQ == WSEQ .and. ! eof()
   vCODIGO[X]   = CODIGO
   vQTDE[X]     = QTDE
   vUNITARIO[X] = UNITARIO
  
   X++

   skip +1
enddo

return .t.

*********************
function INC_OUTRAS_E
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   sc_OE()

   WSEQ     = 0 
   WDOCNO   = space(10)
   WENTRADA = DATE()
   WCOD_FOR = 0
   WCCUSTO  = 0 
   WFORNEC  = space(40)
   WOBS     = space(50)

   PRODUTOS_A()
 
   select OUTRAS_E
   ordsetfocus('SINC001')
   go bottom
   
   WSEQ = SEQ + 1

   setcolor(COR_TEXT)
   @ 01,14 say strzero(WSEQ,6)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 01,43 get WDOCNO
      @ 01,69 get WENTRADA
      
      @ 02,14 get WCOD_FOR picture "@Z 9999" valid win_FORNEC(3)
      @ 03,14 get WCCUSTO  picture "@Z 9999" valid win_CTO(03,19)
      
      @ 04,14 get WOBS   
      read_f()
        
      if lastkey() == 27
         restscreen(00,00,24,79,WBOX)
         return .t.
      endif
         
      WLIN = 07

      for I = 1 to 99

          setcolor(COR_CONS+","+COR_NEG+",,,"+COR_CONS)

          @ WLIN,01 get vCODIGO[I]    picture "99999999"                                         valid seek_P(I)
          @ WLIN,47 get vQTDE[I]      picture "@Z 99999.99"        when vCODIGO[I] <> "99999999" valid ! empty(vQTDE[I])
          @ WLIN,56 get vUNITARIO[I]  picture "@R@E@Z 9999,999.99" when vCODIGO[I] <> "99999999" valid ! empty(vUNITARIO[I]) .and. TOT_MOV(I)
          read_f()

          if lastkey() == 27
             setcolor(COR_TEXT)
             restscreen(00,00,24,79,WBOX)
             return .t.
          endif
            
          if lastkey() <> 5 .and. vCODIGO[I] = replicate("9",8)
             @ WLIN,01 say space(08)
             exit
          endif
         
          WLIN++

          if WLIN > 21
             WLIN = 21
             scroll(07,01,21,78,1)
          endif
      next

      if lastkey() = 27
         if ! empty(vCODIGO[1])
            if QUESTION("Cancelar a digita"+chr(135)+chr(132)+"o dos dados?") == "N"
               loop
            endif
         endif   
         setcolor(COR_TEXT)
         restscreen(00,00,24,79,WBOX)
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") == "S"                                                               

         select OUTRAS_E
         ordsetfocus('SINC001')
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

         WSEQ = isUNIQUE(WSEQ, "SEQ")
 
         if empty(WSEQ)
           MENSAGEM("ERRO AO INCLUIR O REGISTRO.",0)
           if reglock()
              delete()
              grava()
           endif
           return .f.
        endif

        save_OUT_E("BX")
       
        setcolor(COR_TEXT)
        @ 02,14 say strzero(WSEQ,6)
       
        inkey(3)

        exit

      endif

   enddo

enddo

return .t.

******************
function seek_P(I)
******************
LOCAL LIN := ROW()

if lastkey() == 27
   return .t.
endif

if vCODIGO[I] == replicate("9",8)
   setcolor(COR_CONS)
   @ LIN,10 say space(32)           
   @ LIN,43 say space(02)
   @ LIN,46 say space(08)
   @ LIN,55 say space(12)
   @ LIN,68 say space(11)
   return .t.
endif

if empty(vCODIGO[I])
   help_PRODUTOS()
   return .f.
endif

select PRODUTOS
ordsetfocus('SINC001')
seek val(vCODIGO[I])

if ! found()
   mensagem("C"+chr(162)+"digo de produto n"+chr(132)+"o cadastrado!")
   return .f.
endif

vUNITARIO[I] = CUSTO      

setcolor(COR_CONS)
@ LIN,10 say left(PRODUTO,32)
@ LIN,43 say UN          
@ LIN,56 say vUNITARIO[I] picture "@R@E@Z 9999,999.99" 

Keyboard ""

return .t.

*******************
function TOT_MOV(I)
*******************

setcolor(COR_CONS)
@ ROW(),68 say (vQTDE[I] * vUNITARIO[I]) picture "@R@E@Z 9999,999.99"

WTOT = 0

for I=1 to 99
    WTOT = WTOT + (vQTDE[I] * vUNITARIO[I])
next

setcolor(COR_NEG)
@ 22,55 say "TOTAL R$:"
@ 22,65 say WTOT picture "@R@E 999,999,999.99" 
setcolor(COR_CONS)

return .t.

*********************
function ALT_OUTRAS_E
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   sc_OE()

   WSEQ = 0 

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 01,14 get WSEQ picture "@Z 999999"
   read_f()
   @ 01,14 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   select OUTRAS_E
   ordsetfocus('SINC001')
   seek WSEQ

   if ! found()
      mensagem("Requisi"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!")
      loop
   endif

   WDOCNO   = DOCNO
   WENTRADA = ENTRADA
   WCOD_FOR = COD_FOR
   WCCUSTO  = CCUSTO  
   WOBS     = OBS
  
   select FORNEC
   ordsetfocus("SINC001")   
   seek WCOD_FOR

   if found()
      @ 02,19 say space(40)
      @ 02,19 say alltrim(FORNEC)
   else
      @ 02,19 say space(40)
   endif

   select CUSTO
   ordsetfocus('SINC001')
   seek WCCUSTO

   if found()
      @ 03,19 say space(30)
      @ 03,19 say NOME
   else
      @ 03,19 say space(30)
   endif
 
   WLIN = 7
 
   select ITENS_E
   ordsetfocus('SINC001')
   seek WSEQ

   do while SEQ == WSEQ .and. ! eof()

      setcolor(COR_CONS)

      @ WLIN,01 say CODIGO
      @ WLIN,47 say QTDE              picture "@Z 99999.99" 
      @ WLIN,56 say UNITARIO          picture "@R@E@Z 9999,999.99"
      @ WLIN,68 say (QTDE * UNITARIO) picture "@R@E@Z 9999,999.99"

      WWCOD  = CODIGO

      select PRODUTOS
      ordsetfocus('SINC001')
      seek WWCOD

      @ WLIN,10 say left(PRODUTO,32)
      @ WLIN,43 say UN

      WLIN++

      if WLIN > 21
         exit
      endif

      select ITENS_E
      skip +1

    enddo

    do while .t.

       setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

       @ 01,43 get WDOCNO
       @ 01,69 get WENTRADA
      
       @ 02,14 get WCOD_FOR picture "@Z 9999" valid win_FORNEC(3)
       @ 03,14 get WCCUSTO  picture "@Z 9999" valid win_CTO(03,19)
      
       @ 04,14 get WOBS   
       read_f()

       if lastkey() == 27
          exit
       endif
       
       PRODUTOS_A()

       WLIN    = 07
       WSCROLL = .f.
        
       CARREGA_PROD("E")

       for I = 1 to 99
           setcolor(COR_CONS+",W+/R,,,"+COR_CONS)

           @ WLIN,01 get vCODIGO[I] valid seek_P(I)

           if WSCROLL .and. ! empty(vCODIGO[I])

              select PRODUTOS
              ordsetfocus('SINC001')
              seek vCODIGO[I]

              @ WLIN,10 say left(PRODUTO,32)
              @ WLIN,43 say UN 
              @ WLIN,68 say (vQTDE[I] * vUNITARIO[I]) picture "@R@E@Z 9999,999.99"

              WSCROLL = .f.

           endif
               
           @ WLIN,47 get vQTDE[I]      picture "@Z 99999.99"        when vCODIGO[I] <> "99999999" valid ! empty(vQTDE[I])
           @ WLIN,56 get vUNITARIO[I]  picture "@R@E@Z 9999,999.99" when vCODIGO[I] <> "99999999" valid ! empty(vUNITARIO[I]) .and. TOT_MOV(I)
           read_f()

           if lastkey() == 27
              return .t.
           endif
            
           if lastkey() <> 5 .and. vCODIGO[I] == replicate("9",8)
              @ WLIN,01 say space(08)
              exit
           endif
         
           WLIN++

           if WLIN > 21
              WLIN = 21
              scroll(07,01,21,78,1)
              WSCROLL = .t.
           endif
        next
                                                                                                                            
        if lastkey() == 27
           if QUESTION("Cancelar a altera"+chr(135)+chr(132)+"o dos dados?") == "N"
              loop
           endif
           restscreen(00,00,24,79,WBOX)           
           return .t.
        endif

        setcolor(COR_CONS)

        if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"                                                               
           select OUTRAS_E
           save_OUT_E("ALT")
           exit
        endif

    enddo

enddo

return .t.


*********************
function CON_OUTRAS_E
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   WOPC   = 4
   WTRAVA = .f.

   sc_OE()

   SOMBRA(09,14,18,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 17,66
   @ 08,12 to 17,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do n"+chr(163)+"mero de requisi"+chr(135)+chr(132)+"o.......[3]"
   @ 12,14 say "Consulta a partir do n"+chr(163)+"mero do documento........[4]"
   @ 13,14 say "Consulta a partir da data de emiss"+chr(132)+"o............[5]"
   @ 14,14 say "Retorno ao menu principal.......................[6]"

   setcolor(COR_NEG)
   @ 16,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 16,63 get WOPC picture "9" range 1,6
   read_f()

   setcolor(COR_TEXT)

   if WOPC == 6 .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   sc_OE()

   if WOPC == 1
      select OUTRAS_E
      ordsetfocus('SINC001')
      go top

   elseif WOPC == 2
      select OUTRAS_E
      ordsetfocus('SINC001')
      go bottom

   elseif WOPC == 3

      do while .t.

         WSEQ = 0             
 
         setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

         @ 01,14 get WSEQ picture "@Z 999999"
         read_f()

         if ! empty(WSEQ) .or. lastkey() <> 27
            select OUTRAS_E
            ordsetfocus('SINC001')
            seek WSEQ

            if ! found()
               mensagem("Requisi"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!")
               loop
            endif

         else
            WTRAVA = .t.
         endif

      exit
      enddo

   elseif WOPC == 4

      do while .t.

         WDOCNO = space(10)
 
         setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

         @ 01,43 get WDOCNO
         read_f()

         if ! empty(WDOCNO) .or. lastkey() <> 27
            select OUTRAS_E
            ordsetfocus('SINC002')
            seek WDOCNO

            if ! found()
               mensagem("N"+chr(163)+"mero de documento n"+chr(132)+"o cadastrado!",0)
               loop
            endif

         else
            WTRAVA = .t.
         endif

      exit
      enddo

   elseif WOPC == 5

      WENTRADA = DATE()

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
 
      @ 01,69 get WENTRADA
      read_f()

      if ! empty(WENTRADA) .or. lastkey() <> 27
         select OUTRAS_E
         ordsetfocus('SINC003')
         seek WENTRADA

         if eof()
            skip -1
         endif
      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.                      

      sc_OE()

      setcolor(COR_TEXT)       
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    I-Itens    ESC-Retornar")
 
      select OUTRAS_E

      @ 01,14 say strzero(SEQ,6)
      @ 01,43 say DOCNO
      @ 01,69 say ENTRADA
      @ 02,14 say COD_FOR  picture "9999"
      @ 03,14 say CCUSTO   picture "9999"
      @ 04,14 say OBS  
      
      WSEQ     = SEQ 
      WCOD_FOR = COD_FOR  
      WCCUSTO  = CCUSTO  

      select FORNEC
      ordsetfocus("SINC001")   
      seek WCOD_FOR
   
      if found()
         @ 02,19 say space(40)
         @ 02,19 say alltrim(FORNEC)
      else
         @ 02,19 say space(40)
      endif
   
      select CUSTO
      ordsetfocus('SINC001')
      seek WCCUSTO
   
      if found()
         @ 03,19 say space(30)
         @ 03,19 say NOME
      else
         @ 03,19 say space(30)
      endif
 
      WLIN = 7

      select ITENS_E
      ordsetfocus('SINC001')
      seek WSEQ

      do while SEQ == WSEQ .and. ! eof()

         setcolor(COR_CONS)

         @ WLIN,01 say CODIGO
         @ WLIN,47 say QTDE              picture "@Z 99999.99" 
         @ WLIN,56 say UNITARIO          picture "@R@E@Z 9999,999.99"
         @ WLIN,68 say (QTDE * UNITARIO) picture "@R@E@Z 9999,999.99"

         WWCOD  = CODIGO

         select PRODUTOS
         ordsetfocus('SINC001')
         seek WWCOD

         @ WLIN,10 say left(PRODUTO,32)
         @ WLIN,43 say UN

         WLIN++

         if WLIN > 21
            exit
         endif

         select ITENS_E
         skip +1

      enddo

      tTOTAL = busca_TOTAL("E")

      setcolor(COR_NEG)
      @ 22,55 say "TOTAL R$:"
      @ 22,68 say tTOTAL picture "@R@E@Z 9999,999.99" 
      setcolor(COR_TEXT) 

      select OUTRAS_E

      inkey(0)

      if lastkey() == 3
         skip +1

         if eof()
            skip -1
         endif
      elseif lastkey() == 18
         skip -1
      elseif lastkey() == 27
         exit
      elseif lastkey() == 73 .or. lastkey() == 105   // Ii-Itens
         busca_ITENS(WSEQ,"E")
      endif

   enddo

enddo

return .t.


***************************
function busca_TOTAL(WTIPO)
***************************   

tTOTAL = 0

if WTIPO == "E"
   select ITENS_E
elseif WTIPO == "S"
   select ITENS_S
endif
ordsetfocus('SINC001')
seek WSEQ

do while SEQ == WSEQ .and. ! eof()

   tTOTAL = tTOTAL + (QTDE * UNITARIO)
   skip +1

enddo

return tTOTAL


*********************************
function busca_ITENS(WSEQ, WTIPO)
*********************************
LOCAL WAREA := alias()

************************************************************************************************* cria a tabela temporaria
      
WARQ  := WDIRE_TEMP+"\TAB"+strzero(HB_RandomInt(999,99999),5)
WCMP  := {"CODIGO", "PRODUTO", "UN" , "QTDE", "UNITARIO"}
WTPO  := {"C"     , "C"      , "C"  , "N"   , "N"       } 
WTMO  := {08      , 32       , 03   , 14    , 14        }
WDEC  := {00      , 00       , 00   , 02    , 02        }
WIDX1 := ""
WIDX2 := ""

cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2)

************************************************************************************************************************** 

if WTIPO == "E"
   select ITENS_E
elseif WTIPO == "S"
   select ITENS_S
endif
ordsetfocus("SINC001")
seek WSEQ

do while SEQ == WSEQ .and. ! eof()

   WCODIGO   = CODIGO   
   WQTDE     = QTDE     
   WUNITARIO = UNITARIO 

   select PRODUTOS
   ordsetfocus("SINC001")
   seek WCODIGO

   WPRODUTO = left(PRODUTO,32)
   WUN      = UN 

   select TMP
   DBAPPEND()

   replace CODIGO   with WCODIGO,;
           PRODUTO  with WPRODUTO,;
           UN       with WUN,;
           QTDE     with WQTDE,;
           UNITARIO with WUNITARIO

   if WTIPO == "E"
      select ITENS_E
   elseif WTIPO == "S"
      select ITENS_S
   endif

   skip +1 
   
enddo

select TMP
ordsetfocus("SINC001")
go top

private aCAMPO :={{"CODIGO+space(01)+PRODUTO+space(01)+UN+space(01)+transform(QTDE,'@Z 99999.99')+space(01)+transform(UNITARIO,'@R@E@Z 9999,999.99')+space(01)+transform((QTDE * UNITARIO),'@R@E@Z 9999,999.99')","",""}}

BRW_ITENS(07,01,21,78,aCAMPO,WTIPO)

setcolor(COR_TEXT)

exclui_TMP("201", WARQ+ ".DBF", WARQ+ ".CDX")

select &WAREA
   
return .t.


*********************************************************************
function BRW_ITENS(BRW_LS, BRW_CS, BRW_LI, BRW_CI, BRW_CAMPOS, WTIPO)
*********************************************************************
LOCAL oTBrowse, oTBColumn
LOCAL bFieldBlock, cFieldName, i, nKey

// create TBrowse object
oTBrowse           := TBrowse():new( BRW_LS, BRW_CS, BRW_LI, BRW_CI)
oTBrowse:colorSpec := COR_CONS+",W+/R,,,"+COR_CONS

// add code blocks for navigating the record pointer
oTBrowse:goTopBlock    := {|| DbGoTop() }
oTBrowse:goBottomBlock := {|| DbGoBottom() }
oTBrowse:skipBlock     := {|nSkip| DbSkipper(nSkip) }

// create TBColumn objects and add them to TBrowse object
for i:=1 to len(BRW_CAMPOS)
   cp_titu := brw_campos[i,3]
   cp_masc := brw_campos[i,2]
   cp_     := brw_campos[i,1]
   
   oTBColumn := TBColumn():new("",&("{||transform("+cp_+",["+cp_masc+"])}"))
   oTBrowse:addColumn( oTBColumn )
   oTBrowse:getcolumn(i):width := len(transform(&cp_.,cp_masc))

   oTBrowse:getcolumn(i):colorblock=&("{||{1,2}}")
  
next

// display browser and process user input 
do while .t.
   oTBrowse:forceStable()

   WLIN = row()
  
   if oTBrowse:colpos == 1
      setcolor("W/N")
      @ BRW_LS-1,01 clear to BRW_LS-1,78
 
      @ BRW_LS-1,01 say "CODIGO"

      if WTIPO == "E"
         @ BRW_LS-1,10 say "PRODUTO"
      elseif WTIPO == "S"
         @ BRW_LS-1,10 say "PRODUTO/SERVI"+chr(128)+"O"
      endif
      @ BRW_LS-1,43 say "UN"
      @ BRW_LS-1,51 say "QTDE"
      @ BRW_LS-1,59 say "UNITARIO"
      @ BRW_LS-1,74 say "TOTAL"

      setcolor(COR_TEXT)                
      
      @ 24,00 clear to 24,79
      CENTRO(24,chr(25)+chr(24)+"-Navega"+chr(135)+chr(132)+"o    ESC-Retornar") 
   
   endif

   nKEY := inkey(0)

   if oTBrowse:applyKey( nKEY ) == TBR_EXIT
      exit
   endif 

   oTBrowse:refreshCurrent() 
   
enddo

return .t.


*********************
function EXC_OUTRAS_E
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   sc_OE()

   WSEQ = 0 

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 01,14 get WSEQ picture "@Z 999999"
   read_f()
   @ 01,14 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   select OUTRAS_E
   ordsetfocus('SINC001')
   seek WSEQ

   if ! found()
      mensagem("Requisi"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!")
      loop
   endif

   @ 01,43 say DOCNO
   @ 01,69 say ENTRADA
   @ 02,14 say COD_FOR  picture "9999"
   @ 03,14 say CCUSTO   picture "9999" 
   @ 04,14 say OBS  
  
   WCOD_FOR = COD_FOR 
   WCCUSTO  = CCUSTO 

   select FORNEC
   ordsetfocus("SINC001")   
   seek WCOD_FOR

   if found()
      @ 02,19 say space(40)
      @ 02,19 say alltrim(FORNEC)
   else
      @ 02,19 say space(40)
   endif

   select CUSTO
   ordsetfocus('SINC001')
   seek WCCUSTO

   if found()
      @ 03,19 say space(30)
      @ 03,19 say NOME
   else
      @ 03,19 say space(30)
   endif
 
   WLIN = 7

   select ITENS_E
   ordsetfocus('SINC001')
   seek WSEQ

   do while SEQ == WSEQ .and. ! eof()

      setcolor(COR_CONS)

      @ WLIN,01 say CODIGO           
      @ WLIN,47 say QTDE              picture "@Z 99999.99" 
      @ WLIN,56 say UNITARIO          picture "@R@E@Z 9999,999.99" 
      @ WLIN,68 say (QTDE * UNITARIO) picture "@R@E@Z 9999,999.99"

      WCOD = CODIGO

      select PRODUTOS
      ordsetfocus('SINC001')
      seek WCOD

      @ WLIN,10 say left(PRODUTO,32)
      @ WLIN,43 say UN

      WLIN++

      if WLIN > 21
         exit
      endif

      select ITENS_E
      skip +1

   enddo

   tTOTAL = busca_TOTAL()

   setcolor(COR_NEG)
   @ 22,55 say "TOTAL R$:"
   @ 22,68 say tTOTAL picture "@R@E@Z 9999,999.99" 

   setcolor(COR_TEXT)
   if CONFIRMA(24,"Excluir essa requisi"+chr(135)+chr(132)+"o de entrada...(S/N)?","N") = "S"                                                               

      select OUTRAS_E

      if ! reglock() 
         loop
      endif

      replace SEQ     with 0,;
              DOCNO   with space(10),;
              ENTRADA with ctod(space(08)),;
              COD_FOR with 0,;
              CCUSTO  with 0,;
              OBS     with space(50)   
      delete
      grava()

      // deleta todas as entradas 

      select ITENS_E
      ordsetfocus('SINC001')
      seek WSEQ

      do while SEQ == WSEQ .and. ! eof()

         if ! reglock()
            skip +1
            loop
         endif             

         WCOD = CODIGO
         WQTD = QTDE

         replace SEQ      with 0        ,;
                 CODIGO   with space(08),; 
                 QTDE     with 0        ,;
                 UNITARIO with 0        
         delete
         grava()

         // retira as entradas de produtos do estoque 

         select PRODUTOS
         ordsetfocus('SINC001')
         seek val(WCOD)

         if found()
            if reglock()
               replace AQUIS with AQUIS - WQTD

               if AQUIS < 0
                  replace AQUIS with 0
               endif

               grava()
            endif
         endif

         select ITENS_E
         seek WSEQ

      enddo

   endif

enddo

return .t.


*************************
function save_OUT_E(WACT)
*************************

select OUTRAS_E

if ! reglock()
   return .t.
endif

replace SEQ     with WSEQ,;  
        DOCNO   with WDOCNO,;
        ENTRADA with WENTRADA,;
        COD_FOR with WCOD_FOR,;
        CCUSTO  with WCCUSTO,;
        OBS     with WOBS     
grava()

if WACT == "ALT"

   // deleta todas as entradas 

   select ITENS_E
   ordsetfocus('SINC001')
   seek WSEQ

   do while SEQ == WSEQ .and. ! eof()

      if ! reglock()
         skip +1
         loop
      endif             

      WCOD = CODIGO
      WQTD = QTDE

      replace SEQ      with 0,;
              CODIGO   with space(08),; 
              QTDE     with 0,;
              UNITARIO with 0        
      
      delete
      grava()  

      select PRODUTOS
      ordsetfocus('SINC001')
      seek val(WCOD)

      if found()
         if reglock()
            replace AQUIS with AQUIS - WQTD

            if AQUIS < 0
               replace AQUIS with 0
            endif

            grava()
         endif
      endif     
      
      select ITENS_E
      seek WSEQ

   enddo

endif 

for I=1 to 99

  if empty(vCODIGO[I])
     exit
  endif
 
  if vCODIGO[I] == replicate("9",8)
     loop
  endif

  do while .t.

     select ITENS_E

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
  exit
  enddo

  replace SEQ      with WSEQ,;
          CODIGO   with vCODIGO[I],;
          QTDE     with vQTDE[I],;
          UNITARIO with vUNITARIO[I]

  // gera a entrada de produtos no estoque 

  select PRODUTOS
  ordsetfocus('SINC001')
  seek val(vCODIGO[I])

  if found()
     if reglock()
        replace AQUIS with AQUIS + vQTDE[I],;
                CUSTO with vUNITARIO[I]    
        grava()
     endif
  endif

next I

return .t.


**************
function sc_OS
**************

setcolor(COR_TEXT)
@ 00,00 clear to 22,79
@ 24,00 clear to 24,79

setcolor(COR_CONS)
@ 00,00 clear to 00,79
@ 00,23 say "REQUISI"+chr(128)+chr(142)+"O DE SAIDA DE PRODUTOS/SERVI"+chr(128)+"OS"

setcolor(COR_TEXT)
@ 01,00 clear to 22,79

@ 02,01 say "Requisi"+chr(135)+chr(132)+"o:                    Documento:                      Saida:"
@ 03,01 say "C.Custo...:     -"
@ 04,01 say "Observa"+chr(135)+chr(132)+"o:"

SOMBRA(07,03,22,79,8)

setcolor(COR_NEG)
@ 06,01 clear to 06,78
@ 06,01 say "CODIGO"
@ 06,10 say "PRODUTO/SERVI"+chr(128)+"O"
@ 06,43 say "UN"
@ 06,51 say "QTDE"
@ 06,59 say "UNITARIO"
@ 06,74 say "TOTAL"

setcolor(COR_CONS)
@ 07,01 clear to 21,78
setcolor(COR_TEXT)

return .t.


*********************
function INC_OUTRAS_S
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   sc_OS()

   WSEQ    = 0 
   WDOCNO  = space(10)
   WSAIDA  = DATE()
   WCCUSTO = 0
   WOBS    = space(50)

   PRODUTOS_A()
  
   select OUTRAS_S
   ordsetfocus('SINC001')
   go bottom
   
   WSEQ = SEQ + 1

   setcolor(COR_TEXT)
   @ 02,13 say strzero(WSEQ,6)

   do while .t.

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

      @ 02,43 get WDOCNO
      @ 02,71 get WSAIDA  
      @ 03,13 get WCCUSTO picture "@Z 9999" valid win_CTO(03,18)
      @ 04,13 get WOBS       
      read_f()
        
      if lastkey() == 27
         restscreen(00,00,24,79,WBOX)
         return .t.
      endif
         
      WLIN = 07

      for I = 1 to 99
         
          setcolor(COR_CONS+","+COR_NEG+",,,"+COR_CONS)

          @ WLIN,01 get vCODIGO[I]                                                               valid seek_P(I)
          @ WLIN,47 get vQTDE[I]      picture "@Z 99999.99"        when vCODIGO[I] <> "99999999" valid ! empty(vQTDE[I])
          @ WLIN,56 get vUNITARIO[I]  picture "@R@E@Z 9999,999.99" when vCODIGO[I] <> "99999999" valid ! empty(vUNITARIO[I]) .and. TOT_MOV(I)
          read_f()

          if lastkey() == 27
             setcolor(COR_TEXT)
             restscreen(00,00,24,79,WBOX)
             return .t.
          endif
            
          if lastkey() <> 5 .and. vCODIGO[I] = replicate("9",8)
             @ WLIN,01 say space(08)
             exit
          endif
         
          WLIN++

          if WLIN > 21
             WLIN = 21
             scroll(07,01,21,78,1)
          endif

      next
                                                                                                              
      setcolor(COR_TEXT)

      if lastkey() == 27
         if ! empty(vCODIGO[1])
            if QUESTION("Cancelar a digita"+chr(135)+chr(132)+"o dos dados?") == "N"
               loop
            endif
         endif   
         restscreen(00,00,24,79,WBOX)
         return .t.
      endif

      if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"                                                               

         select OUTRAS_S
         ordsetfocus('SINC001')
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

         WSEQ = isUNIQUE(WSEQ, "SEQ")
 
         if empty(WSEQ)
            MENSAGEM("ERRO AO INCLUIR O REGISTRO.",0)
            if reglock()
               delete()
               grava()
            endif
            return .f.
         endif

         save_OUT_S("BX")

         setcolor(COR_TEXT)
         @ 02,13 say strzero(WSEQ,6)

         inkey(3)

         exit

      endif

    enddo

enddo

return .t.

***********************
function win_CTO(LL,CC)
***********************
LOCAL  WAREA := alias()

if lastkey() == 27 
   return .t.
endif

if WCCUSTO == 999
   @ LL,CC say "GERAL"+space(25)
   return .t.
endif 

if empty(WCCUSTO)
   help_CCUSTO()
   select &WAREA
   return .f.
endif

select CUSTO
ordsetfocus('SINC001')
seek WCCUSTO

if ! found()
   mensagem("C"+chr(162)+"digo de centro de custo n"+chr(132)+"o cadastrado!")
   select &WAREA
   return .f.
endif  

@ LL,CC say NOME

select &WAREA

return .t.


*********************
function ALT_OUTRAS_S
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   sc_OS()

   WSEQ = 0 

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 02,13 get WSEQ picture "@Z 999999"
   read_f()
   @ 02,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() == 27
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   select OUTRAS_S
   ordsetfocus('SINC001')
   seek WSEQ

   if ! found()
      mensagem("Requisi"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!")
      loop
   endif
  
   WDOCNO  = DOCNO
   WSAIDA  = SAIDA  
   WCCUSTO = CCUSTO
   WOBS    = OBS 
   
   select CUSTO
   ordsetfocus('SINC001')
   seek WCCUSTO

   if found()
      @ 03,18 say space(30)
      @ 03,18 say NOME
   else
      @ 03,18 say space(30)
   endif
 
   WLIN = 7

   select ITENS_S
   ordsetfocus('SINC001')
   seek WSEQ

   do while SEQ == WSEQ .and. ! eof()

      setcolor(COR_CONS)

      @ WLIN,01 say CODIGO
      @ WLIN,47 say QTDE              picture "@Z 99999.99" 
      @ WLIN,56 say UNITARIO          picture "@R@E@Z 9999,999.99"
      @ WLIN,68 say (QTDE * UNITARIO) picture "@R@E@Z 9999,999.99"

      WCOD  = CODIGO

      select PRODUTOS
      ordsetfocus('SINC001')
      seek val(WCOD)

      @ WLIN,10 say left(PRODUTO,32)
      @ WLIN,43 say UN

      WLIN++

      if WLIN > 22
         exit
      endif

      select ITENS_S
      skip +1

    enddo

    do while .t.

       setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
      
       @ 02,43 get WDOCNO
       @ 02,71 get WSAIDA  
       @ 03,13 get WCCUSTO picture "@Z 9999" valid win_CTO(03,18)
       @ 04,13 get WOBS       
       read_f()

       if lastkey() == 27
          exit
       endif
 
       PRODUTOS_A()

       WLIN = 07
       WSCROLL = .f.
            
       CARREGA_PROD("S")

       for I = 1 to 99
  
           setcolor(COR_CONS+","+COR_NEG+",,,"+COR_CONS)

           @ WLIN,01 get vCODIGO[I]    valid seek_P(I)
            
           if WSCROLL .and. ! empty(vCODIGO[I])

              select PRODUTOS
              ordsetfocus('SINC001')
              seek val(vCODIGO[I])

              @ WLIN,10 say left(PRODUTO,32)
              @ WLIN,43 say UN 
              @ WLIN,68 say (vQTDE[I] * vUNITARIO[I]) picture "@R@E@Z 9999,999.99"

              WSCROLL = .f.

           endif
            
           @ WLIN,47 get vQTDE[I]      picture "@Z 99999.99"        when vCODIGO[I] <> "99999999" valid ! empty(vQTDE[I])
           @ WLIN,56 get vUNITARIO[I]  picture "@R@E@Z 9999,999.99" when vCODIGO[I] <> "99999999" valid ! empty(vUNITARIO[I]) .and. TOT_MOV(I)
           read_f()

           if lastkey() == 27
              restscreen(00,00,24,79,WBOX)
              return .t.
           endif
            
           if lastkey() <> 5 .and. vCODIGO[I] = replicate("9",8)
              @ WLIN,01 say space(08)
              exit
           endif
         
           WLIN++

           if WLIN > 22
              WLIN = 22
              scroll(07,01,21,78,1)
              WSCROLL = .t.
           endif

         next
                                                                                                                            
        if lastkey() == 27
           if QUESTION("Cancelar a altera"+chr(135)+chr(132)+"o dos dados?") == "N"
              loop
           endif
           restscreen(00,00,24,79,WBOX)
           return .t.
        endif

        setcolor(COR_CONS)

        if CONFIRMA(24,"Dados corretos...(S/N)?","S") = "S"                                                               
           select OUTRAS_S
           save_OUT_S("ALT")
           exit
        endif

    enddo

enddo

return .t.


*********************
function CON_OUTRAS_S
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   WOPC   = 5
   WTRAVA = .f.

   sc_OS()

   SOMBRA(09,14,18,67,8)

   setcolor(COR_CONS)
   @ 08,12 clear to 17,66
   @ 08,12 to 17,66 

   @ 09,14 say "Consulta a partir do inicio do arquivo..........[1]"
   @ 10,14 say "Consulta a partir do final do arquivo...........[2]"
   @ 11,14 say "Consulta a partir do n"+chr(163)+"mero da requisi"+chr(135)+chr(132)+"o.......[3]"
   @ 12,14 say "Consulta a partir do n"+chr(163)+"mero do documento........[4]"
   @ 13,14 say "Consulta a partir da data de emiss"+chr(132)+"o............[5]"
   @ 14,14 say "Retorno ao menu principal.......................[6]"

   setcolor(COR_NEG)
   @ 16,14 say "Escolha sua op"+chr(135)+chr(132)+"o...............................[ ]"
   @ 16,63 get WOPC picture "9" range 1,6
   read_f()

   if WOPC == 6 .or. lastkey() == 27
      setcolor(COR_TEXT)
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   sc_OS()

   if WOPC == 1
      select OUTRAS_S
      ordsetfocus('SINC001')
      go top

   elseif WOPC == 2
      select OUTRAS_S
      ordsetfocus('SINC001')
      go bottom
       
   elseif WOPC == 3

      do while .t.

         WSEQ = 0             
 
         setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

         @ 02,13 get WSEQ picture "@Z 999999"
         read_f()

         if ! empty(WSEQ) .or. lastkey() <> 27
 
            select OUTRAS_S
            ordsetfocus('SINC001')
            seek WSEQ

              if ! found()
                 mensagem("Requisi"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!")
                 loop
              endif
         else
            WTRAVA = .t.
         endif

      exit
      enddo

   elseif WOPC == 4

      do while .t.

         WDOCNO = space(10)
 
         setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

         @ 02,43 get WDOCNO
         read_f()

         if ! empty(WDOCNO) .or. lastkey() <> 27

            select OUTRAS_S
            ordsetfocus('SINC002')
            seek WDOCNO

            if ! found()
               mensagem("N"+chr(163)+"mero de documento n"+chr(132)+"o cadastrado!")
               loop
            endif

         else
            WTRAVA = .t.
         endif

      exit
      enddo

   elseif WOPC == 5

      WENTRADA = DATE()

      setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)
 
      @ 02,71 get WENTRADA
      read_f()

      if ! empty(WENTRADA) .or. lastkey() <> 27
 
         select OUTRAS_S
         ordsetfocus('SINC003')
         seek WENTRADA

         if eof()
            skip -1
         endif

      else
         WTRAVA = .t.
      endif

   endif

   if WTRAVA
      loop
   endif

   do while .t.                      

      sc_OS()

      setcolor(COR_TEXT)
      CENTRO(24,"PgDw-Pr"+chr(162)+"ximo    PgUp-Anterior    I-Itens    ESC-Retornar")
        
      select OUTRAS_S

      @ 02,13 say strzero(SEQ,6)
      @ 02,43 say DOCNO
      @ 02,71 say SAIDA
      @ 03,13 say CCUSTO picture "@Z 9999"
      @ 04,13 say OBS 
      
      WSEQ    = SEQ  
      WCCUSTO = CCUSTO

      select CUSTO
      ordsetfocus('SINC001')
      seek WCCUSTO

      if found()
         @ 03,18 say space(30)
         @ 03,18 say NOME
      else
         @ 03,18 say space(30)
      endi
      
      WLIN = 7
        
      select ITENS_S
      ordsetfocus('SINC001')
      seek WSEQ

      do while SEQ == WSEQ .and. ! eof()

         setcolor(COR_CONS)

         @ WLIN,01 say CODIGO        
         @ WLIN,47 say QTDE              picture "@Z 99999.99" 
         @ WLIN,56 say UNITARIO          picture "@R@E@Z 9999,999.99" 
         @ WLIN,68 say (QTDE * UNITARIO) picture "@R@E@Z 9999,999.99"

         WCOD = CODIGO

         select PRODUTOS
         ordsetfocus('SINC001')
         seek val(WCOD)

         @ WLIN,10 say Left(PRODUTO,32)
         @ WLIN,43 say UN

         WLIN++

         if WLIN > 22
            exit
         endif

         select ITENS_S
         skip +1

      enddo

      tTOTAL = busca_TOTAL("S")

      setcolor(COR_NEG)
      @ 22,55 say "TOTAL R$:"
      @ 22,68 say tTOTAL picture "@R@E@Z 9999,999.99" 
      setcolor(COR_TEXT) 

      select OUTRAS_S

      inkey(0)

      if lastkey() == 3
         skip +1

         if eof()
            skip -1
         endif

      elseif lastkey() == 18
         skip -1

      elseif lastkey() == 27
         exit
     
      elseif lastkey() == 73 .or. lastkey() == 105   // Ii-Itens
        busca_ITENS(WSEQ,"S")
      endif

   enddo

enddo

return .t.


*********************
function EXC_OUTRAS_S
*********************
LOCAL WBOX := savescreen(00,00,24,79)

do while .t.

   sc_OS()

   WSEQ = 0 

   setcolor(COR_TEXT+","+COR_GETS+",,,"+COR_TEXT)

   @ 02,13 get WSEQ picture "@Z 999999"
   read_f()
   @ 02,13 say strzero(WSEQ,6)

   if empty(WSEQ) .or. lastkey() = 27
      restscreen(00,00,24,79,WBOX)
      return .t.
   endif

   select OUTRAS_S
   ordsetfocus('SINC001')
   seek WSEQ

   if ! found()
      mensagem("Requisi"+chr(135)+chr(132)+"o n"+chr(132)+"o cadastrada!")
      loop
   endif
   @ 03,13 say CCUSTO picture "@Z 9999"
   @ 04,13 say OBS 
   
   WCCUSTO = CCUSTO

   select CUSTO
   ordsetfocus('SINC001')
   seek WCCUSTO

   if found()
      @ 03,18 say space(30)
      @ 03,18 say NOME
   else
      @ 03,18 say space(30)
   endif

   WLIN = 7

   select ITENS_S
   ordsetfocus('SINC001')
   seek WSEQ

   do while SEQ == WSEQ .and. ! eof()

      setcolor(COR_CONS)

      @ WLIN,01 say CODIGO      
      @ WLIN,47 say QTDE              picture "@Z 99999.99" 
      @ WLIN,56 say UNITARIO          picture "@R@E@Z 9999,999.99" 
      @ WLIN,68 say (QTDE * UNITARIO) picture "@R@E@Z 9999,999.99"

      WCOD = CODIGO

      select PRODUTOS
      ordsetfocus('SINC001')
      seek val(WCOD)

      if found()
         @ WLIN,10 say left(PRODUTO,32)
         @ WLIN,43 say UN 
      endif

      WLIN++

      if WLIN > 22
         exit
      endif

      select ITENS_S
      skip +1

    enddo

    tTOTAL = busca_TOTAL()

    setcolor(COR_NEG)
    @ 22,55 say "TOTAL R$:"
    @ 22,68 say tTOTAL picture "@R@E@Z 9999,999.99" 
    setcolor(COR_TEXT) 
  
    if CONFIRMA(24,"Excluir essa requisi"+chr(135)+chr(132)+"o de saida...(S/N)?","N") = "S"                                                               

      select OUTRAS_S

      if ! reglock()
         loop
      endif

      replace SEQ    with 0,;
              DOCNO  with space(10),;
              SAIDA  with ctod(space(08)),;
              CCUSTO with 0,;
              OBS    with space(50)
      delete
      grava()

      // deleta todas as saidas   

      select ITENS_S
      ordsetfocus('SINC001')
      seek WSEQ

      do while SEQ == WSEQ .and. ! eof()

         if ! reglock()
            skip +1
            loop
         endif             

         WCOD = CODIGO
         WQTD = QTDE

         replace SEQ      with 0,;
                 CODIGO   with space(08),; 
                 QTDE     with 0,;
                 UNITARIO with 0        
    
         delete
         grava()

         // retira as baixas de produtos do estoque 

         select PRODUTOS
         ordsetfocus('SINC001')
         seek val(WCOD)

         if found()
            if reglock()
               replace BAIXAS with BAIXAS - WQTD

               if BAIXAS < 0
                  replace BAIXAS with 0
               endif

               grava()
            endif
         endif

         select ITENS_S
         seek WSEQ

      enddo

   endif

enddo

return .t.


*************************
function save_OUT_S(WACT)
*************************

select OUTRAS_S

if ! reglock()
   return .t.
endif

replace SEQ    with WSEQ,; 
        DOCNO  with WDOCNO,;
        SAIDA  with WSAIDA,;
        CCUSTO with WCCUSTO,;
        OBS    with WOBS  

grava()

if WACT == "ALT"

   // deleta todas as saidas 
   
   select ITENS_S
   ordsetfocus('SINC001')
   seek WSEQ

   do while SEQ == WSEQ .and. ! Eof()

      if ! reglock()
         skip +1
         loop
      endif             

      WCOD = CODIGO
      WQTD = QTDE

      replace SEQ      with 0,;
              CODIGO   with space(08),; 
              QTDE     with 0,;
              UNITARIO with 0        
      delete
      grava()

      // retira as baixas de produtos do estoque 

      select PRODUTOS
      ordsetfocus('SINC001')
      seek val(WCOD)

      if found()
         if reglock()
            replace BAIXAS with BAIXAS - WQTD
            
            if BAIXAS < 0
               replace BAIXAS with 0
            endif

            grava()
         endif
      endif 

      select ITENS_S
      seek WSEQ

   enddo

endif

for I=1 to 99
 
   if empty(vCODIGO[I])
      exit
   endif
   
   if vCODIGO[I] == "99999999"
      loop
   endif

   select ITENS_S
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
   
   replace SEQ      with WSEQ,;
           CODIGO   with vCODIGO[I],;
           QTDE     with vQTDE[I],;
           UNITARIO with vUNITARIO[I]
   
   // saidas de produtos no estoque 
   
   select PRODUTOS
   ordsetfocus('SINC001')
   seek val(vCODIGO[I])
   
   if found()
      if reglock()
         replace BAIXAS with BAIXAS + vQTDE[I]
         grava()
       endif
   endif 

next I

return .t.

