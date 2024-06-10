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

	
* Ingreso Laboral: Ahora tenemos las horas trabajadas al mes, de esta forma evitamos el problema de heterogeneidad de esta variable y ser modelada a una misma unidad de tiempo. 

	gen lnylab = ln(ylab)	
	
	gen ylab_hrs= ylab/(tothrs*4.33)
	gen lnylab_hrs=ln(ylab_hrs)
	
	
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
	label variable edad2 "Edad al cuadrado"
	label variable edad "Edad"

*area

label variable area "Área"

* Usamos la variable declarada genero por los encuestados

	recode s01a_02 (1=0) (2=1), gen (sexo)
	label variable sexo "Género"
	label define label_sexo 0 "Hombre" 1 "Mujer"
	label value sexo label_sexo
	
* Oficio 

	rename s04b_12 oficio

	
// Por otra lado tambien para la variable estado civil, al encuestado se le consulta su estado civil, y dado que el objetivo es saber si el hecho de estas en una relacion estable o no influye en la decision de participacion en el mercado labraol en el nivel de salarios, se agrupan en dos categorias, casados y solteros. 

	
	recode s01a_10 (2/3=1) (1=0) (4/6=0), gen (pareja)
	label define label_pareja 0 "Sin Pareja" 1 "Con Pareja"
	label value pareja label_pareja

// Finalmente para la variable estabilidad laboral, se le consulta al individuo si esta o no afilido a la seguridad social, ya que poseer un contrato laboral es una condicion necesaria para esta afiliado a la seguridad social

	rename s04f_35 seg_soc
	
	
// Hijos nacidos vivos 

	rename s02b_18 hijos
	
// Tiene horas trabajadas 
	gen lp=0
	replace lp=1 if lnylab_hrs>=0
	
* Generamos trabajo no calificado 

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
	
	label variable caeb_op_nocal "Ocupacion no calificada"
	label variable aestudio "Escolaridad"
	label variable seg_soc "Seguro social"
	label define seg_soc_label 1 "Con contrato" 2 "Sin contrato"
	label values seg_soc seg_soc_label


