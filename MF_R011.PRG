*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Programa.....: MFR011.PRG                                  ****
****  Finalidade...: Relatórios Gerenciais                       ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR - Março/2022                       ****
*********************************************************************

************************
function rpr_REL_PLANTEL
************************
LOCAL WCOR := setcolor()

do while .t.

   WPASTO = 999

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Pasto/Piquete...............:"
   @ 05,01 say "Gerar planilha excel...(S/N)?"
   @ 07,01 say "Confirma o relat"+chr(162)+"rio...(S/N)?"  

   setcolor(COR_DEST)
   CENTRO(22,":: Ser"+chr(132)+"o relacionados apenas os animais ativos (sem data de saida).")
   setcolor(COR_TEXT)

   @ 03,31 get WPASTO picture "@Z 999"
   read_f()

   if lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
  
   if empty(WPASTO)
      help_PASTO()
      select PASTO 
      WPASTO = CODIGO
   endif

   if WPASTO == 999
      @ 03,34 say "-"+"GERAL"
      WNPF = "999-GERAL"
   else
      select PASTO 
      ordsetfocus("SINC001") 
      seek WPASTO 

      if ! found()
         MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto/piquete n"+chr(132)+"o cadastrado!",0)
         loop
      endif

      @ 03,34 say "-"+NOME
      WNPF = "999-"+alltrim(NOME)
   endif
   
   WXLS = REDUCAO(05,01,"Gerar planilha excel...(S/N)?","N")
 
   if lastkey() == 27
      loop
   endif

   if REDUCAO(07,01,"Confirma o relat"+chr(162)+"rio...(S/N)?","N") = "N"
      loop
   endif
 
   if lastkey() == 27
      loop
   endif
   
   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif   

   AGUARDE()

   ************************************************************************************************************** cria a tabela temporaria
  
   WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
   WCMP  := {"PASTO", "BRINCO", "REGISTRO", "SEXO", "NASC", "IDADE", "RACA", "PELAGEM", "ENTRADA", "DOC", "VALOR", "OBS1", "OBS2", "OBS3"}                   
   WTPO  := {"C"    , "C"     , "C"       , "C"   , "D"   , "C"    , "C"   , "C"      , "D"      , "C"  , "N"    , "C"   , "C"   , "C"   }
   WTMO  := {40     , 08      , 15        , 05    , 08    , 12     , 35    , 20       , 08       , 12   , 14     , 60    , 60    , 60    }
   WDEC  := {00     , 00      , 00        , 00    , 00    , 00     , 00    , 00       , 00       , 00   , 02     , 00    , 00    , 00    }
    
   WIDX1 := "PASTO+BRINCO"
   WIDX2 := ""
   WIDX3 := ""
    
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
   ***************************************************************************************************************************************
   
   select PLANTEL
   ordsetfocus("SINC004")
   go top

   do while ! eof()

      // checa se houve a saida do animal
      if ! empty(SAIDA)
         skip +1
         loop
      endif 

      // checa se há um filtro de pasto
      if WPASTO <> 999
         if PASTO <> WPASTO
            skip +1
            loop
         endif
      endif

      WNPASTO     = PASTO
      WBRINCO     = BRINCO  
      WREGISTRO   = if(empty(REGISTRO),"-",REGISTRO)
      WSEXO       = if(SEXO == "M","Macho","Femea")
      WNASC       = NASC  
      
      if empty(WNASC)
         WIDADE   = "000.0 meses" 
      else
         WIDADE   = transform(round(((DATE() - WNASC) / 30),1), "@R@E 999.9 meses")
      endif 

      WNRACA      = RACA  
      WPELAGEM    = if(empty(PELAGEM),"-",PELAGEM)
      WENTRADA    = ENTRADA
      WDOC        = if(empty(DOC),"-",DOC)  
      WVALOR      = VALOR  
      WOBS1       = OBS1
      WOBS2       = OBS2
      WOBS3       = OBS3
      
      select PASTO 
      ordsetfocus("SINC001")
      seek WNPASTO 

      if found()
         WDESC_PASTO = strzero(WNPASTO,3)+"-"+alltrim(NOME)
      else
         WDESC_PASTO = "999-SEM PASTO CADASTRADO"
      endif   

      select RACA
      ordsetfocus("SINC001")
      seek WNRACA

      if found()
         WDESC_RACA = NOME
      else
         WDESC_RACA = "-"
      endif   
    
      select TMP
      dbappend()
      replace PASTO    with WDESC_PASTO,;
              BRINCO   with WBRINCO,;
              REGISTRO with WREGISTRO,;
              SEXO     with WSEXO,;
              NASC     with WNASC,;
              IDADE    with WIDADE,;
              RACA     with WDESC_RACA,;
              PELAGEM  with WPELAGEM,;
              ENTRADA  with WENTRADA,;
              DOC      with WDOC,;
              VALOR    with WVALOR,;
              OBS1     with WOBS1,;
              OBS2     with WOBS2,;
              OBS3     with WOBS3

      select PLANTEL
      skip +1

   enddo

   @ 24,00 clear to 24,79

   select TMP

   if lastrec() == 0
      MENSAGEM("AVISO!;N"+chr(132)+"o foi encontrado nenhum registro para o filtro informado!")
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
      select PLANTEL
      loop
   endif

   AGUARDE()

   // inicia a impressao do relatorio

   PAG            = 0
   CAB            = .t.
   WTOTAL_PASTO   = 0
   WTOTAL_ANIMAIS = 0
   WTOTAL_ENTRADA = 0 

   if ! Open_OBJ32PRN(1,"P",WIMP)  
      return .t.
   endif
   
   WDIV_PASTO = .t.

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      if oPrinter:pRow() > 42
         CAB = .t. 
         WDIV_PASTO = .t.
      endif

      if CAB 
         cab_PLANTEL()  
      endif    
 
      if WDIV_PASTO
         oPrinter:newLine()
         middle_OBJ32PRN(alltrim(PASTO),1)
         oPrinter:newLine()
         WDIV_PASTO = .f.
      endif
    
      oPrinter:setPrc(oPrinter:pRow()+1,0)
      oPrinter:textOut(BRINCO)
      oPrinter:setPrc(oPrinter:pRow(),10)
      oPrinter:textOut(left(REGISTRO,12))
      oPrinter:setPrc(oPrinter:pRow(),24)
      oPrinter:textOut(SEXO)
      oPrinter:setPrc(oPrinter:pRow(),31)
      oPrinter:textOut(dtoc(NASC))
      oPrinter:setPrc(oPrinter:pRow(),41)
      oPrinter:textOut(IDADE)
      oPrinter:setPrc(oPrinter:pRow(),55)
      oPrinter:textOut(left(RACA,20))
      oPrinter:setPrc(oPrinter:pRow(),77)
      oPrinter:textOut(left(PELAGEM,20))
      oPrinter:setPrc(oPrinter:pRow(),99)
      oPrinter:textOut(dtoc(ENTRADA))
      oPrinter:setPrc(oPrinter:pRow(),109)
      oPrinter:textOut(DOC)
      oPrinter:setPrc(oPrinter:pRow(),123)
      oPrinter:textOut(transform(VALOR,"@R@E 999,999.99"))
      oPrinter:setPrc(oPrinter:pRow(),135)
      oPrinter:textOut(if(empty(OBS1),"-",alltrim(OBS1)))
     
      if ! empty(OBS2)
         oPrinter:setPrc(oPrinter:pRow()+1,0)
         oPrinter:setPrc(oPrinter:pRow(),135)
         oPrinter:textOut(alltrim(OBS2))
      endif 

      if ! empty(OBS3)
         oPrinter:setPrc(oPrinter:pRow()+1,0)
         oPrinter:setPrc(oPrinter:pRow(),135)
         oPrinter:textOut(alltrim(OBS3))
      endif

      WTOTAL_PASTO++
      WTOTAL_ANIMAIS++
      
      WTOTAL_ENTRADA = WTOTAL_ENTRADA + VALOR 

      if oPrinter:pRow() > 42
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         CAB = .t. 
         WDIV_PASTO = .t.
      endif

      WNP = PASTO 

      skip +1

      if alltrim(PASTO) <> alltrim(WNP)
         oPrinter:newLine()
         Left_OBJ32PRN(replicate("-",199))
         oPrinter:newLine()
         oPrinter:textOut("Total de animais no pasto: "+str(WTOTAL_PASTO,4))
         oPrinter:newLine()
         WTOTAL_PASTO = 0
         WDIV_PASTO   = .t.
      endif

   enddo  

   WSALT = .t.

   if oPrinter:pRow() > 42
      Rodape_OBJ32PRN(PAG)
      oPrinter:endPage()
      WSALT = .f.
   endif

   if oPrinter:pRow() > 37
      cab_PLANTEL()  
      oPrinter:newLine()
   else 
      
      if WSALT
         oPrinter:newLine()
         Left_OBJ32PRN(replicate("-",199))
      endif 
   
      oPrinter:newLine()
      oPrinter:newLine()
   endif    

   Left_OBJ32PRN(+"RESUMO",1)
   oPrinter:newLine()
   oPrinter:newLine()
   oPrinter:textOut("1. Total de animais do plantel............ "+str(WTOTAL_ANIMAIS,4))
   oPrinter:newLine()
   oPrinter:textOut("2. Custo total com a compra dos animais... R$ "+alltrim(transform(WTOTAL_ENTRADA,"@R@E 999,999,999.99")))
   oPrinter:newLine()
   oPrinter:textOut("3. Custo medio por animal................. R$ "+alltrim(transform(WTOTAL_ENTRADA / WTOTAL_ANIMAIS,"@R@E 999,999,999.99")))

   Rodape_OBJ32PRN(PAG)

   Close_OBJ32PRN()

   if WXLS == "S"
 
      WNARQ = CRI+"-"+strzero(HB_RandomInt(999,99999),5)

      select TMP

      if lastrec() > 0 
         WARQCSV := pathCSV+"\MF-Relacao do Plantel-"+WNARQ+".XLS" 
         aHEADER := {"PASTO", "BRINCO", "REGISTRO", "SEXO", "NASC"      , "IDADE", "RACA", "PELAGEM", "BRINCO_MAE", "ENTRADA", "DOC", "VALOR"                             , "OBS1", "OBS2", "OBS3"}
         aFIELD  := {"PASTO", "BRINCO", "REGISTRO", "SEXO", "dtoc(NASC)", "IDADE", "RACA", "PELAGEM", "BRINCO_MAE", "ENTRADA", "DOC", "transform(VALOR,'@R@E 999,999.99')", "OBS1", "OBS2", "OBS3"}
                                                                                                                                
         dbf2xls("TMP", aHEADER, aFIELD, WARQCSV)
      endif

   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
   select PLANTEL

enddo

return .t.

********************
function cab_PLANTEL
********************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")

Left_OBJ32PRN("Pasto: "+WNPF)
Middle_OBJ32PRN("RELACAO DO PLANTEL",1)
Right_OBJ32PRN("Data: "+dtoc(DATE()))
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",199))
oPrinter:newLine()
Left_OBJ32PRN("BRINCO    REGISTRO      SEXO   NASC.     IDADE         RACA                  PELAGEM               ENTRADA   DOCNO              VALOR  OBSERVACAO")  
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",199))
oPrinter:newLine()

return .t.


******************************
function rpr_HIST_PESO_PLANTEL
******************************
LOCAL WCOR := setcolor()

do while .t.

   WIDADE1 = 0.0
   WIDADE2 = 999.9
   WPASTO  = 999

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Pasto/Piquete...............:"
   @ 05,01 say "Idade em Meses..............:       at"+chr(130)
   @ 07,01 say "Gerar planilha excel...(S/N)?"
   @ 09,01 say "Confirma o relat"+chr(162)+"rio...(S/N)?"  
  
   setcolor(COR_DEST)
   CENTRO(22,":: Ser"+chr(132)+"o relacionados apenas os animais ativos (sem data de saida).")
   setcolor(COR_TEXT)

   @ 03,31 get WPASTO picture "@Z 999"
   read_f()

   if lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
  
   if empty(WPASTO)
      help_PASTO()
      select PASTO 
      WPASTO = CODIGO
   endif

   if WPASTO == 999
      @ 03,34 say "-"+"GERAL"
      WNPF = "999-GERAL"
   else
      select PASTO 
      ordsetfocus("SINC001") 
      seek WPASTO 

      if ! found()
         MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto/piquete n"+chr(132)+"o cadastrado!",0)
         loop
      endif

      @ 03,34 say "-"+NOME
      WNPF = "999-"+alltrim(NOME)
   endif  

   @ 05,31 get WIDADE1 picture "999.9"
   @ 05,41 get WIDADE2 picture "999.9"  valid WIDADE2 >= WIDADE1
   read_f()

   if lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
     
   WXLS = REDUCAO(07,01,"Gerar planilha excel...(S/N)?","N")
 
   if lastkey() == 27
      loop
   endif

   if REDUCAO(09,01,"Confirma o relat"+chr(162)+"rio...(S/N)?","N") = "N"
      loop
   endif
 
   if lastkey() == 27
      loop
   endif
   
   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif   

   AGUARDE()

   *************************************************************************** cria a tabela temporaria
  
   WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
   WCMP  := {"PASTO", "BRINCO", "SEXO", "IDADE", "RACA", "PELAGEM", "ARQUIVO", "DATA", "PESO", "GANHO"}                   
   WTPO  := {"C"    , "C"     , "C"   , "C"    , "C"   , "C"      , "N"      , "D"   , "N"   , "N"    }
   WTMO  := {40     , 08      , 05    , 12     , 35    , 20       , 10       , 08    , 14    , 14     }
   WDEC  := {00     , 00      , 00    , 00     , 00    , 00       , 00       , 00    , 01    , 01     }
    
   WIDX1 := "PASTO+BRINCO+dtos(DATA)"
   WIDX2 := ""
   WIDX3 := ""
    
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
   ****************************************************************************************************
   WTOTAL_ANIMAIS = 0
   WTOTAL_NPESADO = 0
   WTOTAL_GANHO   = 0

   select PLANTEL
   ordsetfocus("SINC004")
   go top

   do while ! eof()

      // checa se houve a saida do animal
      if ! empty(SAIDA)
         skip +1
         loop
      endif 

      WBRINCO = BRINCO  
      WSEXO   = if(SEXO == "M","Macho","Femea")
      WNASC   = NASC  
      
      if WPASTO <> 999
         if PASTO <> WPASTO
            skip +1
            loop
         endif
      endif 

      if empty(WNASC)
         WIDADE = "000.0 meses" 
         WAGE   = 0 
      else
         WIDADE = transform(round(((DATE() - WNASC) / 30),1), "@R@E 999.9 meses")
         WAGE   = round(((DATE() - WNASC) / 30),1)
      endif 

      if WAGE < WIDADE1 .or. WAGE > WIDADE2
         skip +1
         loop
      endif 
 
      WNRACA    = RACA  
      WPELAGEM  =  if(empty(PELAGEM),"-",PELAGEM)
      WNPASTO   = PASTO

      WTOTAL_ANIMAIS++

      select PASTO 
      ordsetfocus("SINC001")
      seek WNPASTO 

      if found()
         WDESC_PASTO = strzero(WNPASTO,3)+"-"+alltrim(NOME)
      else
         WDESC_PASTO = "999-Nao Cadastrado"
      endif   

      select RACA
      ordsetfocus("SINC001")
      seek WNRACA

      if found()
         WDESC_RACA = NOME
      else
         WDESC_RACA = "Nao Cadastrada"
      endif   

      select PESAGEM
      ordsetfocus("SINC002")
      seek WBRINCO
    
      if ! found() 

         select TMP
         dbappend()
         replace BRINCO  with WBRINCO,;
                 SEXO    with WSEXO,;
                 IDADE   with WIDADE,;
                 RACA    with WDESC_RACA,;
                 PELAGEM with WPELAGEM,;
                 PASTO   with WDESC_PASTO,;
                 ARQUIVO with 0,;
                 DATA    with ctod(space(08)),;
                 PESO    with 0
         
         WTOTAL_NPESADO++

      else     

         do while BRINCO == WBRINCO .and. ! eof()
        
            WARQUIVO = ARQUIVO
            WDATA    = DATA  
            WPESO    = PESO

            select TMP
            dbappend()
            replace BRINCO  with WBRINCO,;
                    SEXO    with WSEXO,;
                    IDADE   with WIDADE,;
                    RACA    with WDESC_RACA,;
                    PELAGEM with WPELAGEM,;
                    PASTO   with WDESC_PASTO,;
                    ARQUIVO with WARQUIVO,;
                    DATA    with WDATA,;
                    PESO    with WPESO
 
            select PESAGEM
            skip +1
         
         enddo
      
      endif
      
      select PLANTEL
      skip +1

   enddo

   @ 24,00 clear to 24,79

   select TMP

   if lastrec() == 0
      MENSAGEM("AVISO!;N"+chr(132)+"o foi encontrado nenhum registro para o filtro informado!")
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
      select PLANTEL
      loop
   endif

   AGUARDE()

   // totaliza o ganho de peso do plantel

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      WPP     = PASTO 
      WBR     = BRINCO
      WPESO_I = PESO

      replace GANHO with 0 

      skip +1

      do while PASTO+BRINCO == WPP+WBR .and. ! eof()
         replace GANHO with PESO - WPESO_I
         WPESO_I = PESO 
         skip +1
      enddo 

   enddo 

   // inicia a impressao do relatorio

   PAG        = 0
   CAB        = .t.
   WDIV_PASTO = .t.
   WDIV_PESO  = .t.

   if ! Open_OBJ32PRN(1,"",WIMP)  
      return .t.
   endif

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      if CAB 
         cab_HIST_PESO()  
         WDIV_PASTO = .t.
         WDIV_PESO  = .t.
      endif    

      if WDIV_PASTO
         oPrinter:newLine()
         middle_OBJ32PRN(alltrim(PASTO),1)
         oPrinter:newLine()
         WDIV_PASTO = .f.
         WDIV_PESO  = .t.
      endif

      if WDIV_PESO
         oPrinter:setPrc(oPrinter:pRow()+1,0)
         oPrinter:textOut(BRINCO)
         oPrinter:setPrc(oPrinter:pRow(),11)
         oPrinter:textOut(SEXO)
         oPrinter:setPrc(oPrinter:pRow(),19)
         oPrinter:textOut(IDADE)
         oPrinter:setPrc(oPrinter:pRow(),33)
         oPrinter:textOut(left(RACA,18))
         oPrinter:setPrc(oPrinter:pRow(),57)
         oPrinter:textOut(left(PELAGEM,18))
         WDIV_PESO = .f.
      else
         oPrinter:setPrc(oPrinter:pRow()+1,0)
      endif 

      oPrinter:setPrc(oPrinter:pRow(),81)
      oPrinter:textOut(if(ARQUIVO == 0,"-",strzero(ARQUIVO,8)))
      oPrinter:setPrc(oPrinter:pRow(),94)
      oPrinter:textOut(if(empty(DATA),"-",dtoc(DATA)))
      oPrinter:setPrc(oPrinter:pRow(),105)
      oPrinter:textOut(if(empty(DATA),"-",transform(PESO,"@R@E 9999.9")))
      oPrinter:setPrc(oPrinter:pRow(),114)
      oPrinter:textOut(if(empty(DATA),"-",transform(GANHO,"@R@E 9999.9")))
 
      if oPrinter:pRow() > 60
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         CAB = .t. 
      endif

      WPASTO  = PASTO 
      WBRINCO = BRINCO
      WGANHO  = GANHO

      skip +1
      
      if alltrim(PASTO) <> alltrim(WPASTO) .and. ! eof()
         WDIV_PASTO = .t.
         WDIV_PESO  = .t.
         oPrinter:setPrc(oPrinter:pRow()+1,0)
      endif 
 
      if BRINCO <> WBRINCO .and. ! eof()
         oPrinter:setPrc(oPrinter:pRow()+1,0)
         Left_OBJ32PRN(replicate("-",137))
         WTOTAL_GANHO = WTOTAL_GANHO + WGANHO 
         WDIV_PESO    = .t.
         WGANHO       = 0 
      endif 
  
   enddo  

   WSALT = .t.

   if oPrinter:pRow() > 60
      Rodape_OBJ32PRN(PAG)
      oPrinter:endPage()
      WSALT = .f.
   endif

   if WSALT 
      oPrinter:setPrc(oPrinter:pRow()+1,0)
      Left_OBJ32PRN(replicate("-",137))
   endif 
   
   if oPrinter:pRow() > 53
      cab_HIST_PESO()  
      oPrinter:newLine()
   else 
      oPrinter:newLine()
      oPrinter:newLine()
   endif 

   Left_OBJ32PRN("RESUMO",1)
   oPrinter:newLine()
   oPrinter:newLine()
   oPrinter:textOut("1. Total de animais do plantel..... "+str(WTOTAL_ANIMAIS,4))
   oPrinter:newLine()
   oPrinter:textOut("2. Total de animais nao pesados.... "+str(WTOTAL_NPESADO,4))
   oPrinter:newLine()

   WARROBA = WTOTAL_GANHO / 15
   oPrinter:textOut("3. Total de peso ganho............. "+transform(WTOTAL_GANHO,"@R@E 999999.9 Kg")+" | "+alltrim(transform(WARROBA,"@R@E 99999.9"))+" arrobas")
   oPrinter:newLine()

   WGANHO_MEDIO = WTOTAL_GANHO / (WTOTAL_ANIMAIS - WTOTAL_NPESADO)
   oPrinter:textOut("4. Media de peso ganho............. "+transform(WGANHO_MEDIO,"@R@E 999999.9 Kg")+" | somente sobre os animais pesados.")
   oPrinter:newLine()

   Rodape_OBJ32PRN(PAG)

   Close_OBJ32PRN()

   if WXLS == "S"
 
      WNARQ = CRI+"-"+strzero(HB_RandomInt(999,99999),5)

      select TMP

      if lastrec() > 0 
         WARQCSV := pathCSV+"\MF-Historico de Pesagens do Plantel-"+WNARQ+".XLS" 
         aHEADER := {"PASTO", "BRINCO", "SEXO", "IDADE", "RACA", "PELAGEM", "ARQUIVO"           , "DATA"      , "PESO"                         , "GANHO"                         }
         aFIELD  := {"PASTO", "BRINCO", "SEXO", "IDADE", "RACA", "PELAGEM", "strzero(ARQUIVO,8)", "dtoc(DATA)", "transform(PESO,'@R@E 9999.9')", "transform(GANHO,'@R@E 9999.9')"}
         dbf2xls("TMP8", aHEADER, aFIELD, WARQCSV)
      endif

   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
   select PLANTEL

enddo

return .t.

**********************
function cab_HIST_PESO
**********************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")

Middle_OBJ32PRN("HISTORICO DE PESAGENS DO PLANTEL",1)
oPrinter:newLine()
Left_OBJ32PRN("Pasto/Piquete: "+alltrim(WNPF))
Right_OBJ32PRN("Data: "+dtoc(DATE()))
oPrinter:newLine()
Left_OBJ32PRN("Faixa de Idade em Meses: "+alltrim(transform(WIDADE1,"999.9"))+" ate "+alltrim(transform(WIDADE2,"999.9")))
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()
Left_OBJ32PRN("BRINCO     SEXO    IDADE         RACA                    PELAGEM                 ARQUIVO      DATA         PESO    GANHO") 
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()

return .t.


*********************
function rpr_PESAGENS
*********************
LOCAL WCOR := setcolor()

WDATA1  = DATE()
WDATA2  = DATE()
WBRINCO = "99999999"

do while .t.

   WGANHO_S   = 0
   WGANHO_I   = 0
   WORDEM_REL = "1"

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79
  
   @ 03,01 say "Data da pesagem inicial..............:"
   @ 04,01 say "Data da pesagem final................:" 

   @ 06,01 say "N"+chr(163)+"mero do Brinco.....................:" 

   @ 08,01 say "Ganho superior a.....................:"
   @ 09,01 say "Ganho inferior a.....................:"

   @ 11,01 say "Ordenar relat"+chr(162)+"rio por................:"
   setcolor(COR_SUB)
   @ 12,01 say "(1-Brinco, 2-Ganho Max ou 3-Ganho Min)"
   setcolor(COR_TEXT)

   @ 14,01 say "Gerar planilha excel............(S/N)?"

   @ 16,01 say "Confirma o relat"+chr(162)+"rio............(S/N)?"  

   setcolor(COR_DEST)
   CENTRO(22,":: Ser"+chr(132)+"o relacionados apenas os animais ativos (sem data de saida).")
   setcolor(COR_TEXT)

   @ 03,40 get WDATA1         
   @ 04,40 get WDATA2                               valid WDATA2 >= WDATA1

   @ 06,40 get WBRINCO    picture "99999999"        valid busca_BRINCO()
   
   @ 08,40 get WGANHO_S   picture "@Z@R@E 999999.9" when WBRINCO == "99999999"
   @ 09,40 get WGANHO_I   picture "@Z@R@E 999999.9" when WBRINCO == "99999999"
  
   @ 11,40 get WORDEM_REL picture "9"               valid WORDEM_REL $ "123"
   read_f()

   if empty(WDATA1) .or. empty(WDATA2) .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
      
   WXLS = REDUCAO(14,01,"Gerar planilha excel............(S/N)?","N")
 
   if lastkey() == 27
      loop
   endif

   if REDUCAO(16,01,"Confirma o relat"+chr(162)+"rio............(S/N)?","N") = "N"
      loop
   endif
 
   if lastkey() == 27
      loop
   endif

   if WBRINCO == "99999999"
      WIMP = sel_PRINTER()
      if lastkey() == 27
         loop
      endif   
   endif

   AGUARDE()

   **************************************************************************************** cria a tabela temporaria
  
   WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
   WCMP  := {"BRINCO", "ARQ_1", "DATA_1", "PESO_1", "ARQ_2", "DATA_2", "PESO_2", "NPESO", "TPESO", "MEDIA", "GANHO"}                   
   WTPO  := {"C"     , "N"    , "D"     , "N"     , "N"    , "D"     , "N"     , "N"    , "N"    , "N"    , "N"    }
   WTMO  := {08      , 08     , 08      , 14      , 08     , 08      , 14      , 06     , 14     , 14     , 14     }
   WDEC  := {00      , 00     , 00      , 01      , 00     , 00      , 01      , 00     , 03     , 01     , 01     }
    
   WIDX1 := "BRINCO"
   WIDX2 := "GANHO*(-1)"
   WIDX3 := "GANHO"
    
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
   *****************************************************************************************************************  
   
   // insere o plantel ativo
   
   WTOT_PLANTEL = 0

   select PLANTEL
   ordsetfocus("SINC004")
   go top

   do while ! eof()

      // checa se houve a saida do animal
      if ! empty(SAIDA)
         skip +1
         loop
      endif 

      //filtro por brinco 
      if WBRINCO <> "99999999"
         if BRINCO <> WBRINCO
            skip +1
            loop
         endif
      endif
   
      WP_BRINCO = BRINCO

      select TMP
      dbappend()
      replace BRINCO with WP_BRINCO
      
      WTOT_PLANTEL++

      select PLANTEL
      skip +1

   enddo
   
   // busca os dados da pesagens

   WTOT_MAIOR = 0
   WTOT_MENOR = 0
   WNB_MAIOR  = 0
   WNB_MENOR  = 0
   WINI       = .t.

   select PESAGEM
   ordsetfocus("SINC004")
   seek dtos(WDATA1) 
    
   do while dtos(DATA) <= dtos(WDATA2) .and. ! eof()
          
      if WBRINCO <> "99999999"
         if BRINCO <> WBRINCO
            skip +1
            loop
         endif
      endif

      if PESO == 0
         skip +1
         loop
      endif 

      WP_BRINCO = BRINCO
      
      select TMP
      ordsetfocus("SINC001")
      seek WP_BRINCO

      if ! found()
         select PESAGEM
         skip +1
         loop
      endif 
      
      select PESAGEM

      WP_ARQ  = ARQUIVO
      WP_DATA = DATA
      WP_PESO = PESO 

      if PESO > WTOT_MAIOR
         WTOT_MAIOR = PESO
         WNB_MAIOR  = BRINCO
      endif

      if WINI  
         WTOT_MENOR = PESO
         WNB_MENOR  = BRINCO
         WINI = .f.
      endif

      if PESO < WTOT_MENOR
         WTOT_MENOR = PESO
         WNB_MENOR  = BRINCO
      endif

      select TMP
      
      if empty(DATA_1)
         replace ARQ_1  with WP_ARQ,;
                 DATA_1 with WP_DATA,;
                 PESO_1 with WP_PESO,;
                 TPESO  with WP_PESO,;
                 NPESO  with 1
      else
         replace ARQ_2  with WP_ARQ,;
                 DATA_2 with WP_DATA,;
                 PESO_2 with WP_PESO,;
                 TPESO  with TPESO + WP_PESO,;
                 NPESO  with NPESO + 1
      endif

      select PESAGEM
      skip +1

   enddo

   // filtro de ganho superior/inferior
   
   if WGANHO_S <> 0 .or. WGANHO_I <> 0
  
      set deleted off

      select TMP 
      ordsetfocus("SINC001")
      go top

      do while ! eof()

         WP_GANHO = round((PESO_2 - PESO_1),1)

         if WGANHO_S <> 0
            if WP_GANHO < WGANHO_S
               delete
               skip +1
               loop
            endif
         endif

         if WGANHO_I <> 0
            if WP_GANHO > WGANHO_I
               delete
               skip +1
               loop
            endif
         endif
         
         select TMP
         skip +1

      enddo 
      
      select TMP
      pack
     
      set deleted on
     
   endif
 
   @ 24,00 clear to 24,79

   select TMP

   if lastrec() == 0
      MENSAGEM("AVISO!;N"+chr(132)+"o houve nenhuma pesagem no periodo!")
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
      select PESAGEM
      loop
   endif

   AGUARDE()

   // efetua o calculo do RESUMO/MEDIA/GANHO DE PESO

   WTOT_ANIMAIS = 0 
   WTOT_GANHO   = 0
   WTOT_MEDIA   = 0
   
   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      if PESO_1 > 0 .or. PESO_2 > 0
         WTOT_ANIMAIS++
      endif 

      WP_MEDIA = round((TPESO / NPESO),1)
      WP_GANHO = round((PESO_2 - PESO_1),1)

      if PESO_1 = 0 .or. PESO_2 = 0
         WP_MEDIA = 0
         WP_GANHO = 0
      endif

      replace MEDIA with WP_MEDIA,;
              GANHO with WP_GANHO

      WTOT_GANHO = WTOT_GANHO + WP_GANHO

      skip +1

   enddo

   WTOT_MEDIA = round((WTOT_GANHO / WTOT_ANIMAIS),1)

   // quando for um brinco especifico exibe a informacao na tela
   
   if WBRINCO <> "99999999"

      @ 12,00 clear to 22,79
      @ 24,00 clear to 24,79

      setcolor(COR_DEST)
      CENTRO(14,"RELATORIO DE PESAGENS")
      
      @ 16,01 to 16,78
      @ 17,01 say "    PRIMEIRA PESAGEM    |     ULTIMA PESAGEM      |         ESTATISTICA       " 
      @ 18,01 say "Arquivo Data       Peso | Arquivo Data       Peso | N.Pesagens   Media   Ganho"
      @ 19,01 to 19,78

      select TMP
      go top

      setcolor(COR_TEXT)

      @ 20,01 say strzero(ARQ_1,6)
      @ 20,09 say DATA_1
      @ 20,18 say PESO_1 picture "@R@E@Z 9999.9"
      @ 20,25 say "|"
      @ 20,27 say if(empty(ARQ_2),"",strzero(ARQ_2,6))
      @ 20,35 say if(empty(DATA_2),"",dtoc(DATA_2))
      @ 20,44 say if(empty(PESO_2),"",transform(PESO_2,"@R@E@Z 9999.9"))
      @ 20,51 say "|"
      @ 20,54 say NPESO  picture "@Z 99999"
      @ 20,65 say MEDIA  picture "@R@E@Z 9999.9"
      @ 20,73 say GANHO  picture "@R@E@Z 9999.9"
      
      CENTRO(24,"pressione qualquer tecla para retornar...")
      inkey(0)
      
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
      select PESAGEM
      loop
   
   endif

   // inicia a impressao do relatorio

   PAG = 0
   CAB = .t.

   if ! Open_OBJ32PRN(1,"",WIMP)  
      return .t.
   endif

   select TMP
   if WORDEM_REL == "1"
      ordsetfocus("SINC001")
      WTIT = "Ord Brinco"
   elseif WORDEM_REL == "2"
      ordsetfocus("SINC002")
      WTIT = "Ord GMax"
   elseif WORDEM_REL == "3"
      ordsetfocus("SINC003")
      WTIT = "Ord Gmin"
   endif

   go top

   do while ! eof()

      if CAB 
         cab_PESAGEM()  
      endif    

      oPrinter:setPrc(oPrinter:pRow()+1,11)
      oPrinter:textOut(BRINCO)
      
      oPrinter:setPrc(oPrinter:pRow(),20)
      oPrinter:textOut("|")
      oPrinter:setPrc(oPrinter:pRow(),23)
      oPrinter:textOut(if(empty(ARQ_1),"   -",strzero(ARQ_1,8)))
      oPrinter:setPrc(oPrinter:pRow(),33)
      oPrinter:textOut(if(empty(DATA_1),"",dtoc(DATA_1)))
      oPrinter:setPrc(oPrinter:pRow(),45)
      oPrinter:textOut(if(empty(PESO_1),"",transform(PESO_1,"@R@E 999999.9")))
       oPrinter:setPrc(oPrinter:pRow(),55)
      oPrinter:textOut("|")
      
      oPrinter:setPrc(oPrinter:pRow(),58)
      oPrinter:textOut(if(empty(ARQ_2),"   -",strzero(ARQ_2,8)))
      oPrinter:setPrc(oPrinter:pRow(),68)
      oPrinter:textOut(if(empty(DATA_2),"",dtoc(DATA_2)))
      oPrinter:setPrc(oPrinter:pRow(),80)
      oPrinter:textOut(if(empty(PESO_2),"",transform(PESO_2,"@R@E 999999.9")))
      oPrinter:setPrc(oPrinter:pRow(),90)
      oPrinter:textOut("|")

      oPrinter:setPrc(oPrinter:pRow(),96)
      oPrinter:textOut(transform(NPESO,"99999"))
      oPrinter:setPrc(oPrinter:pRow(),106)
      oPrinter:textOut(transform(MEDIA,"@R@E 999999.9"))
      oPrinter:setPrc(oPrinter:pRow(),118)
      oPrinter:textOut(transform(GANHO,"@R@E 999999.9"))
      
      if oPrinter:pRow() > 62
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         CAB = .t. 
      endif

      skip +1

   enddo  

   oPrinter:newLine()
   Left_OBJ32PRN(replicate("-",137))
   
   if oPrinter:pRow() > 50 
      oPrinter:endPage()
      cab_PESAGEM()  
   endif

   oPrinter:newLine()
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"RESUMO",1)
   oPrinter:newLine()
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"1. Total de animais do plantel....... "+transform(WTOT_PLANTEL,"999999"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"2. Total de animais pesados.......... "+transform(WTOT_ANIMAIS,"999999"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"3. Total de animais nao pesados...... "+transform(WTOT_PLANTEL - WTOT_ANIMAIS,"999999"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"4. Total de peso ganho............... "+transform(WTOT_GANHO,"@R@E 999999.9 Kg"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"5. Media de peso ganho............... "+transform(WTOT_MEDIA,"@R@E 999999.9 Kg"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"6. Maior peso registrado >........... "+transform(WTOT_MAIOR,"@R@E 999999.9 Kg")+" ("+alltrim(WNB_MAIOR)+")")
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"7. Menor peso registrado <........... "+transform(WTOT_MENOR,"@R@E 999999.9 Kg")+" ("+alltrim(WNB_MENOR)+")")

   Rodape_OBJ32PRN(PAG)

   Close_OBJ32PRN()

   if WXLS == "S"
 
      WNARQ = CRI+"-"+strzero(HB_RandomInt(999,99999),5)

      select TMP

      if lastrec() > 0 
         WARQCSV := pathCSV+"\MF-Pesagem Comparativa do Plantel-"+WTIT+"-"+WNARQ+".XLS" 
         aHEADER := {"BRINCO", "ARQUIVO 1"       , "DATA 1"      , "PESO 1"                           , "ARQUIVO 2"       , "DATA 2"      , "PESO 2"                           , "N.PESAGENS"              , "MEDIA"                           , "GANHO"                           }
         aFIELD  := {"BRINCO", "strzero(ARQ_1,6)", "dtoc(DATA_1)", "transform(PESO_1,'@R@E 999999.9')", "strzero(ARQ_2,6)", "dtoc(DATA_2)", "transform(PESO_2,'@R@E 999999.9')", "transform(NPESO,'99999')", "transform(MEDIA,'@R@E 999999.9')", "transform(GANHO,'@R@E 999999.9')"}
         dbf2xls("TMP", aHEADER, aFIELD, WARQCSV)
      endif

   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
   select PESAGEM

enddo

return .t.


********************
function cab_PESAGEM
********************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")

Left_OBJ32PRN("Ganho superior a: "+if(WGANHO_S = 0, "GERAL",transform(WGANHO_S,"@R@E 999999.9")))
Middle_OBJ32PRN("PESAGENS COMPARATIVAS DO PLANTEL",1)
Right_OBJ32PRN("Periodo: "+dtoc(WDATA1)+" a "+dtoc(WDATA2))
oPrinter:newLine()
Left_OBJ32PRN("Ganho inferior a: "+if(WGANHO_I = 0, "GERAL",transform(WGANHO_I,"@R@E 999999.9")))
Right_OBJ32PRN("Data: "+dtoc(DATE()))
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()
Left_OBJ32PRN("           NUMERO   |         PRIMEIRA PESAGEM         |          ULTIMA PESAGEM          |             ESTATISTICA            ")  
oPrinter:newLine()
Left_OBJ32PRN("           BRINCO   |  Arquivo   Data            Peso  |  Arquivo   Data            Peso  |  N.Pesagens      Media       Ganho ")

oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))

return .t.

*********************
function busca_BRINCO
*********************

if WBRINCO == "99999999"
   return .t.
endif

if empty(WBRINCO)
   help_BRINCO()
   return .f.
endif 

select PESAGEM
ordsetfocus("SINC002")
seek WBRINCO

if ! found()
    MENSAGEM("AVISO!;N"+chr(163)+"mero de brinco n"+chr(132)+"o cadastrado!")
    return .f.
endif

return .t.

**************************
function rpr_CUSTO_ENGORDA
**************************
LOCAL WCOR := setcolor()

WDATA1 = DATE()
WDATA2 = DATE()

do while .t.

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79
  
   @ 03,01 say "Data da pesagem inicial..............:"
   @ 04,01 say "Data da pesagem final................:" 

   @ 06,01 say "Gerar planilha excel............(S/N)?"
   @ 07,01 say "Confirma o relat"+chr(162)+"rio............(S/N)?"  

   setcolor(COR_DEST)
   CENTRO(22,":: Ser"+chr(132)+"o relacionados apenas os animais ativos (sem data de saida).")
   setcolor(COR_TEXT)

   @ 03,40 get WDATA1         
   @ 04,40 get WDATA2 valid WDATA2 >= WDATA1
   read_f()

   if empty(WDATA1) .or. empty(WDATA2) .or. lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
      
   WXLS = REDUCAO(06,01,"Gerar planilha excel............(S/N)?","N")
 
   if lastkey() == 27
      loop
   endif

   if REDUCAO(07,01,"Confirma o relat"+chr(162)+"rio............(S/N)?","N") = "N"
      loop
   endif
 
   if lastkey() == 27
      loop
   endif

   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif   

   AGUARDE()

   ****************************************************************************************************************** cria a tabela temporaria
  
   WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
   WCMP  := {"BRINCO", "ARQ_1", "DATA_1", "PESO_1", "ARQ_2", "DATA_2", "PESO_2", "NPESO", "TPESO", "MEDIA", "GANHO", "CUSTO_KG", "CUSTO_TOT"}                   
   WTPO  := {"C"     , "N"    , "D"     , "N"     , "N"    , "D"     , "N"     , "N"    , "N"    , "N"    , "N"    , "N"       , "N"        }
   WTMO  := {08      , 08     , 08      , 14      , 08     , 08      , 14      , 06     , 14     , 14     , 14     , 14        , 14         }
   WDEC  := {00      , 00     , 00      , 01      , 00     , 00      , 01      , 00     , 03     , 01     , 01     , 02        , 02         }
    
   WIDX1 := "BRINCO"
   WIDX2 := ""
   WIDX3 := ""
    
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
   *******************************************************************************************************************************************  
 
   // insere o plantel ativo
     
   WTOT_PLANTEL = 0
  
   select PLANTEL
   ordsetfocus("SINC004")
   go top
  
   do while ! eof()
  
      // checa se houve a saida do animal
      if ! empty(SAIDA)
         skip +1
         loop
      endif 
     
      WP_BRINCO = BRINCO
  
      select TMP
      dbappend()
      replace BRINCO with WP_BRINCO
      
      WTOT_PLANTEL++
  
      select PLANTEL
      skip +1
  
   enddo
   
   // busca os dados da pesagens

   select PESAGEM
   ordsetfocus("SINC004")
   seek dtos(WDATA1) 
    
   do while dtos(DATA) <= dtos(WDATA2) .and. ! eof()
       
      if PESO == 0
         skip +1
         loop
      endif 

      WP_BRINCO = BRINCO
      WP_ARQ    = ARQUIVO
      WP_DATA   = DATA
      WP_PESO   = PESO

      select TMP
      ordsetfocus("SINC001")
      seek WP_BRINCO

      if ! found()
         dbappend()
         replace BRINCO with WP_BRINCO,;
                 ARQ_1  with WP_ARQ,;
                 DATA_1 with WP_DATA,;
                 PESO_1 with WP_PESO,;
                 NPESO  with NPESO + 1,;
                 TPESO  with TPESO + WP_PESO
      else
         replace ARQ_2  with WP_ARQ,;
                 DATA_2 with WP_DATA,;
                 PESO_2 with WP_PESO,;
                 NPESO  with NPESO + 1,;
                 TPESO  with TPESO + WP_PESO
      endif

      select PESAGEM
      skip +1

   enddo
 
   @ 24,00 clear to 24,79

   select TMP

   if lastrec() == 0
      MENSAGEM("AVISO!;N"+chr(132)+"o houve nenhuma pesagem no periodo!")
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
      select PESAGEM
      loop
   endif

   AGUARDE()

   // gera o custo de engorda no periodo  
   WCUSTO_ENGORDA = ret_CUSTO_ENGORDA(WDATA1, WDATA2)

   // efetua o cálculo do RESUMO/MEDIA/GANHO DE PESO

   WTOT_ANIMAIS = 0 
   WTOT_GANHO   = 0
   WTOT_MEDIA   = 0

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      WTOT_ANIMAIS++
      
      WP_MEDIA = round((TPESO / NPESO),1)
      WP_GANHO = round((PESO_2 - PESO_1),1)

      if PESO_1 == 0 .or. PESO_2 == 0
         WP_MEDIA = 0
         WP_GANHO = 0
      endif

      replace MEDIA with WP_MEDIA,;
              GANHO with WP_GANHO

      WTOT_GANHO = WTOT_GANHO + WP_GANHO

      skip +1

   enddo

   WTOT_MEDIA = round((WTOT_GANHO / WTOT_ANIMAIS),1)
   WCUSTO_KG  = (WCUSTO_ENGORDA / WTOT_GANHO)
   WTOT_CUSTO = 0 

   // atualiza o custo do ganho por animal

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      replace CUSTO_KG  with WCUSTO_KG,;
              CUSTO_TOT with (GANHO * WCUSTO_KG)

      WTOT_CUSTO = WTOT_CUSTO + CUSTO_TOT 

      skip +1

   enddo

   // inicia a impressao do relatorio

   PAG = 0
   CAB = .t.

   if ! Open_OBJ32PRN(1,"",WIMP)  
      return .t.
   endif

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      if CAB 
         cab_CUSTO()  
      endif    

      oPrinter:setPrc(oPrinter:pRow()+1,0)
      oPrinter:textOut(transform(BRINCO,"99999999"))
      oPrinter:setPrc(oPrinter:pRow(),09)
      oPrinter:textOut("|")
      oPrinter:setPrc(oPrinter:pRow(),11)
      oPrinter:textOut(if(empty(ARQ_1),"   -",strzero(ARQ_1,8)))
      oPrinter:setPrc(oPrinter:pRow(),20)
      oPrinter:textOut(if(empty(DATA_1),"",dtoc(DATA_1)))
      oPrinter:setPrc(oPrinter:pRow(),31)
      oPrinter:textOut(if(empty(PESO_1),"",transform(PESO_1,"@R@E 999999.9")))
      oPrinter:setPrc(oPrinter:pRow(),40)
      oPrinter:textOut("|")

      oPrinter:setPrc(oPrinter:pRow(),42)
      oPrinter:textOut(if(empty(ARQ_2),"   -",strzero(ARQ_2,8)))
      oPrinter:setPrc(oPrinter:pRow(),51)
      oPrinter:textOut(if(empty(DATA_2),"",dtoc(DATA_2)))
      oPrinter:setPrc(oPrinter:pRow(),62)
      oPrinter:textOut(if(empty(PESO_2),"",transform(PESO_2,"@R@E 999999.9")))
      oPrinter:setPrc(oPrinter:pRow(),71)
      oPrinter:textOut("|")

      oPrinter:setPrc(oPrinter:pRow(),75)
      oPrinter:textOut(transform(NPESO,"99999"))
      oPrinter:setPrc(oPrinter:pRow(),85)
      oPrinter:textOut(transform(MEDIA,"@R@E 999999.9"))
      oPrinter:setPrc(oPrinter:pRow(),96)
      oPrinter:textOut(transform(GANHO,"@R@E 999999.9"))
      
      oPrinter:setPrc(oPrinter:pRow(),105)
      oPrinter:textOut("|")
      oPrinter:setPrc(oPrinter:pRow(),107)
      oPrinter:textOut(transform(CUSTO_KG,"@R@E 999,999,999.99"))
      oPrinter:setPrc(oPrinter:pRow(),123)
      oPrinter:textOut(transform(CUSTO_TOT,"@R@E 999,999,999.99"))

      if oPrinter:pRow() > 62 
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         CAB = .t. 
      endif

      skip +1

   enddo  

   oPrinter:newLine()
   Left_OBJ32PRN(replicate("-",137))
   
   if oPrinter:pRow() > 50 
      oPrinter:endPage()
      cab_CUSTO()  
   endif

   oPrinter:newLine()
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"RESUMO",1)
   oPrinter:newLine()
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"1. Total de animais do plantel....... "+transform(WTOT_PLANTEL,"999999"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"2. Total de animais pesados.......... "+transform(WTOT_ANIMAIS,"999999"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"3. Total de peso ganho............... "+transform(WTOT_GANHO,"@R@E 999999.9"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"4. Custo total com engorda........... "+transform(WTOT_CUSTO,"@R@E 999,999,999.99"))
   oPrinter:newLine()
   Left_OBJ32PRN(space(40)+"5. Custo medio por KG................ "+transform(WCUSTO_KG,"@R@E 999,999,999.99"))
   
   Rodape_OBJ32PRN(PAG)

   Close_OBJ32PRN()

   if WXLS == "S"
 
      WNARQ = CRI+"-"+strzero(HB_RandomInt(999,99999),5)

      select TMP

      if lastrec() > 0 
         WARQCSV := pathCSV+"\MF-Custo com Engorda-"+WNARQ+".XLS" 
         aHEADER := {"BRINCO", "ARQUIVO 1"       , "DATA 1"      , "PESO 1"                           , "ARQUIVO 2"       , "DATA 2"      , "PESO 2"                           , "N.PESAGENS"              , "MEDIA"                           , "GANHO"                           , "CUSTO KG"                           , "CUSTO TOTAL"                         }
         aFIELD  := {"BRINCO", "strzero(ARQ_1,8)", "dtoc(DATA_1)", "transform(PESO_1,'@R@E 999999.9')", "strzero(ARQ_2,6)", "dtoc(DATA_2)", "transform(PESO_2,'@R@E 999999.9')", "transform(NPESO,'99999')", "transform(MEDIA,'@R@E 999999.9')", "transform(GANHO,'@R@E 999999.9')", "transform(CUSTO_KG,'@R@E 999999.9')", "transform(CUSTO_TOT,'@R@E 999999.9')"}
         dbf2xls("TMP", aHEADER, aFIELD, WARQCSV)
      endif

   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
   select PESAGEM

enddo

return .t.
   
******************
function cab_CUSTO
******************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")

Middle_OBJ32PRN("CUSTO COM ENGORDA",1)
Right_OBJ32PRN("Periodo: "+dtoc(WDATA1)+" a "+dtoc(WDATA2))
oPrinter:newLine()
Right_OBJ32PRN("Data: "+dtoc(DATE()))
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()
Left_OBJ32PRN("NUMERO   |       PRIMEIRA PESAGEM       |        ULTIMA PESAGEM        |           ESTATISTICA           |             C U S T O         ")  
oPrinter:newLine()
Left_OBJ32PRN("BRINCO   | Arquivo  Data           Peso | Arquivo  Data           Peso | N.Pesagens     Media      Ganho |   Custo por KG     Custo Total")
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))

return .t.
      

***************************
function rpr_HIST_VACINACAO
***************************
LOCAL WCOR := setcolor()

do while .t.

   WPASTO = 999

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Pasto/Piquete...............:"
   @ 05,01 say "Gerar planilha excel...(S/N)?"
   @ 07,01 say "Confirma o relat"+chr(162)+"rio...(S/N)?"  

   @ 03,31 get WPASTO picture "@Z 999"
   read_f()

   if lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
  
   if empty(WPASTO)
      help_PASTO()
      select PASTO 
      WPASTO = CODIGO
   endif

   if WPASTO == 999
      @ 03,34 say "-"+"GERAL"
      WNPF = "999-GERAL"
   else
      select PASTO 
      ordsetfocus("SINC001") 
      seek WPASTO 

      if ! found()
         MENSAGEM("AVISO!;C"+chr(162)+"digo de pasto/piquete n"+chr(132)+"o cadastrado!",0)
         loop
      endif

      @ 03,34 say "-"+NOME
      WNPF = "999-"+alltrim(NOME)
   endif  
     
   WXLS = REDUCAO(05,01,"Gerar planilha excel...(S/N)?","N")
 
   if lastkey() == 27
      loop
   endif

   if REDUCAO(07,01,"Confirma o relat"+chr(162)+"rio...(S/N)?","N") = "N"
      loop
   endif
 
   if lastkey() == 27
      loop
   endif
   
   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif   

   AGUARDE()

   **************************************************************************** cria a tabela temporaria
  
   WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
   WCMP  := {"PASTO", "BRINCO", "SEXO", "IDADE", "RACA", "PELAGEM", "VACINA", "DATA", "PROXIMA", "OBS"}                   
   WTPO  := {"C"    , "C"     , "C"   , "C"    , "C"   , "C"      , "C"     , "D"   , "D"      , "C"  }
   WTMO  := {40     , 08      , 05    , 12     , 35    , 20       , 40      , 08    , 08       , 60   }
   WDEC  := {00     , 00      , 00    , 00     , 00    , 00       , 00      , 00    , 00       , 00   }
    
   WIDX1 := "PASTO+BRINCO+descend(dtos(DATA))"
   WIDX2 := ""
   WIDX3 := ""
    
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
   *****************************************************************************************************
   WTOTAL_ANIMAIS = 0
   WTOTAL_VAC     = 0
   WTOTAL_NVAC    = 0

   select PLANTEL
   ordsetfocus("SINC004")
   go top

   do while ! eof()

      // checa se houve a saida do animal
      if ! empty(SAIDA)
         skip +1
         loop
      endif 

      WBRINCO = BRINCO  
      WSEXO   = if(SEXO == "M","Macho","Femea")
      WNASC   = NASC  
      
      if WPASTO <> 999
         if PASTO <> WPASTO
            skip +1
            loop
         endif
      endif 

      if empty(WNASC)
         WIDADE = "000.0 meses"        
      else
         WIDADE = transform(round(((DATE() - WNASC) / 30),1), "@R@E 999.9 meses")
      endif 
 
      WNRACA   = RACA  
      WPELAGEM =  if(empty(PELAGEM),"-",PELAGEM)
      WNPASTO  = PASTO

      WTOTAL_ANIMAIS++

      select PASTO 
      ordsetfocus("SINC001")
      seek WNPASTO 

      if found()
         WDESC_PASTO = strzero(WNPASTO,3)+"-"+alltrim(NOME)
      else
         WDESC_PASTO = "999-Nao Cadastrado"
      endif   

      select RACA
      ordsetfocus("SINC001")
      seek WNRACA

      if found()
         WDESC_RACA = NOME
      else
         WDESC_RACA = "Nao Cadastrada"
      endif   

      select VACINA_P
      ordsetfocus("SINC002")
      seek WBRINCO

      if ! found()
         select TMP
         dbappend()
         replace BRINCO  with WBRINCO,;
                 SEXO    with WSEXO,;
                 IDADE   with WIDADE,;
                 RACA    with WDESC_RACA,;
                 PELAGEM with WPELAGEM,;
                 PASTO   with WDESC_PASTO,;
                 VACINA  with "000-NAO VACINADO",;
                 DATA    with ctod(space(08)),;
                 PROXIMA with ctod(space(08)),;
                 OBS     with space(60)
         
         WTOTAL_NVAC++

      else

         do while BRINCO == WBRINCO .and. ! eof()

            WCOD_VAC = VACINA
            WNAM_VAC = ""  
            WDATA    = DATA
            WPROXIMA = PROXIMA 
            WOBS     = OBS1

            select VACINA
            ordsetfocus("SINC001")
            seek WCOD_VAC

            if found()
               WNAM_VAC = alltrim(NOME)
            else
               WNAM_VAC = "NAO CADASTRADA"
            endif
     
            select TMP
            dbappend()
            replace BRINCO  with WBRINCO,;
                    SEXO    with WSEXO,;
                    IDADE   with WIDADE,;
                    RACA    with WDESC_RACA,;
                    PELAGEM with WPELAGEM,;
                    PASTO   with WDESC_PASTO,;
                    VACINA  with strzero(WCOD_VAC,3)+"-"+WNAM_VAC,;
                    DATA    with WDATA,;
                    PROXIMA with WPROXIMA,;
                    OBS     with WOBS  
            
            select VACINA_P
            skip +1

         enddo

      endif 
      
      select PLANTEL
      skip +1

   enddo

   @ 24,00 clear to 24,79

   select TMP

   if lastrec() == 0
      MENSAGEM("AVISO!;N"+chr(132)+"o foi encontrado nenhum registro para o filtro informado!")
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
      select PLANTEL
      loop
   endif

   AGUARDE()

   // inicia a impressao do relatorio

   PAG         = 0
   CAB         = .t.
   WDIV_PASTO  = .t.
   WDIV_VACINA = .t.

   if ! Open_OBJ32PRN(1,"",WIMP)  
      return .t.
   endif

   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      if CAB 
         cab_HIST_VACINACAO()  
         WDIV_PASTO  = .t.
         WDIV_VACINA = .t.
      endif    

      if WDIV_PASTO
         oPrinter:newLine()
         middle_OBJ32PRN(alltrim(PASTO),1)
         oPrinter:newLine()
         WDIV_PASTO  = .f.
         WDIV_VACINA = .t.
      endif

      if WDIV_VACINA
         oPrinter:setPrc(oPrinter:pRow()+1,0)
         oPrinter:textOut(BRINCO)
         oPrinter:setPrc(oPrinter:pRow(),11)
         oPrinter:textOut(SEXO)
         oPrinter:setPrc(oPrinter:pRow(),19)
         oPrinter:textOut(IDADE)
         oPrinter:setPrc(oPrinter:pRow(),33)
         oPrinter:textOut(left(RACA,18))
         oPrinter:setPrc(oPrinter:pRow(),57)
         oPrinter:textOut(left(PELAGEM,18))
         WDIV_VACINA = .f.
      else
         oPrinter:setPrc(oPrinter:pRow()+1,0)
      endif 

      oPrinter:setPrc(oPrinter:pRow(),80)
      oPrinter:textOut(left(VACINA,29))
      oPrinter:setPrc(oPrinter:pRow(),112)
      oPrinter:textOut(if(empty(DATA),"-",dtoc(DATA)))
      oPrinter:setPrc(oPrinter:pRow(),123)
      oPrinter:textOut(if(empty(PROXIMA),"-",dtoc(DATA)))
      
      if left(VACINA,3) <> "000"
         WTOTAL_VAC++
      endif 

      if oPrinter:pRow() > 60
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         CAB = .t. 
      endif

      WPASTO  = PASTO 
      WBRINCO = BRINCO

      skip +1
      
      if alltrim(PASTO) <> alltrim(WPASTO) .and. ! eof()
         WDIV_PASTO  = .t.
         WDIV_VACINA = .t.
         oPrinter:setPrc(oPrinter:pRow()+1,0)
      endif 
 
      if BRINCO <> WBRINCO .and. ! eof()
         oPrinter:setPrc(oPrinter:pRow()+1,0)
         Left_OBJ32PRN(replicate("-",137))
         WDIV_VACINA = .t.
      endif 
  
   enddo  

   WSALT = .t.

   if oPrinter:pRow() > 60
      Rodape_OBJ32PRN(PAG)
      oPrinter:endPage()
      WSALT = .f.
   endif

   if WSALT 
      oPrinter:setPrc(oPrinter:pRow()+1,0)
      Left_OBJ32PRN(replicate("-",137))
   endif 

   if oPrinter:pRow() > 53
      cab_HIST_PESO()  
      oPrinter:newLine()
   else 
      oPrinter:newLine()
      oPrinter:newLine()
   endif 

   Left_OBJ32PRN("RESUMO",1)
   oPrinter:newLine()
   oPrinter:newLine()
   oPrinter:textOut("1. Total de animais................. "+str(WTOTAL_ANIMAIS,4))
   oPrinter:newLine()
   oPrinter:textOut("2. Total de animais vacinados....... "+str(WTOTAL_VAC,4))
   oPrinter:newLine()
   oPrinter:textOut("3. Total de animais nao vacinados... "+str(WTOTAL_NVAC,4))
   oPrinter:newLine()

   Rodape_OBJ32PRN(PAG)

   Close_OBJ32PRN()

   if WXLS == "S"
 
      WNARQ = CRI+"-"+strzero(HB_RandomInt(999,99999),5)

      select TMP

      if lastrec() > 0 
         WARQCSV := pathCSV+"\MF-Historico de Vacinacao do Plantel-"+WNARQ+".XLS" 
         aHEADER := {"PASTO", "BRINCO", "SEXO", "IDADE", "RACA", "PELAGEM", "VACINA", "DATA"      , "PROXIMA"      , "OBS"}
         aFIELD  := {"PASTO", "BRINCO", "SEXO", "IDADE", "RACA", "PELAGEM", "VACINA", "dtoc(DATA)", "dtoc(PROXIMA)", "OBS"}
         dbf2xls("TMP8", aHEADER, aFIELD, WARQCSV)
      endif

   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
   select PLANTEL

enddo

return .t.

***************************
function cab_HIST_VACINACAO
***************************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")

Middle_OBJ32PRN("HISTORICO DE VACINACAO DO PLANTEL",1)
oPrinter:newLine()
Left_OBJ32PRN("Pasto/Piquete: "+alltrim(WNPF))
Right_OBJ32PRN("Data: "+dtoc(DATE()))
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()
Left_OBJ32PRN("BRINCO     SEXO    IDADE         RACA                    PELAGEM                VACINA                          DATA       PROXIMA") 

oPrinter:newLine()
Left_OBJ32PRN(replicate("=",137))
oPrinter:newLine()

return .t.

**********************
function rpr_REL_SAIDA
**********************
LOCAL WCOR := setcolor()

do while .t.

   WDATA1  = DATE()
   WDATA2  = DATE()
   WMOTIVO = "GERAL"+space(10)

   setcolor(COR_TEXT)
   @ 02,00 clear to 22,79
   @ 24,00 clear to 24,79

   @ 03,01 say "Data de saida inicial.......:"
   @ 04,01 say "Data de saida final.........:"

   @ 06,01 say "Motivo da saida.............:"
   
   @ 08,01 say "Gerar planilha excel...(S/N)?"
   @ 10,01 say "Confirma o relat"+chr(162)+"rio...(S/N)?"  

   @ 03,31 get WDATA1
   @ 04,31 get WDATA2 valid WDATA2 >= WDATA1
  
   @ 06,31,13,46 get WMOTIVO;   
   LISTBOX {"Venda          ", "Transferencia  ", "Morte          ", "Outros         ", "GERAL          "};
   DROPDOWN SCROLLBAR;
   COLOR COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_TEXT;
   MESSAGE "pressione BARRA DE ESPA"+chr(128)+"O para listar os motivos v"+chr(160)+"lidos."; 
   VALID ! empty(WMOTIVO)

   read_f()

   if lastkey() == 27
      setcolor(WCOR)
      return .t.
   endif
  
   WXLS = REDUCAO(08,01,"Gerar planilha excel...(S/N)?","N")
 
   if lastkey() == 27
      loop
   endif

   if REDUCAO(10,01,"Confirma o relat"+chr(162)+"rio...(S/N)?","N") = "N"
      loop
   endif
 
   if lastkey() == 27
      loop
   endif
   
   WIMP = sel_PRINTER()
   
   if lastkey() == 27
      loop
   endif   

   AGUARDE()

   *********************************************************************************************************************************************************** cria a tabela temporaria
  
   WARQ  := pathTMP+"\TAB"+strzero(random()%99999,5)
   
   WCMP  := {"BRINCO", "REGISTRO", "SEXO", "IDADE", "RACA", "PELAGEM", "ENTRADA", "DOC", "VALOR", "PESO1", "SAIDA", "MOTIVO", "NF", "VR_NF", "PESO2", "OBS_NF", "OBS1", "OBS2", "OBS3"}                   
   WTPO  := {"C"     , "C"       , "C"   , "C"    , "C"   , "C"      , "D"      , "C"  , "N"    , "N"    , "D"    , "C"     , "C" , "N"    , "N"    , "C"     , "C"   , "C"   , "C"   }
   WTMO  := {08      , 15        , 05    , 12     , 35    , 20       , 08       , 12   , 14     , 14     , 08     , 15      , 09  , 14     , 14     , 60      , 60    , 60    , 60    }
   WDEC  := {00      , 00        , 00    , 00     , 00    , 00       , 00       , 00   , 02     , 01     , 00     , 00      , 00  , 02     , 01     , 00      , 00    , 00    , 00    }
     
   WIDX1 := "BRINCO"
   WIDX2 := ""
   WIDX3 := ""
    
   cria_DB(WARQ, "TMP", "201", WCMP, WTPO, WTMO, WDEC, WIDX1, WIDX2, WIDX3)
    
   ************************************************************************************************************************************************************************************
   
   select PLANTEL
   ordsetfocus("SINC005")
   seek WDATA1 

   do while SAIDA <= WDATA2 .and. ! eof()

      if empty(SAIDA)
         skip +1
         loop
      endif 

      if upper(alltrim(WMOTIVO)) <> "GERAL"
         if upper(alltrim(MOTIVO)) <> upper(alltrim(WMOTIVO)) 
            skip +1
            loop
         endif
      endif 

      WBRINCO   = BRINCO  
      WREGISTRO = if(empty(REGISTRO),"-",REGISTRO)
      WSEXO     = if(SEXO == "M","Macho","Femea")
      WNASC     = NASC  
      
      if empty(WNASC)
         WIDADE = "000.0 meses" 
      else
         WIDADE = transform(round(((DATE() - WNASC) / 30),1), "@R@E 999.9 meses")
      endif 

      WNRACA   = RACA  
      WPELAGEM =  if(empty(PELAGEM),"-",PELAGEM)
      WENTRADA = ENTRADA
      WDOC     = if(empty(DOC),"-",DOC)  
      WVALOR   = VALOR  
      WSAIDA   = SAIDA
      WMOT     = MOTIVO 
      WPESO1   = PESO
      WOBS1    = OBS1
      WOBS2    = OBS2
      WOBS3    = OBS3
      WNF      = space(09) 
      WVR_NF   = 0 
      WOBS_NF  = space(60)

      select SAIDA_P
      ordsetfocus("SINC002")
      seek WBRINCO

      if found()
         WNF     = NF 
         WVR_NF  = VALOR   
         WOBS_NF = OBS1 
      endif 
   
      select RACA
      ordsetfocus("SINC001")
      seek WNRACA

      if found()
         WDESC_RACA = NOME
      else
         WDESC_RACA = "Nao Cadastrada"
      endif   

      // busca o peso da ultima pesagem

      WPESO2 = 0

      select PESAGEM
      ordsetfocus("SINC002")
      seek WBRINCO
    
      if found()
         WPESO2 = PESO
      endif 

      select TMP
      dbappend()
      replace BRINCO   with WBRINCO,;
              REGISTRO with WREGISTRO,;
              SEXO     with WSEXO,;
              IDADE    with WIDADE,;
              RACA     with WDESC_RACA,;
              PELAGEM  with WPELAGEM,;
              ENTRADA  with WENTRADA,;
              DOC      with WDOC,;
              VALOR    with WVALOR,;
              PESO1    with WPESO1,;
              SAIDA    with WSAIDA,;
              MOTIVO   with WMOT,;
              NF       with WNF,;
              VR_NF    with WVR_NF,;
              PESO2    with WPESO2,;
              OBS_NF   with WOBS_NF,;
              OBS1     with WOBS1,;
              OBS2     with WOBS2,;
              OBS3     with WOBS3

      select PLANTEL
      skip +1

   enddo

   @ 24,00 clear to 24,79

   select TMP

   if lastrec() == 0
      MENSAGEM("AVISO!;N"+chr(132)+"o foi encontrado nenhum registro para o filtro informado!")
      exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
      select PLANTEL
      loop
   endif

   AGUARDE()

   // inicia a impressao do relatorio

   PAG            = 0
   CAB            = .t.
   WTOTAL_ANIMAIS = 0
   WTOTAL_COMPRA  = 0
   WTOTAL_VENDA   = 0
   WTOTAL_LUCRO   = 0
   WTOTAL_GANHO   = 0

   if ! Open_OBJ32PRN(1,"P",WIMP)  
      return .t.
   endif
   
   select TMP
   ordsetfocus("SINC001")
   go top

   do while ! eof()

      if oPrinter:pRow() > 42
         CAB = .t. 
      endif

      if CAB 
         cab_SAIDA()  
      endif    

      WTOTAL_ANIMAIS++

      oPrinter:setPrc(oPrinter:pRow()+1,0)
      oPrinter:textOut(BRINCO)
      oPrinter:setPrc(oPrinter:pRow(),10)
      oPrinter:textOut(left(REGISTRO,10))
      oPrinter:setPrc(oPrinter:pRow(),22)
      oPrinter:textOut(SEXO)
      oPrinter:setPrc(oPrinter:pRow(),29)
      oPrinter:textOut(IDADE)
      oPrinter:setPrc(oPrinter:pRow(),42)
      oPrinter:textOut(left(RACA,12))
      oPrinter:setPrc(oPrinter:pRow(),56)
      oPrinter:textOut(left(PELAGEM,12))
      oPrinter:setPrc(oPrinter:pRow(),69)
      oPrinter:textOut("|")
      oPrinter:setPrc(oPrinter:pRow(),71)
      oPrinter:textOut(dtoc(ENTRADA))
      oPrinter:setPrc(oPrinter:pRow(),81)
      oPrinter:textOut(if(empty(DOC),"-",DOC))
      oPrinter:setPrc(oPrinter:pRow(),94)
      oPrinter:textOut(transform(VALOR,"@R@E 999,999.99"))
      oPrinter:setPrc(oPrinter:pRow(),106)
      oPrinter:textOut(transform(PESO1,"@R@E 9999.9"))
      oPrinter:setPrc(oPrinter:pRow(),113)
      oPrinter:textOut("|")
      oPrinter:setPrc(oPrinter:pRow(),115)
      oPrinter:textOut(dtoc(SAIDA))
      oPrinter:setPrc(oPrinter:pRow(),125)
      oPrinter:textOut(left(MOTIVO,14))
      oPrinter:setPrc(oPrinter:pRow(),141)
      oPrinter:textOut(if(empty(NF),"-",NF))
      oPrinter:setPrc(oPrinter:pRow(),152)
      oPrinter:textOut(transform(VR_NF,"@R@E 999,999.99"))
      oPrinter:setPrc(oPrinter:pRow(),164)
      oPrinter:textOut(transform(PESO2,"@R@E 9999.9"))
      oPrinter:setPrc(oPrinter:pRow(),172)

      WGANHO = if(PESO1 == 0 .or. PESO2 == 0, 0, PESO2-PESO1)
      oPrinter:textOut(transform(WGANHO,"@R@E 9999.9"))
      
      WLUCRO = if(VR_NF == 0 .or. VALOR == 0, 0, (VR_NF - VALOR))
      
      if VR_NF == 0 .or. VALOR == 0
         WPERC = 0 
      else
         WPERC = ((VALOR / VR_NF) * 100)
      endif 

      oPrinter:setPrc(oPrinter:pRow(),180)
      oPrinter:textOut(transform(WLUCRO,"@R@E 999,999.99"))
      oPrinter:setPrc(oPrinter:pRow(),192)
      oPrinter:textOut(transform(WPERC,"@R@E 999.99%"))
 
      WTOTAL_COMPRA = WTOTAL_COMPRA + VALOR 
      WTOTAL_VENDA  = WTOTAL_VENDA  + VR_NF  
      WTOTAL_GANHO  = WTOTAL_GANHO  + WGANHO
     
      if oPrinter:pRow() > 42
         Rodape_OBJ32PRN(PAG)
         oPrinter:endPage()
         CAB = .t. 
      endif

      skip +1

   enddo  

   WSALT = .t. 

   if oPrinter:pRow() > 42
      Rodape_OBJ32PRN(PAG)
      oPrinter:endPage()
      WSALT = .f.
   endif

   if oPrinter:pRow() > 30
      Rodape_OBJ32PRN(PAG)
      oPrinter:endPage()
      cab_SAIDA()  
      oPrinter:newLine()
   else 
      
      if WSALT
         oPrinter:newLine()
         Left_OBJ32PRN(replicate("-",199))
      endif 

      oPrinter:newLine()
      oPrinter:newLine()
   endif 

   WPERC  = ((WTOTAL_COMPRA / WTOTAL_VENDA) * 100)

   Left_OBJ32PRN("  RESUMO",1)
   oPrinter:newLine()
   oPrinter:newLine()
   oPrinter:textOut("1. Total de animais que sairam......... "+str(WTOTAL_ANIMAIS,4))
   oPrinter:newLine()
   oPrinter:textOut("2. Valor total de compra............... "+transform(WTOTAL_COMPRA,"@R@E 999,999,999.99"))
   oPrinter:newLine()
   oPrinter:textOut("3. Valor total de venda................ "+transform(WTOTAL_VENDA,"@R@E 999,999,999.99"))
   oPrinter:newLine()
   oPrinter:textOut("4. Lucro direto em R$.................. "+transform((WTOTAL_VENDA - WTOTAL_COMPRA),"@R@E 999,999,999.99"))
   oPrinter:newLine()
   oPrinter:textOut("5. Lucro direto em %................... "+alltrim(transform(WPERC,"@R@E 999.99%")))
   oPrinter:newLine()
   oPrinter:textOut("6. Peso total ganho.................... "+transform(WTOTAL_GANHO,"@R@E 9999,999,999.9 Kg"))
   oPrinter:newLine()
   oPrinter:textOut("7. Peso medio ganho por animal......... "+transform(WTOTAL_GANHO / WTOTAL_ANIMAIS ,"@R@E 9999,999,999.9 Kg"))
   oPrinter:newLine()

   Rodape_OBJ32PRN(PAG)

   Close_OBJ32PRN()

   if WXLS == "S"
 
      WNARQ = CRI+"-"+strzero(HB_RandomInt(999,99999),5)

      select TMP

      if lastrec() > 0 
         WARQCSV := pathCSV+"\MF-Relacao de Saidas do Plantel-"+WNARQ+".XLS" 
         aHEADER := {"BRINCO", "REGISTRO", "SEXO", "IDADE", "RACA", "PELAGEM", "ENTRADA"      , "DOC", "VALOR"                             , "PESO"                          , "SAIDA"      , "MOTIVO", "NF", "VALOR NF"                          , "PESO"                          ,  "GANHO"                               , "LUCRO"                                     , "PERC"                                                , "OBS NF", "OBS1", "OBS2", "OBS3"}
         aFIELD  := {"BRINCO", "REGISTRO", "SEXO", "IDADE", "RACA", "PELAGEM", "dtoc(ENTRADA)", "DOC", "transform(VALOR,'@R@E 999,999.99')", "transform(PESO1,'@R@E 9999.9')", "dtoc(SAIDA)", "MOTIVO", "NF", "transform(VR_NF,'@R@E 999,999.99')", "transform(PESO2,'@R@E 9999.9')",  "transform(PESO2-PESO1,'@R@E 9999.9')", "transform(VR_NF - VALOR,'@R@E 999,999.99')", "transform(((VALOR / VR_NF) * 100),'@R@E 999,999.99')", "OBS_NF", "OBS1", "OBS2", "OBS3"}
         dbf2xls("TMP", aHEADER, aFIELD, WARQCSV)
      endif

   endif

   exclui_TMP("201", WARQ+".DBF", WARQ+".cdx")
    
   select PLANTEL

enddo

return .t.

******************
function cab_SAIDA
******************
PAG++

CAB = .f.

Cabecalho_OBJ32PRN("FAZ")

Left_OBJ32PRN("Periodo: "+dtoc(WDATA1)+" a "+dtoc(WDATA2))
Middle_OBJ32PRN("RELACAO DE SAIDAS DO PLANTEL",1)
Right_OBJ32PRN("Data: "+dtoc(DATE()))
oPrinter:newLine()
Left_OBJ32PRN("Motivo.: "+alltrim(WMOTIVO))
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",199))
oPrinter:newLine()
Left_OBJ32PRN("BRINCO    REGISTRO    SEXO   IDADE        RACA          PELAGEM      | ENTRADA   DOCNO             VALOR    PESO | SAIDA     MOTIVO          NF              VALOR    PESO   GANHO       LUCRO     PERC")
oPrinter:newLine()
Left_OBJ32PRN(replicate("=",199))
oPrinter:newLine()

return .t.
