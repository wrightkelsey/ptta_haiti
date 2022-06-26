*********************************************
*	RANDOMIZED INFERENCE IMPACT ANALYSIS OF INPUT SUBSIDIES IN HAITI, GIGNOUX, MACOURS, STEIN & WRIGHT AJAE 2022
*	BALANCING TESTS FOR SAMPLE OF HHs OBSERVED AT FOLLOW-UP
*	first version: Dec 15
*	this version: Jan 22
*	SPECIF WITH GROUP FIXED EFFECTS & LAGOONS AT BASELINE & CLUSTERING AT HABITATION LEVEL
*********************************************


clear
clear mata
clear matrix
pause off
set more off
set maxvar 20000
set matsize 3000 
global user 0 



	

if c(username) == "wrigh" {
	global root "D:\ptta_haiti\replication"       /*** PATH TO BE MODIFIED ***/
	global workdata="D:\Dropbox\Haiti\GAFSP Haiti\submission\final version\replication\data"
	global notreleased="D:\Dropbox\Haiti\GAFSP Haiti\submission\final version\data do not include\data_hasPII_donotinclude"
	global log="${root}\log"
	global results="${root}/results"
}	


* data
	use "$workdata/panel_dataset_for_replication.dta", clear 
	
	/* info on location of input suppliers */
	
	drop _merge
	merge n:1 nsm using "$notreleased/distances from households.dta"
	drop _merge
	g d_town=min(d_FL, d_Ferrier, d_Ouanaminthe)
	 

* note: in dataset constr do-file, we construct unconditional variables for agr production (originally missing for non-producers) *

* define variables tested for balancing: define macros 

*** 1. Income 
	local income ///
	total_income_bsl income_bsl ag_income_bsl other_income_bsl livestock_income_bsl 
	
	local income_l "Household income (USD)" 
	
	
	g liveoth_income_bsl=other_income_bsl+livestock_income_bsl
	g total2_income_bsl=income_bsl+ag_income_bsl+liveoth_income_bsl

	foreach y in total_income_bsl income_bsl ag_income_bsl other_income_bsl livestock_income_bsl liveoth_income_bsl {
		winsor2 `y', replace cuts(0 98)
	}

	lab var total2_income_bsl "total hh income (annual)"
	lab var ag_income_bsl "total agricultural income"
	lab var income_bsl "non farm income"
	lab var liveoth_income_bsl "income from livestock and sales of charcoal and wood"


	label variable total_income_bsl "Total income"
	label variable income_bsl "Income from primary occupation (excl. own farm)" 
	label variable ag_income_bsl "Income from (own-farm) agricultural sales" 
	label variable other_income_bsl "Income from charcoal and wood sales" 
	label variable livestock_income_bsl "Income from livestock"

	local income_sel ///
	total2_income_bsl ag_income_bsl
	
	
	
*** 2. General land use 

	
	local landuse ///
		n_allPlot_bsl n_culPlot_bsl t_sizeculPlot_bsl
	local landuse_l "General land use" 
	
	label variable n_allPlot_bsl "Total number of plots (owned or cultivated)" 
	label variable n_culPlot_bsl "Total number of plots cultivated"
	label variable t_sizeculPlot_bsl "Total area cultivated (ha)"

	local landuse_sel ///
	n_allPlot_bsl n_culPlot_bsl t_sizeculPlot_bsl
	

*** 3. Rice cultivation 
		
	local landuse_rice ///
	d_growrice_bsl n_riceplot_uc_bsl t_plot_area_uc_bsl /// 
	n_instXplot1_uc_bsl harv_any_hh_bsl  harv_notyet_hh_bsl harv_partial_hh_bsl harv_lost_hh_bsl hh_loss_pest_uc_bsl ///
	fstMonth13_bsl
	local landuse_rice_l "Rice cultivation" 
	
	label variable d_growrice_bsl  "Planted rice during period"
	label variable n_riceplot_uc_bsl "Number of rice plots" 
	label variable t_plot_area_uc_bsl "Total area of rice plots (ha)" 
	label variable n_instXplot1_uc_bsl "Number of rice plantings (seasons by plot)" 
	label variable harv_any_hh_bsl "Harvested rice at least once" 
	label variable harv_notyet_hh_bsl "Has at least one harvest still in the field" 
	label variable harv_partial_hh_bsl "Has at least one harvest in progress" 
	label variable harv_lost_hh_bsl "Lost at least one harvest" 
	label variable hh_loss_pest_uc_bsl "Lost part of harvest due to pests" 
	*label variable fstMonth13_bsl "First month planted in 2013" 

	local landuse_rice_sel ///
	d_growrice_bsl n_riceplot_uc_bsl t_plot_area_uc_bsl harv_any_hh_bsl harv_lost_hh_bsl fstMonth13_bsl


*** 3a. Other crops

	local other_crops /// 
	other_harvest_value_bsl other_sale_value_bsl
	local other_crops_l "Other crops" 
	
	label variable other_harvest_value_bsl "Other crops production (USD)" 
	label variable other_sale_value_bsl "Other crops sales(USD)" 
	
	local other_crops_sel ///
	other_harvest_value_bsl other_sale_value_bsl
	
	*not included: d_plant13_bsl fstMonth13_uc_bsl  t_plot_areaFIN_uc_bsl t_plot_area_byinst1_uc_bsl t_plot_area_byFINinst1_uc_bsl
	*note that in baseline, instance area = plot area, and can't distinguish between Yield _1 and _2 (whether count second harvest with same seeds as a second instance or added up) 
	
*** 3. Rice productivity: Everyone
	local yield_1 ///
	t_harvest_std_kg_uc_bsl ///
	HH_riceHaYear_uc_bsl ///
	t_plotRiceYield1_uc_bsl  ///
	t_prod_value_uc_bsl  ///
	HH_valueHaYear_uc_bsl ///
	profit_1_uc_bsl  ///
	h_sold_rice_uc_bsl ///
	t_sale_std_kg_uc_bsl ///
	t_sale_value_uc_bsl 
	 
	local yield_1_sel ///
	t_harvest_std_kg_uc_bsl HH_riceHaYear_uc_bsl t_prod_value_uc_bsl profit_1_uc_bsl h_sold_rice_uc_bsl t_sale_std_kg_uc_bsl t_sale_value_uc_bsl 
	
	label variable t_harvest_std_kg_uc_bsl "Total rice harvested (kg)" 
	label variable HH_riceHaYear_uc_bsl  "Yield (kg) per hectare (yearly)" 
	label variable t_plotRiceYield1_uc_bsl "Yield (kg) per hectare (by planting instance)" 
	label variable t_prod_value_uc_bsl  "Total value of rice harvested (kg)" 
	label variable HH_valueHaYear_uc_bsl "Total value per hectare (yearly, USD)" 
	label variable profit_1_uc_bsl  "Total profit (USD)"
	label variable h_sold_rice_uc_bsl "Household sold rice" 
	label variable t_sale_std_kg_uc_bsl "Total rice sold (kg)" 
	label variable t_sale_value_uc_bsl "Total value of rice sold (USD)" 
	
	*not used: grossmargin_1_uc_bsl margin_1_uc_bsl h_commRice_uc_bsl /// 
	
	local yield_1_l "Rice Productivity: Everyone" 
	


*** 3. Rice productivity: Rice producers only 
	local yield_2 /// 
	t_harvest_std_kg_bsl  ///
	HH_riceHaYear_bsl   ///
	t_plotRiceYield1_bsl   ///
	t_prod_value_bsl   ///
	HH_valueHaYear_bsl ///
	profit_1_bsl /// 
	h_sold_rice_bsl ///
	t_sale_std_kg_bsl  ///
	t_sale_value_bsl  
	
	
		
	label variable t_harvest_std_kg_bsl "Total rice harvested (kg)" 
	label variable HH_riceHaYear_bsl  "Yield (kg) per hectare (yearly)" 
	label variable t_plotRiceYield1_bsl "Yield (kg) per hectare (by planting instance)" 
	label variable  t_prod_value_bsl  "Total value of rice harvested (kg)" 
	label variable HH_valueHaYear_bsl "Total value per hectare (yearly, USD)" 
	label variable profit_1_bsl  "Total profit (USD)"
	label variable h_sold_rice_bsl "Household sold rice" 
	label variable t_sale_std_kg_bsl "Total rice sold (kg)" 
	label variable t_sale_value_bsl "Total value of rice sold (USD)" 
	
	
	
	*not used : grossmargin_1_uc_bsl margin_1_uc_bsl profit_1_uc_bsl  
	

	local yield_2_l "Rice Productivity: Rice Producers Only" // change this local name 
	
	
	
	*** 4. Water access 
		
	*should do with fstMonth13_uc_bsl & d_plant13_bsl
	
	local irrig ///
		irrigated_bsl access_water_bsl 
	local irrig_l "Water Access" 	
	
	label variable irrigated_bsl "Household irrigated a plot" 
	label variable access_water_bsl "Village has good a priori water access" 
	
	local irrig_sel ///
		irrigated_bsl access_water_bsl 

	
	*** 5. Labor for Rice 
	
	/**
	foreach var of varlist n_familylabor_bsl n_unpaidlabor_bsl n_paidlabor_bsl labor_spending_bsl rp_n_familylabor_bsl rp_n_familylabor_uc_bsl  rp_n_unpaidlabor_bsl rp_n_unpaidlabor_uc_bsl rp_n_paidlabor_bsl rp_n_paidlabor_uc_bsl rp_labor_spending_bsl rp_labor_spending_uc_bsl {
	gen L`var' = ln(`var' + 1) 
	}
	**/ 
	
	local labor ///
	d_familylabor_bsl d_unpaidlabor_bsl d_paidlabor_bsl n_familylabor_bsl Ln_familylabor_bsl n_unpaidlabor_bsl Ln_unpaidlabor_bsl n_paidlabor_bsl Ln_paidlabor_bsl ///
	labor_spending_bsl Llabor_spending_bsl ///
	rp_d_familylabor_bsl rp_d_familylabor_uc_bsl rp_d_unpaidlabor_bsl rp_d_unpaidlabor_uc_bsl rp_d_paidlabor_bsl rp_d_paidlabor_uc_bsl ///
	rp_n_familylabor_bsl Lrp_n_familylabor_bsl rp_n_familylabor_uc_bsl Lrp_n_familylabor_uc_bsl  rp_n_unpaidlabor_bsl Lrp_n_unpaidlabor_bsl rp_n_unpaidlabor_uc_bsl Lrp_n_unpaidlabor_uc_bsl rp_n_paidlabor_bsl Lrp_n_paidlabor_bsl Lrp_n_paidlabor_uc_bsl rp_n_paidlabor_uc_bsl ///
	rp_labor_spending_bsl rp_labor_spending_uc_bsl
	local labor_l "Labor for rice" 

	local labor_sel ///
	n_familylabor_bsl n_unpaidlabor_bsl n_paidlabor_bsl labor_spending_bsl rp_labor_spending_uc_bsl


	*** 6. Inputs on rice 
	/***
	foreach var of varlist seed_spending_bsl input_spending_bsl total_spending_bsl fert_spending_bsl pest_spending_bsl urea_spending_bsl npk_spending_bsl allchem_spending_bsl ///
	rp_seed_spending_uc_bsl rp_input_spending_uc_bsl rp_fert_spending_uc_bsl rp_pest_spending_uc_bsl  rp_urea_spending_uc_bsl  rp_npk_spending_uc_bsl rp_allchem_spending_uc_bsl {
	gen L`var' = ln(`var' + 1)
	}
	***/ 
	
	local inputs ///
	ImprovedRice_bsl inputs_bsl fertilizer_bsl pesticide_bsl compost_bsl lime_bsl urea_bsl npk_bsl allchem_bsl ///
	seed_spending_bsl Lseed_spending_bsl fert_spending_bsl Lfert_spending_bsl pest_spending_bsl Lpest_spending_bsl urea_spending_bsl Lurea_spending_bsl npk_spending_bsl Lnpk_spending_bsl allchem_spending_bsl Lallchem_spending_bsl ///
	qty_urea_bsl 	qty_npk_bsl qty_allchem_bsl ///
	rp_inputs_uc_bsl rp_fertilizer_uc_bsl rp_pesticide_uc_bsl rp_compost_uc_bsl rp_urea_uc_bsl rp_npk_uc_bsl rp_allchem_uc_bsl ///
	rp_seed_spending_uc_bsl Lrp_seed_spending_uc_bsl rp_input_spending_uc_bsl Lrp_input_spending_uc_bsl  rp_fert_spending_uc_bsl Lrp_fert_spending_uc_bsl rp_pest_spending_uc_bsl Lrp_pest_spending_uc_bsl rp_urea_spending_uc_bsl Lrp_urea_spending_uc_bsl rp_npk_spending_uc_bsl Lrp_npk_spending_uc_bsl rp_allchem_spending_uc_bsl Lrp_allchem_spending_uc_bsl ///
	rp_qty_urea_uc_bsl rp_qty_npk_uc_bsl rp_qty_allchem_uc_bsl ///
	h_var1_bsl h_var2_bsl h_var3_bsl h_var4_bsl h_var1_uc_bsl h_var2_uc_bsl h_var3_uc_bsl h_var4_uc_bsl rp_spending_uc_bsl
	local inputs_l "Inputs on rice" 
	
	local inputs_sel ///
	ImprovedRice_bsl fertilizer_bsl pesticide_bsl urea_bsl rp_seed_spending_uc_bsl rp_urea_spending_uc_bsl rp_npk_spending_uc_bsl rp_allchem_spending_uc_bsl rp_spending_uc_bsl

	
	*** 7. Livestock 
	
	local livestock ///
		own_cow_bsl own_goat_bsl own_horse_bsl  own_pig_bsl own_chicken_bsl n_cow_bsl n_goat_bsl n_pig_bsl n_chicken_bsl n_horse_bsl assets_livst_ind1_bsl assets_livst_ind2_bsl
	local livestock_l "Livestock"
	
	local livestock_sel ///
	assets_livst_ind1_bsl
	
	*** 8. Assets 
	local assets_hh ///
	own_elec_bsl own_wood_stove_bsl own_generator_bsl own_refrig_bsl own_television_bsl own_cellphone_bsl own_landph_bsl own_computer_bsl own_ventilator_bsl own_car_bsl own_bicycle_bsl own_motorcycle_bsl assets_hh_ind_bsl
	local assets_hh_ind_bsl "Household Assets" 

	local assets_hh_sel ///
	hous_ind_bsl

	local assets_farm ///
		own_tractor_bsl own_mill_bsl own_plough_bsl own_tiller_bsl own_drying_bsl own_tank_bsl assets_farm_ind_bsl
	local assets_farm_l "Farm Assets" 

	local assets_farm_sel ///
	assets_farm_ind_bsl


	local housing ///
		house_own_bsl wall_bsl roof_bsl soil_bsl toilet_bsl light_bsl energy_bsl hous_ind_bsl
	local housing_l "Housing" 
	
	local housing_sel ///
	hous_ind_bsl


	
	
	*** 9. Finance 
	
	local finance ///
		savings_fl_bsl bnk_bsl askloan_bank_bsl refloan_bsl
	local finance_l "Finance" 
		
	local finance_sel ///
		savings_fl_bsl bnk_bsl askloan_bank_bsl refloan_bsl
		
		
	*** 10. Household demographics 

	g agr_prod=HH_occupation==1
	g agr_wage=HH_occupation==2
	g oth_sector=inrange(HH_occupation,3,10)

	


	local demogr ///	
	HH_children_bsl	HH_adults_bsl	femalehead_bsl	HH_age_bsl	///
	agr_prod	agr_wage	oth_sector ///
	HH_atleast_someprim	HH_atleast_allprim	HH_atleast_somesec	HH_atleast_allsec	HH_literacy	workgroup_bsl	///
	agri_asso_bsl	agri_coop_bsl

rename HH_atleast_someprim HH_someprim
rename HH_atleast_somesec HH_somesec

	local demogr_sel ///
	HH_children_bsl	HH_adults_bsl femalehead_bsl HH_age_bsl agr_prod agr_wage oth_sector HH_someprim workgroup_bsl agri_asso_bsl agri_coop_bsl
	
	
	
	
	local demogr_l "Household demographics"  
	*removed: HH_edu7_bsl HH_edu3_bsl HH_number_bsl	

	label variable HH_children_bsl "Number of children under 12" 
	label variable HH_adults_bsl "Number of adults 12 and over" 
	label variable femalehead_bsl "HOH (head of household): female" 
	label variable HH_age_bsl "HOH: age"
	label variable agr_prod "HOH: primary occupation: own-farm agriculture" 
	label variable agr_wage "HOH: primary occupation: wage agriculture" 
	label variable oth_sector "HOH: primary occupation: not agriculture" 
	*label variable HH_atleast_someprim "HOH: education: some primary (at least)"
	label variable HH_atleast_allprim "HOH: education: all primary (at least)"  
	*label variable HH_atleast_somesec "HOH: education: some secondary (at least)" 
	label variable HH_atleast_allsec "HOH: education: all secondary(at least)" 
	label variable HH_literacy "HOH: can read or write" 
	label variable workgroup_bsl "HOF (head of farm): member of agricultural work group"
	label variable agri_asso_bsl "HOF: member of professional agricultural association" 
	label variable agri_coop_bsl "HOF: member of agricultural cooperative" 
	
	

	
	
		*** 11. Food Security  Issue : scores are coded differently in baseline balancing in version of paper in july 2017 

	*HungerScale_bsl - in paper, missing seem to be recoded as 0 
	
	
	local food_sec ///
		 WDDS_bsl WDDS_cat_bsl months_insecure_bsl  HungerScale_bsl HungerScale_cat_bsl ELCSA_adult_bsl ELCSA_full_bsl ELCSA_adult_cat_bsl  ELCSA_full_cat_bsl
	local food_sec_l "Food Security"

	local food_sec_sel ///
		 WDDS_bsl months_insecure_bsl  HungerScale_bsl
	
	
	*not used HDDS_bsl HDDS_cat_bsl 
	

		** 12. Distance to suppliers
	
	local dist_supply ///
		d_town km_to_highway

	local dist_supply_sel ///
		d_town km_to_highway



* log file 
cap log close
log using "$log/balancing tests", replace


local groups income landuse landuse_rice other_crops yield_1 yield_2  irrig labor inputs   livestock housing assets_hh assets_farm finance demogr food_sec dist_supply



local groups_sel demogr_sel income_sel landuse_sel landuse_rice_sel other_crops_sel yield_1_sel  irrig_sel labor_sel inputs_sel livestock_sel housing_sel assets_hh_sel assets_farm_sel finance_sel food_sec_sel dist_supply_sel

/**
local groups_sel demogr_sel income_sel landuse_sel  other_crops_sel yield_1_sel  irrig_sel labor_sel inputs_sel livestock_sel housing_sel assets_hh_sel assets_farm_sel finance_sel food_sec_sel dist_supply_sel

***/

*local groups_sel demogr_sel 


su  `demogr_sel'


local row = 4 



foreach g in `groups_sel' { 
preserve 

	matrix drop _all
 

		keep nsm ``g'' treatment  group2_bsl h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl  habitation_old_bsl
		order ``g'', after(nsm)
	
	 
		foreach win in ``g'' { 
			qui distinct `win'
			if r(ndistinct) > 20 { 
				qui sum `win', d
				gen `win'_w = `win', after(`win')  
				replace `win'_w = `r(p99)' if `win' > `r(p99)' & `win' ! = . 
				local my_label : variable label `win' 
				label variable `win'_w "Winsorized: `my_label'"
				replace `win'=`win'_w
				drop `win'_w
				} 
		} 
	
	
		* hack - y  to get dependent variables with newly winsorized 
		qui ds  nsm  treatment  group2_bsl h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl  habitation_old_bsl, not
		local dep_vars  = r(varlist)  	
		
		loc var_n: word count `dep_vars'

		
		
	
		local y = 1 
		
		foreach var of varlist `dep_vars' {
		

			
			*** With lagoons 
			regress `var' treatment  i.group2_bsl h_d_suplag1_bsl h_d_suplag2_bsl  h_d_suplag3_bsl  h_d_suplag4_bsl  h_d_suplag5_bsl  h_d_suplag6_bsl, cluster(habitation_old_bsl)
			su `var' if treatment==0
			estadd scalar m_ctr=r(mean)
			test treatment
			estadd scalar p_conv = r(p)
			est sto `var', title(test)



			
			local y = `y' + 1	
		} 


 
	restore 
		} 

 

 /**

		estout  `income_sel' `landuse_sel' `landuse_rice_sel'  ///
			using "$results/TA_balancing1.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv m_ctr N, fmt(%9.3f %9.3f %9.0f) labels("p-value conv." "Control mean" "Observations")) replace
***/ 


		/*** 
			
		estout  `other_crops_sel' `yield_1_sel' ///
			using "$results/TA_balancing2.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv m_ctr N, fmt(%9.3f %9.3f %9.0f) labels("p-value conv." "Control mean" "Observations")) replace

			***/
			
		estout  `inputs_sel' ///
			using "$results/TA_balancing3.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv m_ctr N, fmt(%9.3f %9.3f %9.0f) labels("p-value conv." "Control mean" "Observations")) replace

		estout  `irrig_sel'  `labor_sel' `dist_supply_sel' ///
			using "$results/TA_balancing4.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv m_ctr N, fmt(%9.3f %9.3f %9.0f) labels("p-value conv." "Control mean" "Observations")) replace

		estout  `demogr_sel' ///
			using "$results/TA_balancing5.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv m_ctr N, fmt(%9.3f %9.3f %9.0f) labels("p-value conv." "Control mean" "Observations")) replace

		estout  `livestock_sel' `housing_sel' `assets_hh_sel' `assets_farm_sel' `finance_sel' `food_sec_sel' ///
			using "$results/TA_balancing6.tex", cells("b(star fmt(3))" se(par)) ///
			mgroups(none) collabels(none) eqlabels(none) style(tex) ///
			keep(treatment) ///
			numbers(( )) stats(p_conv m_ctr N, fmt(%9.3f %9.3f %9.0f) labels("p-value conv." "Control mean" "Observations")) replace


log close
