********************************************************************************
********************************************************************************
******Example of Analysis of Topics  for Academic Conference Submissions********
**********************Written in STATA 14***************************************
********************************************************************************
********************************************************************************
cd "SET YOUR CD HERE"
use "ConferenceExample", clear //Add 13 to file name if using STATA 13

*************Papers in the conference were written in Spanish, English and Portuguese
*NOTE: I don't speak Spanish or Portuguese
**First run to classify all of the papers using words typical to each language
gen english=0
recode english(0=1) if ustrregexm(ustrlower(abstract), " regarded ")|ustrregexm(ustrlower(abstract), " with ")| /// 
ustrregexm(ustrlower(abstract), " will ")| ///
ustrregexm(ustrlower(abstract), " between ")|ustrregexm(ustrlower(abstract), " during ")| ///
ustrregexm(ustrlower(abstract), " than ")|ustrregexm(ustrlower(abstract), " except ")| ///
ustrregexm(ustrlower(abstract), " very ")|ustrregexm(ustrlower(abstract), " still ")| ///
ustrregexm(ustrlower(abstract), " reading ")|ustrregexm(ustrlower(abstract), " this ")

gen spanish=0 
recode spanish (0=1) if ustrregexm(ustrlower(abstract), " bajo ")|ustrregexm(ustrlower(abstract), " hacia ")| ///
ustrregexm(ustrlower(abstract), " según ")|ustrregexm(ustrlower(abstract), " y ")| ///
ustrregexm(ustrlower(abstract), " hasta ")|ustrregexm(ustrlower(abstract), " en ")| ///
ustrregexm(ustrlower(abstract), " tambi ")|ustrregexm(ustrlower(abstract), " bien ")| ///
ustrregexm(ustrlower(abstract), " una ")|ustrregexm(ustrlower(abstract), " como ")| ///
ustrregexm(ustrlower(abstract), " con ")|ustrregexm(ustrlower(abstract), " este ")| ///
ustrregexm(ustrlower(abstract), " región ")|ustrregexm(ustrlower(abstract), " al ")| ///
ustrregexm(ustrlower(abstract), " estudio ")|ustrregexm(ustrlower(abstract), " es de las ")

gen portuguese=0
recode portuguese (0=1) if ustrregexm(ustrlower(abstract), " esse ")|ustrregexm(ustrlower(abstract), " essas ")| ///
 ustrregexm(ustrlower(abstract), " na frente ")|ustrregexm(ustrlower(abstract), " essas ")| ///
 ustrregexm(ustrlower(abstract), " de baixo ")|ustrregexm(ustrlower(abstract), " em ")| ///
 ustrregexm(ustrlower(abstract), " sim ")|ustrregexm(ustrlower(abstract), " fora ")| ///
 ustrregexm(ustrlower(abstract), " isto ")|ustrregexm(ustrlower(abstract), " pois ")| ///
 ustrregexm(ustrlower(abstract), " estudo ")|ustrregexm(ustrlower(abstract), " vem ")| ///
 ustrregexm(ustrlower(abstract), " governo ")|ustrregexm(ustrlower(abstract), " introduziu ")|ustrregexm(substr(abstract,1,2), "O ")

****confirming that each paper was classified as at least one language
gen noabs=1 if abstract=="" //Marker for papers with no abstract
list abstract if spanish==0&english==0&portuguese==0&noabs==0 //Confirms all papers with abstracts are classified
***************Checking for false positives, i.e. papers in English with only some phrases in Spanish
tab english spanish //17 papers which are classified as both
list abstract if english==1&spanish==1&noab!=1 
*A quick glance shows all papers are English with Spanish phrases, not surprising for a conference on Latin America
*Therefore all can be recoded to just english
recode spanish (1=0) if english==1

tab english portuguese //Only 1 paper which has both English and Portuguese
list abstract if english==1&portuguese==1&noab!=1 
recode portuguese (1=0) if english==1
*Also clearly written in English

*************Checking the same for Portuguese and Spanish
tab spanish portuguese //33 papers which may be either
list abstract if portuguese==1&spanish==1&abstract!=""

**It turns out "O " is a way to start a sentence in portugeuse but not Spanish
recode spanish (1=0) if english==0&portuguese==1&(ustrregexm(substr(abstract,1,2), "O "))
tab spanish portuguese //Still 24 papers classified as both

list abstract if portuguese==1&spanish==1&abstract!=""
* Turns out the ç character is still used in Portuguese but not in Spanish, Let's try some words with that
* Or other words different in the two languages
recode spanish (1=0) if english==0&portuguese==1&((ustrregexm(substr(abstract,1,3), "Em "))| ///
(ustrregexm(substr(abstract,1,5), "Este "))|ustrregexm(abstract, "atuação")|ustrregexm(abstract, "inclusão")| ///
ustrregexm(abstract, "educação")|ustrregexm(abstract, "econômica")|ustrregexm(abstract, "investigação")| ///
ustrregexm(abstract, "produção")|ustrregexm(abstract, "pode")|ustrregexm(abstract, "migração")| ///
ustrregexm(abstract, "condições")|ustrregexm(abstract, "discussões")|ustrregexm(abstract, "uma")| ///
ustrregexm(abstract, "Constituição"))
tab spanish portuguese
list abstract if portuguese==1&spanish==1&abstract!=""
***Have them all

************Checking for misclassifications
*****Looking for Portuguese in Spanish
list abstract if spanish==1&english==0&portuguese==0&noabs==0&(ustrregexm(ustrlower(abstract), " esse ")|ustrregexm(ustrlower(abstract), " essas ")| ///
 ustrregexm(ustrlower(abstract), " na frente ")|ustrregexm(ustrlower(abstract), " essas ")| ///
 ustrregexm(ustrlower(abstract), " de baixo ")|ustrregexm(ustrlower(abstract), " em ")| ///
 ustrregexm(ustrlower(abstract), " sim ")|ustrregexm(ustrlower(abstract), " fora ")| ///
 ustrregexm(ustrlower(abstract), " isto ")|ustrregexm(ustrlower(abstract), " pois ")| ///
 ustrregexm(ustrlower(abstract), " estudo ")|ustrregexm(ustrlower(abstract), " vem ")| ///
 ustrregexm(ustrlower(abstract), " governo ")|ustrregexm(ustrlower(abstract), " introduziu ")|ustrregexm(substr(abstract,1,2), "O "))
*Nothing here

*****Looking for Spanish in Portuguse 
list abstract if spanish==0&english==0&portuguese==1&noabs==0&(ustrregexm(ustrlower(abstract), " bajo ")|ustrregexm(ustrlower(abstract), " hacia ")| ///
ustrregexm(ustrlower(abstract), " según ")|ustrregexm(ustrlower(abstract), " y ")| ///
ustrregexm(ustrlower(abstract), " hasta ")|ustrregexm(ustrlower(abstract), " en ")| ///
ustrregexm(ustrlower(abstract), " tambi ")|ustrregexm(ustrlower(abstract), " bien ")| ///
ustrregexm(ustrlower(abstract), " una ")|ustrregexm(ustrlower(abstract), " como ")| ///
ustrregexm(ustrlower(abstract), " con ")|ustrregexm(ustrlower(abstract), " este ")| ///
ustrregexm(ustrlower(abstract), " región ")|ustrregexm(ustrlower(abstract), " al ")| ///
ustrregexm(ustrlower(abstract), " estudio ")|ustrregexm(ustrlower(abstract), " es de las ")) 
*Nothing here

*****Multinomial variable for language
gen language=0 if noabs==.
recode language (0=1) if spanish==1
recode language (0=2) if portuguese==1
label define language 0 "English" 1 "Spainish" 2 "Portuguese"
label values language language
tab language
graph bar english spanish portuguese
**About even Spanish and English, not many Portuguese

*****Getting at which countries are studied
gen brazil	=0
gen mexico	=0
gen colombia	=0
gen argentina	=0
gen peru	=0
gen venezuela	=0
gen chile	=0
gen ecuador	=0
gen guatemala	=0
gen cuba	=0
gen haiti	=0
gen bolivia	=0
gen dominicanrep =0
gen honduras	=0
gen paraguay	=0
gen nicaragua	=0
gen elsalvador	=0
gen costarica	=0
gen panama	=0
gen uruguay	=0

*********************Coding country names and adjectives in each language
*****English
recode brazil (0=1) if	ustrregexm(ustrlower(abstract), "brazil")|ustrregexm(ustrlower(abstract), "brazilian")
recode mexico (0=1) if	ustrregexm(ustrlower(abstract), "mexico")|ustrregexm(ustrlower(abstract), "mexican")
recode colombia (0=1) if	ustrregexm(ustrlower(abstract), "colombia")|ustrregexm(ustrlower(abstract), "colombian")
recode argentina (0=1) if	ustrregexm(ustrlower(abstract), "argentina")|ustrregexm(ustrlower(abstract), "argentine")
recode peru (0=1) if	ustrregexm(ustrlower(abstract), "peru")|ustrregexm(ustrlower(abstract), "peruvian")
recode venezuela (0=1) if	ustrregexm(ustrlower(abstract), "venezuela")|ustrregexm(ustrlower(abstract), "venezuelan")
recode chile (0=1) if	ustrregexm(ustrlower(abstract), "chile")|ustrregexm(ustrlower(abstract), "chilean")
recode ecuador (0=1) if	ustrregexm(ustrlower(abstract), "ecuador")|ustrregexm(ustrlower(abstract), "ecuadorian")
recode guatemala (0=1) if	ustrregexm(ustrlower(abstract), "guatemala")|ustrregexm(ustrlower(abstract), "guatemalan")
recode cuba (0=1) if	ustrregexm(ustrlower(abstract), "cuba")|ustrregexm(ustrlower(abstract), "cuban")
recode haiti (0=1) if	ustrregexm(ustrlower(abstract), "haiti")|ustrregexm(ustrlower(abstract), "haitian")
recode bolivia (0=1) if	ustrregexm(ustrlower(abstract), "bolivia")|ustrregexm(ustrlower(abstract), "bolivian")
recode dominicanrep (0=1) if	ustrregexm(ustrlower(abstract), "dominican republic")|ustrregexm(ustrlower(abstract), "dominican")
recode honduras (0=1) if	ustrregexm(ustrlower(abstract), "honduras")|ustrregexm(ustrlower(abstract), "honduran")
recode paraguay (0=1) if	ustrregexm(ustrlower(abstract), "paraguay")|ustrregexm(ustrlower(abstract), "paraguayan")
recode nicaragua (0=1) if	ustrregexm(ustrlower(abstract), "nicaragua")|ustrregexm(ustrlower(abstract), "nicaraguan")
recode elsalvador (0=1) if	ustrregexm(ustrlower(abstract), "el salvador")|ustrregexm(ustrlower(abstract), "salvadorian")
recode costarica (0=1) if	ustrregexm(ustrlower(abstract), "costa rica")|ustrregexm(ustrlower(abstract), "costa rican")
recode panama (0=1) if	ustrregexm(ustrlower(abstract), "panama")|ustrregexm(ustrlower(abstract), "panamanian")
recode uruguay (0=1) if	ustrregexm(ustrlower(abstract), "uruguay")|ustrregexm(ustrlower(abstract), "uruguayan")

****Actually this is an easier way recode them
****spanish
local varb="brazil mexico colombia argentina peru venezuela	chile ecuador guatemala	cuba haiti bolivia dominicanrep honduras paraguay nicaragua elsalvador	panama uruguay"
local term="brasil méxico colombia argentina perú venezuela chile ecuador guatemala cuba haití bolivia dominicana honduras paraguay nicaragua salvador Panamá uruguay"
local n : word count `varb'
forvalues i = 1/`n' {
	di `i'
	local a : word `i' of `varb'
	local b : word `i' of `term'
	recode `a'(0=1) if ustrregexm(ustrlower(abstract), "`b'")
}

***********portuguese
local varb="brazil mexico colombia argentina peru venezuela	chile ecuador guatemala	cuba haiti bolivia dominicanrep honduras paraguay nicaragua elsalvador panama uruguay"
local term="brasil méxico colombia argentina Peru venezuela chile equador  guatemala cuba haiti bolivia dominicana honduras paraguai nicarágua salvador panamá uruguai"
local n : word count `varb'
forvalues i = 1/`n' {
	di `i'
	local a : word `i' of `varb'
	local b : word `i' of `term'
	recode `a'(0=1) if ustrregexm(ustrlower(abstract), "`b'")
}

local varb="brazil mexico colombia argentina peru venezuela	chile ecuador guatemala	cuba haiti bolivia dominicanrep honduras paraguay nicaragua elsalvador uruguay panama"
local term="brasileño  mexicano colombiano argentino peruano venezolano chileno ecuatoriano guatemalan cubano haitiano boliviano dominicano hondureña paraguayo nicaragüense salvadoreño uruguayo panameño"
local n : word count `varb'
forvalues i = 1/`n' {
	di `i'
	local a : word `i' of `varb'
	local b : word `i' of `term'
	recode `a'(0=1) if ustrregexm(ustrlower(abstract), "`b'")
}

****How many countries do each paper consider?
gen ccount=0
local varb="brazil mexico colombia argentina peru venezuela	chile ecuador guatemala	cuba haiti bolivia dominicanrep honduras paraguay nicaragua elsalvador	costarica panama uruguay"
foreach y in `varb' {
replace ccount=ccount+`y'
}

sum ccount
hist ccount, discrete
*Mostly 1 country case studies it seems

**********Barchart for countries
foreach i in brazil mexico colombia argentina peru venezuela chile ecuador guatemala cuba haiti bolivia dominicanrep honduras paraguay nicaragua elsalvador costarica panama uruguay{
sum `i'
gen `i'2=floor(r(mean)*799) //Turns indicator variable into count of number of papers
}
graph bar brazil2 mexico2 colombia2 argentina2 peru2 venezuela2 chile2 ecuador2 guatemala2 cuba2 haiti2 bolivia2 dominicanrep2 honduras2 paraguay2 nicaragua2 elsalvador2 costarica2 panama2 uruguay2


*********Number of countries considered by track
encode track, gen(track1)
tab track1, nol
matrix define ncount=([0],[0],[1],[2])
forvalues i= 1/5 {
	tab ccount if track1==`i', matcell(freq)
	scalar zero=freq[1,1]
	scalar one=freq[2,1]
	scalar twom=r(N)-zero-one
	matrix define slice=([`i'],[zero/r(N)],[one/r(N)],[twom/r(N)])
	matrix ncount=(ncount\slice)
}

tab track
matrix list ncount, noheader nonames //Shows the percentage of papers mentioning 0 1 or two or more countries

******Most used words in titles
*renaming country and langauge variables so they don't interfere with usage stats
foreach i in title track abstract sessionsubmissiontitle noabs english spanish portuguese language brazil mexico colombia argentina peru venezuela chile ecuador guatemala cuba haiti bolivia dominicanrep honduras paraguay nicaragua elsalvador panama uruguay costarica ccount brazil2 mexico2 colombia2 argentina2 peru2 venezuela2 chile2 ecuador2 guatemala2 cuba2 haiti2 bolivia2 dominicanrep2 honduras2 paraguay2 nicaragua2 elsalvador2 costarica2 panama2 uruguay2 track1{
rename `i' _`i'
}
***********************Most used words in titles
gen _cell="" //containter for title
global wlist="" //List of words used so far, below list is of common, but uniteresting words, and stata commands that interfere with variable definition
local nonos=" using ira f ay long es double float string que a con ser os ela se na by on su us no its como within por is what uso sus com dos sobre quiero yo ao qué quién between amid how are las can al de la and in of los en el the for as o e y un to desde del una from across with across"
forvalues i=1/799 {
	qui replace _cell=_title[`i'] if _n==1
	qui replace _cell= subinstr(_cell, ".","",.) if _n==1 //Replacing an impressive array of unicode characters used by authors
	qui replace _cell= subinstr(_cell, ",","",.) if _n==1
	qui replace _cell= subinstr(_cell, ":","",.) if _n==1
	qui replace _cell= subinstr(_cell, "?","",.) if _n==1
	qui replace _cell= subinstr(_cell, "¿","",.) if _n==1
	qui replace _cell= subinstr(_cell, `"""',"",.) if _n==1
	qui replace _cell= subinstr(_cell, "!","",.) if _n==1
	qui replace _cell= subinstr(_cell, "“","",.) if _n==1
	qui replace _cell= subinstr(_cell, "(","",.) if _n==1
	qui replace _cell= subinstr(_cell, ")","",.) if _n==1
	qui replace _cell= subinstr(_cell, "”","",.) if _n==1
	qui replace _cell= subinstr(_cell, "“","",.) if _n==1
	qui replace _cell= subinstr(_cell, "-"," ",.) if _n==1
	qui replace _cell= subinstr(_cell, "9","",.) if _n==1
	qui replace _cell= subinstr(_cell, "8","",.) if _n==1
	qui replace _cell= subinstr(_cell, "7","",.) if _n==1
	qui replace _cell= subinstr(_cell, "6","",.) if _n==1
	qui replace _cell= subinstr(_cell, "5","",.) if _n==1
	qui replace _cell= subinstr(_cell, "4","",.) if _n==1
	qui replace _cell= subinstr(_cell, "3","",.) if _n==1
	qui replace _cell= subinstr(_cell, "2","",.) if _n==1
	qui replace _cell= subinstr(_cell, "1","",.) if _n==1
	qui replace _cell= subinstr(_cell, "0","",.) if _n==1
	qui replace _cell= subinstr(_cell, "’s","",.) if _n==1
	qui replace _cell= subinstr(_cell, "'s","",.) if _n==1
	qui replace _cell= subinstr(_cell, "–"," ",.) if _n==1
	qui replace _cell= subinstr(_cell, "'","",.) if _n==1
	qui replace _cell= subinstr(_cell, "‘","",.) if _n==1
	qui replace _cell= subinstr(_cell, "’","",.) if _n==1
	qui replace _cell= subinstr(_cell, "<i>","",.) if _n==1
	qui replace _cell= subinstr(_cell, "</i>","",.) if _n==1
	qui replace _cell= subinstr(_cell, "/"," ",.) if _n==1
	qui replace _cell= subinstr(_cell, "\"," ",.) if _n==1
	qui replace _cell= subinstr(_cell, "´","",.) if _n==1
	qui replace _cell= subinstr(_cell, "&","",.) if _n==1
	qui replace _cell= subinstr(_cell, "¡","",.) if _n==1
	qui replace _cell= subinstr(_cell, "+"," ",.) if _n==1
	qui replace _cell= subinstr(_cell, "-","",.) if _n==1
	qui replace _cell= subinstr(_cell, "*","",.) if _n==1
	qui replace _cell= subinstr(_cell, "$","",.) if _n==1
	qui replace _cell= subinstr(_cell, "+","",.) if _n==1
	qui replace _cell= subinstr(_cell, "#","",.) if _n==1
	qui replace _cell= subinstr(_cell, "%","",.) if _n==1
	qui replace _cell= subinstr(_cell, "^","",.) if _n==1
	qui replace _cell= subinstr(_cell, "@","",.) if _n==1
	qui replace _cell= subinstr(_cell, "~","",.) if _n==1
	qui replace _cell= subinstr(_cell, "[","",.) if _n==1
	qui replace _cell= subinstr(_cell, "]","",.) if _n==1
	qui replace _cell= subinstr(_cell, "{","",.) if _n==1
	qui replace _cell= subinstr(_cell, "}","",.) if _n==1
	qui replace _cell= subinstr(_cell, "«","",.) if _n==1
	qui replace _cell= subinstr(_cell, "»","",.) if _n==1
	qui replace _cell= subinstr(_cell, "<","",.) if _n==1
	qui replace _cell= subinstr(_cell, ">","",.) if _n==1
	qui replace _cell= subinstr(_cell, "¨","",.) if _n==1
	qui replace _cell= subinstr(_cell, "…","",.) if _n==1
	qui replace _cell= subinstr(_cell, ";","",.) if _n==1
 	qui replace _cell= subinstr(_cell, "•","",.) if _n==1
 	qui replace _cell= subinstr(_cell, "‒","",.) if _n==1
 	qui replace _cell= subinstr(_cell, "—","",.) if _n==1
	qui replace _cell= subinstr(_cell, "-­‐","",.) if _n==1
	qui replace _cell= subinstr(_cell, "­‐","",.) if _n==1
	qui replace _cell= subinstr(_cell, "‐","",.) if _n==1
	qui replace _cell= subinstr(_cell, "-­","",.) if _n==1	
	qui replace _cell= ustrlower(_cell) if _n==1
	local text=_cell
	tokenize `text' //Splitting string into words
	while "`*'" != "" {
		if ustrregexm("`nonos'", " `1' ")==0 {
			if ustrregexm("$wlist", " `1' ")==0 {
				capture noisily qui gen `1'=0 if _n==1 //capture noisily lists errors and then continues
				global wlist " $wlist `1' "
			}
			if ustrregexm("$wlist", " `1' ")==1 {
				capture noisily qui replace `1'=`1'+1 if _n==1
			}
		}
		macro shift
	}
di "Observation: `i'"
}

*******Dropping words used less than 5 times
local droplist="" 
foreach i  of global wlist {
	qui sum `i'
	if r(mean)<5{
		local droplist `droplist' `i'
	}
}
drop `droplist'

sum siglo-folklore, separator(0) // Can put table into excel and sort by mean to see most common words

**Most popular non-country words are: social politica america urban	city state latin cultural"
drop siglo-folklore //Droping word counts
***********************Topic areas coding
****Coding some topic areas to check if some topics are more or less commonly together
*******Keywords for topic in each langauge
local politics  =" política political políticas politics político política politicos "     
local rural  =" rural agrarian campestre campesino agrícola aldeão "      
local state  =" state estado estados states "        
local women  =" women mujeres género gender feminista feminist feminism femenina mujer gênero feminismo femenino "
local social  =" social sociales "          
local urban  =" city ciudad urban cidade urbano "       
local development  =" development desarrollo desenvolvimento  "        
local violencewar  =" violence war conflict guerra conflicto violencia violência conflito "    
local education  =" educación education Educação "         
local rights  =" rights derechos direitos "         
local indigin  =" indigenous indígenas indígena "         
local artlit  =" art arte literatura cine literature "       
local culture  =" cultural cultura culture "         
local citizenship  =" identity identidad ciudadanía citizenship identidade cidadania "      


*******Count variable, adds 1 each time a relevant word is mentioned in title or abstract			
foreach i in politics rural state women social urban development violencewar education rights indigin artlit culture citizenship{
	gen `i'2=0
	foreach j of local `i'{
		di "`i':`j'"
		replace `i'2=`i'2+1 if ustrregexm(ustrlower(_title), "`j'")|ustrregexm(ustrlower(_abstract), "`j'") 
	}
}

***Proportion of papers that include each of the below as topic
sum politics2 rural2 state2 women2 social2 urban2 development2 violencewar2 education2 rights2 indigin2 artlit2 culture2 citizenship2, separator(0)

*** Are papers about certain topics more likely to be about certain countries?
foreach i in women rural urban development violencewar education rights indigin artlit culture citizenship {
logit `i'  _brazil _mexico _colombia _argentina _peru _venezuela _chile _ecuador _guatemala _cuba _haiti _bolivia _elsalvador _panama _uruguay _costarica
eststo `i'm
}

esttab womenm ruralm urbanm developmentm violencewarm educationm, p 
***Papers on Columbia are more often about urban urban, development and violence
***Papers on Cuba and Bolivia are less often about urban issues
esttab rightsm indiginm artlitm culturem citizenshipm, p 
****Papers on Brazil and Cuba are more often about culture
****Papers  on Ecuador, Bolivia, and Panama more often concerned with indigenous peoples
***Citizenship more often a concern for papers about Guatamala

*****************Subject Area correlations
**Seeing if some topic areas are more common together
local dv ="state2 social2 politics2 women2 rural2 urban2 development2 violencewar2 education2 rights2 indigin2 artlit2 culture2 citizenship2 "
foreach i of local dv {
	local not `i'
	local ivs: list dv-not
	poisson `i' `ivs'
	eststo `i'm
}

esttab state2m social2m politics2m women2m rural2m urban2m, p 
esttab development2m violencewar2m education2m rights2m, p 
esttab indigin2m artlit2m culture2m citizenship2m, p
***For example, papers about women, are more often also about rights, art and citizenship
***Less often about violence and urban issues


******Labling variables
drop _noabs _cell _est_*
label variable _english "Paper in English" 
label variable _spanish "Paper in Spanish"
label variable _portuguese "Paper in Portuguese"
label variable _language "Categorical Language"
label variable _ccount "Number of Countries in Abstract"
drop _brazil2 _mexico2 _colombia2 _argentina2 _peru2 _venezuela2 _chile2 _ecuador2 _guatemala2 _cuba2 _haiti2 _bolivia2 _dominicanrep2 _honduras2 _paraguay2 _nicaragua2 _elsalvador2 _costarica2 _panama2 _uruguay2
label variable _track1 "Track Encoded"

foreach i in _brazil _mexico _colombia _argentina _peru _venezuela _chile _ecuador _guatemala _cuba _haiti _bolivia _dominicanrep _honduras _paraguay _nicaragua _elsalvador _panama _uruguay _costarica{
label variable `i' "`i' Mentioned in Abstract"
}

foreach i in politics rural state women social urban development violencewar education rights indigin artlit culture citizenship {
label variable `i'2 "`i' Count"
}

***Dataset and report sent off to professor requesting analysis
