Function main()
cls
set color to g+/
set century on
set date to british

@ 1,0 say "-----------------------------------------------------------"
@ 2,0 say "| RESP - 1.0 - 11/07/2025                                 |"
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

public file_list := HB_DirScan( "c:\resp\dbf\" )

if len(file_list) > 1
set color to r+/
? ""
? "Erro! Nao pode haver mais de um arquivo no subdiretorio 'dbf'."
? "Fim do programa."
wait
set color to g+/
quit
endif

if len(file_list) = 0
set color to r+/
? ""
? "Erro! Nao ha nenhum arquivo no subdiretorio 'dbf'."
? "Fim do programa."
wait
set color to g+/
quit
endif

if len(file_list) = 1

cExtesion := right( file_list[1,1] , 3)

if cExtesion <> alltrim("dbf")
set color to r+/
? ""
? "Erro! Extensao do arquivo com a base de dados nao e DBF."
? "Fim do programa."
wait
set color to g+/
quit
endif

endif

cFile := "c:\resp\dbf\" + alltrim( file_list[1,1] )
? cFile

cFile1 := cFile
cFile2 := "c:\resp\dbf\srag.dbf"
rename ( cFile1 ) to ( cFile2 )

cAnoLeft := alltrim( str( val( cAno ) - 1 ) )
cAnoRight := alltrim( str( val( cAno ) + 1 ) )
use "c:\resp\dbf\srag.dbf"

do while .not. eof()
replace co_regiona with alltrim( right( dt_notific,4 ) )
skip
enddo
goto top

count to cAnoLeft_x for co_regiona = cAnoLeft
count to cAno_x for co_regiona = cAno
count to cAnoRight_x for co_regiona = cAnoRight

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