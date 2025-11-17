******************
function DASHBOARD
******************

sc_DASHBOARD()

return .t.


*********************
function sc_DASHBOARD
*********************

setcolor(COR_TEXT)
@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

setcolor("GR+/BG")
@ 02,23 say "Visualiza"+chr(135)+chr(132)+"o de Saldo do Plantel"

SOMBRA(04,02,09,79,8)

setcolor(COR_CONS)
@ 03,01 clear to 08,78

setcolor(COR_OPC)
@ 03,01 say "FAIXA ETARIA"	

setcolor(COR_CONS)
@ 04,09 say "Sexo"
@ 05,04 say "Vacinados"					
@ 06,01 say "N"+chr(132)+"o Vacinados"			
@ 08,02 say "SALDO ATUAL"	
	
setcolor(COR_OPC)

@ 03,14 say "0-2 meses"
@ 03,24 say "3-8 meses"
@ 03,34 say "9-12 meses"
@ 03,45 say "13-24 meses"
@ 03,57 say "25-36 meses"
@ 03,69 say "+36 meses"

setcolor(COR_CONS+"+")
@ 03,13 to 08,13 
@ 03,23 to 08,23 
@ 03,33 to 08,33 
@ 03,44 to 08,44 
@ 03,56 to 08,56 
@ 03,68 to 08,68 

setcolor("BG/W")
@ 04,17 say "M    F"
@ 04,27 say "M    F"
@ 04,37 say "M    F"
@ 04,49 say "M    F"
@ 04,61 say "M    F"
@ 04,72 say "M    F"

setcolor(COR_CONS+"+")
@ 07,01 to 07,78
@ 07,13 say chr(197)
@ 07,23 say chr(197)
@ 07,33 say chr(197)
@ 07,44 say chr(197)
@ 07,56 say chr(197)
@ 07,68 say chr(197)

setcolor(COR_MENU)
@ 11,01 clear to 11,78
@ 11,01 say "Total Macho:"
@ 11,29 say "Total F"+chr(136)+"mea: "
@ 11,58 clear to 11,79	
@ 11,58 say "TOTAL PLANTEL:"	

setcolor("GR+/BG")
@ 14,23 say "Visualiza"+chr(135)+chr(132)+"o de Dados Gerenciais"
                           
setcolor(COR_TEXT)
@ 16,01 say "1. Nascimentos nos "+chr(163)+"ltimos 30 dias......:"
@ 17,01 say "2. Valor atual da arroba R$.............:"
@ 18,01 say "3. Peso total ganho "+chr(163)+"ltimas pesagens....:"
@ 19,01 say "4. N"+chr(163)+"mero de animais pesados (m"+chr(161)+"nimo 2x):"

@ 21,01 say "5. Custo com engorda "+chr(163)+"ltimos 30 dias R$:"
@ 22,01 say "6. Receita estimada R$..................:"

AGUARDE()

// processamento do plantel

WT0_2MVA    = 0
WT0_2MNV    = 0
WT0_2FVA    = 0
WT0_2FNV    = 0

WT3_8MVA    = 0
WT3_8MNV    = 0
WT3_8FVA    = 0
WT3_8FNV    = 0

WT9_12MVA   = 0
WT9_12MNV   = 0
WT9_12FVA   = 0
WT9_12FNV   = 0

WT13_24MVA  = 0
WT13_24MNV  = 0
WT13_24FVA  = 0
WT13_24FNV  = 0

WT25_36MVA  = 0
WT25_36MNV  = 0
WT25_36FVA  = 0
WT25_36FNV  = 0

WT36_99MVA  = 0
WT36_99MNV  = 0
WT36_99FVA  = 0
WT36_99FNV  = 0

WTOT_FEMEA  = 0
WTOT_MACHO  = 0
WTOTAL      = 0

WULT_30D    = DATE() - 30  
WTOT_FNASC  = 0
WTOT_MNASC  = 0

WTOT_OUT    = 0

// pesagem efetuada
WGANHO      = 0
WANIMAIS_P  = 0

WPESO_ATE1  = 0
WPESO_MAIS1 = 0

select PLANTEL
ordsetfocus("SINC001")
go top 

do while ! eof()

   if ! empty(SAIDA)
      skip +1
      loop
   endif

   WBRINCO = BRINCO
   WIDADE  = if(empty(NASC),1,round(((DATE() - NASC) / 30),0))
   WSEXO   = SEXO 
 
   // checa os nascimentos dos últimos 30 dias
   
   if NASC >= WULT_30D .and. NASC <= DATE()  
      if WSEXO = "M"
         WTOT_MNASC = WTOT_MNASC + 1 
      else
         WTOT_FNASC = WTOT_FNASC + 1
      endif 
   endif 

   WTOT_NASC = WTOT_MNASC + WTOT_FNASC

   setcolor(COR_TEXT)

   @ 16,43 say WTOT_NASC picture "999"
   @ 16,47 say "| M: "
   @ 16,53 say WTOT_MNASC picture "999"

   WPERC1 = ((WTOT_MNASC / WTOT_NASC) * 100)
   @ 16,57 say WPERC1 picture "@R@E [999%]"

   @ 16,64 say "| F: "
   @ 16,69 say WTOT_FNASC picture "999"

   WPERC2 = ((WTOT_FNASC / WTOT_NASC) * 100)
   @ 16,73 say WPERC2 picture "@R@E [999%]"

   // checa as vacinações

   select VACINA_P
   ordsetfocus("SINC002")
   seek WBRINCO

   if found()

      if WIDADE <= 2
         if WSEXO == "M"
            WT0_2MVA = WT0_2MVA + 1
         else
            WT0_2FVA = WT0_2FVA + 1 
         endif   
      
      elseif WIDADE >= 3 .and. WIDADE <= 8    
        if WSEXO == "M"
           WT3_8MVA = WT3_8MVA + 1 
        else
           WT3_8FVA = WT3_8FVA + 1 
        endif  

      elseif WIDADE >= 9 .and. WIDADE <= 12    
        if WSEXO == "M"
           WT9_12MVA = WT9_12MVA + 1  
        else 
           WT9_12FVA = WT9_12FVA + 1 
        endif  

      elseif WIDADE >= 13 .and. WIDADE <= 24    
        if WSEXO == "M"
           WT13_24MVA = WT13_24MVA + 1    
        else
           WT13_24FVA = WT13_24FVA + 1 
        endif  

      elseif WIDADE >= 25 .and. WIDADE <= 36    
        if WSEXO == "M"
           WT25_36MVA = WT25_36MVA + 1    
        else
           WT25_36FVA = WT25_36FVA + 1 
        endif  

      elseif WIDADE > 36    
        if WSEXO == "M"
           WT36_99MVA = WT36_99MVA + 1
        else
           WT36_99FVA = WT36_99FVA + 1 
        endif   
      endif 

   else

      if WIDADE <= 2
         if WSEXO == "M"
            WT0_2MNV = WT0_2MNV + 1 
         else
            WT0_2FNV = WT0_2FNV + 1 
         endif

      elseif WIDADE >= 3 .and. WIDADE <= 8    
         if WSEXO == "M"
            WT3_8MNV = WT3_8MNV + 1
         else
            WT3_8FNV = WT3_8FNV + 1 
         endif  

      elseif WIDADE >= 9 .and. WIDADE <= 12    
         if WSEXO == "M"
            WT9_12MNV = WT9_12MNV + 1
         else 
            WT9_12FNV = WT9_12FNV + 1 
         endif  

      elseif WIDADE >= 13 .and. WIDADE <= 24       
         if WSEXO == "M"
            WT13_24MNV = WT13_24MNV + 1
         else
            WT13_24FNV = WT13_24FNV + 1
         endif 

      elseif WIDADE >= 25 .and. WIDADE <= 36       
         if WSEXO == "M"
            WT25_36MNV = WT25_36MNV + 1
         else
            WT25_36FNV = WT25_36FNV + 1
         endif 

      elseif WIDADE >= 36   
         if WSEXO == "M"
            WT36_99MNV = WT36_99MNV + 1
         else 
            WT36_99FNV = WT36_99FNV + 1 
         endif 
      endif  

   endif  

   select PLANTEL

   setcolor(COR_CONS)

   // vacinados [Macho/Fêmea]

   @ 05,14 say WT0_2MVA   picture "9999" 
   @ 05,19 say WT0_2FVA   picture "9999"

   @ 05,24 say WT3_8MVA   picture "9999" 
   @ 05,29 say WT3_8FVA   picture "9999"

   @ 05,34 say WT9_12MVA picture "9999" 
   @ 05,39 say WT9_12FVA picture "9999"

   @ 05,46 say WT13_24MVA picture "9999"  
   @ 05,51 say WT13_24FVA picture "9999"

   @ 05,58 say WT25_36MVA picture "9999"  
   @ 05,63 say WT25_36FVA picture "9999"

   @ 05,69 say WT36_99MVA picture "9999"   
   @ 05,74 say WT36_99FVA picture "9999"

   // não vacinados [Macho/Fêmea]

   @ 06,14 say WT0_2MNV   picture "9999" 
   @ 06,19 say WT0_2FNV   picture "9999"

   @ 06,24 say WT3_8MNV   picture "9999" 
   @ 06,29 say WT3_8FNV   picture "9999"

   @ 06,34 say WT9_12MNV picture "9999" 
   @ 06,39 say WT9_12FNV picture "9999"

   @ 06,46 say WT13_24MNV picture "9999"  
   @ 06,51 say WT13_24FNV picture "9999"

   @ 06,58 say WT25_36MNV picture "9999"  
   @ 06,63 say WT25_36FNV picture "9999"

   @ 06,69 say WT36_99MNV picture "9999"   
   @ 06,74 say WT36_99FNV picture "9999"

   // sub-total [vacinados + não vacinados]

   @ 08,14 say WT0_2MVA  + WT0_2MNV    picture "9999" 
   @ 08,19 say WT0_2FVA  + WT0_2FNV    picture "9999"
 
   @ 08,24 say WT3_8MVA  + WT3_8MNV    picture "9999" 
   @ 08,29 say WT3_8FVA  + WT3_8FNV    picture "9999"
 
   @ 08,34 say WT9_12MVA + WT9_12MNV   picture "9999" 
   @ 08,39 say WT9_12FVA + WT9_12FNV   picture "9999"
 
   @ 08,46 say WT13_24MVA + WT13_24MNV picture "9999"  
   @ 08,51 say WT13_24FVA + WT13_24FNV picture "9999"
 
   @ 08,58 say WT25_36MVA + WT25_36MNV picture "9999"  
   @ 08,63 say WT25_36FVA + WT25_36FNV picture "9999"
 
   @ 08,69 say WT36_99MVA + WT36_99MNV picture "9999"   
   @ 08,74 say WT36_99FVA + WT36_99FNV picture "9999"

   // totais

   WTOT_MACHO = (WT0_2MVA   + WT0_2MNV + WT3_8MVA + WT3_8MNV + WT9_12MVA + WT9_12MNV + WT13_24MVA + WT13_24MNV + WT25_36MVA + WT25_36MNV + WT36_99MVA + WT36_99MNV)
   WTOT_FEMEA = (WT0_2FVA   + WT0_2FNV + WT3_8FVA + WT3_8FNV + WT9_12FVA + WT9_12FNV + WT13_24FVA + WT13_24FNV + WT25_36FVA + WT25_36FNV + WT36_99FVA + WT36_99FNV)
   WTOTAL     = (WTOT_FEMEA + WTOT_MACHO)

   setcolor(COR_MENU)

   @ 11,14 say WTOT_MACHO picture "999999"
   @ 11,42 say WTOT_FEMEA picture "999999"
   @ 11,72 say WTOTAL     picture "999999"

   WPERC1 = ((WTOT_MACHO / WTOTAL) * 100)
   @ 11,21 say WPERC1 picture "@R@E [999%]"

   WPERC2 = ((WTOT_FEMEA / WTOTAL) * 100)
   @ 11,49 say WPERC2 picture "@R@E [999%]"

   // checa o ultimo peso ganho

   WULT_PESO = 0
   WPESO_ANT = 0

   select PESAGEM 
   ordsetfocus("SINC002")
   seek WBRINCO

   if found()
      WULT_PESO = PESO

      skip +1

      if BRINCO == WBRINCO
         WPESO_ANT = PESO 
      endif  
   endif     

   if WPESO_ANT > 0 
      if WULT_PESO > WPESO_ANT
         WGANHO = WGANHO + (WULT_PESO - WPESO_ANT)
         WANIMAIS_P++
         WPESO_MAIS1++
      endif   
   else
      WPESO_ATE1++
   endif 

   select PLANTEL
   skip +1

enddo

// exibe os dados gerenciais

WDIR2 = WDIRE_FAZ+"\INDICA.CFG"

if ! file(WDIR2)
   IND_ARROBA = 0
   IND_ABATE  = 0
   IND_GANHO  = 0
   IND_DATA   = DATE()
else
   restore from &WDIR2 additive
endif

setcolor(COR_TEXT)
@ 17,43 say IND_ARROBA picture "@R@E 999,999,999.99"
@ 18,43 say WGANHO     picture "@R@E 999999.9 Kg"
@ 18,56 say "| "+transform(WGANHO/15,"@R@E 9999 Arroba(s)")
@ 19,43 say WANIMAIS_P picture "99999"

WDESPESA = ret_CUSTO_ENGORDA(DATE()-30, DATE())
@ 21,43 say WDESPESA   picture "@R@E 999,999,999.99"

WRECEITA = (WGANHO / 15) * IND_ARROBA
@ 22,43 say WRECEITA   picture "@R@E 999,999,999.99"

setcolor(COR_TEXT)
@ 24,00 clear to 24,79

setcolor(COR_TEXT)
if confirma(24,"Imprimir o Dashboard...(S/N)?","N") == "S"
   // print_DASHBOARD()
endif

return .t.

******************************************
function ret_CUSTO_ENGORDA(WDATA1, WDATA2)
******************************************

// gera o custo de engorda no periodo [totaliza as saidas com centro de custo CCE = 'S']

WCUSTO_TOTAL = 0

select OUTRAS_S
ordsetfocus("SINC003")
seek WDATA1

do while SAIDA <= WDATA2 .and. ! eof()

   WCCUSTO = CCUSTO 

   select CUSTO
   ordsetfocus("SINC001")
   seek WCCUSTO

   if ! found()
      select OUTRAS_S
      skip +1
      loop
   endif

   // checa se o centro de custo compoe a engorda

   if CCE <> "S"
      select OUTRAS_S
      skip +1
      loop
   endif

   select OUTRAS_S

   WSEQ = SEQ

   select ITENS_S
   ordsetfocus("SINC001")
   seek WSEQ

   do while SEQ == WSEQ .and. ! eof()
         
      WCUSTO_TOTAL = WCUSTO_TOTAL + (QTDE * UNITARIO)

      select ITENS_S
      skip +1

   enddo

   select OUTRAS_S
   skip +1

enddo
   
return WCUSTO_TOTAL
