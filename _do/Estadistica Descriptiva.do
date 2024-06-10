	do _do/Preambulo.do
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
	
							 
	tabout caeb_op_cat d_discap [iw=factor] using "_tbl/t_6.tex", replace style(tex) font(bold) f(0c) ///
	c( col) twidth(14) dropr(3:5) show(prepost) ///
	title(Tabla 6: Condición de Actividad Económica. Bolivia, 2021) ///
	fn(\textbf{Fuente:} Elaboración propia a partir de datos de la Encuesta Hogares 2021)
 
	tab caeb_op_nocal
	
