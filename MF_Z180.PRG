*********************************************************************
****  Sistema......: SCF-Sistema de Controle Financeiro          ****
****  Versao.......: 1.0                                         ****
****  Programa.....: MF_Z180.PRG                                 ****
****  Finalidade...: Abertura do Banco de Dados                  ****
****                                                             ****
*********************************************************************

*******************
function OPEN_ARQ()
*******************
private AOF, ACDX, TCDX

AGUARDE()

TCDX = 16
ACDX = 0
AOF  = 0

CDX_AUXILIAR()
DBCLOSEALL()  

AGUARDE()

AOF = 0      
DBF_AUXILIAR()

@ 24,00 clear to 24,79

return .t.


*********************
function CDX_AUXILIAR
*********************

*** LOGIN
ACDX++
if ! file("&WDIRE_AUX\LOGIN.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\LOGIN")
   abre(AOF,"&WDIRE_AUX\LOGIN","E","LOGIN")
   index on HB_Decrypt(USUARIO,"$!nc0n@2012") tag SINC001
   index on HB_Decrypt(PERFIL,"$!nc0n@2012")  tag SINC002
   DBCLOSEAREA()
endif

*** ACESSO
ACDX++
if ! file("&WDIRE_AUX\ACESSO.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\ACESSO")
   abre(AOF,"&WDIRE_AUX\ACESSO","E","ACESSO")
   index on HB_Decrypt(USUARIO,"$!nc0n@2012")+HB_Decrypt(ACRI,"$!nc0n@2012") tag SINC001
   DBCLOSEAREA()
endif

*** FERIADO
ACDX++
if ! file("&WDIRE_AUX\FERIADO.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\FERIADO")
   abre(AOF,"&WDIRE_AUX\FERIADO","E")
   index on if(FIXO == "N", strzero(year(DATA),4), "0000")+right(dtos(DATA),4) tag SINC001
   DBCLOSEAREA()    
endif

*** CIDADE
ACDX++
if ! file("&WDIRE_AUX\CIDADE.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\CIDADE")
   ABRE(AOF,"&WDIRE_AUX\CIDADE","E","CIDADE")
   index on upper(CODIGO)     tag SINC001
   index on upper(CIDADE)     tag SINC002
   DBCLOSEAREA()
endif

*** FORNEC
ACDX++
if ! file("&WDIRE_AUX\FORNEC.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\FORNEC")
   abre(AOF,"&WDIRE_AUX\FORNEC","E","FORNEC")
   index on CODIGO            tag SINC001
   index on upper(FORNEC)     tag SINC002
   DBCLOSEAREA()    
endif

*** FAZENDA
ACDX++
if ! File("&WDIRE_AUX\FAZENDA.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\FAZENDA")
   abre(AOF,"&WDIRE_AUX\FAZENDA","E","FAZENDA")
   index on CODIGO            tag SINC001
   index on FAZENDA           tag SINC002
   DBCLOSEAREA()
endif

*** GRUPO
ACDX++
if ! file("&WDIRE_AUX\GRUPO.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\GRUPO")
   abre(AOF,"&WDIRE_AUX\GRUPO","E","GRUPO")
   index on CODIGO            tag SINC001
   index on upper(GRUPO)      tag SINC002
   DBCLOSEAREA()
endif

*** VACINA
ACDX++
if ! file("&WDIRE_AUX\VACINA.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\VACINA")
   abre(AOF,"&WDIRE_AUX\VACINA","E","VACINA")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** SINTOMA.DBF
ACDX++
if ! file("&WDIRE_AUX\SINTOMA.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\SINTOMA")
   abre(AOF,"&WDIRE_AUX\SINTOMA","E","SINTOMA")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** CUSTO
ACDX++
if ! file("&WDIRE_AUX\CUSTO.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\CUSTO")
   abre(AOF,"&WDIRE_AUX\CUSTO","E","CUSTO")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** RACA.DBF
ACDX++
if ! file("&WDIRE_AUX\RACA.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\RACA")
   abre(AOF,"&WDIRE_AUX\RACA","E","RACA")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** CATEG.DBF
ACDX++
if ! file("&WDIRE_AUX\CATEG.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\CATEG")
   abre(AOF,"&WDIRE_AUX\CATEG","E","CATEG")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** GRUPO_P.DBF
ACDX++
if ! file("&WDIRE_AUX\GRUPO_P.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\GRUPO_P")
   abre(AOF,"&WDIRE_AUX\GRUPO_P","E","GRUPO_P")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** SUB_GRP.DBF
ACDX++
if ! file("&WDIRE_AUX\SUB_GRP.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\SUB_GRP")
   abre(AOF,"&WDIRE_AUX\SUB_GRP","E","SUB_GRP")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

*** PENDENC.DBF
ACDX++
if ! file("&WDIRE_AUX\PENDENC.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_AUX\PENDENC")
   abre(AOF,"&WDIRE_AUX\PENDENC","E","PENDENC")
   index on CODIGO            tag SINC001
   index on upper(NOME)       tag SINC002
   DBCLOSEAREA()    
endif

return .t.

*********************
function DBF_AUXILIAR
*********************
abre(AOF,"&WDIRE_AUX\LOGIN"  ,"C","LOGIN")
abre(AOF,"&WDIRE_AUX\ACESSO" ,"C","ACESSO")
abre(AOF,"&WDIRE_AUX\FERIADO","C","FERIADO")
abre(AOF,"&WDIRE_AUX\FORNEC" ,"C","FORNEC")
abre(AOF,"&WDIRE_AUX\CIDADE" ,"C","CIDADE")
abre(AOF,"&WDIRE_AUX\FAZENDA","C","FAZENDA")
abre(AOF,"&WDIRE_AUX\GRUPO"  ,"C","GRUPO")
abre(AOF,"&WDIRE_AUX\VACINA" ,"C","VACINA")
abre(AOF,"&WDIRE_AUX\SINTOMA","C","SINTOMA")
abre(AOF,"&WDIRE_AUX\CUSTO"  ,"C","CUSTO")
abre(AOF,"&WDIRE_AUX\RACA"   ,"C","RACA")
abre(AOF,"&WDIRE_AUX\CATEG"  ,"C","CATEG")
abre(AOF,"&WDIRE_AUX\GRUPO_P","C","GRUPO_P")
abre(AOF,"&WDIRE_AUX\SUB_GRP","C","SUB_GRP")
abre(AOF,"&WDIRE_AUX\PENDENC","C","PENDENC")

return .t.

*************************************
function barraCDX(ACDX, TCDX, ARQCDX)
*************************************
ARQCDX = "Indexando arquivo "+ARQCDX+".dbf"
ARQCDX = left(space(40-(len(ARQCDX)/2))+ARQCDX+space(80),80)

setcolor(COR_BARRA)
for I = 1 to ((80/TCDX)*ACDX)
   @ 24,(I-1) say substr(ARQCDX,I,1)
next

setcolor(COR_TEXT)
for X = I to 80
   @ 24,(X-1) say substr(ARQCDX,X,1)
next

return .t.

