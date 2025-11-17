*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Programa.....: MFR012.PRG                                  ****
****  Finalidade...: Relatorios de Estoque                       ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************

********************
function rpr_ENTRADA
********************

do while .t.

   WDATA1  = date()
   WDATA2  = date()             
   WGRUPO  = "999"
   WCCUSTO = 999

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Data de entrada inicial......:"
   @ 04,01 say "Data de entrada final........:"
   
   @ 06,01 say "Centro Custo.................:    -"
   @ 08,01 say "Grupo........................:    -"
   
   @ 10,01 say "Confirma a impress"+chr(132)+"o....(S/N)?"

   @ 03,32 get WDATA1                  
   @ 04,32 get WDATA2                valid WDATA2 >= WDATA1
   
   @ 06,32 get WCCUSTO picture "999" valid win_CTO(06,36)
   @ 08,32 get WGRUPO  picture "999" valid win_GRP(08,35)
   read_f()

   if empty(WDATA1) .or. empty(WDATA2) .or. lastkey() == 27
      return .t.
   endif   

   PRN = REDUCAO(10,01,"Confirma a impress"+chr(132)+"o....(S/N)?","N") 

   if lastkey() == 27 .or. PRN == "N"
      loop
   endif 

   WIMP = sel_PRINTER()

   if lastkey() == 27
      loop
   endif 

   if WCCUSTO == 999
      WNCUSTO = "GERAL"
   else   
      select CUSTO
      ordsetfocus('SINC001')
      seek WCCUSTO
  
      if found()
         WNCUSTO = alltrim(NOME)
      else
         WNCUSTO = "NAO CADASTRADO"
      endif
   endif

   AGUARDE()

   ************************************************************************************************* cria a tabela temporaria

   WARQ  := WDIRE_TEMP+"\TAB"+strzero(HB_RandomInt(999,99999),5)
   WCMP  := {"CODIGO", "PRODUTO", "UN", "QTDE", "TOTAL", "GRUPO"} 
   WTPO  := {"C"     , "C"      , "C" , "N"   , "N"    , "C"    } 
   WTMO  := {08      , 40       , 03  , 14    , 14     , 35     }
   WDEC  := {00      , 00       , 00  , 02    , 02     , 00     }
   WIDX1 := "CODIGO"
   WIDX2 := "GRUPO+PRODUTO"
 
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2)
 
   **************************************************************************************************************************

   select OUTRAS_E
   ordsetfocus("SINC003")
   seek WDATA1
 
   do while ENTRADA <= WDATA2 .and. ! eof()

      if WCCUSTO <> 999
         if CCUSTO <> WCCUSTO 
            skip +1
            loop
         endif
      endif

      WSEQ = SEQ

      select ITENS_E
      ordsetfocus("SINC001")
      seek WSEQ

      do while SEQ == WSEQ .and. ! eof()

         WCODIGO = CODIGO
         WQTDE   = QTDE
         WTOTAL  = round((QTDE * UNITARIO),2)

         select PRODUTOS
         ordsetfocus("SINC001")
         seek val(WCODIGO)

         WPRODUTO = PRODUTO
         WUN      = UN
         WCOD_GRP = COD_GRP
         WNOM_GRP = "N/C"

         if WGRUPO <> "999"
            if WCOD_GRP <> WGRUPO
               select ITENS_E
               skip +1
               loop
            endif
         endif
           
         select GRUPO
         ordsetfocus("SINC001")
         seek WCOD_GRP

         if found()
            WNOM_GRP = GRUPO
         endif

         select TMP
         ordsetfocus("SINC001")
         seek WCODIGO

         if found()
            replace QTDE  with QTDE  + WQTDE,;
                    TOTAL with TOTAL + WTOTAL
         else
            dbappend()
            replace CODIGO  with WCODIGO,;
                    PRODUTO with WPRODUTO,;
                    UN      with WUN,;
                    QTDE    with WQTDE,;
                    TOTAL   with WTOTAL,;
                    GRUPO   with WNOM_GRP
         endif

         select ITENS_E
         skip +1

      enddo

      select OUTRAS_E
      skip +1

   enddo

   PAG    = 1
   tSUB   = 0
   tTOTAL = 0
   GRP    = .t.
   CAB    = .t.
 
   if ! Open_OBJ32PRN(1,"R",WIMP)
      return .t.    
   endif

   select TMP
   ordsetfocus("SINC002")
   go top 

   do while ! eof()
      
      if CAB        
         CAB_ENTRADA()
         CAB = .f.
      endif

      if GRP
         oPrinter:newLine()
         Middle_OBJ32PRN("*** "+alltrim(GRUPO)+" ***")
         oPrinter:newLine()
         GRP = .f.
      endif

      oPrinter:setPrc(oPrinter:prow()+1,21) 
      oPrinter:textOut(CODIGO)
      oPrinter:setPrc(oPrinter:prow(),34)
      oPrinter:textOut(PRODUTO)
      oPrinter:setPrc(oPrinter:prow(),79)
      oPrinter:textOut(UN)
      oPrinter:setPrc(oPrinter:prow(),87)
      oPrinter:textOut(transform(QTDE,"99999.99"))
      oPrinter:setPrc(oPrinter:prow(),100)
      oPrinter:textOut(transform(TOTAL,"@R@E 999,999,999.99"))

      tSUB   = tSUB   + TOTAL
      tTOTAL = tTOTAL + TOTAL
      WGROUP = GRUPO

      skip +1

      if GRUPO <> WGROUP .or. eof()
         oPrinter:setPrc(oPrinter:prow()+1,100)
         oPrinter:textOut(replicate("-",14))
         oPrinter:setPrc(oPrinter:prow()+1,100)
         oPrinter:textOut(transform(tSUB,"@R@E 999,999,999.99"))
         oPrinter:newLine()
         tSUB = 0
         GRP = .t.
      endif

      if oPrinter:prow() > 60
         oPrinter:newLine()
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
           
         PAG++
         CAB = .t.
         GRP = .t.
      endif

      if eof()

         if CAB        
            CAB_ENTRADA()
            CAB = .f.
         endif

         if tTOTAL <> 0 
            oPrinter:setPrc(oPrinter:prow()+1,21)
            oPrinter:textOut(replicate("-",93))
            oPrinter:setPrc(oPrinter:prow()+1,21)
            oPrinter:textOut("T O T A L :")
            oPrinter:setPrc(oPrinter:prow(),100)
            oPrinter:textOut(transform(tTOTAL,"@R@E 999,999,999.99"))
         endif
      
         Rodape_OBJ32PRN(PAG)

      endif

   enddo

   Close_OBJ32PRN()
  
   exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )
   select OUTRAS_E

enddo

return .t.

********************
function CAB_ENTRADA
******************** 
   
Cabecalho_OBJ32PRN()
Middle_OBJ32PRN("RELACAO DE ENTRADAS",1)

oPrinter:newLine()
Left_OBJ32PRN("Periodo: "+dtoc(WDATA1)+" a "+dtoc(WDATA2))
Right_OBJ32PRN("C.Custo: "+WNCUSTO)
oPrinter:setPrc(oPrinter:prow()+1,0) 
oPrinter:textOut(replicate("=",137))
oPrinter:setPrc(oPrinter:prow()+1,0) 
oPrinter:textOut("                     CODIGO       PRODUTO                                      UN          QTDE              TOTAL")
oPrinter:setPrc(oPrinter:prow()+1,00) 
oPrinter:textOut(replicate("=",137))
oPrinter:newLine()

return .t.


****************
function win_GRP
****************
parameters pLIN, pCOL

if lastkey() == 27
   return .t.
endif

if WGRUPO == "999"
   @ pLIN,pCOL say "-GERAL"
   return .t.
endif

if empty(WGRUPO)
   help_GRP() 
   return .f. 
endif

select GRUPO
ordsetfocus('SINC001')
seek WGRUPO

if ! found()
   mensagem("C"+chr(162)+"digo de grupo n"+chr(132)+"o cadastrado!")
   return .f.
endif

@ pLIN,pCOL say "-"+alltrim(GRUPO)

return .t.


******************
function rpr_SAIDA
******************

do while .t.

   WDATA1  = date()
   WDATA2  = date()             
   WGRUPO  = "999"
   WCCUSTO = 999

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Data da sa"+chr(161)+"da inicial........:"
   @ 04,01 say "Data da sa"+chr(161)+"da final..........:"

   @ 06,01 say "Centro Custo.................:    -"
   @ 08,01 say "Grupo........................:    -"
   
   @ 11,01 say "Confirma a impress"+chr(132)+"o....(S/N)?"

   @ 03,32 get WDATA1                    
   @ 04,32 get WDATA2                valid WDATA2 >= WDATA1
   
   @ 06,32 get WCCUSTO picture "999" valid win_CTO(06,36)
   @ 08,32 get WGRUPO  picture "999" valid win_GRP(08,35)
   read_f()

   if empty(WDATA1) .or. empty(WDATA2) .or. lastkey() == 27
      return .t.
   endif   

   PRN = REDUCAO(11,01,"Confirma a impress"+chr(132)+"o....(S/N)?","N") 

   if lastkey() == 27 .or. PRN == "N"
      loop
   endif 

   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif 

   if WCCUSTO == 999
      WNCUSTO = "GERAL"
   else   
      select CUSTO
      ordsetfocus('SINC001')
      seek WCCUSTO
  
      if found()
         WNCUSTO = alltrim(NOME)
      else
         WNCUSTO = "NAO CADASTRADO"
      endif
   endif

   AGUARDE()

   ************************************************************************************************* cria a tabela temporaria
 
   WARQ  := WDIRE_TEMP+"\TAB"+strzero(HB_RandomInt(999,99999),5)
   WCMP  := {"CODIGO", "PRODUTO", "UN", "QTDE", "TOTAL", "GRUPO"} 
   WTPO  := {"C"     , "C"      , "C" , "N"   , "N"    , "C"    } 
   WTMO  := {08      , 40       , 03  , 14    , 14     , 35     }
   WDEC  := {00      , 00       , 00  , 02    , 02     , 00     }
   WIDX1 := "CODIGO"
   WIDX2 := "GRUPO+PRODUTO"
 
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2)
 
   **************************************************************************************************************************

   select OUTRAS_S
   ordsetfocus("SINC003")
   seek WDATA1

   do while SAIDA <= WDATA2 .and. ! eof()

      if WCCUSTO <> 999
         if CCUSTO <> WCCUSTO 
            skip +1
            loop
         endif
      endif

      WSEQ = SEQ

      select ITENS_S
      ordsetfocus("SINC001")
      seek WSEQ

      do while SEQ == WSEQ .and. ! eof()

         WCODIGO = CODIGO
         WQTDE   = QTDE
         WTOTAL  = (QTDE * UNITARIO)

         select PRODUTOS
         ordsetfocus("SINC001")
         seek val(WCODIGO)

         WPRODUTO = PRODUTO
         WUN      = UN
         WCOD_GRP = COD_GRP
         WNOM_GRP = "N/C"

         if WGRUPO <> "999"
           if WCOD_GRP <> WGRUPO
              select ITENS_E
              skip +1
              loop
           endif
         endif
           
         select GRUPO
         ordsetfocus("SINC001")
         seek WCOD_GRP

         if found()
            WNOM_GRP = GRUPO
         endif

         select TMP
         ordsetfocus("SINC001")
         seek WCODIGO

         if found()
            replace QTDE  with QTDE  + WQTDE,;
                    TOTAL with TOTAL + WTOTAL
         else
            dbappend()
            replace CODIGO  with WCODIGO,;
                    PRODUTO with WPRODUTO,;
                    UN      with WUN,;
                    QTDE    with WQTDE,;
                    TOTAL   with WTOTAL,;
                    GRUPO   with WNOM_GRP
         endif

         select ITENS_S
         skip +1

      enddo

      select OUTRAS_S
      skip +1

   enddo
    
   PAG    = 1
   tSUB   = 0
   tTOTAL = 0
   GRP    = .t.
   CAB    = .t.

   if ! Open_OBJ32PRN(1,"R",WIMP)
      return .t.    
   endif

   select TMP
   ordsetfocus('SINC002')
   go top 

   do while ! eof()

      if CAB
         CAB_SAIDA()
         CAB = .f.
      endif

      if GRP
         oPrinter:newLine()
         Middle_OBJ32PRN("*** "+alltrim(GRUPO)+" ***")
         oPrinter:newLine()
         GRP = .f.
      endif

      oPrinter:setPrc(oPrinter:prow()+1,21) 
      oPrinter:textOut(CODIGO)
      oPrinter:setPrc(oPrinter:prow(),34)
      oPrinter:textOut(PRODUTO)
      oPrinter:setPrc(oPrinter:prow(),79)
      oPrinter:textOut(UN)
      oPrinter:setPrc(oPrinter:prow(),87)
      oPrinter:textOut(transform(QTDE,"99999.99"))
      oPrinter:setPrc(oPrinter:prow(),100)
      oPrinter:textOut(transform(TOTAL,"@R@E 999,999,999.99"))

      tSUB   = tSUB   + TOTAL
      tTOTAL = tTOTAL + TOTAL
      WGROUP = GRUPO
         
      skip +1

      if GRUPO <> WGROUP .or. eof()
         oPrinter:setPrc(oPrinter:prow()+1,100)
         oPrinter:textOut(replicate("-",14))
         oPrinter:setPrc(oPrinter:prow()+1,100)
         oPrinter:textOut(transform(tSUB,"@R@E 999,999,999.99"))
         oPrinter:newLine()
         tSUB = 0
         GRP = .t.
      endif

      if oPrinter:prow() > 60
         oPrinter:newLine()
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         
         PAG++
         CAB = .t.
         GRP = .t.
      endif

      if eof()

         if CAB
            CAB_SAIDA()
            CAB = .f.
         endif

         if tTOTAL <> 0 
            oPrinter:setPrc(oPrinter:prow()+1,21)
            oPrinter:textOut(replicate("-",93))
            oPrinter:setPrc(oPrinter:prow()+1,21)
            oPrinter:textOut("T O T A L :")
            oPrinter:setPrc(oPrinter:prow(),100)
            oPrinter:textOut(transform(tTOTAL,"@R@E 999,999,999.99"))
         endif
         
         Rodape_OBJ32PRN(PAG)

      endif

   enddo
   
   Close_OBJ32PRN()

   exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )
   select OUTRAS_S

enddo

return .t.

******************
function CAB_SAIDA
******************

Cabecalho_OBJ32PRN()
Middle_OBJ32PRN("RELACAO DE SAIDAS",1)

oPrinter:newLine()
Left_OBJ32PRN("Periodo: "+dtoc(WDATA1)+" a "+dtoc(WDATA2))
Right_OBJ32PRN("C.Custo: "+WNCUSTO)

oPrinter:setPrc(oPrinter:prow()+1,00) 
oPrinter:textOut(replicate("=",137))
oPrinter:setPrc(oPrinter:prow()+1,00)
oPrinter:textOut("                     CODIGO       PRODUTO/SERVICO                              UN          QTDE              TOTAL")
oPrinter:setPrc(oPrinter:prow()+1,00) 
oPrinter:textOut(replicate("=",137))
oPrinter:newLine()

return .t.


********************
function rpr_ESTOQUE
********************

do while .t.
        
   WGRUPO = "999"
   WN_GRP = "GERAL"

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Grupo........................:"
   @ 05,01 say "Confirma a impress"+chr(132)+"o....(S/N)?"

   @ 03,32 get WGRUPO picture "999" valid win_GRP(03,35)
   read_f()

   if lastkey() == 27
      return .t.
   endif   

   PRN = REDUCAO(05,01,"Confirma a impress"+chr(132)+"o....(S/N)?","N") 

   if lastkey() == 27 .or. PRN == "N"
      loop
   endif 

   if WGRUPO <> "999"
      select GRUPO
      ordsetfocus("SINC001")
      seek WGRUPO 

      if found()
         WN_GRP = GRUPO
      endif
   endif

   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif 

   AGUARDE()

   ************************************************************************************************* cria a tabela temporaria
 
   WARQ  := WDIRE_TEMP+"\TAB"+strzero(HB_RandomInt(999,99999),5)
   WCMP  := {"CODIGO", "PRODUTO", "REF", "UN", "MINIMO", "RESSUP", "SALDO", "CUSTO", "TOTAL", "GRUPO"} 
   WTPO  := {"C"     , "C"      , "C"  , "C" , "N"     , "N"     , "N"    , "N"    , "N"    , "C"    } 
   WTMO  := {08      , 40       , 20   , 03  , 14      , 14      , 14     , 14     , 14     , 35     }
   WDEC  := {00      , 00       , 00   , 00  , 02      , 02      , 02     , 04     , 02     , 00     }
   WIDX1 := "GRUPO+PRODUTO"
   WIDX2 := ""
 
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2)
 
   **************************************************************************************************************************

   select PRODUTOS
   ordsetfocus("SINC002")
   go top 

   do while ! eof()

      if WGRUPO <> "999"
         if WCOD_GRP <> WGRUPO
            skip +1
            loop
         endif
      endif

      WCODIGO  = CODIGO 
      WPRODUTO = PRODUTO
      WREF     = REF  
      WUN      = UN
      WSALDO   = ((SDANT + AQUIS) - BAIXAS)
      WMINIMO  = MINIMO 
      WRESSUP  = RESSUP 
      WCUSTO   = CUSTO
      WTOTAL   = (WSALDO * WCUSTO) 
      WCOD_GRP = COD_GRP
      WNOM_GRP = "N/C"

      select GRUPO
      ordsetfocus("SINC001")
      seek WCOD_GRP

      if found()
         WNOM_GRP = GRUPO
      endif

      select TMP
      dbappend()
      replace CODIGO  with WCODIGO,;
              PRODUTO with WPRODUTO,;
              REF     with WREF,;
              UN      with WUN,;
              SALDO   with WSALDO,;
              MINIMO  with WMINIMO,;
              RESSUP  with WRESSUP,;
              CUSTO   with WCUSTO,;
              TOTAL   with WTOTAL,;
              GRUPO   with WNOM_GRP
 
      select PRODUTOS 
      skip +1

   enddo
    
   PAG    = 1
   tSUB   = 0
   tTOTAL = 0
   GRP    = .t.
   CAB    = .t.

   if ! Open_OBJ32PRN(1,"R",WIMP)
      return .t.    
   endif

   select TMP
   ordsetfocus('SINC002')
   go top 

   do while ! eof()

      if CAB
         CAB_ESTOQUE()
         CAB = .f.
      endif

      if GRP
         oPrinter:newLine()
         Middle_OBJ32PRN("*** "+alltrim(GRUPO)+" ***")
         oPrinter:newLine()
         GRP = .f.
      endif

      oPrinter:setPrc(oPrinter:prow()+1,0) 
      oPrinter:textOut(CODIGO)
      oPrinter:setPrc(oPrinter:prow(),09)
      oPrinter:textOut(PRODUTO)
      oPrinter:setPrc(oPrinter:prow(),50)
      oPrinter:textOut(REF)
      oPrinter:setPrc(oPrinter:prow(),70)
      oPrinter:textOut(UN)
      oPrinter:setPrc(oPrinter:prow(),74)
      oPrinter:textOut(transform(SALDO,"9999999.99"))
      oPrinter:setPrc(oPrinter:prow(),86)
      oPrinter:textOut(transform(MINIMO,"9999999.99"))
      oPrinter:setPrc(oPrinter:prow(),98)
      oPrinter:textOut(transform(RESSUP,"9999999.99"))
      oPrinter:setPrc(oPrinter:prow(),110)
      oPrinter:textOut(transform(CUSTO,"@R@E 999,999.9999"))
      oPrinter:setPrc(oPrinter:prow(),123)
      oPrinter:textOut(transform(TOTAL,"@R@E 999,999,999.99"))

      tSUB   = tSUB   + TOTAL
      tTOTAL = tTOTAL + TOTAL
      WGROUP = GRUPO
         
      skip +1

      if GRUPO <> WGROUP .or. eof()
         oPrinter:setPrc(oPrinter:prow()+1,123)
         oPrinter:textOut(replicate("-",14))
         oPrinter:setPrc(oPrinter:prow()+1,123)
         oPrinter:textOut(transform(tSUB,"@R@E 999,999,999.99"))
         oPrinter:newLine()
         tSUB = 0
         GRP = .t.
      endif

      if oPrinter:prow() > 60
         oPrinter:newLine()
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         
         PAG++
         CAB = .t.
         GRP = .t.
      endif

      if eof()

         if CAB
            CAB_ESTOQUE()
            CAB = .f.
         endif

         if tTOTAL <> 0 
            oPrinter:setPrc(oPrinter:prow()+1,0) 
            oPrinter:textOut(replicate("-",137))
            oPrinter:setPrc(oPrinter:prow()+1,111)
            oPrinter:textOut("T O T A L :")
            oPrinter:setPrc(oPrinter:prow(),123)
            oPrinter:textOut(transform(tTOTAL,"@R@E 999,999,999.99"))
         endif
         
         Rodape_OBJ32PRN(PAG)

      endif

   enddo
   
   Close_OBJ32PRN()

   exclui_TMP("201", WARQ+".DBF" , WARQ+".CDX" )
   select PRODUTOS 

enddo

return .t.


********************
function CAB_ESTOQUE
********************

Cabecalho_OBJ32PRN()
Middle_OBJ32PRN("RELACAO DE PRODUTOS)",1)

oPrinter:newLine()
Left_OBJ32PRN("Grupo: "+WN_GRP)
oPrinter:setPrc(oPrinter:prow()+1,0) 
oPrinter:textOut(replicate("=",137))
oPrinter:setPrc(oPrinter:prow()+1,0)
oPrinter:textOut("CODIGO   PRODUTO                                  REF.                UN       SALDO      MINIMO     RESSUP.         CUSTO          TOTAL")
oPrinter:setPrc(oPrinter:prow()+1,0) 
oPrinter:textOut(replicate("=",137))
oPrinter:newLine()

return .t.
