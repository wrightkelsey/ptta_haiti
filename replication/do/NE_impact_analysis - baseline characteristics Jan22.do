*********************************************
*	RANDOMIZED INFERENCE IMPACT ANALYSIS OF INPUT SUBSIDIES IN HAITI, GIGNOUX, MACOURS, STEIN & WRIGHT AJAE 2022
*	BALANCING TESTS FOR SAMPLE OF HHs OBSERVED AT FOLLOW-UP
*	first version: Dec 15
*	this version: Jan 22
*	SPECIF WITH GROUP FIXED EFFECTS & LAGOONS AT BASELINE & CLUSTERING AT HABITATION LEVEL
*********************************************


if c(username) == "j.gignoux" {
	cd "/home/j.gignoux/U/Travail/GMSW/analysis/replication"       /*** PATH TO BE MODIFIED ***/
	global workdata="./data"
	global log="./log"
	global results="./results"
}	



use "$workdata/panel_dataset_for_replication.dta", clear


*variables definition and labelling

	lab var HH_literacy_bsl "Head can read or write"

	g HH_nonagroccup_bsl=inlist(HH_occupation_bsl,3,4,5,6,7,8,9,10) if HH_occupation_bsl!=.
	lab var HH_nonagroccup_bsl "Head has non-agricultural occupation"

	lab var d_growrice_bsl "Grows rice"

	recode n_riceplot_bsl .=0 
	lab var n_riceplot_bsl "Nb of plots cultivated with rice"

	lab var t_plot_area_bsl "Area of plots with rice (cond.)"

	lab var t_prod_value_uc_bsl "Rice production value"

	lab var rp_urea_uc_bsl "Used urea on rice plot(s)"

	lab var rp_npk_uc_bsl "Used NPK on rice plot(s)"

	recode rp_pesticide_bsl .=0

	g rp_chfert_uc_bsl=rp_urea_uc_bsl==1& rp_npk_uc_bsl==1
	lab var rp_chfert_uc_bsl "Used both npk and urea on rice"

	g rp_chfert_pest_uc_bsl=rp_urea_uc_bsl==1& rp_npk_uc_bsl==1& rp_pesticide_uc_bsl==1
	lab var rp_chfert_pest_uc_bsl "Used chemical fertilizer and pesticides on rice"

	lab var fert_spending_bsl "Total spending in fertilizer"

	lab var askloan_bank_bsl "Asked for a bank loan in previous year"

	g sevhunger= HungerScale_cat_bsl==3 if  HungerScale_cat_bsl!=.
	lab var sevhunger "Severe hunger"

	lab var months_insecure_bsl "Months food insecure"

	g liveoth_income_bsl=other_income_bsl+livestock_income_bsl

	foreach y in total_income_bsl income_bsl ag_income_bsl other_income_bsl livestock_income_bsl liveoth_income_bsl {
		winsor2 `y', replace cuts(0 98)
	}

	g total2_income_bsl=ag_income_bsl+liveoth_income_bsl+income_bsl
	lab var total2_income_bsl "total hh income (annual)"
	
	lab var ag_income_bsl "total agricultural income"

	lab var income_bsl "non farm income"

	lab var liveoth_income_bsl "income from livestock and sales of charcoal and wood"


*description

	estpost tabstat HH_literacy_bsl HH_nonagroccup_bsl access_water_bsl d_growrice_bsl n_riceplot_bsl t_plot_area_bsl rp_irrigated_bsl /*
		*/ rp_urea_uc_bsl rp_npk_uc_bsl rp_chfert_uc_bsl rp_pesticide_bsl rp_chfert_pest_uc_bsl seed_spending_bsl fert_spending_bsl pest_spending_bsl t_prod_value_uc_bsl askloan_bank_bsl /*
		*/ total2_income_bsl ag_income_bsl liveoth_income_bsl income_bsl sevhunger months_insecure_bsl /*
		*/ , stat(mean sd count) col(stat)
				
	esttab . using "$results/T_baseline_char.tex", main("mean %9.3fc" "mean %9.3fc"  "mean %9.0fc") not nostar unstack nomtitle nonumber nonote noobs label replace style(tex) ///
	stats(N, labels("Observations") fmt(0))  prehead(\begin{tabular}{lcccc}\hline Variable & Mean & s.d.\\)









 
