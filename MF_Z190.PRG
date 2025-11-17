*********************************************************************
****  Sistema......: MF-Minha Fazenda (Gerenciador)              ****
****  Versao.......: 4.0                                         ****
****  Programa.....: MFZ190.PRG                                  ****
****  Finalidade...: Funcoes de uso geral do sistema             ****
****                                                             ****
*********************************************************************
#include "inkey.ch"
#include "WinGdi.ch" 
#include "fileio.ch"
#include "TBrowse.ch"
#include "common.ch"
#include "winuser.ch"
#define RGB_BLACK RGB( 0, 0, 0 )

****************
function ACHOISE
****************
static M0, M1, M2, M3, M4, M5, M6, M7, P1

private I, NCRI, OPCOES, ACESSO, LETRAS, P0,;
        A, KEY, POS, W, QQTDE

parameters I, NCRI, OPCOES, ACESSO, LETRAS, P0

M0    = left("MENU PRINCIPAL"+space(40),40)
QQTDE = len(OPCOES)

@ 02,00 clear to 22,79
@ 24,00 clear to 24,79

setcolor(COR_BARRA)

if NCRI == 0
   @ 01,01 say left(M0+space(40),40)
elseif NCRI == 1
   @ 01,01 say left(M1+space(40),40)
elseif NCRI == 2
   @ 01,01 say left(M2+space(40),40)
elseif NCRI == 3
   @ 01,01 say left(M3+space(40),40)
elseif NCRI == 4
   @ 01,01 say left(M4+space(40),40)
elseif NCRI == 5
   @ 01,01 say left(M5+space(40),40)
elseif NCRI == 6
   @ 01,01 say left(M6+space(40),40)
elseif NCRI == 7
   @ 01,01 say left(M7+space(40),40)
endif

@ 01,60 say space(18)
@ 23,63 say left(dtoc(date()),5)+" - "

setcolor(COR_TEXT)

CALENDARIO(.f.)

for W = 1 to QQTDE 
    OPCOES[W] = left(OPCOES[W]+space(40),40)

    if ACESSO[W]
       setcolor(COR_TEXT)
    else
       setcolor(COR_SUB)
       if W = I
          I++
       endif
    endif
    @ 01+W,00 say OPCOES[W]
next

setcolor(COR_DEST)
for W = 1 to QQTDE
    if ACESSO[W]
       @ 01+W,00+at(upper(LETRAS[W]),upper(OPCOES[W]))-1 say LETRAS[W]
    endif
next

setcolor(COR_GETS) 
@ 01+I,00 say OPCOES[I]
setcolor(COR_TEXT)

A = I

************** C.R.I. *************
CRI = left(CRI,NCRI)
CRI = CRI + LETRAS[I]

setcolor(COR_BARRA)
@ 01,43 say replicate(chr(177),8)
@ 01,43 say CRI

setcolor(COR_TEXT)
CRI = left(CRI,len(CRI)-1)

************** C.R.I. *************

do while .t.

   if A <> I
      if ACESSO[A]
         setcolor(COR_TEXT)
      else
         setcolor(COR_SUB)
      endif
      @ 01+A,00 say OPCOES[A]   
      setcolor(COR_TEXT)
      if ACESSO[A]
         setcolor(COR_DEST)
         @ 01+A,00+at(upper(LETRAS[A]),upper(OPCOES[A]))-1 say LETRAS[A] 
         setcolor(COR_TEXT)
      endif

      setcolor(COR_GETS) 
      @ 01+I,00 say OPCOES[I]
      setcolor(COR_TEXT)

      CRI = CRI + LETRAS[I]
      setcolor(COR_BARRA)
      @ 01,43 say replicate(chr(177),8)
      @ 01,43 say CRI
      setcolor(COR_TEXT)
      CRI = left(CRI,len(CRI)-1)
   endif

   A = I
   
   KEY = inkey(0) 
   
   if KEY == 5
      I = I - 1
      if I < 1
         I = QQTDE
      endif

      do while ! ACESSO[I]
         I = I - 1
         if I < 1 
            I = QQTDE
         endif
      enddo
   elseif KEY == 24
      I = I + 1
      if I > QQTDE
         I = 1
      endif

      do while ! ACESSO[I]
         I = I + 1
         if I > QQTDE
            I = 1
         endif
      enddo

   elseif KEY == K_RIGHT  
      if ACESSO[I]
         setcolor(COR_TEXT)
      else
         setcolor(COR_SUB)
      endif
      @ 01+I,00 say OPCOES[I]   
      setcolor(COR_TEXT)
      if ACESSO[I]
         setcolor(COR_DEST)
         @ 01+I,00+at(upper(LETRAS[I]),upper(OPCOES[I]))-1 say LETRAS[I] 
         setcolor(COR_TEXT)
      endif

      CALENDARIO(.t.)

      setcolor(COR_GETS) 
      @ 01+I,00 say OPCOES[I]
      setcolor(COR_TEXT)

   elseif (KEY >= 65 .and. KEY <= 90) .or. (KEY >= 97 .and. KEY <=122)
      POS = ascan(LETRAS,upper(chr(KEY)))

      if POS <> 0 .and. ACESSO[POS]
         I    = POS
         KEY  = 13
      endif
      
   endif

   if KEY == 27 .or. KEY == 13
      if KEY == 13
         if QQTDE == I
            CRI = left(CRI,len(CRI)-1)
         else
            CRI = CRI + LETRAS[I]
         endif

         if NCRI == 0
            M1 = ltrim(OPCAO[I])
         elseif NCRI == 1
            M2 = ltrim(OPCAO[I])
         elseif NCRI == 2
            M3 = ltrim(OPCAO[I])
         elseif NCRI == 3
            M4 = ltrim(OPCAO[I])
         elseif NCRI == 4
            M5 = ltrim(OPCAO[I])
         elseif NCRI == 5
            M6 = ltrim(OPCAO[I])
         elseif NCRI == 6
            M7 = ltrim(OPCAO[I])
         endif

         setcolor(COR_BARRA)
         if ! P0 
            @ 01,01 say ltrim(OPCAO[I])
         else
            @ 01,60 say left(ltrim(OPCAO[I])+space(19),19)
         endif
         setcolor(COR_TEXT)
      else
         I = 0
      endif

      setcolor(COR_BARRA)
      @ 01,43 say replicate(chr(177),8)
      @ 01,43 say CRI
      setcolor(COR_TEXT)

      return I
   endif
enddo

return 0


**************************
function CALENDARIO(WWNAV)
**************************
LOCAL WWDATA, WWWDATA, WWMES, WWDIA, WWFER, WWLIMITE, COL, LIN, A, I, L, P
LOCAL cJSON := hash()

WCITY = "27300"

PRIVATE WWCOR    := setcolor()
PRIVATE WWCURSOR := setcursor()
PRIVATE WWAREA   := alias()
   
select FERIADO
ordsetfocus("SINC001")

WWDATA  = DATE()
WWDREF  = day(DATE())
   
do while .t. 
   WWMES    = month(WWDATA)
   WWLIMITE = day(EoM(WWDATA))

   setcolor(COR_BARRA)
   @ 01,60 clear to 01,78
   @ 01,60 say upper(mes(WWMES))
   @ 01,75 say str(year(WWDATA),4)
   setcolor(COR_TEXT)
   @ 02,59 say " D  S  T  Q  Q  S  S"
   setcolor(COR_DEST)
   @ 02,59 say " D"
   setcolor(COR_SUB) 

   WWDIA = ctod("01/"+str(WWMES,2)+"/"+right(str(year(WWDATA),4),2))
   COL   = ((dow(WWDIA)*3)-2)+1
   LIN   = 03
   L     = 10

   setcolor(COR_TEXT) 
   if WWNAV
      @ 09,59 say "use +/- para navegar"
   else
      @ 09,59 say ">acesse seta direita"
   endif
   setcolor(COR_SUB) 

   for I = 1 to WWLIMITE
      if I == WWDREF .and. WWNAV
         setcolor(COR_GETS)
         @ 02,COL+57 say substr(" D  S  T  Q  Q  S  S",COL-1,2)
         @ LIN,COL+57 say str(I,2)
         setcolor(COR_SUB)
      elseif COL == 02 
         setcolor(COR_DEST) 
         @ LIN,COL+57 say str(I,2)
         setcolor(COR_SUB)
      else
         @ LIN,COL+57 say str(I,2)
      endif   

      if year(WWDATA) == year(date()) .and. month(WWDATA) == month(date()) .and. I = day(date())
         setcolor(COR_DEST)
         @ 02,55+(dow(date())*3) say "["
         @ 02,58+(dow(date())*3) say "]"

         @ LIN,55+(dow(date())*3) say "["
         @ LIN,58+(dow(date())*3) say "]"
         setcolor(COR_SUB)
      endif

      WWFER = space(01)

      select FERIADO
      ordsetfocus("SINC001")
      seek strzero(year(WWDIA),4)+right(dtos(WWDIA),4)

      if ! found()
         seek "0000"+right(dtos(WWDIA),4)

         if found()
            if CIDADE == "99999"
               WWFER = "N"
            elseif CIDADE == WCITY
               WWFER = "M"
            endif
         endif
      else
         if CIDADE == "99999"
            WWFER = "N"
         elseif CIDADE == WCITY
            WWFER = "M"
         endif
      endif

      if I <> WWDREF .or. ! WWNAV
         if WWFER == "N" 
            setcolor(COR_DEST) 
            @ LIN,COL+57 say str(I,2)
            setcolor(COR_SUB)
         elseif WWFER == "M"
            setcolor(COR_DEST) 
            @ LIN,COL+57 say str(I,2)
            setcolor(COR_SUB)
         endif
      endif

      if WWFER <> space(01)
         @ L,59 say str(I,2)+" - "+FERIADO
         L = L + 1
      endif
      
      COL   = COL + 3
      WWDIA = WWDIA + 1     

      if (COL) > 21
         LIN = LIN + 1
         COL = 02
      endif
   next

   if ! WWNAV
      exit
   endif

   A = inkey(0)

   if A == 43
      WWDREF = WWDREF + 1
      if WWDREF > WWLIMITE
         if month(WWDATA) < 12
            WWDATA = ctod("01/"+strzero(month(WWDATA)+1,2)+"/"+strzero(year(WWDATA),4))
         else
            WWDATA = ctod("01/01/"+strzero(year(WWDATA)+1,4))
         endif
         WWDREF = 1
         @ 02,58 clear to 22,78
      endif
   elseif A == 45
      WWDREF = WWDREF - 1
      if WWDREF < 1
         if month(WWDATA) > 1
            WWDATA = ctod("01/"+strzero(month(WWDATA)-1,2)+"/"+strzero(year(WWDATA),4))
         else
            WWDATA = ctod("01/12/"+strzero(year(WWDATA)-1,4))
         endif
         WWDREF = day(EoM(WWDATA))
         @ 02,58 clear to 22,78
      endif
   else
      WWNAV   = .f.
      if year(WWDATA) <> year(date()) .or. month(WWDATA) <> month(date())
         WWDATA  = date()
         WWDREF  = date()
         @ 02,58 clear to 22,78
      endif
   endif
  
enddo

setcursor(WWCURSOR)
setcolor(WWCOR)
   
if ! empty(WWAREA)
   select &WWAREA
endif

return .t.
      
********************
function iSEQUENCIAL
********************
LOCAL IQ, CR

DBAPPEND()

if NETERR()

   IQ = savescreen(12,18,17,63)
   CR = setcolor()

   SOMBRA(13,20,17,63,8)

   setcolor(COR_CONS) 
   @ 12,18 clear to 16,62
   @ 12,18 to 16,62 

   Setcolor(COR_CONS+"*") 
   @ 13,25 say "         Aten"+chr(135)+chr(132)+"o...           "

   setcolor(COR_CONS) 
   @ 15,25 say "  Erro na inclus"+chr(132)+"o do registro!  "

   inkey(4)

   restscreen(12,18,17,63,IQ)
   setcolor(CR)

   return .f.

endif

return .t.

*************
function MASK
*************

if len(alltrim(CNPJ)) > 11
   return("@R 99.999.999/9999-99") 
else
   return("@R 999.999.999-99") 
endif


********************
function imp_DEFAULT
********************
cPRINTER := GetDefaultPrinter()

return (cPRINTER)

*********************
function busca_INDICE
*********************
local getlist :={}
private MODO
parameters MODO

if MODO >= 4
   if lastkey() = 27 .or. lastkey() = 13
      return 0
   endif

   if (lastkey() >= 32 .and. lastkey() <= 254).or. lastkey() == 8
      if lastkey() == 8 
         if len(WWCHAVE) > 1
            WWCHAVE = left(WWCHAVE,len(WWCHAVE)-1) 
         else
            WWCHAVE = ""
         endif 
      elseif len(WWCHAVE) < 35
         WWCHAVE = WWCHAVE + chr(lastkey())
      endif

      @ 06,11 clear to 06,69   
      @ 06,11 say WWCHAVE

      seek upper(WWCHAVE)

      setcursor(0)

      return 2
   endif
endif

return 1


*****************************************************************
function PROMPT(PI, aCAMPO, aLIN, aCOL, COR_NORMAL, COR_DESTAQUE)
*****************************************************************
LOCAL COR, I, PA, KEY

COR = setcolor()

for I = 1 to len(aCAMPO)
    setcolor(COR_NORMAL)
    @ aLIN[I],aCOL[I] say aCAMPO[I]
next

PA = PI

do while .t.
   setcolor(COR_NORMAL)
   @ aLIN[PA],aCOL[PA] say aCAMPO[PA]
   setcolor(COR_DESTAQUE)
   @ aLIN[PI],aCOL[PI] say aCAMPO[PI]
   setcolor(COR_NORMAL)

   KEY = inkey(0)
     
   if KEY == 4 .or. KEY == 24
      PA = PI
      if PI + 1 <= len(aCAMPO)
         PI = PI + 1
      else
         PI = 1
      endif
   elseif KEY == 19 .or. KEY == 5
      PA = PI
      if PI - 1 >= 1
         PI = PI - 1
      else
         PI = len(aCAMPO)
      endif
   elseif KEY == 13
      setcolor(COR)
      return PI
   elseif KEY == 27
      setcolor(COR)
      return 0
   endif
enddo

setcolor(COR)
return 0    

*********************
function DDMMAA(mmaa)
*********************

if len(alltrim(MMAA)) <> 7
   return ctod("")
else
   return ctod("01/"+MMAA)
endif

*********************
function MMAA(ddmmaa)
*********************

return right(dtoc(DDMMAA),7)

*******************
function DDMM(ddmm)
*******************

if len(DDMM) == 4
   DDMM = left(DDMM,2)+"/"+right(DDMM,2)
endif

return ctod(DDMM+"/"+strzero(year(DATE()),4))

******************************
function LIMPA_NUMERO(WSTRING)
******************************
LOCAL I
LOCAL WNUMLIMPA := ""

for I = 1 to len(WSTRING)
    if upper(substr(WSTRING,I,1)) $ "0123456789"
       WNUMLIMPA = WNUMLIMPA + substr(WSTRING,I,1)
    endif
next

return alltrim(WNUMLIMPA)

****************************
function LIMPA_TUDO(WSTRING)
****************************
LOCAL I
LOCAL WSTRLIMPA := ""

for I = 1 to len(WSTRING)
    if upper(substr(WSTRING,I,1)) $ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.,-"
       WSTRLIMPA = WSTRLIMPA + substr(WSTRING,I,1)
    else
       WSTRLIMPA = WSTRLIMPA + space(01)
    endif    
next

return alltrim(WSTRLIMPA)


*****************
function CHCK_SEQ
*****************

WREGISTRO = recno()

do while .t.
   seek WSEQ

   if recno() == WREGISTRO
      exit
   endif

   ordsetfocus("SINC001")
   go bottom

   WSEQ    = SEQ + 1

   go WREGISTRO

   if ! reglock()
      loop
   endif
   
   replace SEQ    with WSEQ
      
   grava()
enddo

return .t.

********************
function CHCK_CODIGO
********************

WREGISTRO = recno()

do while .t.
   seek WCODIGO

   if recno() == WREGISTRO
      exit
   endif

   ordsetfocus("SINC001")
   go bottom

   WCODIGO = CODIGO + 1

   go WREGISTRO

   if ! reglock()
      loop
   endif
   
   replace CODIGO   with WCODIGO
      
   grava()
enddo

return .t.

*********************
function ARREND(WVAR)
*********************

if (WVAR - int(WVAR)) <> 0
   return int(WVAR + 1)
else
   return int(WVAR)
endif

**************************
function VALID_HORA(hhora)
**************************

if empty(HHORA)
   return .t.
endif

if len(alltrim(HHORA)) <> 4
   return .f.
endif

if val(left(HHORA,2)) > 23 
   return .f.
endif

if val(right(HHORA,2)) > 59 
   return .f.
endif

return .t.

*****************
function CHCK_CGC
*****************
private D[12], WCPF, DF1, RESTO, PRIDIG, SEGDIG
parameters WCPF

if empty(WCPF)
   return .t.
endif

if len(alltrim(WCPF)) <> 11 .and. len(alltrim(WCPF)) <> 14
   return .f.
endif

if WCPF <> replicate("9",14) .and. left(WCPF,2) == "99" .and. right(WCPF,2) == "99" 
   MENSAGEM2("Inscri��o v�lida somente para EXPORTA��O.")
   return .t.
endif

if len(alltrim(WCPF)) < 11
   return .f.
endif   

if alltrim(WCPF) = replicate("9",14) .or. alltrim(WCPF) = replicate("9",11)
   return .t.
endif

afill(D,0)

for I = 1 to len(alltrim(WCPF))-2
    D[I] = val(substr(WCPF,I,1)) 

    if empty(substr(WCPF,I,1))
       MENSAGEM2("CNPJ/CPF inv�lido!")
       return .f.
    endif
next

if len(alltrim(WCPF)) > 11
   DF1 = 5*D[1] + 4*D[2] + 3*D[3] + 2*D[4] + 9*D[5] + 8*D[6] + 7*D[7] + 6*D[8] + 5*D[9] + 4*D[10] + 3*D[11] + 2*D[12]
else
   DF1 = 10*D[1] + 9*D[2] + 8*D[3] + 7*D[4] + 6*D[5] + 5*D[6] + 4*D[7] + 3*D[8] + 2*D[9]
endif

RESTO = mod(DF1,11)

if RESTO = 0 .or. RESTO = 1
   PRIDIG = 0
else
   PRIDIG = 11 - RESTO
endif

if len(alltrim(WCPF)) > 11
   DF1 = 6*D[1] + 5*D[2] + 4*D[3] + 3*D[4] + 2*D[5] + 9*D[6] + 8*D[7] + 7*D[8] + 6*D[9] + 5*D[10] + 4*D[11] + 3*D[12] + 2*PRIDIG 
else
   DF1 = 11*D[1] + 10*D[2] + 9*D[3] + 8*D[4] + 7*D[5] + 6*D[6] + 5*D[7] + 4*D[8] + 3*D[9] + 2*PRIDIG 
endif

RESTO = mod(DF1,11)

if RESTO = 0 .or. RESTO = 1
   SEGDIG = 0
else
   SEGDIG = 11 - RESTO
endif

if PRIDIG <> val(substr(WCPF,len(alltrim(WCPF))-1,1)) .or. SEGDIG <> val(substr(WCPF,len(alltrim(WCPF)),1))
   MENSAGEM2("CNPJ/CPF inv�lido!")
   return .f.
endif

return .t.

*****************
function MOD(W,X)
*****************
local Y

Y = W % X

return iif(X = 0, W, iif(Y*X < 0, Y+X, Y))

***************
function CENTRO
***************

private c_LIN, c_STRING, c_COLUNA
parameters c_LIN, c_STRING

c_COLUNA = 0

c_COLUNA = int(40 - (len(c_STRING)/2)) 
@ c_LIN,c_COLUNA say c_STRING

return .t.

******************
function MES(WMES)
******************

WMES = WMES * 9 - 8

return alltrim(substr("Janeiro  "+"Fevereiro"+"Marco    "+"Abril    "+"Maio     ";
                     +"Junho    "+"Julho    "+"Agosto   "+"Setembro "+"Outubro  ";
                     +"Novembro "+"Dezembro ",WMES ,9))

************************
Function SEMANA(WDDMMAA)
************************

WDDMMAA = dow(WDDMMAA) * 13 - 12

return alltrim(substr("Domingo      "+"Segunda-Feira"+"Terca-Feira  "+"Quarta-Feira ";
                     +"Quinta-Feira "+"Sexta-Feira  "+"Sabado       ",WDDMMAA,13))

***************
function SOMBRA
***************

private L1,C1,L2,C2,ATR,TELA,TAM,FORM
parameters L1,C1,L2,C2,ATR

TELA = savescreen(L1,C1,L2,C2,ATR)
TAM  = len(TELA)
FORM = replicate("X"+chr(ATR),TAM/2)

restscreen(L1,C1,L2,C2,transform(TELA,FORM))

return .t.

***************
function READ_F
***************

setcursor(1)
READ MSG AT 24, 00, 79 MSG COLOR COR_TEXT
setcursor(0)

return .t.

**********************************************
function Open_OBJ32PRN(xCopies,xFORM,xPRINTER)
**********************************************
LOCAL cPrinter := if(empty(xPRINTER),GetDefaultPrinter(),xPRINTER)
LOCAL aFonts, cFont, nFont 

// Create printer object and configure print job 

oPrinter := Win32Prn():new( cPrinter )

If xFORM = "P"
   oPrinter:landscape := .T. 
else
   oPrinter:landscape := .F. 
endif

oPrinter:formType := DMPAPER_A4
oPrinter:copies   := xCopies

// Create device context 
IF .NOT. oPrinter:create()
    Alert( "Erro ao acessar o dispositivo : "+GetDefaultPrinter() )
    return .f.
endif 

// Create print job 

IF .NOT. oPrinter:startDoc( "Relatorio do MinhaFazenda" )
   Alert( "Erro de escrita no dispositivo : "+GetDefaultPrinter() )
   return .f.
endif

oPrinter:SetFont('Courier New',10,18)

oPrinter:leftMargin   := 150
oPrinter:rightMargin  := oPrinter:pageWidth - 300
oPrinter:topMargin    := 220
oPrinter:bottomMargin := oPrinter:pageHeight - 220

return.t.

********************************
function Cabecalho_OBJ32PRN(WMD)
********************************
#include "win32prn.ch"

oPrinter:textOutAt(oPrinter:leftMargin, oPrinter:topMargin, if(empty(WMD),alltrim(CFG_EMPRES),alltrim(WNAM_FAZ)))
oPrinter:textOutAt(oPrinter:rightMargin - oPrinter:getTextWidth(CRI), oPrinter:topMargin, CRI)

oPrinter:setPen( PS_DASH, 5, RGB_BLACK )

oPrinter:line( oPrinter:leftMargin, ;
               oPrinter:topMargin+40, ;
               oPrinter:rightMargin, ;
               oPrinter:topMargin+40 )

oPrinter:newLine()
oPrinter:newLine()
               
return .t.

*******************************
function Rodape_OBJ32PRN(xPage)
*******************************

oPrinter:line( oPrinter:leftMargin, ;
               oPrinter:bottomMargin-140, ;
               oPrinter:rightMargin, ;
               oPrinter:bottomMargin-140 )

oPrinter:newLine()
oPrinter:textOutAt(oPrinter:leftMargin, oPrinter:bottomMargin, "MinhaFazenda (Gerenciador)")

if xPage > 0
   oPrinter:textOutAt(oPrinter:rightMargin - oPrinter:getTextWidth("Pagina: "+alltrim(str(xPage))), oPrinter:bottomMargin, "Pagina: "+alltrim(str(xPage)))
endif

return .t.

********************************
function Rodape2_OBJ32PRN(xPage)
********************************

oPrinter:line( oPrinter:leftMargin, ;
               oPrinter:bottomMargin-140, ;
               oPrinter:rightMargin, ;
               oPrinter:bottomMargin-140 )

oPrinter:newLine()

if xPage > 0
   oPrinter:textOutAt(oPrinter:rightMargin - oPrinter:getTextWidth("Pagina: "+alltrim(str(xPage))), oPrinter:bottomMargin, "Pagina: "+alltrim(str(xPage)))
endif

return .t.


**********************
function line_OBJ32PRN
**********************

oPrinter:line( oPrinter:leftMargin, ;
               oPrinter:bottomMargin-140, ;
               oPrinter:rightMargin, ;
               oPrinter:bottomMargin-140 )

oPrinter:newLine()

return .t.

***************************************
function Middle_OBJ32PRN(xMessage,xTam)
***************************************

if (xTam == 1)
   oPrinter:SetFont('Courier New',10,12)
   oPrinter:bold(FW_EXTRABOLD)
endif

oPrinter:textOutAt(int((oPrinter:rightMargin - oPrinter:getTextWidth(xMessage))/2), oPrinter:posY, xMessage)

oPrinter:SetFont('Courier New',10,18)
OPrinter:bold(FW_NORMAL)

return .t.

***************************************
function Right_OBJ32PRN(xMessage,xTam)
***************************************

if (xTam == 1)
   oPrinter:SetFont('Courier New',10,12)
   oPrinter:bold(FW_EXTRABOLD)
endif

oPrinter:textOutAt(int((oPrinter:rightMargin - oPrinter:getTextWidth(xMessage))), oPrinter:posY, xMessage)

oPrinter:SetFont('Courier New',10,18)
OPrinter:bold(FW_NORMAL)

return .t.

*************************************
function left_OBJ32PRN(xMessage,xTam)
*************************************

if (xTam == 1)
   oPrinter:SetFont('Courier New',10,12)
   oPrinter:bold(FW_EXTRABOLD)
elseif (xTam == 0)
   oPrinter:SetFont('Courier New',10,12)
endif

oPrinter:textOutAt(oPrinter:leftMargin, oPrinter:posY, xMessage)

oPrinter:SetFont('Courier New',10,18)
OPrinter:bold(FW_NORMAL)

return .t.

**************************************
function left2_OBJ32PRN(xMessage,xTam)
**************************************

if (xTam == 1)
   oPrinter:SetFont('Courier New',12,14)
   oPrinter:bold(FW_EXTRABOLD)
elseif (xTam == 0)
   oPrinter:SetFont('Courier New',12,14)
endif

oPrinter:textOutAt(oPrinter:leftMargin, oPrinter:posY, xMessage)

oPrinter:SetFont('Courier New',12,20)
OPrinter:bold(FW_NORMAL)

return .t.

***********************
function Close_OBJ32PRN
***********************

// Send output to printer 
oPrinter:enddoc()

// Release GDI device context 
oPrinter:destroy()

return .t.

***********************************
FUNCTION RGB( nRed, nGreen, nBlue )
***********************************

RETURN ( nRed + ( nGreen * 256 ) + ( nBlue * 65536 ) )


**************
function SCALC
**************
static C

local WCOR
local WCURSOR
local TELA
local CONTROL  
local PAUSA
local PARC
local PONTO
local RESP
local COMANDO
local KEY
local SINAL
local WWTELA
local STOTAL
local I
local A

set fixed on
set decimals to 12

if valtype(C) == "U"
   C       = 0
endif

WCOR    = setcolor()
WCURSOR = setcursor()

save screen to TELA
setcursor(0)

setcolor(COR_TEXT)
@ 14,01+C to 15,19+C
setcolor(COR_CONS)

@ 15,00+C clear to 24,20+C
@ 15,00+C to 24,20+C double

@ 20,14+C to 22,18+C double
@ 21,16+C say "H"

@ 20,02+C say "SuperCalc"
@ 21,02+C say "    ver 2.1"
@ 23,04+C say "(C)Sinergia" 

setcolor(COR_TEXT)
@ 16,01+C clear to 18,19+C
@ 16,01+C to 18,19+C 

CONTROL = 0
PAUSA   = .t.
PARC    = ""
PONTO   = "."
RESP    = 0
COMANDO = "+"
KEY     = .t.
SINAL   = " "
WWTELA  = savescreen(14,01+C,15,19+C)

do while .t.
   ****************
   ***  DISPLAY ***
   ****************

   @ 17,02+C clear to 17,18+C

   if empty(SINAL) .or. SINAL == "=" .or. COMANDO == "V"
      if int(val(PARC)) == val(PARC)
         set fixed off
      endif

      if empty(PARC) 
         @ 17,16-len("0")+C say "0"
      else
         @ 17,16-len(PARC)+C say PARC
      endif

      @ 17,16+C           say PONTO
      @ 17,18+C           say SINAL
   else
      if int(RESP) == RESP
         set fixed off

         PONTO  = "."
         STOTAL = left(alltrim(transform(int(RESP),"@Z")),14)
      else
         PONTO  = " "
         STOTAL = left(alltrim(transform(RESP,"@Z")),14)

         for I = 14 to 1 step -1
             if right(STOTAL,1) == "0" .or. empty(right(STOTAL,1))
                STOTAL = left(STOTAL,I)
             else
                exit
             endif
         next
      endif

      if empty(STOTAL) 
         @ 17,16-len("0")+C say "0"
      else
         @ 17,16-len(STOTAL)+C say STOTAL
      endif
   
      @ 17,16+C             say PONTO
      @ 17,18+C             say SINAL

      PONTO = "."
   endif

   set fixed on

   A = inkey(0) 

   if A == 67 .or. A == 99           
      *********************
      ***  CANCELA - C  ***      
      *********************

      if SINAL <> "=" 
         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif      
         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      RESP    = 0
      PARC    = ""
      PONTO   = "."
      COMANDO = "+"
      SINAL   = " "

   elseif A == 27
      ***************************
      ***  FINALIZACAO - Esc  *** 
      ***************************

      restore screen from TELA
      setcursor(WCURSOR)
      setcolor(WCOR)
      set fixed on
      set decimals to 2
      return 

   elseif A == 84 .or. A == 116
      ************************
      ***  TRANSPORTA - T  *** 
      ************************

      restore screen from TELA
      setcursor(WCURSOR)
      setcolor(WCOR)
      set fixed on
      set decimals to 2

      WVARR = readvar()

      if ! empty(WVARR)
         if valtype(&WVARR) == "N" 
            &WVARR = val(PARC)
         endif
      endif

      return 

   elseif A == 19
      **************************************
      ***  MOVIMENTACAO - Seta Esquerda  ***
      **************************************

      restore screen from TELA
      C = C - 1
      if C < 0
         C = 59
      endif

      setcolor(COR_CONS)
      @ 15,00+C clear to 24,20+C
      @ 15,00+C to 24,20+C double

      @ 20,14+C to 22,18+C double
      @ 21,16+C say "H"

      @ 20,02+C say "SuperCalc"
      @ 21,02+C say "    ver 2.0"
      @ 23,04+C say "(C)Sinergia"

      setcolor(COR_TEXT)
      @ 16,01+C clear to 18,19+C
      @ 16,01+C to 18,19+C 
    
      if PAUSA
         restscreen((13-CONTROL+1),01+C,15,19+C,WWTELA)
      else
         restscreen(00,01+C,15,19+C,WWTELA)
      endif

   elseif A == 4
      *************************************
      ***  MOVIMENTACAO - Seta Direita  ***
      *************************************

      restore screen from TELA
      C = C + 1
      if C > 59
         C = 0 
      endif

      setcolor(COR_CONS)
      @ 15,00+C clear to 24,20+C
      @ 15,00+C to 24,20+C double

      @ 20,14+C to 22,18+C double
      @ 21,16+C say "H"

      @ 20,02+C say "SuperCalc"
      @ 21,02+C say "    ver 2.0"
      @ 23,04+C say "(C)Sinergia"

      setcolor(COR_TEXT)
      @ 16,01+C clear to 18,19+C
      @ 16,01+C to 18,19+C 

      if PAUSA
         restscreen((13-CONTROL+1),01+C,15,19+C,WWTELA)
      else
         restscreen(00,01+C,15,19+C,WWTELA)
      endif

   elseif A >= 48 .and. A <= 57 
      *************************
      ***  NUMEROS - 0 a 9  ***
      *************************
 
      if SINAL = "="
         PARC = ""
      endif

      if len(PARC) < 14
         PARC = PARC + chr(A) 
      endif

      if COMANDO <> "V"
         SINAL = " "
      endif
   elseif A == 86 .or. A == 118 
      *******************
      ***  CUBAGEM  V ***
      *******************
 
      SINAL   = "A"
      COMANDO = "V"
   elseif A == 46 
      ***************************
      ***  PONTO DECIMAL - .  ***
      ***************************

      if PONTO <> " "
         PONTO = " "
         PARC = PARC + chr(A) 
      endif

      if COMANDO <> "V"
         SINAL = " "
      endif
   elseif A == 8 
      *******************************************
      ***  ELIMINACAO DE NUMEROS - Backspace  ***
      *******************************************

      if len(PARC) > 0
         if right(PARC,1) == "."
            PONTO = "."
         endif
         PARC = left(PARC,len(PARC)-1)
      endif

      SINAL = " "

   elseif A == 43 .and. SINAL <> "+"
      *****************
      *** SOMA - +  ***
      *****************

      if COMANDO == "/" .and. val(PARC) == 0
         RESP = 0
      else
         if COMANDO = "+"
            RESP = RESP + val(PARC)
         elseif COMANDO = "-"
            RESP = RESP - val(PARC)
         elseif COMANDO = "*"
            RESP = RESP * val(PARC)
         elseif COMANDO = "/"
            RESP = RESP / val(PARC)
         endif
      endif

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
       
         @ 14,16-len(PARC)+C say PARC
         @ 14,16+C           say PONTO
         @ 14,18+C           say COMANDO
    
         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on

      PARC    = ""
      COMANDO = "+"
      PONTO   = "."
      SINAL   = "+"

   elseif A == 45 .and. SINAL <> "-"
      **********************
      *** SUBTRACAO - -  ***
      **********************

      if COMANDO == "/" .and. val(PARC) == 0
         RESP = 0 
      else
         if COMANDO = "+"
            RESP = RESP + val(PARC)
         elseif COMANDO = "-"
            RESP = RESP - val(PARC)
         elseif COMANDO = "*"
            RESP = RESP * val(PARC)
         elseif COMANDO = "/"
            RESP = RESP / val(PARC)
         endif
      endif

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         @ 14,16-len(PARC)+C say PARC
         @ 14,16+C           say PONTO
         @ 14,18+C           say COMANDO

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on

      PARC    = ""
      COMANDO = "-"
      PONTO   = "."
      SINAL   = "-"

   elseif A == 42  .and. SINAL <> "*"
      **************************
      *** MULTIPLICACAO - *  ***
      **************************

      if COMANDO == "/" .and. val(PARC) == 0
         RESP = 0 
      else
         if COMANDO = "+"
            RESP = RESP + val(PARC)
         elseif COMANDO = "-"
            RESP = RESP - val(PARC)
         elseif COMANDO = "*"
            RESP = RESP * val(PARC)
         elseif COMANDO = "/"
            RESP = RESP / val(PARC)
         endif
      endif

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         @ 14,16-len(PARC)+C say PARC
         @ 14,16+C           say PONTO
         @ 14,18+C           say COMANDO

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif
  
         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on

      PARC    = ""
      COMANDO = "*"
      PONTO   = "."
      SINAL   = "*"

   elseif A == 81 .or. A == 113
      ***************************
      ***  RAIZ QUADRADA - Q  ***
      ***************************

      if COMANDO == "/" .and. val(PARC) == 0
         RESP = 0 
      else
         if COMANDO = "+"
            RESP = RESP + val(PARC)
         elseif COMANDO = "-"
            RESP = RESP - val(PARC)
         elseif COMANDO = "*"
            RESP = RESP * val(PARC)
         elseif COMANDO = "/"
            RESP = RESP / val(PARC)
         endif
      endif

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         @ 14,16-len(PARC)+C say PARC
         @ 14,16+C           say PONTO
         @ 14,18+C           say chr(251)

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on

      RESP = sqrt(RESP)

      if int(RESP) == RESP 
         set fixed off

         PONTO = "."
         PARC = left(alltrim(transform(int(RESP),"@Z")),14)
      else
         PONTO = " "
         PARC = left(alltrim(transform(RESP,"@Z")),14)

         for I = 14 to 1 step -1
             if right(PARC,1) == "0" .or. empty(right(PARC,1))
                PARC = left(PARC,I)
             else
                exit
             endif
         next
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)
      
      if empty(PARC) 
         @ 14,16-len("0")+C say "0"
      else
         @ 14,16-len(PARC)+C say PARC
      endif

      @ 14,16+C           say PONTO
      @ 14,18+C           say "="

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif

      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      set fixed on
  
      SINAL   = "="
      COMANDO = "+"
      RESP    = 0

   elseif A == 37 .and. SINAL <> "%"
      *************************
      ***  PORCENTAGEM - %  ***
      *************************

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         @ 14,16-len(COMANDO+PARC)+C say COMANDO+PARC
         @ 14,16+C                   say PONTO
         @ 14,18+C                   say "%"

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on

      if COMANDO = "+"
         RESP = RESP + ((RESP * val(PARC)) / 100) 
      elseif COMANDO = "-"
         RESP = RESP - ((RESP * val(PARC)) / 100)
      else
         RESP = ((RESP * val(PARC)) / 100)
      endif

      if int(RESP) == RESP
         set fixed off

         PONTO = "."
         PARC = left(alltrim(transform(int(RESP),"@Z")),14)
      else
         PONTO = " "
         PARC = left(alltrim(transform(RESP,"@Z")),14)

         for I = 14 to 1 step -1
             if right(PARC,1) == "0" .or. empty(right(PARC,1))
                PARC = left(PARC,I)
             else
                exit
             endif
         next
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)
      
      if empty(PARC) 
         @ 14,16-len("0")+C say "0"
      else
         @ 14,16-len(PARC)+C say PARC
      endif

      @ 14,16+C           say PONTO
      @ 14,18+C           say "="

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif

      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      set fixed on
  
      SINAL   = "="
      COMANDO = "+"
      RESP    = 0

   elseif A == 47 .and. SINAL <> "/"
      *********************
      ***  DIVISAO - /  ***
      *********************

      if COMANDO == "/" .and. val(PARC) == 0
         RESP = 0 
      else
         if COMANDO = "+"
            RESP = RESP + val(PARC)
         elseif COMANDO = "-"
            RESP = RESP - val(PARC)
         elseif COMANDO = "*"
            RESP = RESP * val(PARC)
         elseif COMANDO = "/"
            RESP = RESP / val(PARC)
         endif
      endif

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         @ 14,16-len(PARC)+C say PARC
         @ 14,16+C           say PONTO
         @ 14,18+C           say COMANDO

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on

      PARC    = ""
      COMANDO = "/"
      PONTO   = "."
      SINAL   = "/"

   elseif A == 13 .and. SINAL <> "="
      ***********************
      ***  RESULTADO - =  ***
      ***********************

      if COMANDO == "/" .and. val(PARC) == 0
         RESP = 0 
      else
         if COMANDO = "+"
            RESP = RESP + val(PARC)
         elseif COMANDO = "-"
            RESP = RESP - val(PARC)
         elseif COMANDO = "*"
            RESP = RESP * val(PARC)
         elseif COMANDO = "/"
            RESP = RESP / val(PARC)
         elseif COMANDO = "V"
            if SINAL == "A"
               ALTURA = val(PARC)
            elseif SINAL == "C"
               COMP = val(PARC)
            elseif SINAL == "L"
               LARGURA = val(PARC)
            elseif SINAL == "K"
               KILO = val(PARC)
            endif
         endif
      endif

      if ! empty(PARC)
         if int(val(PARC)) == val(PARC)
            set fixed off
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         @ 14,16-len(PARC)+C say PARC
         @ 14,16+C           say PONTO
         @ 14,18+C           say if(COMANDO="V",SINAL,COMANDO)  

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif
      endif

      set fixed on
 
      if COMANDO == "V"
         if SINAL == "A"
            SINAL = "C"
         elseif SINAL == "C"
            SINAL = "L"
         elseif SINAL == "L"
            SINAL = "K"
         elseif SINAL == "K"
            SINAL = "V"
         endif
      endif

      if SINAL == "V"
         RESP = (ALTURA*COMP*LARGURA)*KILO
      endif

      if int(RESP) == RESP
         set fixed off

         PONTO = "."
         PARC = left(alltrim(transform(int(RESP),"@Z")),14)
      else
         PONTO = " "
         PARC = left(alltrim(transform(RESP,"@Z")),14)

         for I = 14 to 1 step -1
             if right(PARC,1) == "0" .or. empty(right(PARC,1))
                PARC = left(PARC,I)
             else
                exit
             endif
         next
      endif

      if COMANDO <> "V" .or. SINAL == "V"
         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)
      
         if empty(PARC) 
            @ 14,16-len("0")+C say "0"
         else
            @ 14,16-len(PARC)+C say PARC
         endif

         @ 14,16+C           say PONTO
         @ 14,18+C           say "="
     
         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif

         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif

         scroll(13-CONTROL,01+C,14,19+C,+1)

         @ 14,01+C say chr(179)
         @ 14,19+C say chr(179)

         if PAUSA
            WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
         else
            WWTELA = savescreen(00,01+C,15,19+C)
         endif
      
         if CONTROL < 13 .and. PAUSA
            CONTROL = CONTROL + 1
         else
            PAUSA   = .f.
            CONTROL = 12
         endif

         set fixed on

         SINAL   = "="
         COMANDO = "+"
      endif
      RESP    = 0
   elseif A == 76 .or. A == 108
      *******************
      ***  LIMPA - L  ***       
      *******************

      restore screen from TELA

      setcolor(COR_TEXT)
      @ 14,01+C to 15,19+C  
      setcolor(COR_CONS)

      @ 15,00+C clear to 24,20+C
      @ 15,00+C to 24,20+C double

      @ 20,14+C to 22,18+C double
      @ 21,16+C say "H"

      @ 20,02+C say "SuperCalc"
      @ 21,02+C say "    ver 2.0"
      @ 23,04+C say "(C)Sinergia"

      setcolor(COR_TEXT)
      @ 16,01+C clear to 18,19+C
      @ 16,01+C to 18,19+C 
    
      CONTROL = 0
      PAUSA   = .t.

      WWTELA = savescreen(14,01+C,15,19+C)

   elseif A == 72 .or. A == 104
      ******************
      ***  HELP - H  ***      
      ******************

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "H  HELP"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say chr(26)+chr(27)+" Movimenta"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "+  Soma"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "-  Subtra"+chr(135)+chr(132)+"o"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "*  Multiplica"+chr(135)+chr(132)+"o"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "/  Divis"+chr(132)+"o"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "%  Porcentagem"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "Q  Raiz Quadrada"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say chr(17)+chr(217)+" Resultado"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "C  Cancela"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "L  Limpa"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "T  Transporta"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "V  Cubagem"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif

      scroll(13-CONTROL,01+C,14,19+C,+1)

      @ 14,01+C say chr(179)
      @ 14,19+C say chr(179)

      @ 14,03+C say "Esc Fim"

      if PAUSA
         WWTELA = savescreen(13-CONTROL,01+C,15,19+C)
      else
         WWTELA = savescreen(00,01+C,15,19+C)
      endif
      
      if CONTROL < 13 .and. PAUSA
         CONTROL = CONTROL + 1
      else
         PAUSA   = .f.
         CONTROL = 12
      endif
   endif      
enddo

return .t.

*********************
Function chck_UF(WUF)
*********************
LOCAL WESTADOS := { "AC", "AL", "AM", "AP", "BA", "CE" , "ES", "GO", "MA", "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", "RO", "RR", "RS", "SC", "SE", "SP", "TO"}

if empty(WUF)
   return .t.
endif

if ASCAN(WESTADOS, WUF) == 0
   MENSAGEM2("UF inv"+chr(160)+"lido.")
   return .f.
endif

return .t.


****************************************************** 
function CONFIRMA(c_LIN, c_STRING, c_DEFAULT, c_LIMPA)
******************************************************
LOCAL c_COLOR := setcolor()
LOCAL c_CURSOR := setcursor()
LOCAL c_TECLA, c_COLUNAL

setcursor(1)
setcolor(COR_TEXT)

c_COLUNA = 0
c_TECLA  = 0

if pcount() <> 4
   @ c_LIN,00 clear to c_LIN,79
endif

c_COLUNA = int(40 - ((len(c_STRING) + 1)/2))

@ c_LIN,c_COLUNA say c_STRING

if c_DEFAULT == "S"
   @ c_LIN,c_COLUNA+len(c_STRING)+1 say "Sim    "
   @ c_LIN,c_COLUNA+len(c_STRING)+1 say ""
   c_RESP = "S"
else
   @ c_LIN,c_COLUNA+len(c_STRING)+1 say "N"+chr(132)+"o    "
   @ c_LIN,c_COLUNA+len(c_STRING)+1 say ""
   c_RESP = "N"
endif

do while .t.

   c_TECLA = inkey(0)

   if lastkey() == 27 .or. lastkey() == 13
      exit
   endif

   if c_TECLA == -7
      scalc()
   endif

   if c_TECLA == 83 .or. c_TECLA == 115
      c_RESP = "S"                       
      @ c_LIN,c_COLUNA+len(c_STRING)+1 say "Sim    "
      @ c_LIN,c_COLUNA+len(c_STRING)+1 say ""
      exit
   elseif c_TECLA == 78 .or. c_TECLA == 110
      c_RESP = "N"                       
      @ c_LIN,c_COLUNA+len(c_STRING)+1 say "N"+chr(132)+"o    "
      @ c_LIN,c_COLUNA+len(c_STRING)+1 say ""
      exit
   endif 
enddo  

if pcount() <> 4
   @ c_LIN,10 clear to c_LIN,79 
endif

setcolor(c_COLOR)
setcursor(c_CURSOR)

return c_RESP

*********************************************** 
function REDUCAO(LLIN, COLUNA, STRING, DEFAULT)
***********************************************
LOCAL c_CURSOR := setcursor()
LOCAL TECLA

if pcount() == 3
   DEFAULT = "N"
endif

setcursor(1)

TECLA  = 0

@ LLIN,COLUNA say STRING

if DEFAULT == "S"
   @ LLIN,COLUNA+len(STRING)+1 say "Sim    "
   @ LLIN,COLUNA+len(STRING)+1 say ""
   RESP = "S"
else
   @ LLIN,COLUNA+len(STRING)+1 say "N"+chr(132)+"o    "
   @ LLIN,COLUNA+len(STRING)+1 say ""
   RESP = "N"
endif

do while .t.
   TECLA = inkey(0)

   if TECLA == -7
      scalc()
      @ LLIN,COLUNA+len(STRING)+1 say ""
   endif

   if TECLA == 27 .or. TECLA == 13
      exit
   endif

   if TECLA == 83 .or. TECLA == 115
      RESP = "S"                       
      @ LLIN,COLUNA+len(STRING)+1 say "Sim    "
      @ LLIN,COLUNA+len(STRING)+1 say ""
      exit
   elseif TECLA == 78 .or. TECLA == 110
      RESP = "N"                       
      @ LLIN,COLUNA+len(STRING)+1 say "N"+chr(132)+"o    "
      @ LLIN,COLUNA+len(STRING)+1 say ""
      exit
   endif 
enddo  

setcursor(c_CURSOR)

return RESP

*******************
function CENTRO_PRN
*******************
private T_FORM, STRING, COLUNA
parameters T_FORM, STRING

COLUNA = int((T_FORM - len(STRING))/2)    

@ prow(), COLUNA say STRING

return .t.

**************
function PAPEL
**************
LOCAL P, L, C

setcolor(COR_SUB)
@ 00,00 clear to 25,79

P = 13

for L = 0 to 24
    @ L,00 say right("MinhaFazenda",P)+space(01)

    for C = col() to 80 step 13 
        @ L,C say "MinhaFazenda"
    next
  
    P = P - 4
    
    if P < 0
       P = 13
    endif
next

return .t.


***********************************************************
function ABRE(ofAREA, ofARQUIVO, ofMODO, ofALIAS, ofSTATUS)
**********************************************************
LOCAL WTT_ABRE

select &ofAREA

if used()         
   return .f.
endif

if pcount() == 2
   ofMODO = "C"
   ofALIAS = right(ofARQUIVO, len(ofARQUIVO)-rat("\",ofARQUIVO))
   ofSTATUS = .t.
endif

if pcount() == 3
   ofALIAS = right(ofARQUIVO, len(ofARQUIVO)-rat("\",ofARQUIVO))
   ofSTATUS = .t.
endif

if pcount() == 4
   ofSTATUS = .t.
endif

if select(ofALIAS) <> 0 
   return .t.
endif

do while .t.
   if ofMODO == "E"
      use &ofARQUIVO alias &ofALIAS EXCLUSIVE
   else
      use &ofARQUIVO alias &ofALIAS
   endif

   if ! neterr() 
      return .t. 
   endif

   if ofSTATUS
      mensagem("AGUARDE UM INSTANTE. Arquivo "+alltrim(ofARQUIVO)+" n"+chr(132)+"o est"+chr(160)+" dispon"+chr(161)+"vel em modo "+if(ofMODO == "E", "EXCLUSIVO", "COMPARTILHADO")+".",20)

      if lastkey() == 27
         fim()
      endif
   else
      return .f.
   endif
enddo

return .f.


*****************
function ABRE_TMP
*****************
local WTT_ABRE
private ofAREA, ofARQUIVO, ofALIAS, ofARQNUM, ofARQNAME, ofV
parameters ofAREA, ofARQUIVO, ofALIAS, ofARQNUM

select &ofAREA

if USED()       
   Return .F.
endif

if empty(ofALIAS)
   ofALIAS = ARQNAME
endif

do while .t.
   if ofARQNUM >= 1
      for ofV = 1 to ofARQNUM
          ofARQNAME = ofARQUIVO+strzero(ofV,if(ofARQNUM > 9,2,1))

          if ferase(ofARQNAME+".CDX") == 0 .or. ! file(ofARQNAME+".CDX")
             use &ofARQNAME alias &ofALIAS EXCLUSIVE 

             if ! neterr() 
                ferase(ofARQNAME+".CDX")
                return .t. 
             endif
          endif
      next
   else
      ofARQNAME = ofARQUIVO
   
      use &ofARQNAME alias &ofALIAS EXCLUSIVE 

      if ! neterr() 
         ferase(ofARQNAME+".CDX")
         return .t. 
      endif
   endif

   mensagem("AGUARDE UM INSTANTE. Arquivo "+alltrim(ofARQUIVO)+" n"+chr(132)+"o est"+chr(160)+" dispon"+chr(161)+"vel em modo EXCLUSIVO.",20)

   if lastkey() == 27
      fim()
   endif
enddo

return .f.


****************
function ARQLOCK
****************
local WTT_ARQLOCK

do while .t.
   if flock()
      return .t.
   endif

   mensagem("AGUARDE UM INSTANTE. Arquivo "+alltrim(alias())+" n"+chr(132)+"o est"+chr(160)+" dispon"+chr(161)+"vel para BLOQUEIO.",20)

   if lastkey() == 27
      fim()
   endif
enddo

return .f.

****************
function REGLOCK
****************
local WTT_REGLOCK

if rlock()
   return .t.
endif

mensagem("AGUARDE UM INSTANTE. Registro n"+chr(132)+"o dispon"+chr(161)+"vel em modo EXCLUSIVO.",20)

return .f.

**************
function GRAVA
**************

dbcommit()
unlock 

return .t.

****************
function INC_REG
****************
LOCAL WTT_INCREG

dbappend()

if ! neterr()
   return .t.
endif

MENSAGEM2('ERRO! Falha na inclusao do registro.')

return .f.

****************************************************

****************
function AGUARDE
****************

setcolor(COR_GETS)
@ 24,00 clear to 24,79
@ 24,70 say "Aguarde..."
setcolor(COR_TEXT)

return .t.

******************************
function MENSAGEM(WMSG,WDELAY)
******************************

if pcount() == 1
   WDELAY = 5
endif

if WDELAY = 0
   WDELAY = 20
endif

Alert( WMSG, , "W+/R,"+COR_BARRA, WDELAY )

return .t.

*******************************
function MENSAGEM2(WMSG,WDELAY)
*******************************

if pcount() == 1
   WDELAY = 5
endif

if WDELAY = 0
   WDELAY = 20
endif

Alert( WMSG, , "W+/R,"+COR_BARRA, WDELAY )

return .t.

********************************
function MENSAGEM3(WTEXTO, WTIP)
********************************
#include "winuser.ch"

if valtype(WTIP) == "N" 
    WMB_ICON = 'MB_ICONEXCLAMATION'
else    
   if WTIP = 'ALERT'
      WMB_ICON = 'MB_ICONEXCLAMATION'
   elseif WTIP = 'INFO'
      WMB_ICON = 'MB_ICONINFORMATION'
   elseif WTIP = 'QUEST'
      WMB_ICON = 'MB_ICONQUESTION'
   elseif WTIP = 'ERROR'
      WMB_ICON = 'MB_ICONERROR'
   else   
      WMB_ICON = 'MB_ICONEXCLAMATION'
   endif  
endif

MessageBox(, WTEXTO, 'Aviso', WMB_ICON)

return .t.

******************
function COPIA_REG
******************
parameters ARQ_ORI, ARQ_DEST

LOCAL aFields := {}
LOCAL i
LOCAL nCampos := fcount()
LOCAL Result

select &ARQ_ORI
for i := 1 to nCampos
    aAdd(aFields,FieldGet(i))
next

select &ARQ_DEST
append blank
Result  := neterr()
if !Result
   aeval(aFields,{|x,z| FieldPut(z,x) })
endif

select &ARQ_ORI

RETURN !Result


****************************
function DV_CTE(wwchave_cte)
****************************
local WWSOMA, WWPESO, WWDV

WWSOMA = 0
WWPESO = 2
WWDV   = 0

for DV = 43 to 1 step -1
    WWSOMA = WWSOMA + (val(substr(WWCHAVE_CTE,DV,1))*WWPESO)

    WWPESO = WWPESO + 1
    if WWPESO > 9
       WWPESO = 2
    endif
next

if (WWSOMA % 11) <= 1
   WWDV = 0
else
   WWDV = (11-(WWSOMA % 11))
endif

return(WWCHAVE_CTE+strzero(WWDV,1))


******************************
function ret_IBGE(nCOD, nCAMP)    
******************************
// nCAMP=1 -> retorna cidade, nCAMP=2 -> retorna UF, nCAMP=3 -> retorna IBGE

nALIAS = ALIAS()
nCID   = ""
nUF    = ""

select CIDADE
ordsetfocus("SINC001")
seek upper(nCOD)

nIBGE = IBGE
nUF   = ESTADO
nCID  = alltrim(CIDADE)

select &nALIAS

if nCAMP = 1
   return(nCID)
elseif nCAMP = 2
   return(nUF)
else
   return(nIBGE)
endif

************************
function ultimo_DIA(WDT)
************************
LOCAL WMES, WANO, WDD 

WMES = month(WDT)
WANO = right(str(year(WDT)),4)
WDD  = 0
 
if WMES = 1
   WDD = 31   
elseif WMES = 2

   if val(WANO) % 4 = 0
      WDD = 29
   else
      WDD = 28
   endif

elseif WMES = 3
   WDD = 31      
elseif WMES = 4
   WDD = 30 
elseif WMES = 5
   WDD = 31 
elseif WMES = 6
   WDD = 30   
elseif WMES = 7
   WDD = 31   
elseif WMES = 8
   WDD = 31   
elseif WMES = 9
   WDD = 30   
elseif WMES = 10
   WDD = 31   
elseif WMES = 11
   WDD = 30   
elseif WMES = 12
   WDD = 31   
endif

return(ctod(str(WDD,2)+"/"+strzero(WMES,2)+"/"+WANO))

*****************
function FIND_DBF
*****************
private WACAMPOS := array(FCount())
private WATIPO   := array(FCount())
private WAREA    := alias()
private WARQ     := alltrim(str(random()%9999999,7))

WARQSTR = "&WDIRE_TEMP\CSV\O"+WARQ+".DBF"   && Estrutura dos Arquivos
WARQVEW = "&WDIRE_TEMP\CSV\V"+WARQ+".DBF"   && Visualizador dos Campos
WARQDES = "&WDIRE_TEMP\CSV\D"+WARQ+".DBF"   && Arquivo Destino

@ 02,00 clear to 22,79

@ 02,01 say "Campo: "
@ 02,21 say "Sinal: "
@ 02,42 say "Valor: "
@ 02,67 say "Logica: "

setcolor(COR_CAB)
@ 08,00 clear to 08,79
@ 08,01 say "D"+WARQ
@ 08,20 say chr(179)
@ 08,22 say "Reg. "+strzero(0,6)+"/"+strzero(0,6)
@ 08,41 say chr(179)
setcolor(COR_TEXT)

AFields(WACAMPOS, WATIPO)

copy to &WARQSTR structure extended 
copy to &WARQVEW structure extended 

abre_TMP(231,"&WARQSTR","ARQSTR",0)

if ! file(WARQSTR)
   restscreen(00,00,24,79,WTT_FIND)
   return .t.
endif

index on FIELD_NAME tag SINC001
go top

aDBF := {}
do while ! eof()
   aadd(aDBF, {FIELD_NAME, FIELD_TYPE, FIELD_LEN, FIELD_DEC})
   skip +1
enddo

dbcreate(WARQDES, aDBF)

abre_tmp(232,"&WARQVEW","ARQVEW",0)
replace FIELD_TYPE with space(01) all

abre_tmp(233,"&WARQDES","ARQDES",0)

WLOGICA = ""

WCAMPO1 = space(10)
WCAMPO2 = space(10)
WCAMPO3 = space(10)
WCAMPO4 = space(10)
WCAMPO5 = space(10)

WCOND1  = space(02)
WCOND2  = space(02)
WCOND3  = space(02)
WCOND4  = space(02)
WCOND5  = space(02)

WEXP1   = space(16)
WEXP2   = space(16)
WEXP3   = space(16)
WEXP4   = space(16)
WEXP5   = space(16)

WLOG1   = space(05)
WLOG2   = space(05)
WLOG3   = space(05)
WLOG4   = space(05)

****************************************
BUSCA_LOGICA()
****************************************

if lastkey() == 27
   CLOSE_FIND()
   return .t.
endif

select &WAREA
ordsetfocus(0)
go top

XX      = lastrec()
XSIMBOL = "-"

do while inkey() <> 27 .and. ! eof()
   barra()

   if ! empty(WLOGICA)
      if ! (&WLOGICA)
         skip +1
         loop
      endif
   endif

   select ARQDES
   append blank

   for I = 1 to len(aDBF)
       WVAR1 = aDBF[I,1]
       WVAR2 = alltrim(WAREA)+"->"+aDBF[I,1]

       replace &WVAR1 with &WVAR2
   next

   select &WAREA
   skip +1
enddo

if lastkey() <> 27
   setcolor(COR_SUB)  
   @ 08,58 say replicate(chr(219),5)
   setcolor(COR_CAB)
   @ 08,64 say "100% Completado"
   setcolor(COR_TEXT)
else
  setcolor(COR_CAB)
  @ 08,67 say "%"
  setcolor(COR_TEXT)
endif

@ 24,00 clear to 24,79
   
do while .t.
   centro(24,"F5-Filtro  HOME-Inserir/Excluir Campos   END-Sair  F2-Salvar")

   select ARQVEW
   go top

   XX = 0

   do while ! eof()
      if alltrim(FIELD_TYPE) <> "*"
         XX = XX + 1
      endif

      skip +1
   enddo

   private aCAMPO1[XX]
   private aPIC1[XX]
   go top   

   XX = 1

   do while ! eof()
      if alltrim(FIELD_TYPE) <> "*"
         aCAMPO1[XX] = FIELD_NAME

         select ARQSTR
         ordsetfocus("SINC001")
         seek aCAMPO1[XX]

         if FIELD_TYPE == "N"
            aPIC1[XX] = "@R@E "+replicate("9",FIELD_LEN)+if(FIELD_DEC <> 0, "."+replicate("9",FIELD_DEC),"")
         else
            aPIC1[XX] = ""
         endif

         select ARQVEW

         XX = XX + 1
      endif

      skip +1
   enddo

   select ARQDES
   go top

   setcolor(COR_CAB)
   @ 08,27 say strzero(recno(),6)+"/"+strzero(lastrec(),6)
   setcolor(COR_TEXT)

   dbedit(09,00,22,79,aCAMPO1,"UDF_FIND",aPIC1)

   if lastkey() == 1
      setcolor(COR_CONS)
      @ 10,25 clear to 20,55
      @ 10,25 to 20,55 double

      select ARQVEW
      ordsetfocus(0)
      go top

      private aCAMPO2[2]
      aCAMPO2[1] = "FIELD_NAME"
      aCAMPO2[2] = "FIELD_TYPE"

      dbedit(11,26,19,54,aCAMPO2,"UDF_CAMPO")
   elseif lastkey() == -1
      setcolor(COR_CONS)
      @ 12,20 clear to 16,60
      @ 12,20 to 16,60 double

      WARQCSV = space(20)

      @ 14,22 say "Salvar Como...: "
      @ 14,38 get WARQCSV                 picture "@!"    valid ! empty(WARQCSV)
      read_f()
      setcolor(COR_TEXT)

      if lastkey() == 27
         loop
      endif

      WARQXLS = pathCSV+"\"+alltrim(WARQCSV)+".XLS"

      if file(WARQXLS)
         MENSAGEM2("Nome de arquivo encontrado na pasta.")
         loop
      endif

      DBF2XLS("ARQDES", WACAMPOS, WACAMPOS, WARQXLS)

   elseif lastkey() == -4
      WLOGICA = ""
   
      WCAMPO1 = space(10)
      WCAMPO2 = space(10)
      WCAMPO3 = space(10)
      WCAMPO4 = space(10)
      WCAMPO5 = space(10)
      
      WCOND1  = space(11)
      WCOND2  = space(11)
      WCOND3  = space(11)
      WCOND4  = space(11)
      WCOND5  = space(11)
      
      WEXP1   = space(16)
      WEXP2   = space(16)
      WEXP3   = space(16)
      WEXP4   = space(16)
      WEXP5   = space(16)
      
      WLOG1   = space(02)
      WLOG2   = space(02)
      WLOG3   = space(02)
      WLOG4   = space(02)
      ****************************************
      BUSCA_LOGICA()
      ****************************************

      if lastkey() == 27
         select ARQDES
         loop
      endif
   
      select ARQDES
      go top
      
      XX      = lastrec()
      XSIMBOL = "-"
   
      do while inkey() <> 27 .and. ! eof()
         barra()
   
         if ! empty(WLOGICA)
            if ! (&WLOGICA)
               delete
            endif
         endif
   
         skip +1
      enddo
      PACK
   
      if lastkey() <> 27
         setcolor(COR_SUB) 
         @ 08,58 say replicate(chr(219),5)
         setcolor(COR_CAB)
         @ 08,64 say "100% Completado"
         setcolor(COR_TEXT)
      else
         setcolor(COR_CAB)
         @ 08,67 say "%"
         setcolor(COR_TEXT)
      endif

      select ARQDES
      go top
   elseif lastkey() == 6
      exit
   endif

enddo

CLOSE_FIND()

return .t.

*******************
function CLOSE_FIND
*******************

select 231
DBCLOSEAREA()
select 232
DBCLOSEAREA()
select 233
DBCLOSEAREA()

select &WAREA

FErase("&WDIRE_TEMP\CSV\V"+WARQ+".DBF")
FErase("&WDIRE_TEMP\CSV\D"+WARQ+".DBF")
FErase("&WDIRE_TEMP\CSV\D"+WARQ+".SMT")

return .t.

*********************
function BUSCA_LOGICA
*********************
LOCAL I
LOCAL cCOLOR_GET := COR_TEXT+","+COR_TEXT+","+COR_TEXT+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_SUB

select ARQSTR
ordsetfocus("SINC001")
go top

do while .t.
   @ 02,08,10,19 get WCAMPO1;
                 LISTBOX WACAMPOS;
                 VALID ! empty(WCAMPO1);
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN SCROLLBAR;
                 COLOR cCOLOR_GET
              
   @ 02,28,12,40 get WCOND1;
                 LISTBOX {"IGUAL","EXATAMENTE","DIFERENTE","MAIOR QUE","MENOR QUE","MAIOR IGUAL","MENOR IGUAL","CONTEM"};             
                 WHEN ! empty(WCAMPO1); 
                 VALID ! empty(WCOND1);
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN; 
                 COLOR cCOLOR_GET

   @ 02,49 get WEXP1;
               WHEN ! empty(WCAMPO1);
               VALID ! empty(WEXP1)

   @ 02,75,06,79 get WLOG1;
                 LISTBOX {"E", "OU"};
                 WHEN ! empty(WCAMPO1); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET

   @ 03,08,11,19 get WCAMPO2;
                 LISTBOX WACAMPOS;
                 WHEN ! empty(WLOG1); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN SCROLLBAR;
                 COLOR cCOLOR_GET
              
   @ 03,28,13,40 get WCOND2;
                 LISTBOX {"IGUAL","EXATAMENTE","DIFERENTE","MAIOR QUE","MENOR QUE","MAIOR IGUAL","MENOR IGUAL","CONTEM"};
                 WHEN ! empty(WCAMPO2); 
                 VALID ! empty(WCOND2);
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET

   @ 03,49 get WEXP2;
               WHEN ! empty(WCAMPO2); 
               VALID ! empty(WEXP2)

   @ 03,75,07,79 get WLOG2;
                 LISTBOX {"E", "OU"};
                 WHEN ! empty(WCAMPO2); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET
  
   @ 04,08,12,19 get WCAMPO3;
                 LISTBOX WACAMPOS;
                 WHEN ! empty(WLOG2); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN SCROLLBAR;
                 COLOR cCOLOR_GET
              
   @ 04,28,14,40 get WCOND3;
                 LISTBOX {"IGUAL","EXATAMENTE","DIFERENTE","MAIOR QUE","MENOR QUE","MAIOR IGUAL","MENOR IGUAL","CONTEM"};
                 WHEN ! empty(WCAMPO3); 
                 VALID ! empty(WCOND3);
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET
   
   @ 04,49 get WEXP3;
               WHEN ! empty(WCAMPO3); 
               VALID ! empty(WEXP3)

   @ 04,75,08,79 get WLOG3;
                 LISTBOX {"E", "OU"};
                 WHEN ! empty(WCAMPO3); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET
              
   @ 05,08,13,19 get WCAMPO4;
                 LISTBOX WACAMPOS;
                 WHEN ! empty(WLOG3); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN SCROLLBAR;
                 COLOR cCOLOR_GET
              
   @ 05,28,14,40 get WCOND4;
                 LISTBOX {"IGUAL","EXATAMENTE","DIFERENTE","MAIOR QUE","MENOR QUE","MAIOR IGUAL","MENOR IGUAL","CONTEM"};
                 WHEN ! empty(WCAMPO4); 
                 VALID ! empty(WCOND4);
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET

   @ 05,49 get WEXP4;
               WHEN ! empty(WCAMPO4); 
               VALID ! empty(WEXP4)
  
   @ 05,75,09,79 get WLOG4;
                 LISTBOX {"E", "OU"};
                 WHEN ! empty(WCAMPO4); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN SCROLLBAR;
                 COLOR cCOLOR_GET
              
   @ 06,08,14,19 get WCAMPO5;
                 LISTBOX WACAMPOS;
                 WHEN ! empty(WLOG4); 
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN SCROLLBAR;
                 COLOR cCOLOR_GET
              
   @ 06,28,16,40 get WCOND5;
                 LISTBOX {"IGUAL","EXATAMENTE","DIFERENTE","MAIOR QUE","MENOR QUE","MAIOR IGUAL","MENOR IGUAL","CONTEM"};
                 WHEN ! empty(WCAMPO5); 
                 VALID ! empty(WCOND5);
                 MESSAGE "Tecle ESPA"+chr(128)+"O para visualizar as op"+chr(135)+chr(148)+"es e TAB para navegar nos campos.";
                 DROPDOWN;
                 COLOR cCOLOR_GET

   @ 06,49 get WEXP5;
               WHEN ! empty(WCAMPO5);
               VALID ! empty(WEXP5)
   read_f()

   if lastkey() == 27
      return .t.
   endif
   
   if empty(WCAMPO1) .or. empty(WCOND1)
      loop
   endif
   
   exit
enddo

select ARQSTR
ordsetfocus("SINC001")

WLOGICA = ""

if ! empty(WCAMPO1)
   WCAMPO1 = alltrim(WCAMPO1)
   WCOND1  = alltrim(WCOND1)
   WEXP1   = alltrim(WEXP1)
   WLOG1   = alltrim(WLOG1)

   if WCOND1 == "IGUAL"
      WCOND1 = "="
   elseif WCOND1 == "EXATAMENTE"
      WCOND1 = "=="
   elseif WCOND1 == "DIFERENTE"
      WCOND1 = "<>"
   elseif WCOND1 == "MAIOR QUE"
      WCOND1 = ">"
   elseif WCOND1 == "MENOR QUE"
      WCOND1 = "<"
   elseif WCOND1 == "MAIOR IGUAL"
      WCOND1 = ">="
   elseif WCOND1 == "MENOR IGUAL"
      WCOND1 = "<="
   elseif WCOND1 == "CONTEM"
      WCOND1 = "$"
   endif

   if WLOG1 == "OU"
      WLOG1 = ".or."
   elseif WLOG1 == "E"
      WLOG1 = ".and."
   endif
   
   seek WCAMPO1
   if left(WEXP1,1) <> "&"
      if FIELD_TYPE == "C"  
         WEXP1 = "'"+WEXP1+"'"
      elseif FIELD_TYPE == "D"
         WEXP1 = "ctod('"+WEXP1+"')"
      endif   
   else
      WEXP1 = right(WEXP1,len(WEXP1)-1)
   endif
   if WCOND1 == "$"
      WLOGICA = WLOGICA + (WEXP1+WCOND1+WCAMPO1)
   else
      WLOGICA = WLOGICA + (WCAMPO1+WCOND1+WEXP1)
   endif

   if ! empty(WCAMPO2)
      WLOGICA = WLOGICA + WLOG1
      
      WCAMPO2 = alltrim(WCAMPO2)
      WCOND2  = alltrim(WCOND2)
      WEXP2   = alltrim(WEXP2)
      WLOG2   = alltrim(WLOG2)

      if WCOND2 == "IGUAL"
         WCOND2 = "="
      elseif WCOND2 == "EXATAMENTE"
         WCOND2 = "=="
      elseif WCOND2 == "DIFERENTE"
         WCOND2 = "<>"
      elseif WCOND2 == "MAIOR QUE"
         WCOND2 = ">"
      elseif WCOND2 == "MENOR QUE"
         WCOND2 = "<"
      elseif WCOND2 == "MAIOR IGUAL"
         WCOND2 = ">="
      elseif WCOND2 == "MENOR IGUAL"
         WCOND2 = "<="
      elseif WCOND2 == "CONTEM"
         WCOND2 = "$"
      endif

      if WLOG2 == "OU"
         WLOG2 = ".or."
      elseif WLOG2 == "E"
         WLOG2 = ".and."
      endif

      seek WCAMPO2
      if left(WEXP2,1) <> "&"
         if FIELD_TYPE == "C"  
            WEXP2 = "'"+WEXP2+"'"
         elseif FIELD_TYPE == "D"
            WEXP2 = "ctod('"+WEXP2+"')"
         endif   
      else
         WEXP2 = right(WEXP2,len(WEXP2)-1)
      endif
      if WCOND2 == "$"
         WLOGICA = WLOGICA + (WEXP2+WCOND2+WCAMPO2)
      else
         WLOGICA = WLOGICA + (WCAMPO2+WCOND2+WEXP2)
      endif

      if ! empty(WCAMPO3)
         WLOGICA = WLOGICA + WLOG2

         WCAMPO3 = alltrim(WCAMPO3)
         WCOND3  = alltrim(WCOND3)
         WEXP3   = alltrim(WEXP3)
         WLOG3   = alltrim(WLOG3)

         if WCOND3 == "IGUAL"
            WCOND3 = "="
         elseif WCOND3 == "EXATAMENTE"
            WCOND3 = "=="
         elseif WCOND3 == "DIFERENTE"
            WCOND3 = "<>"
         elseif WCOND3 == "MAIOR QUE"
            WCOND3 = ">"
         elseif WCOND3 == "MENOR QUE"
            WCOND3 = "<"
         elseif WCOND3 == "MAIOR IGUAL"
            WCOND3 = ">="
         elseif WCOND3 == "MENOR IGUAL"
            WCOND3 = "<="
         elseif WCOND3 == "CONTEM"
            WCOND3 = "$"
         endif

         if WLOG3 == "OU"
            WLOG3 = ".or."
         elseif WLOG3 == "E"
            WLOG3 = ".and."
         endif

         seek WCAMPO3
         if left(WEXP3,1) <> "&"
            if FIELD_TYPE == "C"  
               WEXP3 = "'"+WEXP3+"'"
            elseif FIELD_TYPE == "D"
               WEXP3 = "ctod('"+WEXP3+"')"
            endif   
         else
            WEXP3 = right(WEXP3,len(WEXP3)-1)
         endif
         if WCOND3 == "$"
            WLOGICA = WLOGICA + (WEXP3+WCOND3+WCAMPO3)
         else
            WLOGICA = WLOGICA + (WCAMPO3+WCOND3+WEXP3)
         endif

         if ! empty(WCAMPO4)
            WLOGICA = WLOGICA + WLOG3

            WCAMPO4 = alltrim(WCAMPO4)
            WCOND4  = alltrim(WCOND4)
            WEXP4   = alltrim(WEXP4)
            WLOG4   = alltrim(WLOG4)

            if WCOND4 == "IGUAL"
               WCOND4 = "="
            elseif WCOND4 == "EXATAMENTE"
               WCOND4 = "=="
            elseif WCOND4 == "DIFERENTE"
               WCOND4 = "<>"
            elseif WCOND4 == "MAIOR QUE"
               WCOND4 = ">"
            elseif WCOND4 == "MENOR QUE"
               WCOND4 = "<"
            elseif WCOND4 == "MAIOR IGUAL"
               WCOND4 = ">="
            elseif WCOND4 == "MENOR IGUAL"
               WCOND4 = "<="
            elseif WCOND4 == "CONTEM"
               WCOND4 = "$"
            endif

            if WLOG4 == "OU"
               WLOG4 = ".or."
            elseif WLOG4 == "E"
               WLOG4 = ".and."
            endif
 
            seek WCAMPO4
            if left(WEXP4,1) <> "&"
               if FIELD_TYPE == "C"  
                  WEXP4 = "'"+WEXP4+"'"
               elseif FIELD_TYPE == "D"
                  WEXP4 = "ctod('"+WEXP4+"')"
               endif   
            else
               WEXP4 = right(WEXP4,len(WEXP4)-1)
            endif
            if WCOND4 == "$"
               WLOGICA = WLOGICA + (WEXP4+WCOND4+WCAMPO4)
            else
               WLOGICA = WLOGICA + (WCAMPO4+WCOND4+WEXP4)
            endif

            if ! empty(WCAMPO5)
               WLOGICA = WLOGICA + WLOG4

               WCAMPO5 = alltrim(WCAMPO5)
               WCOND5  = alltrim(WCOND5)
               WEXP5   = alltrim(WEXP5)

               if WCOND5 == "IGUAL"
                  WCOND5 = "="
               elseif WCOND5 == "EXATAMENTE"
                  WCOND5 = "=="
               elseif WCOND5 == "DIFERENTE"
                  WCOND5 = "<>"
               elseif WCOND5 == "MAIOR QUE"
                  WCOND5 = ">"
               elseif WCOND5 == "MENOR QUE"
                  WCOND5 = "<"
               elseif WCOND5 == "MAIOR IGUAL"
                  WCOND5 = ">="
               elseif WCOND5 == "MENOR IGUAL"
                  WCOND5 = "<="
               elseif WCOND5 == "CONTEM"
                  WCOND5 = "$"
               endif

               seek WCAMPO5
               if left(WEXP5,1) <> "&"
                  if FIELD_TYPE == "C"  
                     WEXP5 = "'"+WEXP5+"'"
                  elseif FIELD_TYPE == "D"
                     WEXP5 = "ctod('"+WEXP5+"')"
                  endif   
               else
                  WEXP5 = right(WEXP5,len(WEXP5)-1)
               endif
               if WCOND5 == "$"
                  WLOGICA = WLOGICA + (WEXP5+WCOND5+WCAMPO5)
               else
                  WLOGICA = WLOGICA + (WCAMPO5+WCOND5+WEXP5)
               endif
            endif
         endif
      endif
   endif
endif

WLOGICA = WLOGICA + space(255)

@ 07,01 say WLOGICA  picture "@S78"

WLOGICA = alltrim(WLOGICA) 

return .t.

*****************
function UDF_FIND
*****************

if lastkey() == 6 .or. lastkey() == 1 .or. lastkey() == -1 .or. lastkey() == -4
   return 0
endif

setcolor(COR_CAB)
@ 08,27 say strzero(recno(),6)+"/"+strzero(lastrec(),6)
setcolor(COR_TEXT)

return 1

******************
function UDF_CAMPO
******************

if lastkey() == 13 
   if alltrim(FIELD_TYPE) == "*"
      replace FIELD_TYPE with " "
   else
      replace FIELD_TYPE with "*"
   endif

   return 1
elseif lastkey() == 27
   return 0
endif

return 1

**************
function BARRA
**************
private WPERC

if XSIMBOL == "/"
   XSIMBOL = "-"
elseif XSIMBOL == "-"
   XSIMBOL = "\" 
elseif XSIMBOL == "\"
   XSIMBOL = "|"
elseif XSIMBOL == "|"
   XSIMBOL = "/"
endif

if recno() == 1
   setcolor(COR_CAB)
   @ 08,43 clear to 08,79
   setcolor(COR_TEXT)
endif

WPERC = int((recno()/XX)*100)

setcolor(COR_SUB) 
if WPERC <= 25
   @ 08,43 say replicate(chr(176),int(WPERC/5))
elseif WPERC <= 50
   @ 08,43 say replicate(chr(176),int(WPERC/5))
   @ 08,48 say replicate(chr(177),(int(WPERC/5)-5))
elseif WPERC <= 75
   @ 08,43 say replicate(chr(176),int(WPERC/5))
   @ 08,48 say replicate(chr(177),(int(WPERC/5)-5))
   @ 08,53 say replicate(chr(178),(int(WPERC/5)-10))
elseif WPERC <= 100
   @ 08,43 say replicate(chr(176),int(WPERC/5))
   @ 08,48 say replicate(chr(177),(int(WPERC/5)-5))
   @ 08,53 say replicate(chr(178),(int(WPERC/5)-10))
   @ 08,58 say replicate(chr(219),(int(WPERC/5)-15))
endif

setcolor(COR_CAB)
@ 08,64 say str(int((recno()/XX)*100),3)+XSIMBOL+" Completado"
setcolor(COR_TEXT)

return .t.

************************************************************
function DBF2XLS(ARQ_DBF, aHEADER, aFIELD, ARQ_XLS, ARQ_SEC)
************************************************************
LOCAL I, X := 0
PRIVATE WVAR

if empty(ARQ_SEC)
   ARQ_SEC = 1
endif

AGUARDE()

nHandle := FCreate( ARQ_XLS, FC_NORMAL )

FWriteLine( nHandle, '<html>' )
FWriteLine( nHandle, '<body>' )
FWriteLine( nHandle, '<table border="1">' )

FWriteLine( nHandle, '<tr bgcolor="#FFE4E1">' )
for I = 1 to len(aHEADER)
    FWriteLine( nHandle, '<th nowrap>'+aHEADER[I]+'</th>' )
next
FWriteLine( nHandle, '</tr>' )

select &ARQ_DBF
go top

do while ! eof()
   if inkey() == 27
      if confirma(24, "Interromper gera"+chr(135)+chr(132)+"o do arquivo...(S/N)?", "N") == "S"
         exit
      endif
      AGUARDE()
   endif
   
   if (X++ % 2) == 0    
      FWriteLine( nHandle, '<tr bgcolor="#FFFFFF" >' )
   else
      FWriteLine( nHandle, '<tr bgcolor="#FFE4E1">' )
   endif
   
   for I = 1 to len(aFIELD)
       WVAR = aFIELD[I]
       WVAR = &WVAR
       
       if ! ("(" $ aFIELD[I])    // verificar se o campo nao tem funcao como parametro
          if Valtype(WVAR) == "N"  
             WVAR = CharRepl( "." , str(WVAR), ",")
          elseif Valtype(WVAR) == "L"
             WVAR = if(WVAR,"Verdadeiro","Falso")
          elseif Valtype(WVAR) == "D"
             WVAR = dtoc(WVAR)
          elseif Valtype(WVAR) == "M"
             WVAR = memoline(WVAR,240,1)
          endif              
       endif
       
       FWriteLine( nHandle, '<th nowrap>'+WVAR+'</th>' )
   next
   skip +1
enddo

FWriteLine( nHandle, '</table>' )
FWriteLine( nHandle, '</body>' )
FWriteLine( nHandle, '</html>' )

FClose( nHandle )

@ 24,00 clear to 24,79

if ARQ_SEC = 1
   WNARQ_XLS = ARQ_XLS 
else
   WNARQ_XLS = right(ARQ_XLS,(len(ARQ_XLS) - WPRFX))   
endif

if lastkey() <> 27      
   MENSAGEM2('Arquivo '+WNARQ_XLS+' gerado com sucesso.')
else
   MENSAGEM2('Atencao! Arquivo '+WNARQ_XLS+' gerado parcialmente.')
endif

return .t.

*****************
function CON_USER
*****************
LOCAL WCOR    := setcolor()
LOCAL WCURSOR := setcursor()
LOCAL WBOX    := savescreen(05,13,19,66)

SOMBRA(06,15,19,66,8)

setcolor(COR_CAB+'+')
@ 05,13 clear to 18,65 
@ 05,13 to 18,65 

setcolor(COR_CAB)
@ 06,15 say "LOG de acessos na tabela de "+ALIAS()

setcolor(COR_CAB)
@ 06,65 to 17,65
@ 18,14 to 18,64
@ 18,65 say chr(217)

setcolor(COR_TEXT)
@ 08,15 clear to 08,63
@ 08,19 say "Usu"+chr(160)+"rio" 
@ 08,47 say "Data"  
@ 08,56 say "Hora"

setcolor(COR_TEXT)
@ 09,15 say "Inc"
@ 10,15 say "Alt"
@ 11,15 say "Bx " 
@ 12,15 say "Can"
@ 13,15 say "Imp"

setcolor(COR_CAB)

@ 09,19 say USER_INC
@ 09,47 say if(empty(DATE_INC),space(08),DATE_INC)
@ 09,56 say TIME_INC

@ 10,19 say USER_ALT
@ 10,47 say if(empty(DATE_ALT),space(08),DATE_ALT)
@ 10,56 say TIME_ALT

@ 11,19 say USER_BX  
@ 11,47 say if(empty(DATE_BX),space(08),DATE_BX) 
@ 11,56 say TIME_BX  

@ 12,19 say USER_CAN 
@ 12,47 say if(empty(DATE_CAN),space(08),DATE_CAN)
@ 12,56 say TIME_CAN 

@ 13,19 say USER_IMP
@ 13,47 say if(empty(DATE_IMP),space(08),DATE_IMP)
@ 13,56 say TIME_IMP

setcolor(COR_OPC)
@ 17,31 say strzero(day(DATE()),2)+"/"+upper(left(MES(month(DATE())),3))+"/"+right(strzero(year(DATE()),4),2)

TIME_DELAY = TIME()

do while INKEY() == 0 .and. (SECS(TIME()) - SECS(TIME_DELAY)) <= 30
   @ 17,42 say TIME()
enddo      

setcolor(WCOR)

setcursor(WCURSOR)

restscreen(05,13,19,66,WBOX)

return .t.

*************
function KEYS
*************

if KEY == -7
   scalc()
elseif KEY == 278
   con_USER()
elseif KEY == 3
   skip
   if eof()
      skip -1
   endif
elseif KEY == 18
   skip -1
elseif KEY == 27
   return .f.
endif

return .t.

****************************
function FWriteLine( nh, c )
****************************

FWrite( nh, c + hb_osNewLine() )

RETURN nil

    
************
function FIM
************

SET BACKGROUND TASKS OFF

setcursor(0)

setcolor("W/N")
clearslow(1,00,00,24,79," ")

setcolor(right(COR_TEXT,len(COR_TEXT)-at("/",COR_TEXT))+"+/N")

exibe_BIG()

if seconds() <= 43200
   centro(14, "Bom dia!")
elseif seconds() <= 64800
   centro(14, "Boa tarde!")
else
   centro(14, "Boa noite!")
endif

setcolor("W/N")
inkey(5)

close all

QUIT

return .t.


******************
function exibe_BIG
******************
                                                                                         
@ 10,10 say "                            _                              "
@ 11,10 say " |\/|  o  ._   |_    _.    |_   _.  _    _   ._    _|   _. "
@ 12,10 say " |  |  |  | |  | |  (_|    |   (_|  /_  (/_  | |  (_|  (_| "
                                                                       
return .t.


*************************************************************************************
function cria_DB(WTABELA, WALIAS, WAREA, WFLD, WTYP, WTAM, WDEC, WCDX1, WCDX2, WCDX3)
*************************************************************************************
LOCAL I
private WFILE1 := WTABELA+".TMP"
private WFILE2 := WTABELA+".DBF"

exclui_TMP(&WAREA, WTABELA+".DBF", WTABELA+".CDX" )  

select &WAREA
create &WFILE1

for I = 1 to len(WFLD) 
    if WTYP[I] <> "N"
       WDEC[I] = 0
    endif
    
    DBAPPEND()  
    
    replace FIELD_NAME with WFLD[I],;
            FIELD_TYPE with WTYP[I],;
            FIELD_LEN  with WTAM[I],;
            FIELD_DEC  with WDEC[I]
next

create &WFILE2 from &WFILE1

close("&WFILE1")
ferase(WFILE1)

select &WAREA 
use &WFILE2 alias &WALIAS EXCLUSIVE
if ! empty(WCDX1)
   index on &WCDX1 tag SINC001
endif

if ! empty(WCDX2)
   index on &WCDX2 tag SINC002
endif

if ! empty(WCDX3)
   index on &WCDX3 tag SINC003
endif

return .t.


*****************************************
function exclui_TMP(WAREA, WTABELA, WCDX)
*****************************************

select &WAREA
DBCLOSEAREA()
   
ferase(WTABELA)

if ! empty(WCDX)
   ferase(WCDX)
endif

select LOGIN

return .t.


**********************
FUNCTION HEX2DEC(cHex) 
**********************
local nReturn,n,nLength,nExp,c,nTemp 
nReturn := 0 
cHex := Upper( Alltrim( cHex ) ) 
// 
nLength := len( cHex ) ; nExp := 0 
for n := nLength to 1 step -1 
 c := subst( cHex , n , 1 ) 
 if c >= "0" .and. c <= "9" 
  nTemp := val( c ) 
 elseif c >= "A" .and. c <= "F" 
  nTemp := asc( c ) - asc( "A" ) + 10 
 else 
  // Not a hexanumber 
  alert( cHex + " is not a valid Hex Number" ) 
  quit 
 endif 
 // 
 nReturn += nTemp*16^nExp 
 nExp++ 
next 
RETURN nReturn 

**********************
FUNCTION DEC2HEX(nDec)
**********************
local cReturn := "" ,  nTemp , c 
do while nDec <> 0 
 nTemp := nDec % 16 
 if nTemp < 10 
  c := str( nTemp , 1 , 0 ) 
 else 
  c := chr(  nTemp - 10 + asc( "A" ) ) 
 endif 
 cReturn := c + cReturn 
 // 
 nDec -= nTemp 
 nDec /= 16 
enddo 
if Len( cReturn ) = 0 
 cReturn := "0" 
endif 
if cRETURN <> "0"
   RETURN right("000"+alltrim(cReturn),3) 
endif
RETURN ""

*****************************************************
* ROTINA PARA MOSTRAR ARQUIVOS TEXTO ALEM DOS 64 KB *
* ANDRE EVANDRO MANSANO             AEM@ONDA.COM.BR *
*****************************************************

*****************************************************************************
function browse_REL(ARQ_, L_SUP_, C_SUP_,L_INF_, C_INF_,COR, MOLD, STEL, MSG)
*****************************************************************************
#include "inkey.ch"
* arq_ = ARQUIVO TEXTO
* l_sup_, c_sup_, l_inf_, c_inf_ = COORDENADAS DE LINHA E COLUNA
* cor  = QUAL A COR                                (DEFAULT = W+/B)
* mold = SE VAI TER MOLDURA                        (DEFAULT = .T.)
* stel = SE VAI SALVAR E RESTAURAR A TELA NO FINAL (DEFAULT = .T.)
* MSG  = se vai mostrar caminho/nome do arquivo no rodape (nao informado � .T.)

LOCAL cur_atual, cor_atual
mold:=IF(mold=NIL,.T.,mold)
stel:=IF(stel=NIL,.T.,stel)
MSG :=IF(MSG=NIL,.T.,MSG)

if mold
   PRIV l_arq[l_inf_-l_sup_+1], maxlin_, area_, tablin_, fim_arq_, offset_ini,;
        offset_fim, lsup_:=l_sup_+1, csup_:=c_sup_+1,linf_:=l_inf_-1, t_w, t_r, ;
        cinf_:= c_inf_-1, cod_sos:=55, t_c, t_s, t_d
else
   PRIV l_arq[l_inf_-l_sup_+1], maxlin_, area_, tablin_, fim_arq_, offset_ini,;
        offset_fim, lsup_:=l_sup_, csup_:=c_sup_,linf_:=l_inf_, t_w, t_r, ;
        cinf_:= c_inf_, cod_sos:=55, t_c, t_s, t_d
endif
t_w:=SETKEY(K_CTRL_W,NIL); t_r:=SETKEY(K_CTRL_R,NIL)
t_c:=SETKEY(K_CTRL_C,NIL); t_s:=SETKEY(K_CTRL_S,NIL)
t_d:=SETKEY(K_CTRL_D,NIL)
if stel
   t_t:=SAVESCREEN(l_sup_, c_sup_, l_inf_, c_inf_)
endif
if AT(".",arq_)=0
   arq_+=".prn"
ENDI
if (area_:=FOPEN(arq_))<0
   RETURN .F.     // ERRO AO ABRIR ARQUIVO
ENDI
cor=IF(cor=NIL,"W+/B",cor)
cor_atual=SETCOLOR(cor)
cur_atual:=SETCURSOR(0)

setcolor(COR_TEXT)

if MSG
   @ 24,00 CLEAR TO 24,79                    && LIMPA O AGUARDE NA LINHA 24
   WNARQ = right(WARQRPR,(len(ARQ_) - WPRFX)) 
   centro(24,"Arquivo Gerado: "+WNARQ)
endif

SETCOLOR(cor)

@ l_sup_,c_sup_ CLEAR TO l_inf_,c_inf_
if mold
   @ l_sup_,c_sup_ TO l_inf_,c_inf_
endif
maxlin_=linf_-lsup_+1
AFILL(l_arq,"")
offset_ini:=offset_fim := 0
tablin_ = 1
fim_arq_=FSEEK(area_,0,2)
FSEEK(area_,0)
MONTA_LIN(maxlin_,0,.F.)
offset_ini=0
DO WHILE .t.

   tecl_p=inkey(0)

   if SETKEY(tecl_p)!=NIL
      EVAL(SETKEY(tecl_p))
      tecl_p=0
   ENDI
   DO CASE
      CASE tecl_p=27
         EXIT

      CASE tecl_p=24
         MONTA_LIN(1,0)

      CASE tecl_p=5
         MONTA_LIN(-1,0)

      CASE tecl_p=31
         offset_ini:=offset_fim := 0
         AFILL(l_arq,"")
         MONTA_LIN(maxlin_,0)
         offset_ini=0

      CASE tecl_p=30
         offset_ini:=offset_fim := fim_arq_
         AFILL(l_arq,chr(0))
         @ l_sup_+1,c_sup_+1 CLEAR TO l_inf_-1,c_inf_-1
         MONTA_LIN(-1*(maxlin_),0)

      CASE tecl_p=4
         MONTA_LIN(0,10)   // ELE PULA 10 ESPACOS, PODE SER ALTERADO

      CASE tecl_p=19
         MONTA_LIN(0,-10)  // ELE PULA 10 ESPACOS, PODE SER ALTERADO

      CASE tecl_p=3
         MONTA_LIN(maxlin_-1,0)

      CASE tecl_p=18
         MONTA_LIN(-1*(maxlin_-1),0)

   END CASE
ENDD
FCLOSE(area_)
SETKEY(K_CTRL_W,t_w); SETKEY(K_CTRL_R,t_r)
SETKEY(K_CTRL_C,t_c); SETKEY(K_CTRL_S,t_s)
SETKEY(K_CTRL_D,t_d)
if stel
   RESTSCREEN(l_sup_, c_sup_, l_inf_, c_inf_, t_t)
endif
SETCOLOR(COR_TEXT)
@ 24,00 CLEAR TO 24,79
SETCURSOR(cur_atual)
SETCOLOR(cor_atual)

RETU

STATIC PROC MONTA_LIN(qtlin_,qttab_)  // le/imprime linhas do arquivo binario
LOCAL t_, i_, x_, j_, lin_, buf_, tambuf_, ini_, fim_, qts_:=0
if qtlin_!=0
   tambuf_=MIN(ABS(qtlin_)*2700,32000)
   if qtlin_<0 .AND. offset_ini>1
      DO WHILE .t.
         if offset_ini<tambuf_
            tambuf_=offset_ini
         ENDI
         FSEEK(area_,offset_ini-tambuf_)
         buffer_=SPAC(tambuf_)
         FREAD(area_,@buffer_,tambuf_)
         EXIT
      ENDD
      buffer_=STRTRAN(buffer_,chr(12)+chr(13),chr(13)+chr(10))
      tambuf_++
      buf_=tambuf_
      FOR t_ = qtlin_ TO -1
         if tambuf_ > 1
            tambuf_-=3
            i_=tambuf_
            tambuf_=RAT(chr(13)+chr(10),SUBS(buffer_,1,tambuf_))
            tambuf_=IF(tambuf_>0,tambuf_+2,1)
            if l_arq[maxlin_]!=chr(0)
               offset_fim-=LEN(l_arq[maxlin_])+2
            ENDI
            AINS(l_arq,1)
            i_=i_-tambuf_+1
            l_arq[1]=SUBS(buffer_,tambuf_,i_)
            qts_--
         else
            EXIT
         ENDI
      NEXT
      offset_ini-=buf_-tambuf_

   elseif l_arq[2]!=chr(0)
      FSEEK(area_,offset_fim)
      if offset_fim+tambuf_>fim_arq_
         tambuf_=fim_arq_-offset_fim
      ENDI
      buffer_=SPAC(tambuf_)
      FREAD(area_,@buffer_,tambuf_)
      buffer_=STRTRAN(buffer_,chr(12)+chr(13),chr(13)+chr(10))
      FOR t_ = 1 TO qtlin_
         if l_arq[1]!=chr(0)
            offset_ini+=LEN(l_arq[1])+2
         ENDI
         ADEL(l_arq,1)
         qts_++
         if LEN(buffer_)<3
            l_arq[maxlin_]=chr(0)
            if l_arq[2]=chr(0)
               EXIT
            ENDI
         else
            l_arq[maxlin_]=PARSE(@buffer_,chr(13)+chr(10))
            offset_fim+=LEN(l_arq[maxlin_])+2
         ENDI
      NEXT
   ENDI
ENDI
i_=0
FOR t_ = 1 TO maxlin_
   i_=MAX(i_,LEN(l_arq[t_]))
NEXT
if (qttab_<0 .AND. tablin_>1) .OR.;
   (qttab_>0 .AND. tablin_<i_-10)
   tablin_+=qttab_
   qts_=maxlin_
ENDI
if qts_!=0
   SCROLL(lsup_,csup_,linf_,cinf_,qts_)
   ini_=IF(qts_>0,maxlin_-qts_+1,1)
   fim_=IF(qts_>0,maxlin_,ABS(qts_))
   FOR t_=ini_ TO fim_
      lin_=l_arq[t_]
      if !EMPTY(lin_)  //.AND.!OK_PRINT(lin_)
         if AT(" "+chr(8),lin_)>0
            lin_=SUBS(lin_,AT(" "+chr(8),lin_)+2)
         ENDI
      ENDI
      XPUL=0
      if SUBSTR(lin_,1,1)==chr(13)
         XPUL=1
      endif
      @ lsup_+t_-1,csup_ say SUBS(lin_,tablin_+XPUL,CINF_-CSUP_+1)
   NEXT
ENDI
buffer_=""
RETU

FUNC DESEMBARALHA(_lin)
LOCAL ret_val:="", i, j, x, k
x="17389280912340243"
k=0
FOR i=1 TO LEN(_lin)
   k++
   if k>LEN(x)
      k=1
   ENDI
   j=ASC(SUBS(_lin,i,1))-VAL(SUBS(x,k,1))
   if j<0
      j=255+j
   ENDI
   ret_val+=chr(j)
NEXT
RETU ret_val

********************************
function PARSE(Arg1, Arg2)
********************************
   local Local1, Local2
   if (PCount() < 2)
      Arg2:= ","
   endif
   Local2:= At(Arg2, Arg1)
   if (Local2 > 0)
      Local1:= left(Arg1, Local2 - 1)
      Arg1:= SubStr(Arg1, Local2 + Len(Arg2))
   else
      Local1:= Arg1
      Arg1:= ""
   endif
   return Local1

*****************************************************************

Function extenso()
Private nValor, cVarExt, nQtdLin, nTamLin, cCharComp
Parameters nValor, cVarExt, nMOEDA

if nValor = 0

   aAdd( cVarExt , replicate("*",255) )
   Return .f.

endif

if Empty(nMOEDA)
   MONEY = 1
else
   MONEY = 0
endif

nQtdLin   := 1  
nTamLin   := 150
cCharComp := "*"

nTamWord := 0
cModo    := space( 01 )
cPrepos  := space( 01 )

nUnidade := {}
nDezena  := {}
nCentena := {}
nDecimal := {}

aAdd( nUnidade , "UM"              )
aAdd( nUnidade , "DOIS"            )
aAdd( nUnidade , "TRES"            )
aAdd( nUnidade , "QUA-TRO"         )
aAdd( nUnidade , "CIN-CO"          )
aAdd( nUnidade , "SEIS"            )
aAdd( nUnidade , "SE-TE"           )
aAdd( nUnidade , "OI-TO"           )
aAdd( nUnidade , "NO-VE"           )
aAdd( nUnidade , "DEZ"             )
aAdd( nUnidade , "ON-ZE"           )
aAdd( nUnidade , "DO-ZE"           )
aAdd( nUnidade , "TRE-ZE"          )
aAdd( nUnidade , "QUA-TOR-ZE"      )
aAdd( nUnidade , "QUIN-ZE"         )
aAdd( nUnidade , "DE-ZES-SEIS"     )
aAdd( nUnidade , "DE-ZES-SE-TE"    )
aAdd( nUnidade , "DE-ZOI-TO"       )
aAdd( nUnidade , "DE-ZE-NO-VE"     )

aAdd( nDezena  , ""                )
aAdd( nDezena  , "VIN-TE"          )
aAdd( nDezena  , "TRIN-TA"         )
aAdd( nDezena  , "QUA-REN-TA"      )
aAdd( nDezena  , "CIN-QUEN-TA"     )
aAdd( nDezena  , "SES-SEN-TA"      )
aAdd( nDezena  , "SE-TEN-TA"       )
aAdd( nDezena  , "OI-TEN-TA"       )
aAdd( nDezena  , "NO-VEN-TA"       )

aAdd( nCentena , "CEN-TO"          )
aAdd( nCentena , "DU-ZEN-TOS"      )
aAdd( nCentena , "TRE-ZEN-TOS"     )
aAdd( nCentena , "QUA-TRO-CEN-TOS" )
aAdd( nCentena , "QUI-NHEN-TOS"    )
aAdd( nCentena , "SEIS-CEN-TOS"    )
aAdd( nCentena , "SE-TE-CEN-TOS"   )
aAdd( nCentena , "OI-TO-CEN-TOS"   )
aAdd( nCentena , "NO-VE-CEN-TOS"   )

For a := 1 To 15

   if a <= nQtdLin

      aAdd( cVarExt , "" )

   endif

   aAdd( nDecimal  , Val( SubStr( Str( nValor , 15 , 2 ) , a , 1 ) ) )

Next

nIndice := 1
nNumLin := 1

While nIndice < 13

   if Str( nIndice , 2 ) $(" 1 4 710") .And. nDecimal[nIndice] > 0

      if nDecimal[nIndice] = 1 .AND. nDecimal[nIndice+1] = 0 .AND. nDecimal [nIndice+2] = 0

         cWord2 := "CEM"
         cWord1 := "CEM"

      else

         cWord2 := nCentena[nDecimal[nIndice]]
         cWord1 := StrTran( cWord2 , "-" )

      endif

      Escreve( cWord2, cWord1 )

   endif

   if Str( nIndice , 2 ) $(" 2 5 811") .And. nDecimal[nIndice] > 0

      if cModo = "P"

         cWord2 := "E"
         cWord1 := "E"
         cModo  := ""

         Escreve( cWord2, cWord1 )

      endif

      if nDecimal[nIndice] = 1

         nIndAux := ( 10 + nDecimal[nIndice + 1] )
         cWord2  := nUnidade[nIndAux]
         cWord1  := StrTran( cWord2 , "-" )
      else

         cWord2 := nDezena[nDecimal[nIndice]]
         cWord1 := StrTran( cWord2 , "-" )

      endif

      Escreve( cWord2, cWord1 )

   endif

   if Str( nIndice , 2 ) $(" 3 6 912") .And. nDecimal[nIndice] > 0

      if nDecimal[nIndice -1] # 1

         if cModo = "P"

            cWord2 := "E"
            cWord1 := "E"
            cModo  := ""

            Escreve( cWord2, cWord1 )

         endif

         cWord2 := nUnidade[nDecimal[nIndice]]
         cWord1 := StrTran( cWord2 , "-" )

         Escreve( cWord2, cWord1 )

      endif

   endif

   if Str( nIndice , 2 ) $(" 3 6 912")

      if Str( nIndice , 2 ) == " 3" .And. ( nDecimal[nIndice] # 0 .Or. nDecimal[nIndice-1] # 0 .Or. nDecimal[nIndice-2] # 0)

         cVirgula := ""

         For a := 4 To 12

             if nDecimal[A] # 0

                cVirgula := ","

             endif

         Next a

         if nDecimal[nIndice - 2] # 0 .Or. nDecimal[nIndice - 1] # 0 .Or. nDecimal[nIndice] > 1

            cWord2 := "BI-LHOES" + cVirgula
            cWord1 := "BILHOES"  + cVirgula

         else

            cWord2 := "BI-LHAO" + cVirgula
            cWord1 := "BILHAO"  + cVirgula

         endif

         Escreve( cWord2, cWord1 )

         cPrepos := "DE"

      elseif Str( nIndice , 2 ) == " 6" .And. (nDecimal[nIndice] # 0 .Or. nDecimal[nIndice-1] # 0 .Or. nDecimal[nIndice-2] # 0)

         cVirgula := ""

         For a := 7 To 12

             if nDecimal[A] # 0

                cVirgula := ","

             endif

         Next a

         if nDecimal[nIndice - 2] # 0 .Or. nDecimal[nIndice - 1] # 0 .Or. nDecimal[nIndice] > 1

            cWord2 := "MI-LHOES" + cVirgula
            cWord1 := "MILHOES"  + cVirgula

         else

            cWord2 := "MI-LHAO" + cVirgula
            cWord1 := "MILHAO"  + cVirgula

         endif

         Escreve( cWord2, cWord1 )

         cPrepos := "DE"

      elseif Str( nIndice , 2 ) == " 9" .And. (nDecimal[nIndice] # 0 .Or. nDecimal[nIndice-1] # 0 .Or. nDecimal[nIndice-2] # 0)

         cVirgula := ""

         For a := 10 To 12

             if nDecimal[A] # 0

                cVirgula := ","

             endif

         Next a

         cWord2 := "MIL" + cVirgula
         cWord1 := "MIL" + cVirgula

         Escreve( cWord2, cWord1 )

         cPrepos := " "

      endif

   endif

   nIndice += 1

enddo

if cPrepos # " "

   cWord2 := cPrepos
   cWord1 := cPrepos

   Escreve( cWord2, cWord1 )

endif

***********************************************
UNQ = 1  // VARIAVEL PARA CONTROLE DE VALOR < 0
         // JULIANO
***********************************************

if MONEY = 1

   if Int( nValor ) == 1
      cWord2 := "RE-AL"
      cWord1 := "REAL"
   else
      if nVALOR > 1             
         cWord2 := "RE-A-IS"
         cWord1 := "REAIS"
      else                      
         cWord2 := ""           
         cWord1 := ""           
         UNQ    := 0            
      endif                     
   endif

else
   cWord2 := ""
   cWord1 := ""
endif

Escreve( cWord2, cWord1 )

if nDecimal[14] # 0 .Or. nDecimal[15] # 0

   if UNQ = 1        // JULIANO
      cWord2 := "E"
      cWord1 := "E"
      Escreve( cWord2, cWord1 )
   endif             

endif

if nDecimal[14] # 0

   if nDecimal[14] == 1

      nIndAux := 10 + nDecimal[15]
      cWord2  := nUnidade[nIndAux]
      cWord1  := StrTran( cWord2 , "-" )

   else

      cWord2  := nDezena[nDecimal[14]]
      cWord1  := StrTran( cWord2 , "-" )

   endif

   Escreve( cWord2, cWord1 )

endif

if nDecimal[15] # 0

   if nDecimal[14] > 1

      cWord2 := "E"
      cWord1 := "E"

      Escreve( cWord2, cWord1 )

   endif

   if nDecimal[14] # 1

      cWord2 := nUnidade[nDecimal[15]]
      cWord1 := StrTran( cWord2 , "-" )

      Escreve( cWord2, cWord1 )

   endif

endif

if ( ( nDecimal[14] * 10 ) + nDecimal[15] ) # 0

   if ( ( nDecimal[14] * 10 ) + nDecimal[15] ) == 1

      cWord2 := "CEN-TA-VO"
      cWord1 := "CENTAVO"

   else

      cWord2 := "CEN-TA-VOS"
      cWord1 := "CENTAVOS"

   endif

   Escreve( cWord2, cWord1 )

endif

For a := nNumLin To nQtdLin

   cVarExt[A] := cVarExt[A] + Replicate( cCharComp , nTamLin - Len( cVarExt[A] ) )

Next a
 
Static Function escreve( cWord2, cWord1 )

if Len( cWord1 ) + 1 > nTamLin - nTamWord

   nPosicao := SubStr( cWord1 , 1 , nTamLin - nTamWord - 1 )
   nCountb  := 1

   For a := 1 To Len( nPosicao )

       if SubStr( cWord2 , A , 1 ) # SubStr( nPosicao , nCountb , 1 )

          nCountb += 1

          loop

       endif

       nCountb += 1

   Next a

   For a := nCountb To 1 Step -1

       M_QUAESP = 0

       if SUBSTR(cWord2,A,1) = "-"

          For c := a To 1 Step -1

              if SubStr( cWord2 , C , 1 ) == "-"

                 M_QUAESP += 1

              endif

          Next c

          cVarExt[nNumLin] := cVarExt[nNumLin] + SubStr( cWord1 , 1 , A - M_QUAESP ) + "-"

          nTamWord += ( A - ( M_QUAESP + 1 ) )

          cModo = "P"

          Exit

       endif

   Next a

   cVarExt[nNumLin] := cVarExt[nNumLin] + Replicate( cCharComp ,nTamLin - nTamWord )

   nNumLin  := nNumLin + 1
   nTamWord := 0

   if a # 1

      cWord1 := Right( cWord1, Len( cWord1 ) - Len( SubStr( cWord1 , 1 , A - M_QUAESP ) ) )  + " "
      cVarExt[nNumLin] += cWord1

      nTamWord += Len( cWord1 )

   else

      cVarExt[nNumLin] += ( cWord1 + " " )

      nTamWord += ( Len( cWord1 ) + 1 )

      cModo := "P"

   endif

else

   cVarExt[nNumLin] += ( cWord1 + " " )

   nTamWord += ( Len( cWord1 ) + 1 )

   cModo := "P"

endif

return .t.

**********************************************************************************
function CHCK_TOKEN(WNIVEL, WBLOQUEIO1, WTIPO_DOC, WDOCNO, WBLOQUEIO2, WBLOQUEIO3)
**********************************************************************************
LOCAL getlist    :={}
LOCAL WCOR       := setcolor()
LOCAL WTT_TOKEN  := savescreen(03,10,19,70)
LOCAL WTT_EMAIL  := savescreen(24,00,24,79)
LOCAL cCOLOR_GET := COR_BARRA+","+COR_BARRA+","+COR_BARRA+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_BARRA
LOCAL I
private WAREA    := alias()

if pcount() == 4
   WBLOQUEIO2 = space(50)
   WBLOQUEIO3 = space(50)
endif
if pcount() == 5
   WBLOQUEIO3 = space(50)
endif

setcolor(COR_CONS)
@ 03,10 clear to 19,70
@ 03,10 to 19,70
@ 03,53 say "[ Digital TOKEN ]"

@ 04,12 say "RESPONS"+chr(181)+"VEL...:"

centro(08, WBLOQUEIO1)
centro(09, WBLOQUEIO2)
centro(10, WBLOQUEIO3)

@ 17,12 say "TOKEN.........:"
@ 18,12 say "JUSTIFICATIVA.:"

select LOGIN
ordsetfocus("SINC003")
seek WNIVEL

I = 0

do while val(WNIVEL) <= val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. ! eof()
   if empty(HB_Decrypt(TOKEN_SYS,"$!nc0n@2012")) 
      skip +1
      loop
   endif
   if val(WNIVEL) == 3 .or. val(WNIVEL) == 4
      if val(WNIVEL) <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. 5 <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012"))
         skip +1
         loop
      endif
   elseif val(WNIVEL) == 1 .or. val(WNIVEL) == 2
      if val(WNIVEL) <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. 2 <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. 5 <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012"))
         skip +1
         loop
      endif
   endif
   
   I = I + 1
   skip +1
enddo

private WAUSUARIO[I]

seek WNIVEL

I = 0

do while val(WNIVEL) <= val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. ! eof()
   if empty(HB_Decrypt(TOKEN_SYS,"$!nc0n@2012")) 
      skip +1
      loop
   endif
   if val(WNIVEL) == 3 .or. val(WNIVEL) == 4
      if val(WNIVEL) <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. 5 <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012"))
         skip +1
         loop
      endif
   elseif val(WNIVEL) == 1 .or. val(WNIVEL) == 2
      if val(WNIVEL) <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. 2 <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012")) .and. 5 <> val(HB_Decrypt(TKNIVEL,"$!nc0n@2012"))
         skip +1
         loop
      endif
   endif

   I = I + 1
   WAUSUARIO[I] = HB_Decrypt(USUARIO,"$!nc0n@2012")
   
   skip +1

enddo

asort(WAUSUARIO)

WUSUARIO            = space(50)
WSOLICITACAO        = space(20)
WTOKEN_DECODIFICADO = space(20)
WJUSTIFICA          = space(50)

@ 04,28,15,68 get WUSUARIO      ;
              LISTBOX WAUSUARIO ;
              DROPDOWN SCROLLBAR;
              COLOR cCOLOR_GET
READ SAVE
clear gets

if lastkey() == 27 .or. empty(WUSUARIO)
   setcolor(WCOR)
   restscreen(03,10,19,70,WTT_TOKEN)

   select &WAREA
   return .f.
endif

if alltrim(WPUSUARIO) == "ADMINISTRADOR"
   WNOME_SOLICITA = "ADMINISTRADOR DO SISTEMA"
else
   select LOGIN
   ordsetfocus("SINC001")
   seek WPUSUARIO

   WNOME_SOLICITA = alltrim(HB_Decrypt(NOME,"$!nc0n@2012"))
endif
   
select LOGIN
ordsetfocus("SINC001")
seek WUSUARIO

WCELULAR        = HB_Decrypt(CELULAR,"$!nc0n@2012")
WEMAIL          = alltrim(HB_Decrypt(EMAIL,"$!nc0n@2012"))
WNOME_LIBERADO  = alltrim(HB_Decrypt(NOME,"$!nc0n@2012"))

@ 05,28 say WCELULAR picture "99999999999"

********************** TOKEN SYS
WTOKEN         = HB_RandomInt(1,999999)
WTOKEN_SYS     = HB_Decrypt(TOKEN_SYS,"$!nc0n@2012")
WULTIMO_DIGITO = val(right(alltrim(WTOKEN_SYS),1))
if WULTIMO_DIGITO = 0
   WULTIMO_DIGITO = 9
endif

WSOLICITACAO = NumToHex(((WTOKEN*WULTIMO_DIGITO)+val(WTOKEN_SYS))*if(left(time(),2) == "00", 24, val(left(time(),2))))

********************** TOKEN APP
WTOKEN_APP     = HB_Decrypt(TOKEN_APP,"$!nc0n@2012")
WULTIMO_DIGITO = val(right(alltrim(WTOKEN_APP),1))
if WULTIMO_DIGITO = 0
   WULTIMO_DIGITO = 9
endif

if (val(WTOKEN_APP) == 0) 
   WRETORNO = NumToHex(HB_RandomInt(999,999999999))
else
   WRETORNO = NumToHex(((WTOKEN*WULTIMO_DIGITO)+val(WTOKEN_APP))*if(left(time(),2) == "00", 24, val(left(time(),2))))
endif

setcolor(COR_BARRA)
centro(12, "SOLICITA"+chr(128)+chr(142)+"O [ "+WSOLICITACAO+" ]")

if (val(WTOKEN_APP) == 0)
   sendsms("solicitacao "+WSOLICITACAO+" token "+WRETORNO+" - "+alltrim(WBLOQUEIO1+WBLOQUEIO2+WBLOQUEIO3),left(alltrim(WCELULAR),2),right(WCELULAR,len(alltrim(WCELULAR))-2))
endif                                                                                  
 
setcolor(COR_CONS+","+COR_GETS+","+COR_CONS+","+COR_CONS+","+COR_CONS)
@ 17,28 get WTOKEN_DECODIFICADO  picture "@!"         valid (alltrim(WTOKEN_DECODIFICADO) == alltrim(WRETORNO))
@ 18,28 get WJUSTIFICA           picture "@S40"       valid ! empty(WJUSTIFICA)
READ SAVE
clear gets

if (alltrim(WTOKEN_DECODIFICADO) == alltrim(WRETORNO))
   select TOKEN
   ordsetfocus("SINC001")

   if ! inc_reg()
      setcolor(WCOR) 
      restscreen(03,10,19,70,WTT_TOKEN)

      select &WAREA
      return .F.      
   endif

   replace SOLICITA   with WNOME_SOLICITA,;
           LIBERADO   with WNOME_LIBERADO,;
           TOKEN      with WTOKEN        ,;
           NIVEL      with WNIVEL        ,;
           TIPO_DOC   with WTIPO_DOC     ,;
           DOCNO      with WDOCNO        ,;
           BLOQUEIO1  with WBLOQUEIO1    ,;
           BLOQUEIO2  with WBLOQUEIO2    ,;
           BLOQUEIO3  with WBLOQUEIO3    ,;
           JUSTIFICA  with WJUSTIFICA    ,;
           EMAIL      with WEMAIL        ,;
           DATE       with date()        ,;
           TIME       with time()
    
   grava()
   
   notificar_token(TOKEN, TIPO_DOC, DOCNO)

endif

setcolor(WCOR)
restscreen(03,10,19,70,WTT_TOKEN)
restscreen(24,00,24,79,WTT_EMAIL)

select &WAREA

return(alltrim(WTOKEN_DECODIFICADO) == alltrim(WRETORNO))

***************************************************
function NOTIFICAR_TOKEN(WTOKEN, WTIPO_DOC, WDOCNO)
***************************************************
LOCAL WCARRO, WCIDADE1, WCIDADE2, WCIDADE3, WVIAGEM, WCOLETA, WENTREGA, WCTRB

LOCAL WORD    := indexord()
LOCAL WREG    := recno()
private WAREA := alias()

AGUARDE()
      
select TOKEN
ordsetfocus("SINC002")
seek str(WTOKEN,10)+WTIPO_DOC+WDOCNO
  
if ! found() .or. empty(EMAIL)
   select &WAREA
   ordsetfocus(WORD)
   go WREG
   
   return .f.
endif

WARQ_RET = pathTMP+"\"+alltrim(str(RANDOM()%99999999,8))+".html"
            
set print to &WARQ_RET
set device to print
set console off

setprc(0,0)

@ prow(),00     say '<body>'
@ prow()+1,00   say '<table>'
@ prow()+1,00   say '<tr>'
@ prow()+1,00   say '<td>Prezado '+alltrim(LIBERADO)
@ prow(),pcol() say '<br><br>Voc&ecirc; atendeu a solicita&ccedil;&atilde;o de '+alltrim(SOLICITA)+' para:<br><br><b>- '+alltrim(BLOQUEIO1)

if (! empty(BLOQUEIO2))
   @ prow(),pcol() say '<br>- '+alltrim(BLOQUEIO2)
endif   

if (! empty(BLOQUEIO3))
   @ prow(),pcol() say '<br>- '+alltrim(BLOQUEIO3)
endif   

@ prow(),pcol() say '</b><br><br>com a justificativa:<br><br><b>- '+alltrim(JUSTIFICA)+'</b>'
@ prow(),pcol() say '<font color = "#FF00FF">'

if WTIPO_DOC = '1'
   @ prow(),pcol() say '<br><br>WMS-Liberar troca de nota apos 10 dias: '+alltrim(DOCNO)
elseif WTIPO_DOC = '2'
   @ prow(),pcol() say '<br><br>WMS-Liberar ajuste de estoque (AJU) - '+alltrim(DOCNO)
endif
    
@ prow(),pcol() say '<br><br>Nivel de libera&ccedil;&atilde;o: '+alltrim(NIVEL)           
@ prow(),pcol() say '</font>'  
         
@ prow(),pcol() say '<br><br>Atenciosamente,<br><br>Sara Vembu<br>ORACULO-WMS - Dimen&ccedil;&atilde;o do Espa&ccedil;o<br>NTI - N&uacute;cleo de Tecnologia da Informa&ccedil;&atilde;o<br>Grupo Toniato<br></td>'
@ prow()+1,00   say '</tr>'
@ prow()+1,00   say '</table>'
@ prow()+1,00   say '</body>'
      
set print to  
set device to screen
set console on

if alltrim(NIVEL) == "3"  
   SendMail(EMAIL,{"claudia.moura@grupotoniato.com.br","sergio@grupotoniato.com.br"},, WARQ_RET, "ORACULO-Token [ "+TIPO_DOC+"-"+alltrim(DOCNO)+" ]")
endif
      
ferase(WARQ_RET)

select &WAREA
ordsetfocus(WORD)
go WREG

return .t.


********************************************************************************
****************INICIO DO ENVIO DE EMAIL****************************************
********************************************************************************
/*
Autor Responsavel: Luiz Rafael Culik

Exemplo:
     SendMail("sergio.sac@gmail.com" ,,, "email.html", "assunto sara", "c:\meus documentos\arq_anexo.txt")
*/
        
FUNCTION SendMail(aTo, aCC, aBCC, cBody, cSubject, aFiles)   
   /*
   cServer    -> Necess�rio. Nome IP ou o dom�nio do servidor de email
   nPort      -> Opcional.   A porta usada pelo o meu servidor de email
   cFro       -> Necess�rio. Endere�o de email do remetente
   aTo        -> Necess�rio. Seq��ncia de caracteres ou matriz de endere�os de email para enviar o email para
   aCC        -> Opcional.   Seq��ncia de caracteres ou matriz de email adresses para CC (Copia do email)
   aBCC       -> Opcional.   Seq��ncia de caracteres ou matriz de email adresses de Cco (copia oculta do email)
   cBody      -> Opcional.   A mensagem do corpo do email como texto, ou o nome do arquivo da mensagem em HTML para enviar.
   cSubject   -> Opcional.   Assunto do email
   aFiles     -> Opcional.   Matriz/arquivos de anexos para enviar com o email
   cUser      -> Necess�rio. Nome de usu�rio para o servidor POP3
   cPass      -> Necess�rio. Senha para cUser
   cPopServer -> Necess�rio. Nome IP ou o dom�nio do servidor de email POP3
   nPriority  -> Opcional.   Email de prioridade: 1 = alta, 3 = Normal (padr�o), 5 = baixa
   lRead      -> Opcional.   Se definido como. T., uma solicita��o de confirma��o � enviada. A configura��o padr�o �. f.
   lTrace     -> Opcional.   Se definido como. T., um arquivo de log � criado (sendmail .log). A configura��o padr�o �. f.
   lPopAuth   -> Opcional.   Sinalizador para indicar que Autentication POP3 � usado. A configura��o padr�o �. T.
   lnoauth    -> Opcional.   Servidores de email que nao precisam de autenticacao smtp
   nTimeOut   -> Opcional.   Numero de milesimos de segundos a Aguarda o envio - Padr�o � 2000(2 segundos)
   */

   LOCAL cServer      := "mail.servidor2.com.br"
   LOCAL nPort        := 25
   LOCAL cFrom        := "sara@servidor2.com.br" 
   LOCAL cUser        := "sara@servidor2.com.br"   
   LOCAL cPass        := "toniato123"   
   LOCAL cPopServer   := "mail.servidor2.com.br"
   LOCAL nPriority    := 3
   LOCAL lRead        := .F.
   LOCAL lTrace       := .F.
   LOCAL lPopAuth     := .T.
   LOCAL lNoAuth      := .f.
   LOCAL nTimeOut     := 20000
   
   LOCAL oInMail, cBodyTemp, oUrl, oMail, oAttach, aThisFile, cFile, cFname, cFext, cData, oUrl1

   LOCAL cTmp          := ""
   LOCAL cMimeText     := ""
   LOCAL cTo           := ""
   LOCAL cCC           := ""
   LOCAL cBCC          := ""

   LOCAL lConnectPlain := .F.
   LOCAL lReturn       := .T.
   LOCAL lAuthLogin    := .F.
   LOCAL lAuthPlain    := .F.
   LOCAL lConnect      := .T.
   local oPop
   local adata:={},nCount,nSize,nSent

   DEFAULT cUser       TO ""
   DEFAULT cPass       TO ""
   DEFAULT nPort       TO 25
   DEFAULT aFiles      TO {}


   cUser := StrTran( cUser, "@", "&at;" )

   if !( (".htm" IN Lower( cBody ) .OR. ".html" IN Lower( cBody ) ) .AND. File(cBody) )

      if Right(cBody,2) != HB_OSNewLine()
         cBody += HB_OsNewLine()
      endif

   endif

   // cTo
   if Valtype( aTo ) == "A"
      if Len( aTo ) > 1
         FOR EACH cTo IN aTo
            if HB_EnumIndex() != 1
               cTmp += cTo + ","
            endif
         NEXT
         cTmp := Substr( cTmp, 1, Len( cTmp ) - 1 )
      endif
      cTo := aTo[ 1 ]
      if Len( cTmp ) > 0
         cTo += "," + cTmp
      endif
   else
      cTo := Alltrim( aTo )
   endif

   // CC (Carbon Copy)
   if Valtype(aCC) =="A"
      if Len(aCC) >0
         FOR EACH cTmp IN aCC
            cCC += cTmp + ","
         NEXT
         cCC := Substr( cCC, 1, Len( cCC ) - 1 )
      endif
   elseif Valtype(aCC) =="C"
      cCC := Alltrim( aCC )
   endif

   // BCC (Blind Carbon Copy)
   if Valtype(aBCC) =="A"
      if Len(aBCC)>0
         FOR EACH cTmp IN aBCC
            cBCC += cTmp + ","
         NEXT
         cBCC := Substr( cBCC, 1, Len( cBCC ) - 1 )
      endif
   elseif Valtype(aBCC) =="C"
      cBCC := Alltrim( aBCC )
   endif

   if cPopServer != NIL .AND. lPopAuth
      Try
         oUrl1 := tUrl():New( "pop://" + cUser + ":" + cPass + "@" + cPopServer + "/" )
         oUrl1:cUserid := Strtran( cUser, "&at;", "@" )
         opop:= tIPClientpop():New( oUrl1, lTrace )
         if oPop:Open()
            oPop:Close()
         endif
      Catch
         lReturn := .F.
      END

   endif

   if !lReturn
      RETURN .F.
   endif

   TRY
    oUrl := tUrl():New( "smtp://" + cUser + "@" + cServer + '/' + cTo )
   CATCH
    lReturn := .F.
   END

   if !lReturn
      RETURN .F.
   endif

   oUrl:nPort   := nPort
   oUrl:cUserid := Strtran( cUser, "&at;", "@" )

   oMail   := tipMail():new()
   oAttach := tipMail():new()
   oAttach:SetEncoder( "7-bit" )

   if (".htm" IN Lower( cBody ) .OR. ".html" IN Lower( cBody ) ) .AND. File(cBody)
      cMimeText := "text/html ; charset=ISO-8859-1"
      oAttach:hHeaders[ "Content-Type" ] := cMimeText
      cBodyTemp := cBody
      cBody     := MemoRead( cBodyTemp ) + chr( 13 ) + chr( 10 )

   else
      oMail:hHeaders[ "Content-Type" ] := "text/plain; charset=iso8851"
   endif

   oAttach:SetBody( cBody )
   oMail:Attach( oAttach )
   oUrl:cFile := cTo + If( Empty(cCC), "", "," + cCC ) + If( Empty(cBCC), "", "," + cBCC)

   oMail:hHeaders[ "Date" ] := tip_Timestamp()
   oMail:hHeaders[ "From" ] := cFrom

   if !Empty(cCC)
      oMail:hHeaders[ "Cc" ] := cCC
   endif
   if !Empty(cBCC)
      oMail:hHeaders[ "Bcc" ] := cBCC
   endif

   TRY
    oInmail := tIPClientsmtp():New( oUrl, lTrace)
   CATCH
    lReturn := .F.
   END

   if !lReturn
      RETURN .F.
   endif

   oInmail:nConnTimeout:= nTimeOut

   if !lNoAuth

      if oInMail:Opensecure()

         WHILE .T.
            oInMail:GetOk()
            if oInMail:cReply == NIL
               EXIT
            elseif "LOGIN" IN oInMail:cReply
               lAuthLogin := .T.
            elseif "PLAIN" IN oInMail:cReply
               lAuthPlain := .T.
            endif
         enddo

         if lAuthLogin
            if !oInMail:Auth( cUser, cPass )
               lConnect := .F.
            else
               lConnectPlain  := .T.
            endif
         endif

         if lAuthPlain .AND. !lConnect
            if !oInMail:AuthPlain( cUser, cPass )
               lConnect := .F.
            endif
         else
            if !lConnectPlain
               oInmail:Getok()
               lConnect := .F.
            endif
         endif

      else

         lConnect := .F.

      endif
   else
         lConnect := .F.
   endif

   if !lConnect

      if !lNoAuth
         oInMail:Close()
      endif
      TRY
       oInmail := tIPClientsmtp():New( oUrl, lTrace)
      CATCH
       lReturn := .F.
      END

      oInmail:nConnTimeout:=nTimeOut

      if !oInMail:Open()
         lConnect := .F.
         oInmail:Close()
         RETURN .F.
      endif

      WHILE .T.
         oInMail:GetOk()
         if oInMail:cReply == NIL
            EXIT
         endif
      enddo

   endif

   oInMail:oUrl:cUserid := cFrom
   oMail:hHeaders[ "To" ]      := cTo
   oMail:hHeaders[ "Subject" ] := cSubject

   FOR EACH aThisFile IN AFiles

      if Valtype( aThisFile ) == "C"
         cFile := aThisFile
         cData := Memoread( cFile ) + chr( 13 ) + chr( 10 )
      elseif Valtype( aThisFile ) == "A" .AND. Len( aThisFile ) >= 2
         cFile := aThisFile[ 1 ]
         cData := aThisFile[ 2 ] + chr( 13 ) + chr( 10 )
      else
         lReturn := .F.
         EXIT
      endif

      oAttach := TipMail():New()

      HB_FNameSplit( cFile,, @cFname, @cFext )

      if Lower( cFile ) LIKE ".+\.(vbd|asn|asz|asd|pqi|tsp|exe|sml|ofml)"    .OR. ;
         Lower( cFile ) LIKE ".+\.(pfr|frl|spl|gz||stk|ips|ptlk|hqx|mbd)"    .OR. ;
         Lower( cFile ) LIKE ".+\.(mfp|pot|pps|ppt|ppz|doc|n2p|bin|class)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(lha|lzh|lzx|dbf|cdx|dbt|fpt|ntx|oda)"     .OR. ;
         Lower( cFile ) LIKE ".+\.(axs|zpa|pdf|ai|eps|ps|shw|qrt|rtc|rtf)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(smp|dst|talk|tbk|vmd|vmf|wri|wid|rrf)"    .OR. ;
         Lower( cFile ) LIKE ".+\.(wis|ins|tmv|arj|asp|aabaam|aas|bcpio)"    .OR. ;
         Lower( cFile ) LIKE ".+\.(vcd|chat|cnc|coda|page|z|con|cpio|pqf)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(csh|cu|csm|dcr|dir|dxr|swa|dvi|evy|ebk)"  .OR. ;
         Lower( cFile ) LIKE ".+\.(gtar|hdf|map|phtml|php3|ica|ipx|ips|js)"  .OR. ;
         Lower( cFile ) LIKE ".+\.(latex|bin|mif|mpl|mpire|adr|wlt|nc|cdf)"  .OR. ;
         Lower( cFile ) LIKE ".+\.(npx|nsc|pgp|css|sh||shar|swf|spr|sprite)" .OR. ;
         Lower( cFile ) LIKE ".+\.(sit|sca|sv4cpio|sv4crc|tar|tcl|tex)"      .OR. ;
         Lower( cFile ) LIKE ".+\.(texinfo|texi|tlk|t|tr|roff|man|mems)"     .OR. ;
         Lower( cFile ) LIKE ".+\.(alt|che|ustar|src|xls|xlt|zip|au|snd)"    .OR. ;
         Lower( cFile ) LIKE ".+\.(es|gsm|gsd|rmf|tsi|vox|wtx|aif|aiff)"     .OR. ;
         Lower( cFile ) LIKE ".+\.(aifc|cht|dus|mid|midi|mp3|mp2|m3u|ram)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(ra|rpm|stream|rmf|vqf|vql|vqe|wav|wtx)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(mol|pdb|dwf|ivr|cod|cpi|fif|gif|ief)"     .OR. ;
         Lower( cFile ) LIKE ".+\.(jpeg|jpg|jpe|rip|svh|tiff|tif|mcf|svf)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(dwg|dxf|wi|ras|etf|fpx|fh5|fh4|fhc|dsf)"  .OR. ;
         Lower( cFile ) LIKE ".+\.(pnm|pbm|pgm|ppm|rgb|xbm|xpm|xwd|dig)"     .OR. ;
         Lower( cFile ) LIKE ".+\.(push|wan|waf||afl|mpeg|mpg|mpe|qt|mov)"   .OR. ;
         Lower( cFile ) LIKE ".+\.(viv|vivo|asf|asx|avi|movie|vgm|vgx)"      .OR. ;
         Lower( cFile ) LIKE ".+\.(xdr|vgp|vts|vtts|3dmf|3dm|qd3d|qd3)"      .OR. ;
         Lower( cFile ) LIKE ".+\.(svr|wrl|wrz|vrt)"                       .OR. Empty(cFExt)
         oAttach:SetEncoder( "base64" )
      else
         oAttach:SetEncoder( "7-bit" )
      endif

      cMimeText := HB_SetMimeType( cFile, cFname, cFext )
      // Some EMAIL readers use Content-Type to check for filename

      if ".html" in lower( cFext) .OR. ".htm" in lower( cFext)
         cMimeText += "; charset=ISO-8859-1"
      endif

      oAttach:hHeaders[ "Content-Type" ] := cMimeText
      // But usually, original filename is set here
      oAttach:hHeaders[ "Content-Disposition" ] := "attachment; filename=" + cFname + cFext
      oAttach:SetBody( cData )
      oMail:Attach( oAttach )

   NEXT

   if lRead
      oMail:hHeaders[ "Disposition-Notification-To" ] := cUser
   endif

   if nPriority != 3
      oMail:hHeaders[ "X-Priority" ] := Str( nPriority, 1 )
   endif

//   oInmail:Write( oMail:ToString() )
   cData := oMail:ToString()
   nSize := Len(cData)
   for nCount := 1 to len(cData) step 1024
       aadd(aData, substr( cData,nCount,1024))
   next
   nSent :=0
   for nCount :=1 to len(aData)
      nSent += oInmail:Write( aData[nCount],len(aData[nCount]))
   next
   oInMail:Commit()
   oInMail:Close()

RETURN lReturn

***********************************************
FUNCTION HB_SetMimeType( cFile, cFname, cFext )
***********************************************
cFile := Lower( cFile )
if     cFile LIKE ".+\.vbd"                         ; RETURN "application/activexdocument="+cFname + cFext
elseif cFile LIKE ".+\.(asn|asz|asd)"               ; RETURN "application/astound="+cFname + cFext
elseif cFile LIKE ".+\.pqi"                         ; RETURN "application/cprplayer=" + cFname + cFext
elseif cFile LIKE ".+\.tsp"                         ; RETURN "application/dsptype="+cFname + cFext
elseif cFile LIKE ".+\.exe"                         ; RETURN "application/exe="+cFname + cFext
elseif cFile LIKE ".+\.(sml|ofml)"                  ; RETURN "application/fml="+cFname + cFext
elseif cFile LIKE ".+\.pfr"                         ; RETURN "application/font-tdpfr=" +cFname + cFext
elseif cFile LIKE ".+\.frl"                         ; RETURN "application/freeloader=" +cFname + cFext
elseif cFile LIKE ".+\.spl"                         ; RETURN "application/futuresplash =" + cFname + cFext
elseif cFile LIKE ".+\.gz"                          ; RETURN "application/gzip =" + cFname + cFext
elseif cFile LIKE ".+\.stk"                         ; RETURN "application/hstu =" + cFname + cFext
elseif cFile LIKE ".+\.ips"                         ; RETURN "application/ips="+cFname + cFext
elseif cFile LIKE ".+\.ptlk"                        ; RETURN "application/listenup =" + cFname + cFext
elseif cFile LIKE ".+\.hqx"                         ; RETURN "application/mac-binhex40 =" + cFname + cFext
elseif cFile LIKE ".+\.mbd"                         ; RETURN "application/mbedlet="+cFname + cFext
elseif cFile LIKE ".+\.mfp"                         ; RETURN "application/mirage=" +cFname + cFext
elseif cFile LIKE ".+\.(pot|pps|ppt|ppz)"           ; RETURN "application/mspowerpoint =" + cFname + cFext
elseif cFile LIKE ".+\.doc"                         ; RETURN "application/msword=" +cFname + cFext
elseif cFile LIKE ".+\.n2p"                         ; RETURN "application/n2p="+cFname + cFext
elseif cFile LIKE ".+\.(bin|class|lha|lzh|lzx|dbf)" ; RETURN "application/octet-stream =" + cFname + cFext
elseif cFile LIKE ".+\.oda"                         ; RETURN "application/oda="+cFname + cFext
elseif cFile LIKE ".+\.axs"                         ; RETURN "application/olescript=" + cFname + cFext
elseif cFile LIKE ".+\.zpa"                         ; RETURN "application/pcphoto="+cFname + cFext
elseif cFile LIKE ".+\.pdf"                         ; RETURN "application/pdf="+cFname + cFext
elseif cFile LIKE ".+\.(ai|eps|ps)"                 ; RETURN "application/postscript=" +cFname + cFext
elseif cFile LIKE ".+\.shw"                         ; RETURN "application/presentations=" + cFname + cFext
elseif cFile LIKE ".+\.qrt"                         ; RETURN "application/quest=" + cFname + cFext
elseif cFile LIKE ".+\.rtc"                         ; RETURN "application/rtc="+cFname + cFext
elseif cFile LIKE ".+\.rtf"                         ; RETURN "application/rtf="+cFname + cFext
elseif cFile LIKE ".+\.smp"                         ; RETURN "application/studiom="+cFname + cFext
elseif cFile LIKE ".+\.dst"                         ; RETURN "application/tajima=" +cFname + cFext
elseif cFile LIKE ".+\.talk"                        ; RETURN "application/talker=" +cFname + cFext
elseif cFile LIKE ".+\.tbk"                         ; RETURN "application/toolbook =" + cFname + cFext
elseif cFile LIKE ".+\.vmd"                         ; RETURN "application/vocaltec-media-desc="+cFname + cFext
elseif cFile LIKE ".+\.vmf"                         ; RETURN "application/vocaltec-media-file="+cFname + cFext
elseif cFile LIKE ".+\.wri"                         ; RETURN "application/write=" + cFname + cFext
elseif cFile LIKE ".+\.wid"                         ; RETURN "application/x-DemoShield =" + cFname + cFext
elseif cFile LIKE ".+\.rrf"                         ; RETURN "application/x-InstallFromTheWeb="+cFname + cFext
elseif cFile LIKE ".+\.wis"                         ; RETURN "application/x-InstallShield="+cFname + cFext
elseif cFile LIKE ".+\.ins"                         ; RETURN "application/x-NET-Install=" + cFname + cFext
elseif cFile LIKE ".+\.tmv"                         ; RETURN "application/x-Parable-Thing="+cFname + cFext
elseif cFile LIKE ".+\.arj"                         ; RETURN "application/x-arj=" + cFname + cFext
elseif cFile LIKE ".+\.asp"                         ; RETURN "application/x-asap=" +cFname + cFext
elseif cFile LIKE ".+\.aab"                         ; RETURN "application/x-authorware-bin =" + cFname + cFext
elseif cFile LIKE ".+\.(aam|aas)"                   ; RETURN "application/x-authorware-map =" + cFname + cFext
elseif cFile LIKE ".+\.bcpio"                       ; RETURN "application/x-bcpio="+cFname + cFext
elseif cFile LIKE ".+\.vcd"                         ; RETURN "application/x-cdlink =" + cFname + cFext
elseif cFile LIKE ".+\.chat"                        ; RETURN "application/x-chat=" +cFname + cFext
elseif cFile LIKE ".+\.cnc"                         ; RETURN "application/x-cnc=" + cFname + cFext
elseif cFile LIKE ".+\.(coda|page)"                 ; RETURN "application/x-coda=" +cFname + cFext
elseif cFile LIKE ".+\.z"                           ; RETURN "application/x-compress=" +cFname + cFext
elseif cFile LIKE ".+\.con"                         ; RETURN "application/x-connector="+cFname + cFext
elseif cFile LIKE ".+\.cpio"                        ; RETURN "application/x-cpio=" +cFname + cFext
elseif cFile LIKE ".+\.pqf"                         ; RETURN "application/x-cprplayer="+cFname + cFext
elseif cFile LIKE ".+\.csh"                         ; RETURN "application/x-csh=" + cFname + cFext
elseif cFile LIKE ".+\.(cu|csm)"                    ; RETURN "application/x-cu-seeme=" +cFname + cFext
elseif cFile LIKE ".+\.(dcr|dir|dxr|swa)"           ; RETURN "application/x-director=" +cFname + cFext
elseif cFile LIKE ".+\.dvi"                         ; RETURN "application/x-dvi=" + cFname + cFext
elseif cFile LIKE ".+\.evy"                         ; RETURN "application/x-envoy="+cFname + cFext
elseif cFile LIKE ".+\.ebk"                         ; RETURN "application/x-expandedbook=" +cFname + cFext
elseif cFile LIKE ".+\.gtar"                        ; RETURN "application/x-gtar=" +cFname + cFext
elseif cFile LIKE ".+\.hdf"                         ; RETURN "application/x-hdf=" + cFname + cFext
elseif cFile LIKE ".+\.map"                         ; RETURN "application/x-httpd-imap =" + cFname + cFext
elseif cFile LIKE ".+\.phtml"                       ; RETURN "application/x-httpd-php="+cFname + cFext
elseif cFile LIKE ".+\.php3"                        ; RETURN "application/x-httpd-php3 =" + cFname + cFext
elseif cFile LIKE ".+\.ica"                         ; RETURN "application/x-ica=" + cFname + cFext
elseif cFile LIKE ".+\.ipx"                         ; RETURN "application/x-ipix=" +cFname + cFext
elseif cFile LIKE ".+\.ips"                         ; RETURN "application/x-ipscript=" +cFname + cFext
elseif cFile LIKE ".+\.js"                          ; RETURN "application/x-javascript =" + cFname + cFext
elseif cFile LIKE ".+\.latex"                       ; RETURN "application/x-latex="+cFname + cFext
elseif cFile LIKE ".+\.bin"                         ; RETURN "application/x-macbinary="+cFname + cFext
elseif cFile LIKE ".+\.mif"                         ; RETURN "application/x-mif=" + cFname + cFext
elseif cFile LIKE ".+\.(mpl|mpire)"                 ; RETURN "application/x-mpire="+cFname + cFext
elseif cFile LIKE ".+\.adr"                         ; RETURN "application/x-msaddr =" + cFname + cFext
elseif cFile LIKE ".+\.wlt"                         ; RETURN "application/x-mswallet=" +cFname + cFext
elseif cFile LIKE ".+\.(nc|cdf)"                    ; RETURN "application/x-netcdf =" + cFname + cFext
elseif cFile LIKE ".+\.npx"                         ; RETURN "application/x-netfpx =" + cFname + cFext
elseif cFile LIKE ".+\.nsc"                         ; RETURN "application/x-nschat =" + cFname + cFext
elseif cFile LIKE ".+\.pgp"                         ; RETURN "application/x-pgp-plugin =" + cFname + cFext
elseif cFile LIKE ".+\.css"                         ; RETURN "application/x-pointplus="+cFname + cFext
elseif cFile LIKE ".+\.sh"                          ; RETURN "application/x-sh =" + cFname + cFext
elseif cFile LIKE ".+\.shar"                        ; RETURN "application/x-shar=" +cFname + cFext
elseif cFile LIKE ".+\.swf"                         ; RETURN "application/x-shockwave-flash=" + cFname + cFext
elseif cFile LIKE ".+\.spr"                         ; RETURN "application/x-sprite =" + cFname + cFext
elseif cFile LIKE ".+\.sprite"                      ; RETURN "application/x-sprite =" + cFname + cFext
elseif cFile LIKE ".+\.sit"                         ; RETURN "application/x-stuffit=" + cFname + cFext
elseif cFile LIKE ".+\.sca"                         ; RETURN "application/x-supercard="+cFname + cFext
elseif cFile LIKE ".+\.sv4cpio"                     ; RETURN "application/x-sv4cpio=" + cFname + cFext
elseif cFile LIKE ".+\.sv4crc"                      ; RETURN "application/x-sv4crc =" + cFname + cFext
elseif cFile LIKE ".+\.tar"                         ; RETURN "application/x-tar=" + cFname + cFext
elseif cFile LIKE ".+\.tcl"                         ; RETURN "application/x-tcl=" + cFname + cFext
elseif cFile LIKE ".+\.tex"                         ; RETURN "application/x-tex=" + cFname + cFext
elseif cFile LIKE ".+\.(texinfo|texi)"              ; RETURN "application/x-texinfo=" + cFname + cFext
elseif cFile LIKE ".+\.tlk"                         ; RETURN "application/x-tlk=" + cFname + cFext
elseif cFile LIKE ".+\.(t|tr|roff)"                 ; RETURN "application/x-troff="+cFname + cFext
elseif cFile LIKE ".+\.man"                         ; RETURN "application/x-troff-man="+cFname + cFext
elseif cFile LIKE ".+\.me"                          ; RETURN "application/x-troff-me=" +cFname + cFext
elseif cFile LIKE ".+\.ms"                          ; RETURN "application/x-troff-ms=" +cFname + cFext
elseif cFile LIKE ".+\.alt"                         ; RETURN "application/x-up-alert=" +cFname + cFext
elseif cFile LIKE ".+\.che"                         ; RETURN "application/x-up-cacheop =" + cFname + cFext
elseif cFile LIKE ".+\.ustar"                       ; RETURN "application/x-ustar="+cFname + cFext
elseif cFile LIKE ".+\.src"                         ; RETURN "application/x-wais-source=" + cFname + cFext
elseif cFile LIKE ".+\.xls"                         ; RETURN "application/xls="+cFname + cFext
elseif cFile LIKE ".+\.xlt"                         ; RETURN "application/xlt="+cFname + cFext
elseif cFile LIKE ".+\.zip"                         ; RETURN "application/zip="+cFname + cFext
elseif cFile LIKE ".+\.(au|snd)"                    ; RETURN "audio/basic="+cFname + cFext
elseif cFile LIKE ".+\.es"                          ; RETURN "audio/echospeech =" + cFname + cFext
elseif cFile LIKE ".+\.(gsm|gsd)"                   ; RETURN "audio/gsm=" + cFname + cFext
elseif cFile LIKE ".+\.rmf"                         ; RETURN "audio/rmf=" + cFname + cFext
elseif cFile LIKE ".+\.tsi"                         ; RETURN "audio/tsplayer=" +cFname + cFext
elseif cFile LIKE ".+\.vox"                         ; RETURN "audio/voxware=" + cFname + cFext
elseif cFile LIKE ".+\.wtx"                         ; RETURN "audio/wtx=" + cFname + cFext
elseif cFile LIKE ".+\.(aif|aiff|aifc)"             ; RETURN "audio/x-aiff =" + cFname + cFext
elseif cFile LIKE ".+\.(cht|dus)"                   ; RETURN "audio/x-dspeech="+cFname + cFext
elseif cFile LIKE ".+\.(mid|midi)"                  ; RETURN "audio/x-midi =" + cFname + cFext
elseif cFile LIKE ".+\.mp3"                         ; RETURN "audio/x-mpeg =" + cFname + cFext
elseif cFile LIKE ".+\.mp2"                         ; RETURN "audio/x-mpeg =" + cFname + cFext
elseif cFile LIKE ".+\.m3u"                         ; RETURN "audio/x-mpegurl="+cFname + cFext
elseif cFile LIKE ".+\.(ram|ra)"                    ; RETURN "audio/x-pn-realaudio =" + cFname + cFext
elseif cFile LIKE ".+\.rpm"                         ; RETURN "audio/x-pn-realaudio-plugin="+cFname + cFext
elseif cFile LIKE ".+\.stream"                      ; RETURN "audio/x-qt-stream=" + cFname + cFext
elseif cFile LIKE ".+\.rmf"                         ; RETURN "audio/x-rmf="+cFname + cFext
elseif cFile LIKE ".+\.(vqf|vql)"                   ; RETURN "audio/x-twinvq=" +cFname + cFext
elseif cFile LIKE ".+\.vqe"                         ; RETURN "audio/x-twinvq-plugin=" + cFname + cFext
elseif cFile LIKE ".+\.wav"                         ; RETURN "audio/x-wav="+cFname + cFext
elseif cFile LIKE ".+\.wtx"                         ; RETURN "audio/x-wtx="+cFname + cFext
elseif cFile LIKE ".+\.mol"                         ; RETURN "chemical/x-mdl-molfile=" +cFname + cFext
elseif cFile LIKE ".+\.pdb"                         ; RETURN "chemical/x-pdb=" +cFname + cFext
elseif cFile LIKE ".+\.dwf"                         ; RETURN "drawing/x-dwf=" + cFname + cFext
elseif cFile LIKE ".+\.ivr"                         ; RETURN "i-world/i-vrml=" +cFname + cFext
elseif cFile LIKE ".+\.cod"                         ; RETURN "image/cis-cod=" + cFname + cFext
elseif cFile LIKE ".+\.cpi"                         ; RETURN "image/cpi=" + cFname + cFext
elseif cFile LIKE ".+\.fif"                         ; RETURN "image/fif=" + cFname + cFext
elseif cFile LIKE ".+\.gif"                         ; RETURN "image/gif=" + cFname + cFext
elseif cFile LIKE ".+\.ief"                         ; RETURN "image/ief=" + cFname + cFext
elseif cFile LIKE ".+\.(jpeg|jpg|jpe)"              ; RETURN "image/jpeg=" +cFname + cFext
elseif cFile LIKE ".+\.rip"                         ; RETURN "image/rip=" + cFname + cFext
elseif cFile LIKE ".+\.svh"                         ; RETURN "image/svh=" + cFname + cFext
elseif cFile LIKE ".+\.(tiff|tif)"                  ; RETURN "image/tiff=" +cFname + cFext
elseif cFile LIKE ".+\.mcf"                         ; RETURN "image/vasa=" +cFname + cFext
elseif cFile LIKE ".+\.(svf|dwg|dxf)"               ; RETURN "image/vnd=" + cFname + cFext
elseif cFile LIKE ".+\.wi"                          ; RETURN "image/wavelet=" + cFname + cFext
elseif cFile LIKE ".+\.ras"                         ; RETURN "image/x-cmu-raster=" +cFname + cFext
elseif cFile LIKE ".+\.etf"                         ; RETURN "image/x-etf="+cFname + cFext
elseif cFile LIKE ".+\.fpx"                         ; RETURN "image/x-fpx="+cFname + cFext
elseif cFile LIKE ".+\.(fh5|fh4|fhc)"               ; RETURN "image/x-freehand =" + cFname + cFext
elseif cFile LIKE ".+\.dsf"                         ; RETURN "image/x-mgx-dsf="+cFname + cFext
elseif cFile LIKE ".+\.pnm"                         ; RETURN "image/x-portable-anymap="+cFname + cFext
elseif cFile LIKE ".+\.pbm"                         ; RETURN "image/x-portable-bitmap="+cFname + cFext
elseif cFile LIKE ".+\.pgm"                         ; RETURN "image/x-portable-graymap =" + cFname + cFext
elseif cFile LIKE ".+\.ppm"                         ; RETURN "image/x-portable-pixmap="+cFname + cFext
elseif cFile LIKE ".+\.rgb"                         ; RETURN "image/x-rgb="+cFname + cFext
elseif cFile LIKE ".+\.xbm"                         ; RETURN "image/x-xbitmap="+cFname + cFext
elseif cFile LIKE ".+\.xpm"                         ; RETURN "image/x-xpixmap="+cFname + cFext
elseif cFile LIKE ".+\.xwd"                         ; RETURN "image/x-xwindowdump="+cFname + cFext
elseif cFile LIKE ".+\.dig"                         ; RETURN "multipart/mixed="+cFname + cFext
elseif cFile LIKE ".+\.push"                        ; RETURN "multipart/x-mixed-replace=" + cFname + cFext
elseif cFile LIKE ".+\.(wan|waf)"                   ; RETURN "plugin/wanimate="+cFname + cFext
elseif cFile LIKE ".+\.ccs"                         ; RETURN "text/ccs =" + cFname + cFext
elseif cFile LIKE ".+\.(htm|html)"                  ; RETURN "text/html=" + cFname + cFext
elseif cFile LIKE ".+\.pgr"                         ; RETURN "text/parsnegar-document="+cFname + cFext
elseif cFile LIKE ".+\.txt"                         ; RETURN "text/plain=" +cFname + cFext
elseif cFile LIKE ".+\.rtx"                         ; RETURN "text/richtext=" + cFname + cFext
elseif cFile LIKE ".+\.tsv"                         ; RETURN "text/tab-separated-values=" + cFname + cFext
elseif cFile LIKE ".+\.hdml"                        ; RETURN "text/x-hdml="+cFname + cFext
elseif cFile LIKE ".+\.etx"                         ; RETURN "text/x-setext=" + cFname + cFext
elseif cFile LIKE ".+\.(talk|spc)"                  ; RETURN "text/x-speech=" + cFname + cFext
elseif cFile LIKE ".+\.afl"                         ; RETURN "video/animaflex="+cFname + cFext
elseif cFile LIKE ".+\.(mpeg|mpg|mpe)"              ; RETURN "video/mpeg=" +cFname + cFext
elseif cFile LIKE ".+\.(qt|mov)"                    ; RETURN "video/quicktime="+cFname + cFext
elseif cFile LIKE ".+\.(viv|vivo)"                  ; RETURN "video/vnd.vivo=" +cFname + cFext
elseif cFile LIKE ".+\.(asf|asx)"                   ; RETURN "video/x-ms-asf=" +cFname + cFext
elseif cFile LIKE ".+\.avi"                         ; RETURN "video/x-msvideo="+cFname + cFext
elseif cFile LIKE ".+\.movie"                       ; RETURN "video/x-sgi-movie=" + cFname + cFext
elseif cFile LIKE ".+\.(vgm|vgx|xdr)"               ; RETURN "video/x-videogram=" + cFname + cFext
elseif cFile LIKE ".+\.vgp"                         ; RETURN "video/x-videogram-plugin =" + cFname + cFext
elseif cFile LIKE ".+\.vts"                         ; RETURN "workbook/formulaone="+cFname + cFext
elseif cFile LIKE ".+\.vtts"                        ; RETURN "workbook/formulaone="+cFname + cFext
elseif cFile LIKE ".+\.(3dmf|3dm|qd3d|qd3)"         ; RETURN "x-world/x-3dmf=" +cFname + cFext
elseif cFile LIKE ".+\.svr"                         ; RETURN "x-world/x-svr=" + cFname + cFext
elseif cFile LIKE ".+\.(wrl|wrz)"                   ; RETURN "x-world/x-vrml=" +cFname + cFext
elseif cFile LIKE ".+\.vrt"                         ; RETURN "x-world/x-vrt=" + cFname + cFext
endif

RETURN  "text/plain;filename=" + cFname + cFext

*****************************************
FUNCTION SendSMS(cMensagem,cDDD,cCelular)
*****************************************
LOCAL oUrl
LOCAL oPagina
LOCAL cUrl
LOCAL cPost
LOCAL cBuf

// Parametros da conta no ByJG

LOCAL cUsuario := "sergiosac"
LOCAL cSenha   := "$1nc0n@2012"

cUrl  := "http://www.byjg.com.br/site/webservice.php/ws/sms"
cPost := "?httpmethod=enviarsms"
cPost := cPost + "&ddd=" + cDDD
cPost := cPost + "&celular=" + cCelular
cPost := cPost + "&mensagem=" + cMensagem
cPost := cPost + "&usuario=" + cUsuario
cPost := cPost + "&senha=" + cSenha

oUrl:=TUrl():New( cUrl )
oPagina := TipClientHttp():New( oUrl , .T. )
oPagina:nConnTimeout := 20000

if oPagina:Open( cUrl+cPost )
   cBuf := oPagina:ReadAll()
   mensagem(cBuf)
else
   mensagem("MENSAGEM N"+chr(142)+"O ENVIADA.")
endif

if file("http*.log")
   ferase("http*.log")
endif
   
RETURN NIL

***********************************
function CONFIRMA2(WTEXTO, WTITULO)
***********************************

if MessageBox(, WTEXTO, WTITULO, MB_ICONQUESTION|MB_YESNO ) <> IDYES
   return .f.
endif
   
return .t.

*************************************************
function read_tagxml(WTAG1, WTEXTO, WTAG0, WPAR4) 
*************************************************
WTAGTP1=""
WTAGTP2=""

if pcount()=4
   WTAGTP1=' type="dict"'
   WTAGTP2=' type="str"'
endif

if pcount() = 3
   WPOS = at('<'+WTAG0+WTAGTP1+'>', WTEXTO)+len("<"+WTAG0+WTAGTP1+">")
   WTAM = (at("</"+WTAG0+">", WTEXTO) - WPOS)
   
   WTEXTO = substr(WTEXTO, WPOS, WTAM)
endif

WPOS = at("<"+WTAG1+WTAGTP2+">", WTEXTO)+len("<"+WTAG1+WTAGTP2+">")
WTAM = (at("</"+WTAG1+">", WTEXTO) - WPOS)

if WPOS = 0
   return ""
endif

return substr(WTEXTO, WPOS, WTAM)

***********************
function check_DOC(DOC)
***********************
Local D[12], WCPF, DF1, RESTO, PRIDIG, SEGDIG

if Empty(DOC)
   Return .F.
endif

Afill(D,0)

For I=1 To Len(Alltrim(DOC))-2
    D[I] = Val(Substr(DOC,I,1)) 
Next

if Len(Alltrim(DOC)) > 11
   DF1 = 5*D[1] + 4*D[2] + 3*D[3] + 2*D[4] + 9*D[5] + 8*D[6] + 7*D[7] + 6*D[8] + 5*D[9] + 4*D[10] + 3*D[11] + 2*D[12]
else
   DF1 = 10*D[1] + 9*D[2] + 8*D[3] + 7*D[4] + 6*D[5] + 5*D[6] + 4*D[7] + 3*D[8] + 2*D[9]
endif

RESTO = Mod(DF1,11)

if RESTO = 0 .Or. RESTO = 1
   PRIDIG = 0
else
   PRIDIG = 11 - RESTO
endif

if Len(Alltrim(DOC)) > 11
   DF1 = 6*D[1] + 5*D[2] + 4*D[3] + 3*D[4] + 2*D[5] + 9*D[6] + 8*D[7] + 7*D[8] + 6*D[9] + 5*D[10] + 4*D[11] + 3*D[12] + 2*PRIDIG 
else
   DF1 = 11*D[1] + 10*D[2] + 9*D[3] + 8*D[4] + 7*D[5] + 6*D[6] + 5*D[7] + 4*D[8] + 3*D[9] + 2*PRIDIG 
endif

RESTO = Mod(DF1,11)

if RESTO = 0 .or. RESTO = 1
   SEGDIG = 0
else
   SEGDIG = 11 - RESTO
endif

if PRIDIG <> Val(Substr(DOC,Len(Alltrim(DOC))-1,1)) .Or. SEGDIG <> Val(Substr(DOC,Len(Alltrim(DOC)),1))

   if Len(Alltrim(DOC)) > 11
      MENSAGEM2('Numero de CNPJ invalido!')
   else
      MENSAGEM2('Numero de CPF invalido!')
   endif

   return .t.

endif

return .t.


***************************************************
function BRW_HELP(BRW_TITULO, BRW_SEEK, BRW_CAMPOS)
***************************************************
LOCAL oTBrowse, oTBColumn, WCHAVE
LOCAL bFieldBlock, cFieldName, I, nKey 
LOCAL SC_HELP := savescreen(04,05,21,75)

SOMBRA(05,06,21,75,8)

setcolor(COR_CONS)
@ 04,05 clear to 20,74
@ 05,05 to 19,74 double

@ 04,06 say chr(175) 
@ 07,05 say chr(204)
@ 07,74 say chr(185)

@ 20,06 say "PgDw/PgUp - "+chr(24)+chr(26)+chr(25)+chr(27)+'   '
@ 20,74-len(BRW_TITULO) say BRW_TITULO
setcolor(COR_TEXT)

// create TBrowse object
oTBrowse := TBrowse():new( 06, 06, 18, 73)
oTBrowse:headSep := chr(205)+chr(205)+chr(205)
oTBrowse:colsep:=" "+chr(179)
oTBrowse:colorSpec := COR_CONS+","+COR_TEXT

// add code blocks for navigating the record pointer
oTBrowse:goTopBlock := {|| DbGoTop() }
oTBrowse:goBottomBlock := {|| DbGoBottom() }
oTBrowse:skipBlock := {|nSkip| DbSkipper(nSkip) }

// create TBColumn objects and add them to TBrowse object
for I := 1 to len(BRW_CAMPOS)
   cp_titu:=brw_campos[i,3]
   cp_masc:=brw_campos[i,2]
   cp_:=brw_campos[i,1]
   
   oTBColumn := TBColumn():new(cp_titu,&("{||transform("+cp_+",["+cp_masc+"])}"))
   oTBrowse:addColumn( oTBColumn )
   if len(transform(&cp_.,cp_masc)) > len(cp_titu)
      oTBrowse:getcolumn(i):width := len(transform(&cp_.,cp_masc))
   else
      oTBrowse:getcolumn(i):width := len(cp_titu)
   endif
   oTBrowse:getcolumn(i):colorblock=&("{||{1,2}}")
next

// display browser and process user input 

WCHAVE = ""

do while .t.
   oTBrowse:forceStable()
   
   nKEY := inkey(0)

   if oTBrowse:applyKey( nKEY ) == TBR_EXIT  
      exit
   endif
   
   if nKEY == K_ENTER   
      exit
   endif

   if BRW_SEEK
      if (nKEY >= 32 .and. nKEY <= 254).or. nKEY == 8
         if nKEY == 8 
            if len(WCHAVE) > 1
               WCHAVE = left(WCHAVE,len(WCHAVE)-1) 
            else
               WCHAVE = ""
            endif 
         elseif len(WCHAVE) < 35
            WCHAVE = WCHAVE + chr(nKEY)
         endif

         setcolor(COR_BARRA)
         @ 04,07 clear to 04,74
         @ 04,07 say WCHAVE
         setcolor(COR_TEXT)

         seek upper(WCHAVE)

         oTBrowse:refreshAll()
      endif
   endif
enddo

restscreen(04,05,21,75,SC_HELP)

return .t.

*************************
function view_RELAT(WTXT)
*************************

nDll := DllLoad( "Shell32.dll" ) 
pApi := GetProcAddress( nDll, "ShellExecute" ) 

CallDll( pApi, 0, "open", '"'+WARQRPR+'"', NIL, "", 1 ) 

DllUnload( nDll )

return .t.

********************
Function help_CCUSTO
********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select CUSTO
ordsetfocus("SINC002")

BRW_HELP("CENTROS DE CUSTO",.t., {;
{"CODIGO","999","Codigo"         },;
{"NOME"  ,""   ,"Centro de Custo"}})
 
if lastkey() = 13
   if Valtype(&WVAR) = "N" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

********************
function help_CIDADE
********************
private WAREA := alias()
private WVAR  := readvar()

select CIDADE
ordsetfocus("SINC002")

BRW_HELP("CIDADES",.t., {;
{"CODIGO", "", "Codigo" },;
{"CIDADE", "", "Cidade" },;
{"ESTADO", "", "Estado" },;
{"IBGE"  , "", "IBGE"   }})
                     
if empty(WVAR)
   WCIDADE = CODIGO
else
   &WVAR   = CODIGO
endif

select &WAREA

return .f.

********************
function help_FORNEC
********************
private WAREA := alias()
private WVAR  := readvar()

select FORNEC
ordsetfocus("SINC002")

BRW_HELP("FORNECEDORES",.t., {;
{"CODIGO"  , "999999"        , "Codigo"       },;
{"FORNEC"  , ""              , "Fornecedor"   },;
{"ENDERECO", ""              , "Endereco"     },;
{"BAIRRO"  , ""              , "Bairro"       },;
{"CIDADE"  , ""              , "Cidade"       },;
{"UF"      , ""              , "UF"           },;
{"CEP"     , "@R 99.999-999" , "CEP"          },;
{"TEL"     , ""              , "Telefone"     },;
{"CNPJ"    , "99999999999999", "CNPJ/CPF"     },;
{"INSCEST" , ""              , "Insc.Estadual"}})
                     
if empty(WVAR)
   WCOD_FOR = CODIGO
else
   &WVAR = CODIGO
endif

select &WAREA

return .f.

*****************
function help_GRP
*****************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select GRUPO
ordsetfocus("SINC002")

BRW_HELP("GRUPOS DE PRODUTOS",.t., {;
{"CODIGO","" ,"Codigo" },;
{"GRUPO" ,"" ,"Grupo"  }})
 
if lastkey() == 13
   if Valtype(&WVAR) = "C" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

**********************
function help_PRODUTOS
**********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()


select PRODUTOS
ordsetfocus('SINC002')

BRW_HELP("PRODUTOS",.t., {;
{"CODIGO"                    ,""              ,"Codigo"  },;
{"PRODUTO"                   ,""              ,"Produto" },;
{"UN"                        ,""              ,"UN"      },;
{"((SDANT + AQUIS) - BAIXAS)","99999"         ,"Saldo"   },;
{"CUSTO"                     ,"@R@E 9999.9999","Custo"   }})
 
if lastkey() == 13
   if Valtype(&WVAR) = "C" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .t.

********************
function help_BRINCO
********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select PLANTEL
ordsetfocus("SINC001")

BRW_HELP("PLANTEL",.t., {;
{"BRINCO" ,"99999999" ,"Brinco" },;
{"SEXO"   ,""         ,"Sexo"   },;
{"PELAGEM",""         ,"Pelagem"},;
{"ENTRADA",""         ,"Entrada"}})
 
if lastkey() == 13
   if Valtype(&WVAR) = "C" 
      &WVAR = BRINCO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

******************
function help_RACA
******************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select RACA
ordsetfocus("SINC002")

BRW_HELP("RA"+chr(128)+"AS",.t., {;
{"CODIGO","999","Codigo" },;
{"NOME"  ,""   ,"Ra"+chr(135)+"a"  }})
 
if lastkey() == 13
   if Valtype(&WVAR) = "N" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

******************
function help_LOTE
******************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select LOTE
ordsetfocus("SINC002")

BRW_HELP("LOTES",.t., {;
{"CODIGO","999","Codigo"},;
{"NOME"  ,""   ,"Lote"  }})
 
if lastkey() == 13
   if Valtype(&WVAR) = "N" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

*******************
function help_PASTO
*******************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select PASTO
ordsetfocus("SINC002")

BRW_HELP("PASTOS",.t., {;
{"CODIGO","999","Codigo"},;
{"NOME"  ,""   ,"Pasto" }})
 
if lastkey() == 13
   if Valtype(&WVAR) = "N" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

*********************
function help_PLANTEL
*********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select PLANTEL
ordsetfocus("SINC001")

BRW_HELP("PLANTEL",.t., {;
{"BRINCO"      ,"99999999","Brinco"    },;
{"SEXO"        ,""        ,"Sexo"      },;
{"ret_I(NASC)" ,""        ,"Idade"     },;
{"PELAGEM"     ,""        ,"Pelagem"   },;
{"ret_R(RACA)" ,""        ,"Raca"      },;
{"ret_L(LOTE)" ,""        ,"Lote"      },;
{"ret_P(PASTO)",""        ,"Pasto"     },;
{"BRINCO_MAE"  ,"99999999","Brinco Mae"},;
{"ENTRADA"     ,""        ,"Entrada"   },;
{"SAIDA"       ,""        ,"Saida"     },;
{"MOTIVO"      ,""        ,"Motivo"    }})
 
if lastkey() == 13
   if Valtype(&WVAR) = "C" 
      &WVAR = BRINCO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

**************
function ret_I
**************

WIDADE = round(((DATE() - NASC) / 30),1)

return transform(WIDADE, "@R@E 999.9 meses")

*********************
function ret_R(WRACA)
*********************

select RACA
ordsetfocus("SINC001")
seek WRACA

WNOME = NOME

select PLANTEL

return WNOME 


*********************
function ret_L(WLOTE)
*********************

select LOTE
ordsetfocus("SINC001")
seek WLOTE

WNOME = NOME

select PLANTEL

return WNOME 


**********************
function ret_P(WPASTO)
**********************

select PASTO 
ordsetfocus("SINC001")
seek WPASTO 

WNOME = NOME

select PLANTEL

return WNOME 


********************
function help_VACINA
********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select VACINA
ordsetfocus("SINC002")

BRW_HELP("VACINAS",.t., {;
{"CODIGO"  ,"999"        ,"C"+chr(162)+"digo"},;
{"NOME"    ,""           ,"Vacina"},;
{"FREQUENC","@R 9999dias","Frequ"+chr(136)+"ncia"}})
 
if lastkey() == 13
   if Valtype(&WVAR) = "N" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

*********************
function help_SINTOMA
*********************
private WAREA := alias()
private WVAR  := readvar()
private WCOR  := setcolor()

select SINTOMA
ordsetfocus("SINC002")

BRW_HELP("DOEN"+chr(128)+"AS/SINTOMAS/TRATAMENTOS",.t., {;
{"CODIGO"  ,"999","C"+chr(162)+"digo"},;
{"NOME"    ,""   ,"Decri"+chr(135)+chr(132)+"o"}})
 
if lastkey() == 13
   if Valtype(&WVAR) = "N" 
      &WVAR = CODIGO
   endif
endif

select &WAREA
setcolor(WCOR)

return .f.

********************
function sel_PRINTER
********************
local WBOX     := savescreen(13,40,22,79)
local aPRINTER := GetPrinters()
local WMAX     := len(aPRINTER)
local cCOLOR   := COR_CONS+","+COR_CONS+","+COR_CONS+","+COR_GETS+","+COR_DEST+",N/W,R/B,"+COR_CONS

WIMP = ""
WTAM = 0

declare vPRINTER[WMAX]
afill(vPRINTER,"")

WNI = 0

for I=1 to WMAX

    if ! empty(aPRINTER[I]) .and. aPRINTER[I] <> GetDefaultPrinter()
       vPRINTER[I] = aPRINTER[I] 

       if len(alltrim(aPRINTER[I])) > WTAM
          WTAM = len(alltrim(aPRINTER[I]))
       endif
    
       WNI++

    endif

next

declare aPRN[WNI+1]
afill(aPRN,"")

aPRN[1] = GetDefaultPrinter()
Z       = 2

for I=1 to WNI
    aPRN[Z] = aPRINTER[I]
    Z++
next

SOMBRA(14,80-WTAM,22,79,8)

@ 13,78-WTAM,21,78 get WIMP;
                   LISTBOX aPRN;
                   COLOR cCOLOR
read save
clear gets

restscreen(13,40,22,79,WBOX)

return(WIMP)


***************************
function QUESTION(cMessage)
***************************
aOptions := { "N"+chr(132)+"o", "Sim" } 
 
nChoice := Alert( cMessage, aOptions, , 5) 
 
DO CASE
   CASE nChoice == 0
      WRQ = "N" 
   CASE nChoice == 1
      WRQ = "N"
   CASE nChoice == 2
      WRQ = "S"
ENDCASE 
 
return(WRQ) 

*****************
function isUNIQUE
*****************
parameters WKEY, WFIELD
LOCAL WPRE, WNUM
LOCAL WREG := recno()
LOCAL WERROR := .f.

if empty(&WFIELD)
   if ! reglock()
      if valtype(WKEY) == "C"
         WKEY = ""
      else
         WKEY = 0
      endif
   
      return WKEY
   endif

   replace &WFIELD with WKEY
   
   grava()
endif

if valtype(WKEY) == "C"
   WPRE = left(WKEY,3)
   do while .t.
      seek WKEY

      if recno() == WREG
         exit
      endif

      WERROR = .t.

      MENSAGEM("ATEN"+chr(128)+chr(142)+"O;Falha ao gerar numera"+chr(135)+chr(132)+"o "+chr(163)+"nica para o registro.",0)
      inkey(1)

      seek WPRE+"999999"
      skip -1

      if left(&WFIELD,3) == WPRE
         WKEY = WPRE+strzero((val(right(&WFIELD,6)) + 1),6)
      else
         WKEY = WPRE+"000001"
      endif  
      
      go WREG

      if ! reglock()
         loop
      endif
      
      replace &WFIELD with WKEY
      
      grava()
   enddo
else
   do while .t.
      seek WKEY

      if recno() == WREG
         exit
      endif

      WERROR = .t.

      MENSAGEM("ATEN"+chr(128)+chr(142)+"O;Falha ao gerar numera"+chr(135)+chr(132)+"o "+chr(163)+"nica para o registro.",0)
      inkey(1)

      go bottom

      WKEY = &WFIELD + 1

      go WREG

      if ! reglock()
         loop
      endif

      replace &WFIELD with WKEY
      
      grava()
   enddo
endif   

return(WKEY)


***********************
function win_FORNEC(WP)
***********************
NL = ROW()
CL = COL()

if lastkey() = 27 
   return .t.
endif

if WCOD_FOR = 9999 .and. WP <> 3
   if WP = 2
      @ NL,CL+7 say space(40)
      @ NL,CL+7 say "<AVULSO>"
   else
      @ NL,CL+2 say space(40)
      @ NL,CL+2 say "AVULSO"
   endif
   return .t.
endif

if empty(WCOD_FOR)
   help_FORNEC()
   if lastkey() <> 27
      keyboard chr(13)
   endif
   return .f.
endif

select FORNEC
ordsetfocus("SINC001")
seek WCOD_FOR

if ! found()
   MENSAGEM2("C"+chr(162)+"digo de fornecedor n"+chr(132)+"o cadastrado!")
   return .f.
endif

if WP = 2
   @ NL,CL+7 say space(40)
   @ NL,CL+7 say "<"+alltrim(FORNEC)+">"
elseif WP = 3
   @ 02,19 say space(40)
   @ 02,19 say alltrim(FORNEC)
   WFORNEC = FORNEC 
else
   @ NL,CL+2 say FORNEC
endif

return .t.

