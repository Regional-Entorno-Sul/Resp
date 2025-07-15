Function main()
cls
set color to g+/
set century on
set date to british

@ 1,0 say "-----------------------------------------------------------"
@ 2,0 say "| RESP - versao alfa - 09/07/2025                         |"
@ 3,0 say "| Consolida os dados de virus respiratorio do SIVEP Gripe |"
@ 4,0 say "-----------------------------------------------------------"

cAno := HB_ArgV ( 1 )
cAnoLeft := ""
cAnoRight := ""

if empty( cAno ) = .T.
set color to r+/
? ""
? "Erro! Falta o argumento do ano na linha de comando."
? "Fim do programa."
wait
set color to g+/
quit
endif

cAnoLeft := alltrim( str( val( cAno ) - 1 ) )
cAnoRight := alltrim( str( val( cAno ) + 1 ) )
use "c:\resp\dbf\srag_2023.dbf"

? cAnoLeft
? cAnoRight

do while .not. eof()
replace co_regiona with alltrim( right( dt_notific,4 ) )
skip
enddo
goto top

count to cAnoLeft_x for co_regiona = cAnoLeft
count to cAno_x for co_regiona = cAno
count to cAnoRight_x for co_regiona = cAnoRight

? cAnoLeft_x
? cAno_x
? cAnoRight_x

if ( cAnoLeft_x > cAno_x ) .or. ( cAnoRight_x > cAno_x )
set color to r+/
? ""
? "Erro! Base de dados nao corresponde ao ano do argumento."
? "Fim do programa."
wait
set color to g+/
quit
endif

if cAno_x = 0
set color to r+/
? ""
? "Erro! Base de dados nao corresponde ao ano do argumento."
? "Fim do programa."
wait
set color to g+/
quit
endif

return nil