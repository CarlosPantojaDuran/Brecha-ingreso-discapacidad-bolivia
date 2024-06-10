********************************************************************************
******************************* PAPER ******************************************
********************************************************************************

* ORGANIZACIÓN:		Fundación ARU
* TITULO:			Un analisis del Ingreso Personal de las personas con 
*					discapacidad en Bolivia para el año 2021
* FECHA:			Abril, 2024
* BASE DE DATOS:	Encuestas de Hogares // EH 2021 Persona 
* PASANTE:		Carlos Pantoja

********************************************************************************
********************************************************************************
* BLOQUE 1: LECTURA Y DISEÑO MUESTRAL

* Importacion Base de Datos

	use _in/EH2021_Persona.dta, clear

* Definición del diseño muestral

	svyset upm [pw = factor], strata(estrato) || folio

********************************************************************************
* BLOQUE 2: CREACIÓN DE VARIABLES PARA DESAGREGACIONES

* Crearemos la variable de Discapacidad segun Grupo WS con las preguntas 2 , 3, 4. 

	cap drop d_discap
	gen d_discap=0 
	local letters a b c d e f g
	foreach let in `letters'{
		replace d_discap=1 if inlist(s02a_11`let', 2, 3, 4)
	}
	la def label_d_discap 0  "Sin discapacidad" 1 "Con discapacidad"
	label value d_discap label_d_discap
	tab d_discap
	
	
* Crearemos la variable de Discapacidad segun Grupo WS con las preguntas  3, 4. 

	cap drop d_discap34
	gen d_discap34=0 
	local letters a b c d e f g
	foreach let in `letters'{
		replace d_discap34=1 if inlist(s02a_11`let', 3, 4)
	}
	la var d_discap34 "Discapacidad"
	la def label_d_discap34 0  "Sin discapacidad" 1 "Con discapacidad"
	label value d_discap34 label_d_discap34
	tab d_discap34
	
	
* Crearemos la variable de Discapacidad segun Grupo WS con las preguntas   4. 

	cap drop d_discap2
	gen d_discap2=0 
	local letters a b c d e f g
	foreach let in `letters'{
		replace d_discap2=1 if inlist(s02a_11`let', 2)
	}
	la var d_discap2 "Discapacidad"
	la def label_d_discap2 0  "Sin discapacidad" 1 "Con discapacidad"
	label value d_discap2 label_d_discap2
	tab d_discap2
	
* Ahora vemos cuantas personas son de cada grupo por separado entre el 2 3 4

gen g_discapacidad=0 
replace g_discapacidad=1 if s02a_11a==1 | s02a_11b==1 | s02a_11c==1 | s02a_11d==1 | s02a_11e==1 | s02a_11f==1 | s02a_11g==1
replace g_discapacidad=2 if s02a_11a==2 | s02a_11b==2 | s02a_11c==2 | s02a_11d==2 | s02a_11e==2 | s02a_11f==2 | s02a_11g==2
replace g_discapacidad=3 if s02a_11a==3 | s02a_11b==3 | s02a_11c==3 | s02a_11d==3 | s02a_11e==3 | s02a_11f==3 | s02a_11g==3
replace g_discapacidad=4 if s02a_11a==4 | s02a_11b==4 | s02a_11c==4 | s02a_11d==4 | s02a_11e==4 | s02a_11f==4 | s02a_11g==4



* Ahora necesito la variable segun tipo de discapacidad: 

* Generar la variable categoría
gen categoria = ""

replace categoria = "A. ver, aún con los anteojos o lentes puestos?" if inlist(s02a_11a, 2, 3, 4)
replace categoria = "B. oir, aún cuando utiliza algún dispositivo auditivo?" if inlist(s02a_11b, 2, 3, 4)
replace categoria = "C. caminar o subir gradas?" if inlist(s02a_11c, 2, 3, 4)
replace categoria = "D. aprender, recordar, concentrarse, razonar para desarrollar actividades de la vida diaria?" if inlist(s02a_11d, 2, 3, 4)
replace categoria = "E. autocuidado personal como vestirse, bañarse o comer?" if inlist(s02a_11e, 2, 3, 4)
replace categoria = "F. hablar, comunicarse o conversar, aún cuando utilice lengua de señas u otro medio de comunicación?" if inlist(s02a_11f, 2, 3, 4)
replace categoria = "G. adaptarse, comprender la realidad o tiene alteraciones o trastornos mentales o psíquicos" if inlist(s02a_11g, 2, 3, 4)

tab categoria


	
* Ingreso Laboral: Ahora tenemos las horas trabajadas al mes, de esta forma evitamos el problema de heterogeneidad de esta variable y ser modelada a una misma unidad de tiempo. 

	gen lnylab = ln(ylab)	
	
	gen ylab_hrs= ylab/(tothrs*4.33)
	gen lnylab_hrs=ln(ylab_hrs)
	
	sum ylab tothrs ylab_hrs

	
* La variable escolaridad esta medida en años, considerando el año y el nivel mas alto que el encuestado aprobo a lo que se le suman los años necesarios de los niveles previos. 
	sum aestudio

	tab s03a_02a

	tab niv_ed_g
	
* Tambien tenemos la variable edad y la variable años de experiencia laboral, se considera el dato que el individuo comenzo a trabajar, como una forma de eviatar la multicolinedad entre la escolaridad y la edad 
	
	gen aexperiencia= s01a_03-aestudio-4 if s01a_03>=14 
	replace aexperiencia = . if aexperiencia<0 
	gen aexperiencia2= aexperiencia^2
	
	rename s01a_03 edad
	gen edad2=edad^2
	
	
* Crear una nueva variable para el grupo de edad con etiquetas
egen grupo_edad = cut(edad), at(0(20)100) label
* Etiquetar las categorías de edad
label define grupo_edad_label 0 "0-19" 1 "20-39" 2 "40-59" 3 "60-79" 4 "80 o mas"

* Asignar las etiquetas definidas a la variable grupo_edad
label values grupo_edad grupo_edad_label
label variable grupo_edad "Edad"

* Tabular la variable grupo_edad con las etiquetas
tab grupo_edad

*area

label variable area "Área"

* Usamos la variable declarada genero por los encuestados

	recode s01a_02 (1=0) (2=1), gen (mujer)
	label variable mujer "Género"
	label define label_mujer 0 "Hombre" 1 "Mujer"
	label value mujer label_mujer
	
* Tambien se tiene la variable de sector economico, o actividad economica permanente que realiza. Se agrupan tres sectores, primario, secunario y terciario. 

	// Actividad en la ocupacion principal
	tab caeb_op if d_discap==1
	// Actividad en la ocupacion secundaria
	tab caeb_os if d_discap==1
	// Oficio de la persona encuestada
	rename s04b_12 oficio
	tab oficio 
	
// Por otra lado tambien para la variable estado civil, al encuestado se le consulta su estado civil, y dado que el objetivo es saber si el hecho de estas en una relacion estable o no influye en la decision de participacion en el mercado labraol en el nivel de salarios, se agrupan en dos categorias, casados y solteros. 

	
	recode s01a_10 (2/3=1) (1=0) (4/6=0), gen (pareja)
	label define label_pareja 0 "Sin Pareja" 1 "Con Pareja"
	label value pareja label_pareja
	
	tab pareja

// Finalmente para la variable estabilidad laboral, se le consulta al individuo si esta o no afilido a la seguridad social, ya que poseer un contrato laboral es una condicion necesaria para esta afiliado a la seguridad social


	tab s04f_35 
	rename s04f_35 seg_soc
	
	
// Hijos nacidos vivos 

	rename s02b_18 hijos
	
// Tiene horas trabajadas 
	gen lp=0
	replace lp=1 if lnylab_hrs>=0


********************************************************************************
* BLOQUE 3: ESTADISTICA DESCRIPTIVA

* Grafico 1

	graph bar (count) [pw=factor], over(g_discapacidad) ///
    ytitle("Frecuencia", size(4) margin(medlarge)) ///
    bar(1, color(gs8) lcolor(black) lwidth(none)) /// 
    blabel(bar, format(%9.2f) size(small) position(outside) color(black) align(center)) ///
    bgcolor(white) ///
    graphregion(color(white)) ///
    legend(off) ///
    ylabel(, nogrid labsize(small)) ///
    plotregion(margin(medium))

	graph export "_ghp/g_1.pdf", replace 
	

* Distribucion poblacion con discapacidad 
  
	preserve 
	drop if d_discap==0
	  tabout mujer grupo_edad area categoria [iw=factor] using "_tbl/t_3.tex", ///
	  replace style(tex) font(bold) oneway c(freq col) ///
	  f(0c 1) clab(Count Col_% ) twidth(11) npos(col) ///
	  nlab(Sample) title(Tabla 3: Distribución de personas con discapacidad. Bolivia , 2021) ///
	  fn(Fuente: Elaboración propia a partir de datos de la Encuesta Hogares 2021)
	restore


* Muestra la distribución de la población discapacitada empleada por sectores económicos.

	tab condact
	label define condact_label 1 "Ocupado" 2 "Cesante" 3 "Aspirante" 4 "Inactivo Temporal" 5 "Inactivo Permanente"
	label value condact condact_label

		
	tabout condact oficio d_discap [iw=factor] using "_tbl/t_4.tex", replace style(tex) font(bold) f(0c) ///
	c(freq col) twidth(14) dropr(3:5) show(prepost) ///
	nlab(Obs)  title(Tabla 4: Indicadores sobre inserción laboral de la población de 14 años y más con y sin discapacidad) ///
	fn(Fuente: Elaboración propia a partir de datos de la Encuesta Hogares 2021)
	

* Comparacion del Ingreso Laboral Mensual de las personas con y sin discapacidad.

	tabout  mujer area depto d_discap using ///
	"_tbl/t_5.tex", replace style(tex) font(italic) sum svy ///
	c(mean ylab se) f(2,2) clab(Media_Ingreso_Laboral SE) npor(lab) ///
	twidth(15) title(Tabla 5: Tabla Resumen del Ingreso Laboral de las PSD y PCD) ///
	fn(\textbf{Fuente:} Elaboración propia a partir de datos de la Encuesta Hogares 2021)
	
********************************************************************************
* BLOQUE 4: MODELO ECONOMETRICO 

	egen caeb_op_cat = group(caeb_op), label
	gen caeb_op_nocal=0
	replace caeb_op_nocal = 1 if caeb_op_cat == 1 | ///
								caeb_op_cat == 2 | ///
								caeb_op_cat == 6 | ///
								caeb_op_cat == 7 | ///
								caeb_op_cat == 8 | ///
								caeb_op_cat == 9 | ///
								caeb_op_cat == 12 | ///
								caeb_op_cat == 14 | ///
								caeb_op_cat == 17 | ///
								caeb_op_cat == 18 | ///
								caeb_op_cat == 19 | ///
								caeb_op_cat == 20
							 
	tabout caeb_op_cat d_discap [iw=factor] using "_tbl/t_6.tex", replace style(tex) font(bold) f(0c) ///
	c( col) twidth(14) dropr(3:5) show(prepost) ///
	title(Tabla 6: Condición de Actividad Económica. Bolivia, 2021) ///
	fn(\textbf{Fuente:} Elaboración propia a partir de datos de la Encuesta Hogares 2021)
 
	tab caeb_op_nocal
	
* 4.1 Regresiones MCO

	label variable aestudio "Escolaridad"
	label variable edad2 "Edad al cuadrado"
	label variable edad "Edad"
	label variable seg_soc "Seguro social"
	label define seg_soc_label 1 "Con contrato" 2 "Sin contrato"
	label values seg_soc seg_soc_label

	svy: reg lnylab_hrs  edad  edad2 aestudio i.mujer i.area i.seg_soc if d_discap==0 & caeb_op_nocal==1
	reg lnylab_hrs  edad  edad2 aestudio i.mujer i.area i.seg_soc if d_discap==0 & caeb_op_nocal==1, robust
	eststo MCO1 
	
	svy: reg lnylab_hrs   edad  edad2 aestudio i.mujer i.area i.seg_soc  if d_discap==1 & caeb_op_nocal==1
	reg lnylab_hrs   edad  edad2 aestudio i.mujer i.area i.seg_soc  if d_discap==1 & caeb_op_nocal==1, robust
	eststo MCO2 
	
	esttab MCO1 MCO2 using "_tbl/t_8.tex", replace ///
    b(%9.2f) ///
    mtitles("Sin discapacidad" "Con discapacidad") ///
    title(\textbf{"Regresión para ambos grupos"}) ///
    stats(N r2, labels("Observaciones" "R-cuadrado ajustado")) ///
    alignment(D{.}{,}{-1}) ///
    note(\textbf{Fuente:} Elaboración propia a partir de datos de la Encuesta Hogares 2021)

* 4.2 Descomposición Blinder Oaxaca 

	oaxaca lnylab_hrs   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1, by(d_discap) pooled svy nodetail
	eststo  oaxaca_lnylabhrs

	oaxaca lnylab_hrs aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1 , by(d_discap) pooled svy  eform nodetail
	eststo  oaxaca_lnylabhrs_bs
	
	esttab oaxaca_lnylabhrs oaxaca_lnylabhrs_bs using "_tbl/t_9.tex", replace ///
    label ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("Resultados de la Descomposición Oaxaca en ocupaciones no calificadas") ///
    mtitle("Oaxaca" "Blinder-Oaxaca") ///
    nonotes ///
    compress ///
    booktabs ///
    varwidth(40)


* 4.3 Descomposición Blinder Oaxaca con PCD severa y no severa

	oaxaca lnylab_hrs   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1 , by(d_discap2) pooled svy nodetail
	eststo no_severa
	oaxaca lnylab_hrs   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1, by(d_discap34) pooled svy nodetail
	eststo severa
	
	esttab no_severa severa using "_tbl/t_10.tex", replace ///
    label ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("Resultados de la Descomposición Oaxaca") ///
    mtitle("PSD vs. PCD no severa" " PSD vs. PCD severa") ///
    nonotes ///
    compress ///
    booktabs ///
    varwidth(40)


* 4.4 Emparejamiento de ñopo

	net install nopo, from("https://raw.githubusercontent.com/mhamjediers/nopo_decomposition/main/")
nopo decomp lnylab_hrs aestudio aexperiencia , by(d_discap)









* Anexos

 	oaxaca lnylab   aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1, by(d_discap) pooled svy nodetail
	eststo logaritmo
	
	oaxaca lnylab aestudio aexperiencia aexperiencia2 if caeb_op_nocal==1 , by(d_discap) pooled svy  eform nodetail
	eststo nominal
	
	esttab logaritmo nominal using "_tbl/t_11.tex", replace ///
    label ///
    cells(b(fmt(%9.2f)) se(fmt(%9.2f) star)) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    title("\textbf{Tabla 11: Descomposición Oaxaca con el Ingreso laboral mensual}") ///
    mtitle("Sin discapacidad" " Con discapacidad") ///
    nonotes ///
    compress ///
    booktabs ///
    varwidth(40)
	