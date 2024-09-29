**Deskriptive Statistik** 

* Daten laden
use "/Users/clarasonnleitner/Documents/Uni/Master/SoSe_2024/Masterarbeit/Code_17.09./lpp_w1w2w3w4.dta", clear 

* Gesamtanzahl der Beschäftigten im Jahr 2018
count if jahr == 2018
gen total_employment = r(N)

* Gesamtanzahl der Frauen in Beschäftigung im Jahr 2018
count if msex == 2 & jahr == 2018
gen women_employment = r(N)

* Gesamtanzahl der Männer in Beschäftigung im Jahr 2018
count if msex == 1 & jahr == 2018
gen men_employment = r(N)


* ---- TEILZEIT ---- *

* Anzahl der Frauen in Teilzeit im Jahr 2018
count if msex == 2 & maz_voll_teil == 2 & jahr == 2018
gen part_time_women = r(N)

* Anzahl der Männer in Teilzeit im Jahr 2018
count if msex == 1 & maz_voll_teil == 2 & jahr == 2018
gen part_time_men = r(N)

* Anzahl der Frauen in Teilzeit in Führungspositionen im Jahr 2018
count if msex == 2 & maz_voll_teil == 2 & mleitung == 1 & jahr == 2018
gen part_time_women_management = r(N)

* Anzahl der Männer in Teilzeit in Führungspositionen im Jahr 2018
count if msex == 1 & maz_voll_teil == 2 & mleitung == 1 & jahr == 2018
gen part_time_men_management = r(N)


* ---- VOLLZEIT ---- *

* Anzahl der Frauen in Vollzeit im Jahr 2018
count if msex == 2 & maz_voll_teil == 1 & jahr == 2018
gen full_time_women = r(N)

* Anzahl der Männer in Vollzeit im Jahr 2018
count if msex == 1 & maz_voll_teil == 1 & jahr == 2018
gen full_time_men = r(N)

* Anzahl der Frauen in Vollzeit in Führungspositionen im Jahr 2018
count if msex == 2 & maz_voll_teil == 1 & mleitung == 1 & jahr == 2018
gen full_time_women_management = r(N)

* Anzahl der Männer in Vollzeit in Führungspositionen im Jahr 2018
count if msex == 1 & maz_voll_teil == 1 & mleitung == 1 & jahr == 2018
gen full_time_men_management = r(N)


* ---- ERGEBNISSE ANZEIGEN ---- *

* Gesamtanzahl der Beschäftigten
display "Gesamtbeschäftigung in 2018: " total_employment

* Teilzeitbeschäftigung
display "Teilzeitbeschäftigte Frauen in 2018: " part_time_women
display "Teilzeitbeschäftigte Männer in 2018: " part_time_men
display "Teilzeitbeschäftigte Frauen in Management in 2018: " part_time_women_management
display "Teilzeitbeschäftigte Männer in Management in 2018: " part_time_men_management

* Vollzeitbeschäftigung
display "Vollzeitbeschäftigte Frauen in 2018: " full_time_women
display "Vollzeitbeschäftigte Männer in 2018: " full_time_men
display "Vollzeitbeschäftigte Frauen in Management in 2018: " full_time_women_management
display "Vollzeitbeschäftigte Männer in Management in 2018: " full_time_men_management


* ---- FÜHRUNG AUFSTIEGE ---- *

* Sortiere die Daten nach pers_id und jahr
sort pers_id jahr

* Erstelle eine Variable, die angibt, ob in einem Jahr keine Führungsposition vorhanden war
by pers_id: gen no_leadership_prev = (mleitung == 2)

* Erstelle eine Variable, die angibt, ob es in einem früheren Jahr keine Führungsposition gab
by pers_id: gen had_no_leadership_before = 0
by pers_id: replace had_no_leadership_before = 1 if sum(no_leadership_prev[_n-1]) > 0

* Falls Duplikate auf pers_id-Ebene vermeiden möchtest, prüfe nur das letzte Jahr jeder pers_id
bysort pers_id (jahr): keep if _n == _N

* Erstelle eine Variable, um Aufstiege zu identifizieren
gen aufstieg = (msex == 2 & mleitung == 1 & had_no_leadership_before == 1)

* Zähle, wie viele pers_id den Aufstieg aufweisen
count if aufstieg == 1

* Zeige die Anzahl der Frauen, die aufgestiegen sind
display "Anzahl der Frauen, die von mleitung 2 auf 1 aufgestiegen sind: " r(N)


* Führungskräfte nach wie viele untergeordnet nach Alter und Geschlecht


* Berechne das Alter basierend auf dem Geburtsjahr
gen alter = 2018 - mgebjahr

* Erstelle Alterskategorien
gen alter_gruppe = .
replace alter_gruppe = 1 if alter < 30
replace alter_gruppe = 2 if alter >= 30 & alter < 40
replace alter_gruppe = 3 if alter >= 40 & alter < 50
replace alter_gruppe = 4 if alter >= 50 & alter < 60
replace alter_gruppe = 5 if alter >= 60

* 1. Anzahl der Personen vorgesetzt und Geschlecht für Männer, nur Leitungsposition = 1 im Jahr 2018
di "--------------------------------------------"
di "Anzahl der Personen vorgesetzt und Geschlecht (Männer) für Leitungsposition = 1 im Jahr 2018"
di "--------------------------------------------"
sum mleitung_anz if mleitung == 1 & msex == 1 & jahr == 2018

* 1a. Anzahl der Personen vorgesetzt für Männer nach Altersgruppen
di "--------------------------------------------"
di "Anzahl der Personen vorgesetzt und Geschlecht (Männer) nach Altersgruppen für Leitungsposition = 1 im Jahr 2018"
di "--------------------------------------------"
tabstat mleitung_anz if mleitung == 1 & msex == 1 & jahr == 2018, by(alter_gruppe) stats(mean sd min max)

* 2. Anzahl der Personen vorgesetzt und Geschlecht für Frauen, nur Leitungsposition = 1 im Jahr 2018
di "--------------------------------------------"
di "Anzahl der Personen vorgesetzt und Geschlecht (Frauen) für Leitungsposition = 1 im Jahr 2018"
di "--------------------------------------------"
sum mleitung_anz if mleitung == 1 & msex == 2 & jahr == 2018

* 2a. Anzahl der Personen vorgesetzt für Frauen nach Altersgruppen
di "--------------------------------------------"
di "Anzahl der Personen vorgesetzt und Geschlecht (Frauen) nach Altersgruppen für Leitungsposition = 1 im Jahr 2018"
di "--------------------------------------------"
tabstat mleitung_anz if mleitung == 1 & msex == 2 & jahr == 2018, by(alter_gruppe) stats(mean sd min max)

* Definiere die Fragen als eine Liste
local fragen mwe_zusatz mwe_befoerd mwe_entwick mwe_inhalte mwe_sicherheit mwe_privat mwe_probleme mwe_fach mwe_umstruk

* Für jede Frage auswerten
foreach frage of local fragen {
    di "--------------------------------------------"
    di "Prozentuale Verteilung für `frage' im Jahr 2018"
    di "--------------------------------------------"
    
    * Alle Männer (msex = 1)
    di "Männer"
    tabulate `frage' if msex == 1 & jahr == 2018

    * Männer nach Altersgruppen
    di "Männer nach Altersgruppen"
    tabulate `frage' alter_gruppe if msex == 1 & jahr == 2018

    * Alle Frauen (msex = 2)
    di "Frauen"
    tabulate `frage' if msex == 2 & jahr == 2018

    * Frauen nach Altersgruppen
    di "Frauen nach Altersgruppen"
    tabulate `frage' alter_gruppe if msex == 2 & jahr == 2018
}
