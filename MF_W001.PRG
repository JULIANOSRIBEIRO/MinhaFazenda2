*********************************************************************
****  Sistema......: SINCON-Sistema Integrado de Controle        ****
****  Programa.....: MF_W001.PRG                                 ****
****  Finalidade...: Visualização HTML/CSS Relatórios            ****
****  Desenvolvedor: Juliano Ribeiro                             ****
****  Versao.......: xHARBOUR                                    ****
*********************************************************************

***********************************************************
function print_ANIMAIS_PASTO(det_PASTO, WTOTAL_M, WTOTAL_F)
***********************************************************

AGUARDE()

WARQRPR = pathWEB+"\animaisPasto_"+strzero(random()%99999,5)+".HTML"

set print to &WARQRPR
set device to print
set console off

setprc(0,0)

@ prow(),0   say '<!DOCTYPE html>'
@ prow()+1,0 say '<html>'
@ prow()+1,0 say '<head>'
@ prow()+1,0 say '    <title>Animais no Pasto</title>'
@ prow()+1,0 say '    <meta charset="UTF-8">'
@ prow()+1,0 say '    <link rel="stylesheet" href="custom.css"</head>'
@ prow()+1,0 say '    <style>'
@ prow()+1,0 say '        tr:hover {'
@ prow()+1,0 say '            background-color: #f5f5f5'
@ prow()+1,0 say '        }'
@ prow()+1,0 say '        div {'
@ prow()+1,0 say '            padding: 10px;'
@ prow()+1,0 say '            border: null;'
@ prow()+1,0 say '        }'
@ prow()+1,0 say '    </style>'
@ prow()+1,0 say '</head>'
@ prow()+1,0 say '<body style="background-color: #fff;">'
@ prow()+1,0 say '    <div style="display:inline-block;vertical-align:top;">'
@ prow()+1,0 say '        <img src="imagem\boi.png" height="140" width="180" alt="Nelore" title="MinhaFazenda" aling="left">'
@ prow()+1,0 say '    </div>'
@ prow()+1,0 say '    <div style="display:inline-block;">'
@ prow()+1,0 say '        <p>'
@ prow()+1,0 say '           <h2>'+alltrim(CFG_FAZ)+'<br>'
@ prow()+1,0 say '               '+alltrim(CFG_CIDADE)+"-"+CFG_UF
@ prow()+1,0 say '           </h2>'
@ prow()+1,0 say '           <h3>Relação de Animais do '+alltrim(det_PASTO)+'</h3>'
@ prow()+1,0 say '        </p>'
@ prow()+1,0 say '    </div>'
@ prow()+1,0 say '    <div class="main">'
@ prow()+1,0 say '        <button class="imprimir" onclick="window.print();">Imprimir</button>'
@ prow()+1,0 say '    </div>'
@ prow()+1,0 say '    <section>'
@ prow()+1,0 say '        <table>'
@ prow()+1,0 say '            <tr>'
@ prow()+1,0 say '                <th class="conteudo">Brinco</th>'
@ prow()+1,0 say '                <th class="conteudo">Sexo</th>'
@ prow()+1,0 say '                <th class="conteudo">Pelagem</th>'
@ prow()+1,0 say '                <th class="conteudo">Idade</th>'
@ prow()+1,0 say '                <th class="conteudo">Raça</th>'
@ prow()+1,0 say '            </tr>'

select TMP
ordsetfocus("SINC001")
go top

do while ! eof()

   @ prow()+1,0 say '            <tr>'  
   @ prow()+1,0 say '                <td class="conteudo">'+alltrim(BRINCO)+'</td>'
   @ prow()+1,0 say '                <td class="conteudo">'+SEXO+'</td>'
   @ prow()+1,0 say '                <td class="conteudo">'+PELAGEM+'</td>'
   @ prow()+1,0 say '                <td class="conteudo">'+IDADE+'</td>'
   @ prow()+1,0 say '                <td class="conteudo">'+RACA+'</td>'
   @ prow()+1,0 say '            </tr>'

   skip +1

enddo

@ prow()+1,0 say '        </table>'
@ prow()+1,0 say '    </section>'

WTOT = str(WTOTAL_M + WTOTAL_F,3)+" | Macho: "+str(WTOTAL_M,3)+" | Fêmea: "+str(WTOTAL_F,3)

@ prow()+1,0 say '    <h4>'
@ prow()+1,0 say '        Total de animais: '+WTOT
@ prow()+1,0 say '    </h4>'
@ prow()+1,0 say '</body>'
@ prow()+1,0 say '</html>'

setprc(0,0)

set print to 
set device to screen
set console on

nDll := DllLoad( "Shell32.dll" ) 
pApi := GetProcAddress( nDll, "ShellExecute" ) 

CallDll( pApi, 0, "open", '"'+WARQRPR+'"', NIL, "", 1 ) 

DllUnload( nDll )

@ 24,00 clear to 27,79

return .t.


************************
function print_DASHBOARD
************************

AGUARDE()

WARQRPR = pathWEB+"\dashboard_"+strzero(random()%99999,5)+".HTML"

set print to &WARQRPR
set device to print
set console off

setprc(0,0)

@ prow(),0   say '<!DOCTYPE html>'
@ prow()+1,0 say '<html>'
@ prow()+1,0 say '<head>'
@ prow()+1,0 say '    <title>Dashboard</title>'
@ prow()+1,0 say '    <meta charset="UTF-8">'
@ prow()+1,0 say '    <link rel="stylesheet" href="custom.css"</head>'

@ prow()+1,0 say '    <style>'
@ prow()+1,0 say '        tr:hover {'
@ prow()+1,0 say '            background-color: #f5f5f5'
@ prow()+1,0 say '        }'
@ prow()+1,0 say '        div {'
@ prow()+1,0 say '            padding: 5px;'
@ prow()+1,0 say '            border: null;'
@ prow()+1,0 say '        }'
@ prow()+1,0 say '    </style>' 
@ prow()+1,0 say '</head>'
@ prow()+1,0 say '<body>'

@ prow()+1,0 say '<body style="background-color: #fff;">'
@ prow()+1,0 say '    <div style="display:inline-block;vertical-align:top;">'
@ prow()+1,0 say '        <img src="imagem\boi.png" height="140" width="180" alt="Nelore" title="MinhaFazenda" aling="left">'
@ prow()+1,0 say '    </div>'
@ prow()+1,0 say '    <div style="display:inline-block;">'
@ prow()+1,0 say '        <p>'
@ prow()+1,0 say '           <h2>'+alltrim(CFG_FAZ)+'<br>'
@ prow()+1,0 say '               '+alltrim(CFG_CIDADE)+"-"+CFG_UF
@ prow()+1,0 say '           </h2>'
@ prow()+1,0 say '        </p>'
@ prow()+1,0 say '    </div>' 

@ prow()+1,0 say '    <div style="display:inline-block;vertical-align:center;">'
@ prow()+1,0 say '        <p>'
@ prow()+1,0 say '           <h2 <span style="font-weight:bold color:#008B8B">D A S H B O A R D</span></h2>'
@ prow()+1,0 say '        </p>'
@ prow()+1,0 say '    </div>' 

@ prow()+1,0 say '    <div class="main">'
@ prow()+1,0 say '        <button class="imprimir" onclick="window.print();">Imprimir</button>'
@ prow()+1,0 say '    </div>'

@ prow()+1,0 say '<style type="text/css">'
@ prow()+1,0 say '.tg  {border-collapse:collapse;border-spacing:0;}'
@ prow()+1,0 say '.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px; overflow:hidden;padding:10px 5px;word-break:normal;}'
@ prow()+1,0 say '.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px; font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}'
@ prow()+1,0 say '.tg .tg-jd0a{background-color:#efefef;border-color:#ffffff; font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif !important;font-weight:bold;text-align:center; vertical-align:top}'
@ prow()+1,0 say '.tg .tg-jd1a{background-color:#efefef;border-color:#ffffff; font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif !important;text-align:center; vertical-align:top}'
@ prow()+1,0 say '.tg .tg-1sar{background-color:#34696d;border-color:#ffffff;color:#ffffff;   font-family:"Lucida Sans Unicode", "Lucida Grande", sans-serif !important;font-size:16px;font-weight:bold; text-align:center;vertical-align:top}'
@ prow()+1,0 say '</style>'

@ prow()+1,0 say '<table class="tg">'

@ prow()+1,0 say '<thead>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <th class="tg-1sar">Faixa Etária</th>'
@ prow()+1,0 say '    <th class="tg-1sar">0 a 2 meses</th>'
@ prow()+1,0 say '    <th class="tg-1sar">3 a 8 meses<br></th>'
@ prow()+1,0 say '    <th class="tg-1sar">9 a 12 meses</th>'
@ prow()+1,0 say '    <th class="tg-1sar">13 a 24 meses</th>'
@ prow()+1,0 say '    <th class="tg-1sar">25 a 36 meses</th>'
@ prow()+1,0 say '    <th class="tg-1sar">+36 meses</th>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '</thead>'

@ prow()+1,0 say '<tbody>'

@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-1sar">Sexo<br></td>'
@ prow()+1,0 say '    <td class="tg-jd0a">M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">M&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;F</td>'
@ prow()+1,0 say '  </tr>'

// vacinados [Macho/Fêmea]

@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-1sar">Vacinados<br></td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT0_2MNV,4)   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT0_2FNV,4)   + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT3_8MNV,4)   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT3_8FNV,4)   + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT9_12MNV,4)  + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT9_12FNV,4)  + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT13_24MNV,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT13_24FNV,4) + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT25_36MNV,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT25_36FNV,4) + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT36_99MNV,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT36_99FNV,4) + '</td>'
@ prow()+1,0 say '  </tr>'

// não vacinados [Macho/Fêmea]

@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-1sar">Não Vacinados<br></td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT0_2MVA,4)   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT0_2FVA,4)   + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT3_8MVA,4)   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT3_8FVA,4)   + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT9_12MVA,4)  + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT9_12FVA,4)  + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT13_24MVA,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT13_24FVA,4) + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT25_36MVA,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT25_36FVA,4) + '</td>'
@ prow()+1,0 say '    <td class="tg-jd1a">' + str(WT36_99MVA,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT36_99FVA,4) + '</td>'
@ prow()+1,0 say '  </tr>'

// sub-total [vacinados + não vacinados]

@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-1sar">Saldo Atual</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">' + str(WT0_2MVA   + WT0_2MNV,4)   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT0_2FVA   + WT0_2FNV,4)   + '</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">' + str(WT3_8MVA   + WT3_8MNV,4)   + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT3_8FVA   + WT3_8FNV,4)   + '</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">' + str(WT9_12MVA  + WT9_12MNV,4)  + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT9_12FVA  + WT9_12FNV,4)  + '</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">' + str(WT13_24MVA + WT13_24MNV,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT13_24FVA + WT13_24FNV,4) + '</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">' + str(WT25_36MVA + WT25_36MNV,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT25_36FVA + WT25_36FNV,4) + '</td>'
@ prow()+1,0 say '    <td class="tg-jd0a">' + str(WT36_99MVA + WT36_99MNV,4) + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + str(WT36_99FVA + WT36_99FNV,4) + '</td>'
@ prow()+1,0 say '  </tr>'

@ prow()+1,0 say '</tbody>'
@ prow()+1,0 say '</table>'

// totais

@ prow()+1,0 say '  <br>'

@ prow()+1,0 say '<table class="tg">'
@ prow()+1,0 say '<thead>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-1sar">Total de Machos: '+transform(WTOT_MACHO,'999999')+'&nbsp;'+transform(WPERC1,'@R@E [999%]')+'</td>'
@ prow()+1,0 say '    <td class="tg-1sar">Total de Fêmeas: '+transform(WTOT_FEMEA,'999999')+'&nbsp;'+transform(WPERC2,'@R@E [999%]')+'</td>'
@ prow()+1,0 say '    <td class="tg-1sar">Total do Plantel:'+transform(WTOTAL,'999999')+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '</thead>'
@ prow()+1,0 say '</table>'
 
@ prow()+1,0 say '  <br>'

@ prow()+1,0 say '<style type="text/css">'
@ prow()+1,0 say '.tg  {border-collapse:collapse;border-spacing:0;}'
@ prow()+1,0 say '.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px; overflow:hidden;padding:8px 5px;word-break:normal;}'
@ prow()+1,0 say '.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px; font-weight:normal;overflow:hidden;padding:8px 5px;word-break:normal;}'
@ prow()+1,0 say '.tg .tg-zv4m{border-color:#ffffff;text-align:left;vertical-align:top}'
@ prow()+1,0 say '.tg .tg-6sub{border-color:#efefef;font-size:18px;text-align:left;vertical-align:top}'
@ prow()+1,0 say '.tg .tg-8jgo{border-color:#ffffff;text-align:center;vertical-align:top}'
@ prow()+1,0 say '.tg .tg-alle{border-color:#efefef;font-size:18px;text-align:right;vertical-align:top}'
@ prow()+1,0 say '.tg .tg-1gxh{border-color:#ffffff;font-size:22px;text-align:center;vertical-align:top}'
@ prow()+1,0 say '.tg .tg-ixxo{border-color:#efefef;font-size:18px;font-weight:bold;text-align:left;vertical-align:top}'
@ prow()+1,0 say '.tg .tg-2kvz{border-color:#efefef;font-size:18px;font-weight:bold;text-align:right;vertical-align:top}'

@ prow()+1,0 say '</style>'
@ prow()+1,0 say '<table class="tg">'
@ prow()+1,0 say '<thead>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <th class="tg-1gxh" colspan="3"><span style="font-weight:bold color:#008B8B">Dados Estatísticos</span></th>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '</thead>'
@ prow()+1,0 say '<tbody>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/nasc.png" viewBox="0 0 512 512"%3e%3cpath fill="%23000000" d="M256 8C119 8 8 119 8 256s111 248 248 248 248-111 248-248S393 8 256 8zm144 276c0 6.6-5.4 12-12 12h-92v92c0 6.6-5.4 12-12 12h-56c-6.6 0-12-5.4-12-12v-92h-92c-6.6 0-12-5.4-12-12v-56c0-6.6 5.4-12 12-12h92v-92c0-6.6 5.4-12 12-12h56c6.6 0 12 5.4 12 12v92h92c6.6 0 12 5.4 12 12v56z"/%3e%3c/svg%3e" alt="Image" width="32" height="32"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">1. Nascimentos ocorridos nos últimos 30 dias</td>'
@ prow()+1,0 say '    <td class="tg-alle">'+str(WTOT_NASC,5)+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/plantel.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M96 464v32c0 8.84 7.16 16 16 16h224c8.84 0 16-7.16 16-16V153.25c4.56-2 8.92-4.35 12.99-7.12l142.05 47.63c8.38 2.81 17.45-1.71 20.26-10.08l10.17-30.34c2.81-8.38-1.71-17.45-10.08-20.26l-128.4-43.05c.42-3.32 1.01-6.6 1.01-10.03 0-44.18-35.82-80-80-80-29.69 0-55.3 16.36-69.11 40.37L132.96.83c-8.38-2.81-17.45 1.71-20.26 10.08l-10.17 30.34c-2.81 8.38 1.71 17.45 10.08 20.26l132 44.26c7.28 21.25 22.96 38.54 43.38 47.47V448H112c-8.84 0-16 7.16-16 16zM0 304c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0C-1.32 295.27.02 287.82.02 304H0zm56-16l72-144 72 144H56zm328.02 144H384c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0-86.38 172.78-85.04 165.33-85.04 181.51zM440 416l72-144 72 144H440z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">2. Número de animais não pesados</td>'
@ prow()+1,0 say '    <td class="tg-alle">'+transform(WTOTAL-WANIMAIS_P,'99999')+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/plantel.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M96 464v32c0 8.84 7.16 16 16 16h224c8.84 0 16-7.16 16-16V153.25c4.56-2 8.92-4.35 12.99-7.12l142.05 47.63c8.38 2.81 17.45-1.71 20.26-10.08l10.17-30.34c2.81-8.38-1.71-17.45-10.08-20.26l-128.4-43.05c.42-3.32 1.01-6.6 1.01-10.03 0-44.18-35.82-80-80-80-29.69 0-55.3 16.36-69.11 40.37L132.96.83c-8.38-2.81-17.45 1.71-20.26 10.08l-10.17 30.34c-2.81 8.38 1.71 17.45 10.08 20.26l132 44.26c7.28 21.25 22.96 38.54 43.38 47.47V448H112c-8.84 0-16 7.16-16 16zM0 304c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0C-1.32 295.27.02 287.82.02 304H0zm56-16l72-144 72 144H56zm328.02 144H384c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0-86.38 172.78-85.04 165.33-85.04 181.51zM440 416l72-144 72 144H440z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">3. Número de animais pesados (1 vez)</td>'
@ prow()+1,0 say '    <td class="tg-alle">'+str(WPESO_ATE1,5)+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/plantel.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M96 464v32c0 8.84 7.16 16 16 16h224c8.84 0 16-7.16 16-16V153.25c4.56-2 8.92-4.35 12.99-7.12l142.05 47.63c8.38 2.81 17.45-1.71 20.26-10.08l10.17-30.34c2.81-8.38-1.71-17.45-10.08-20.26l-128.4-43.05c.42-3.32 1.01-6.6 1.01-10.03 0-44.18-35.82-80-80-80-29.69 0-55.3 16.36-69.11 40.37L132.96.83c-8.38-2.81-17.45 1.71-20.26 10.08l-10.17 30.34c-2.81 8.38 1.71 17.45 10.08 20.26l132 44.26c7.28 21.25 22.96 38.54 43.38 47.47V448H112c-8.84 0-16 7.16-16 16zM0 304c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0C-1.32 295.27.02 287.82.02 304H0zm56-16l72-144 72 144H56zm328.02 144H384c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0-86.38 172.78-85.04 165.33-85.04 181.51zM440 416l72-144 72 144H440z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">4. Número de animais pesados (2 ou + vezes)</td>'
@ prow()+1,0 say '    <td class="tg-alle">'+str(WPESO_MAIS1,5)+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/peso.png"  viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M96 464v32c0 8.84 7.16 16 16 16h224c8.84 0 16-7.16 16-16V153.25c4.56-2 8.92-4.35 12.99-7.12l142.05 47.63c8.38 2.81 17.45-1.71 20.26-10.08l10.17-30.34c2.81-8.38-1.71-17.45-10.08-20.26l-128.4-43.05c.42-3.32 1.01-6.6 1.01-10.03 0-44.18-35.82-80-80-80-29.69 0-55.3 16.36-69.11 40.37L132.96.83c-8.38-2.81-17.45 1.71-20.26 10.08l-10.17 30.34c-2.81 8.38 1.71 17.45 10.08 20.26l132 44.26c7.28 21.25 22.96 38.54 43.38 47.47V448H112c-8.84 0-16 7.16-16 16zM0 304c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0C-1.32 295.27.02 287.82.02 304H0zm56-16l72-144 72 144H56zm328.02 144H384c0 44.18 57.31 80 128 80s128-35.82 128-80h-.02c0-15.67 2.08-7.25-85.05-181.51-17.68-35.36-68.22-35.29-85.87 0-86.38 172.78-85.04 165.33-85.04 181.51zM440 416l72-144 72 144H440z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">5. Peso total ganho nas últimas pesagens</td>'
@ prow()+1,0 say '    <td class="tg-alle">'+transform(WGANHO,"@R@E 999999.9 Kg")+'<br>'+transform(WGANHO/15,"@R@E 9999 Arroba(s)")+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/arroba.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M608 32H32C14.33 32 0 46.33 0 64v384c0 17.67 14.33 32 32 32h576c17.67 0 32-14.33 32-32V64c0-17.67-14.33-32-32-32zM176 327.88V344c0 4.42-3.58 8-8 8h-16c-4.42 0-8-3.58-8-8v-16.29c-11.29-.58-22.27-4.52-31.37-11.35-3.9-2.93-4.1-8.77-.57-12.14l11.75-11.21c2.77-2.64 6.89-2.76 10.13-.73 3.87 2.42 8.26 3.72 12.82 3.72h28.11c6.5 0 11.8-5.92 11.8-13.19 0-5.95-3.61-11.19-8.77-12.73l-45-13.5c-18.59-5.58-31.58-23.42-31.58-43.39 0-24.52 19.05-44.44 42.67-45.07V152c0-4.42 3.58-8 8-8h16c4.42 0 8 3.58 8 8v16.29c11.29.58 22.27 4.51 31.37 11.35 3.9 2.93 4.1 8.77.57 12.14l-11.75 11.21c-2.77 2.64-6.89 2.76-10.13.73-3.87-2.43-8.26-3.72-12.82-3.72h-28.11c-6.5 0-11.8 5.92-11.8 13.19 0 5.95 3.61 11.19 8.77 12.73l45 13.5c18.59 5.58 31.58 23.42 31.58 43.39 0 24.53-19.05 44.44-42.67 45.07zM416 312c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h112c4.42 0 8 3.58 8 8v16zm160 0c0 4.42-3.58 8-8 8h-80c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h80c4.42 0 8 3.58 8 8v16zm0-96c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h272c4.42 0 8 3.58 8 8v16z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">6. Valor atual da arroba em '+dtoc(IND_DATA)+'</td>'
@ prow()+1,0 say '    <td class="tg-alle">R$'+alltrim(transform(IND_ARROBA,"@R@E 999,999,999.99"))+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/custo.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M608 32H32C14.33 32 0 46.33 0 64v384c0 17.67 14.33 32 32 32h576c17.67 0 32-14.33 32-32V64c0-17.67-14.33-32-32-32zM176 327.88V344c0 4.42-3.58 8-8 8h-16c-4.42 0-8-3.58-8-8v-16.29c-11.29-.58-22.27-4.52-31.37-11.35-3.9-2.93-4.1-8.77-.57-12.14l11.75-11.21c2.77-2.64 6.89-2.76 10.13-.73 3.87 2.42 8.26 3.72 12.82 3.72h28.11c6.5 0 11.8-5.92 11.8-13.19 0-5.95-3.61-11.19-8.77-12.73l-45-13.5c-18.59-5.58-31.58-23.42-31.58-43.39 0-24.52 19.05-44.44 42.67-45.07V152c0-4.42 3.58-8 8-8h16c4.42 0 8 3.58 8 8v16.29c11.29.58 22.27 4.51 31.37 11.35 3.9 2.93 4.1 8.77.57 12.14l-11.75 11.21c-2.77 2.64-6.89 2.76-10.13.73-3.87-2.43-8.26-3.72-12.82-3.72h-28.11c-6.5 0-11.8 5.92-11.8 13.19 0 5.95 3.61 11.19 8.77 12.73l45 13.5c18.59 5.58 31.58 23.42 31.58 43.39 0 24.53-19.05 44.44-42.67 45.07zM416 312c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h112c4.42 0 8 3.58 8 8v16zm160 0c0 4.42-3.58 8-8 8h-80c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h80c4.42 0 8 3.58 8 8v16zm0-96c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h272c4.42 0 8 3.58 8 8v16z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">7. Custo total com engorda nos últimos 30 dias</td>'
@ prow()+1,0 say '    <td class="tg-alle">R$'+alltrim(transform(WDESPESA,"@R@E 999,999,999.99"))+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/receita.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M608 32H32C14.33 32 0 46.33 0 64v384c0 17.67 14.33 32 32 32h576c17.67 0 32-14.33 32-32V64c0-17.67-14.33-32-32-32zM176 327.88V344c0 4.42-3.58 8-8 8h-16c-4.42 0-8-3.58-8-8v-16.29c-11.29-.58-22.27-4.52-31.37-11.35-3.9-2.93-4.1-8.77-.57-12.14l11.75-11.21c2.77-2.64 6.89-2.76 10.13-.73 3.87 2.42 8.26 3.72 12.82 3.72h28.11c6.5 0 11.8-5.92 11.8-13.19 0-5.95-3.61-11.19-8.77-12.73l-45-13.5c-18.59-5.58-31.58-23.42-31.58-43.39 0-24.52 19.05-44.44 42.67-45.07V152c0-4.42 3.58-8 8-8h16c4.42 0 8 3.58 8 8v16.29c11.29.58 22.27 4.51 31.37 11.35 3.9 2.93 4.1 8.77.57 12.14l-11.75 11.21c-2.77 2.64-6.89 2.76-10.13.73-3.87-2.43-8.26-3.72-12.82-3.72h-28.11c-6.5 0-11.8 5.92-11.8 13.19 0 5.95 3.61 11.19 8.77 12.73l45 13.5c18.59 5.58 31.58 23.42 31.58 43.39 0 24.53-19.05 44.44-42.67 45.07zM416 312c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h112c4.42 0 8 3.58 8 8v16zm160 0c0 4.42-3.58 8-8 8h-80c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h80c4.42 0 8 3.58 8 8v16zm0-96c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h272c4.42 0 8 3.58 8 8v16z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-6sub">8. Receita Estimada (5x6)</td>'
@ prow()+1,0 say '    <td class="tg-alle">R$'+alltrim(transform(WRECEITA,"@R@E 999,999,999.99"))+'</td>'
@ prow()+1,0 say '  </tr>'
@ prow()+1,0 say '  <tr>'
@ prow()+1,0 say '    <td class="tg-8jgo"><img src="imagem/resultado.png" viewBox="0 0 640 512"%3e%3cpath fill="%23000000" d="M608 32H32C14.33 32 0 46.33 0 64v384c0 17.67 14.33 32 32 32h576c17.67 0 32-14.33 32-32V64c0-17.67-14.33-32-32-32zM176 327.88V344c0 4.42-3.58 8-8 8h-16c-4.42 0-8-3.58-8-8v-16.29c-11.29-.58-22.27-4.52-31.37-11.35-3.9-2.93-4.1-8.77-.57-12.14l11.75-11.21c2.77-2.64 6.89-2.76 10.13-.73 3.87 2.42 8.26 3.72 12.82 3.72h28.11c6.5 0 11.8-5.92 11.8-13.19 0-5.95-3.61-11.19-8.77-12.73l-45-13.5c-18.59-5.58-31.58-23.42-31.58-43.39 0-24.52 19.05-44.44 42.67-45.07V152c0-4.42 3.58-8 8-8h16c4.42 0 8 3.58 8 8v16.29c11.29.58 22.27 4.51 31.37 11.35 3.9 2.93 4.1 8.77.57 12.14l-11.75 11.21c-2.77 2.64-6.89 2.76-10.13.73-3.87-2.43-8.26-3.72-12.82-3.72h-28.11c-6.5 0-11.8 5.92-11.8 13.19 0 5.95 3.61 11.19 8.77 12.73l45 13.5c18.59 5.58 31.58 23.42 31.58 43.39 0 24.53-19.05 44.44-42.67 45.07zM416 312c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h112c4.42 0 8 3.58 8 8v16zm160 0c0 4.42-3.58 8-8 8h-80c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h80c4.42 0 8 3.58 8 8v16zm0-96c0 4.42-3.58 8-8 8H296c-4.42 0-8-3.58-8-8v-16c0-4.42 3.58-8 8-8h272c4.42 0 8 3.58 8 8v16z"/%3e%3c/svg%3e" alt="Image" width="32" height="25"></td>'
@ prow()+1,0 say '    <td class="tg-ixxo">9. Apuração do resultado (8-7)</td>'
@ prow()+1,0 say '    <td class="tg-2kvz">R$'+alltrim(transform(WRECEITA-WDESPESA,"@R@E 999,999,999.99"))+'</td>'
@ prow()+1,0 say '  </tr>'

@ prow()+1,0 say '</tbody>'
@ prow()+1,0 say '</table>'

@ prow()+1,0 say '</body>'
@ prow()+1,0 say '</html>'

setprc(0,0)

set print to 
set device to screen
set console on

nDll := DllLoad( "Shell32.dll" ) 
pApi := GetProcAddress( nDll, "ShellExecute" ) 

CallDll( pApi, 0, "open", '"'+WARQRPR+'"', NIL, "", 1 ) 

DllUnload( nDll )

@ 24,00 clear to 27,79

return .t.
