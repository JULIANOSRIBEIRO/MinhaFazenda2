*********************************************************************
****  Sistema......: SCF-Sistema de Controle Financeiro          ****
****  Versao.......: 4.0                                         ****
****  Programa.....: MFZ181.PRG                                  ****
****  Finalidade...: Abertura do Banco de Dados da Fazenda       ****
****                                                             ****
*********************************************************************

*********************
function OPEN_ARQ_FAZ
*********************
private AOF, ACDX, TCDX

AGUARDE()

TCDX = 38
AOF  = 0
ACDX = 0

CDX_PRIME()

AGUARDE()

AOF = 0
DBF_PRIME()

@ 24,00 clear to 24,79

return .t.

******************
function CDX_PRIME
******************

*** PESAGEM
ACDX++
if ! file("&WDIRE_FAZ\PESAGEM.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\PESAGEM")
   abre(AOF,"&WDIRE_FAZ\PESAGEM","E","PESAGEM")  
   index on BRINCO+dtos(DATA)+HORA                                  tag SINC001
   index on BRINCO+descend(dtos(DATA))+descend(HORA)                tag SINC002
   index on str(ARQUIVO,8)+BRINCO+descend(dtos(DATA))+descend(HORA) tag SINC003
   index on dtos(DATA)+HORA+BRINCO                                  tag SINC004
   DBCLOSEAREA()
endif

*** PASTO
ACDX++
if ! file("&WDIRE_FAZ\PASTO.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\PASTO")
   abre(AOF,"&WDIRE_FAZ\PASTO","E","PASTO")  
   index on CODIGO                                tag SINC001
   index on upper(NOME)                           tag SINC002
   DBCLOSEAREA()
endif

*** LOTE 
ACDX++
if ! file("&WDIRE_FAZ\LOTE.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\LOTE")
   abre(AOF,"&WDIRE_FAZ\LOTE","E","LOTE")  
   index on CODIGO                                tag SINC001
   index on upper(NOME)                           tag SINC002
   DBCLOSEAREA()
endif

*** PLANTEL
ACDX++
if ! file("&WDIRE_FAZ\PLANTEL.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\PLANTEL")
   abre(AOF,"&WDIRE_FAZ\PLANTEL","E","PLANTEL")  
   index on BRINCO                                tag SINC001
   index on REGISTRO                              tag SINC002
   index on upper(NOME)                           tag SINC003
   index on BRINCO_MAE                            tag SINC004
   index on ENTRADA                               tag SINC005
   index on SAIDA                                 tag SINC006
   DBCLOSEAREA()
endif

*** TROCA_L
ACDX++
if ! file("&WDIRE_FAZ\TROCA_L.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\TROCA_L")
   abre(AOF,"&WDIRE_FAZ\TROCA_L","E","TROCA_L")  
   index on SEQ                                   tag SINC001
   index on BRINCO+descend(dtos(DATA))            tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif

*** TROCA_P
ACDX++
if ! file("&WDIRE_FAZ\TROCA_P.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\TROCA_P")
   abre(AOF,"&WDIRE_FAZ\TROCA_P","E","TROCA_P")  
   index on SEQ                                   tag SINC001
   index on BRINCO+descend(dtos(DATA))            tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif 

*** SAIDA_P
ACDX++
if ! file("&WDIRE_FAZ\SAIDA_P.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\SAIDA_P")
   abre(AOF,"&WDIRE_FAZ\SAIDA_P","E","SAIDA_P")
   index on SEQ                                   tag SINC001
   index on BRINCO+descend(dtos(DATA))            tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif 

*** VACINA_P
ACDX++
if ! file("&WDIRE_FAZ\VACINA_P.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\VACINA_P")
   abre(AOF,"&WDIRE_FAZ\VACINA_P","E","VACINA_P")  
   index on SEQ                                   tag SINC001
   index on BRINCO+descend(dtos(DATA))            tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif

*** ANAMNESE
ACDX++
if ! file("&WDIRE_FAZ\ANAMNESE.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\ANAMNESE")
   abre(AOF,"&WDIRE_FAZ\ANAMNESE","E","ANAMNESE")  
   index on SEQ                                   tag SINC001
   index on BRINCO+descend(dtos(DATA))            tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif

*** PRODUTOS 
ACDX++
if ! file("&WDIRE_FAZ\PRODUTOS.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\PRODUTOS")
   abre(AOF,"&WDIRE_FAZ\PRODUTOS","E")
   index on val(CODIGO)                           tag SINC001
   index on upper(PRODUTO)                        tag SINC002
   index on REF                                   tag SINC003
   index on CODIGO                                tag SINC004
   DBCLOSEAREA()
endif

*** OUTRAS_E 
ACDX++
if ! file("&WDIRE_FAZ\OUTRAS_E.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\OUTRAS_E")
   abre(AOF,"&WDIRE_FAZ\OUTRAS_E","E")
   index on SEQ                                   tag SINC001
   index on DOCNO                                 tag SINC002
   index on ENTRADA                               tag SINC003
   DBCLOSEAREA()
endif

*** ITENS_E
ACDX++
if ! File("&WDIRE_FAZ\ITENS_E.CDX")
   BARRACDX(ACDX,TCDX,"&WDIRE_FAZ\ITENS_E")
   ABRE(AOF,"&WDIRE_FAZ\ITENS_E","E")
   index On SEQ                                   tag SINC001
   DBCLOSEAREA()
endif

*** OUTRAS_S
ACDX++
if ! file("&WDIRE_FAZ\OUTRAS_S.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\OUTRAS_S")
   abre(AOF,"&WDIRE_FAZ\OUTRAS_S","E")
   index on SEQ                                   tag SINC001
   index on DOCNO                                 tag SINC002
   index on SAIDA                                 tag SINC003
   DBCLOSEAREA()
endif

*** ITENS_S 
ACDX++
if ! file("&WDIRE_FAZ\ITENS_S.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\ITENS_S")
   abre(AOF,"&WDIRE_FAZ\ITENS_S","E")
   index on SEQ                                   tag SINC001
   DBCLOSEAREA()
endif

*** BCO_SEM
ACDX++
if ! file("&WDIRE_FAZ\BCO_SEM.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\BCO_SEM")
   abre(AOF,"&WDIRE_FAZ\BCO_SEM","E")
   index on LOTE                                  tag SINC001
   index on DATA                                  tag SINC002
   index on DOADOR+descend(dtos(DATA))            tag SINC003
   DBCLOSEAREA()
endif

*** ENT_BS 
ACDX++
if ! file("&WDIRE_FAZ\ENT_BS.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\ENT_BS")
   abre(AOF,"&WDIRE_FAZ\ENT_BS","E")
   index on SEQ                                   tag SINC001
   index on LOTE                                  tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif

*** SAI_BS 
ACDX++
if ! file("&WDIRE_FAZ\SAI_BS.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\SAI_BS")
   abre(AOF,"&WDIRE_FAZ\SAI_BS","E")
   index on SEQ                                   tag SINC001
   index on LOTE                                  tag SINC002
   index on DATA                                  tag SINC003
   DBCLOSEAREA()
endif

*** REPRODUCAO
ACDX++
if ! file("&WDIRE_FAZ\REPRODUCAO.CDX")
   barraCDX(ACDX,TCDX,"&WDIRE_FAZ\REPRODUCAO")
   abre(AOF,"&WDIRE_FAZ\REPRODUCAO","E")
   index on SEQ                                   tag SINC001
   index on DATA                                  tag SINC002
   index on BRINCO+descend(dtos(DATA))            tag SINC003
   index on CN_TOURO                              tag SINC004
   index on IA_LOTE                               tag SINC005
   index on TE_TOURO                              tag SINC006
   DBCLOSEAREA()
endif

return .f.


******************
function DBF_PRIME
******************

abre(AOF,"&WDIRE_FAZ\PESAGEM"   ,"C","PESAGEM")
abre(AOF,"&WDIRE_FAZ\PASTO"     ,"C","PASTO")
abre(AOF,"&WDIRE_FAZ\LOTE"      ,"C","LOTE")
abre(AOF,"&WDIRE_FAZ\PLANTEL"   ,"C","PLANTEL")
  
abre(AOF,"&WDIRE_FAZ\TROCA_L"   ,"C","TROCA_L")
abre(AOF,"&WDIRE_FAZ\TROCA_P"   ,"C","TROCA_P")
abre(AOF,"&WDIRE_FAZ\SAIDA_P"   ,"C","SAIDA_P")
abre(AOF,"&WDIRE_FAZ\VACINA_P"  ,"C","VACINA_P")
abre(AOF,"&WDIRE_FAZ\ANAMNESE"  ,"C","ANAMNESE")
  
abre(AOF,"&WDIRE_FAZ\PRODUTOS"  ,"C","PRODUTOS")
abre(AOF,"&WDIRE_FAZ\OUTRAS_E"  ,"C","OUTRAS_E")
abre(AOF,"&WDIRE_FAZ\ITENS_E"   ,"C","ITENS_E")
abre(AOF,"&WDIRE_FAZ\OUTRAS_S"  ,"C","OUTRAS_S")
abre(AOF,"&WDIRE_FAZ\ITENS_S"   ,"C","ITENS_S")

abre(AOF,"&WDIRE_FAZ\BCO_SEM"   ,"C","BCO_SEM")
abre(AOF,"&WDIRE_FAZ\ENT_BS"    ,"C","ENT_BS")
abre(AOF,"&WDIRE_FAZ\SAI_BS"    ,"C","SAI_BS")
abre(AOF,"&WDIRE_FAZ\REPRODUCAO","C","REPRODUCAO")

return .t.


**********************
function FECHA_ARQ_FAZ
**********************

CLOSE PESAGEM
CLOSE PASTO
CLOSE LOTE
CLOSE PLANTEL
CLOSE TROCA_L
CLOSE TROCA_P
CLOSE SAIDA_P
CLOSE VACINA_P
CLOSE ANAMNESE
CLOSE PRODUTOS
CLOSE OUTRAS_E
CLOSE ITENS_E
CLOSE OUTRAS_S
CLOSE ITENS_S

return .t.

