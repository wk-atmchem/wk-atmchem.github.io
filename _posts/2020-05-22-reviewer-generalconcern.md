---
layout:     post
title:      General concern of reviewers
subtitle:   paper review
date:       2020-05-22
author:     吴锴
header-img: img/post-bg-ios9-web.jpg
catalog: true
tags:
    - satellite
    - models
---
# About innovation of the paper

**Comment:**This methodology has been presented in previous work and the nighttime impact of urbanization has been well documented in the literature. For instance, the paper by Li et al (“Achieving accurate simulations of urban impacts on ozone at high resolution”, ERL, 9, 2014) introduced similar configurations (WRF-Chem including anthropogenic emissions, with and without urbanization) and used them to derive impacts of urbanization on air quality by analyzing the differences in the simulated fields between the two scenarios. Although the region and the period of time considered in this manuscript are different, the main idea and the nighttime impact are similar.

**Response#1:**While this study shows some similarity in research idea with previous literature, it extend this research topic in that

**1)** it includes discussion  on the impact of land surface changes on total and speciated PM2.5 concentration, which has been seldom studied,

**2)** it focuses on the Southern California region where such research is limited but necessary given the high pollutant loads, and

**3)** it incorporates accurately resolved land surface data. 
We added a few sentences in the last paragraph of introduction section to clarify these points.

**Comment:**How exactly does your experimental setup treat the “wide heterogeneity of urban land surface processes” compared to existing studies? A large number of studies already exist using model
systems (e.g. WRF) which include urban canopy models with varying complexity (SLUCM, BEP), which consider a similar level of heterogeneity than your experiments? Please discuss your statement.

**Response#1:**While previous studies have used models with different levels of complexity, most of them failed to incorporate real-world land surface property data as input. They used default WRF settings for land surface properties such as building morphology, albedo, vegetation fraction, which either is out of date, or lacks spatial heterogeneity. By contrast, in this study we use NLCD for land cover type and impervious fraction, satellite-retrieved data for albedo, vegetation fraction and leaf area index, and GIS-based data for building morphology, which resolves spatial heterogeneity of land surface properties, and better predicts regional weather and air quality. The default version of the WRF/UCM assumes that many land cover properties are spatially homogeneous, which is not realistic. 

**Comment:**It should be made clear which new aspects you aim to analyze compared to the studies mentioned above. In my opinion simply turning urban on/off does not reveal significantly new insights. Further the term “human disturbance” is unclear, as this would also involve air quality modifications.

**Response#1:**As we mentioned in the introduction, there are limited studies on the effect of land surface change via urbanization on regional air quality, most of which do not resolve the real-world spatial heterogeneity. In addition, there are several recent studies by our group, which incorporate satellite data for land surface characterization within Southern California, and quantifies the effect of land surface changes on regional climate including temperature and wind speed. Thus, this study combines the research idea of these two types of studies together, and aims to characterize the influence of land surface changes via historical urbanization on urban meteorology and air quality in Southern California using highly resolved land surface characterization.

# About the motivation of the paper
**comment:** I am aware that these model systems are not suitable for applied urban planning, but however the currently existing urban canopy models in WRF-Chem (and other models), together with high resolution datasets for both emission and urban morphology do offer a framework for a number of different scenarios in the context of climate change/UHI mitigation. Recent studies have been analyzing the impact of highly reflecting building materials, urban greening or varying building density for a number urban areas. These aspects should also be possible with this model system and worth being discussed in order to increase the scientific substance of that work and highlight the new contribution to the field. In light of the scope of the journal, it should also be worked out more detailed what are the implications for atmospheric science in general rather than purely investigating local/regional aspects.

**Response:**The study certainly builds on our prior work, but this paper focuses on air quality impacts, whereas our previous research was on only meteorology. Thus, the most important contribution of this work is that we investigate a totally different environmental system than previous work. In order to do so,we also add a new modeling component (atmospheric chemistry) that is not presented in past work. While the influence of land use changes on regional weather has been well studied, its influence on regional air quality has been seldom studied with accurately resolved land surface data, especially in the Southern California region. Therefore, our study fills this research gap.

# About model simulation
## model input selection

**Comment:**Why the author choose the NLCD data? What is the additional gain of a 30 m land surface classification which has to be scaled to 2 km model resolution?

**Response#1:**We chose to use 30 m-resolution 33-category NLCD mainly for two reasons. First, urban land use varies at spatial scales on the order of 10s of meters. So it works best to define land use at spatial scales of 10s of m, and then aggregate to the model grid resolution. It would be difficult to detect land use using data at 2km resolution. Second, the 30 m-resolution land use dataset has 33 categories of land use type, which divides urban type into three sub-types: low-intensity residential, highintensity residential, and industrial/commercial. This allows different parameterizationsfor different sub- urban types, which better characterize land surface properties.


## data assimilation and nudging applied
**Comment:** Was data assimilation or nudging of large scale meteorological field (NCEP final analysis data) applied? 72 hour is long for plume simulations without any of these adjustments of large-scale forcing.

**Response#1:**In the present study, we did not apply data assimilation or nudging for the 72h simulations. Nonetheless, both the meteorological variables and pollutant concentrations simulated by the models showed good agreements with the observations.

## episode selection
**Comment:** On which basis authors claim that the period chosen is representative of summer conditions in Southern California?

**Response#1:**Typical summer days in Southern California are clear or mostly sunny days without precipitation. The chosen simulation period has these characteristics. We added a figure in the supplemental information (Figure S8) showing the diurnal cycle of averaged (observed) near surface air temperature over JJA (June, July and August) and over our simulation period. We also added a sentence in the main paper.

“This simulation period is chosen as representative of typical summer days in Southern California,
which are generally clear or mostly sunny without precipitation. A comparison of observed diurnal
cycles for average near surface air temperatures over JJA (June, July and August) versus over our
simulation period is shown in Figure S8 in the supplemental information.”

## model results validation
**Comment1:** It is not known how well the model represents key factors, such as the magnitude of the UHI, differences in boundary layer height between the city and outside of the city, and winds in the city core that will affect the conclusions drawn in this study. The authors need to include key results from that study that demonstrate the model performs reasonably well in representing observed temperature and winds in the urban area. Readers need to know if there are sufficient observations to verify the meteorological model predictions, otherwise, the present study is simply more of a modeling exercise that may or may not represent the true impact of the UHI on air quality predictions.

**Response1:** In Ryu and Baik (2012), the simulated meteorological variables are evaluated against observation dataset. The WRF-SNUUCM coupled model showed satisfactory performances in reproducing the diurnal variations of observed wind and temperature both in the city core and outside the core. The PBL height is reasonably well simulated by the model as compared with that observed in an urban site and that observed in a rural site (~50 km away from the urban core) although the validation result is not given in Ryu and Baik (2012). Note that the YSU PBL scheme showed a better performance in simulating PBL height in the urban site than the MYJ PBL scheme.

**Comment1:**The ability of WRF-Chem to realistically represent urban processes requires more evaluation to better establish the credibility of the present-day scenario. Therefore, better model verification should be considered. I also suggest adding to Fig. 3 panels comparing diurnal variations of observed and simulated temperature, O3 and PM2.5.

**Response1:** The results indicate that while the model underestimates both observed air temperature and O3 concentrations, the shape of the diurnal cycle is well modeled. For air temperature, simulation results tend to capture daytime (relatively higher) values better than nighttime (relatively lower) values. For O3 concentrations, the model predicts lower concentrations better than higher concentrations. Thus, we edited the sentence the reviewer mentioned. And we put these two figures to the supplemental information, and added a sentence in the main paper.


## model ability for capture min/max temperature variation
**Comment1:** I think that it is necessary to perform a more thorough validation of the simulations to get more confidence in the results, also because the RMSE, presented in table 1, is much larger than the urbanization effect. Therefore, I recommend making a separate analysis of urban and rural stations, and to separate between urban stations based on the different urban morphological characteristics. The validity of this study relies completely on the model capability to reproduce correctly the differences between urban and rural areas, so it is very important to show this comparison. For example, the following questions should be addressed: what are the RMSE and Mean Bias for the urban stations only? And for the rural stations? We have to be sure that the model is simulating correctly the urban areas AND the rural areas (in particular shrubs). Is the model able to capture the maximum and minimum temperature at each station? Is the model able to reproduce the differences between stations, and in particular the differences between the urban and the rural stations? (e. g. if at a certain hour higher temperature is measured in an urban station compared to a rural one, is the model doing the same? If rural stations measured lower minimum (maximum) than urban stations, is the model doing the same qualitatively and quantitatively?, etc.).

**Response1:** 

## emission inventory adjustment
**Comment:** Is base year of emission inventory 2007 and does it need to be adjusted (projected) to 2008 level? I thought the episode in 2010 was simulated in this study.

**Response:**We chose an ozone episode occurred in 2010, but an emission inventory in 2010 is not available at present. Under the present circumstances, the gridded and speciated hourly anthropogenic emission data are derived from the emission inventory in 2007. The emission data based on the emission inventory in 2008 are not yet established, but the total annual emissions of pollutants in 2008 are available. To update the emission data with the up-to-date information, the amounts of NOx (VOC) emitted are adjusted according to the ratio of the total annual emissions of NOx (VOC) in 2008 to those in 2007. We conclude that this is the best way we can do at present. Following your comment, this part is clarified in the revised manuscript.

## model uncertainty from parameterization selection
**Comment1:** It is not clear how this effect compares to other uncertainties in air quality predictions. For example, choice of PBL parameterization could also introduce differences in ozone concentrations and uncertainties in emission inventories will impact predictions of ozone. How does the impact of the UHI compare to other commonly known uncertainties in air quality predictions? Some context is needed.

**Response1:**Following your comment, we examined changes in ozone concentration owing to the choice of PBL parameterization scheme and changes in ozone precursor emissions. In the present study, the YSU PBL scheme is used and this is mentioned in the revised manuscript. To examine an uncertainty owing to the choice of PBL parameterization scheme, the MYJ PBL scheme is chosen and the results are presented in Table B1. The difference in area-averaged O3 concentration between the baseline simulation with the YSU PBL scheme and the simulation with the MYJ PBL scheme is small in the daytime (3 ppb) but large in the nighttime (11 ppb).
To examine possible uncertainties in O3 prediction associated with emission uncertainties, simulations in which anthropogenic NOx and anthropogenic VOC emissions are altered by 20% are performed. We considered four types of scenarios with 20% decrease in NOx emission (denoted by NOx0.8), 20% increase in NOx emission (denoted by NOx1.2), 20% decrease in VOC emission (denoted by VOC0.8), and 20% increase in VOC emission (denoted by VOC1.2). When either NOx emission or VOC emission is altered, the other precursor emission is set to be the same as the emission in the baseline simulation. In Table B1, it is found that the change in O3 concentration owing to the change in the precursor emissions is larger in the daytime than in the nighttime and that O3 concentration is more
sensitive to the change in the NOx emission than to the change in the VOC emission. Four additional simulations in which the urban areas are replaced with cropland areas are performed with the same emission scenarios (Table B1). Even though the precursor emissionsare altered, the impact of urban land-surface forcing is substantial for each emission scenario. So, the changes in precursor emissions do not change the conclusions drawn in this study.
So, the changes in precursor emissions do not change the conclusions drawn in this study. In summary, the changes in O3 concentration owing to urban land-surface forcing are significant as compared with those owing to the choice of different PBL parameterization schemes and those owing to the changes in O3 precursor emissions.

**Response2:**Note that the results reported in this paper are based on model simulations and are thus dependent on how accurately the regional climate–chemistry model characterizes the climate–chemistry system (e.g., meteorology, surfaceatmosphere coupling, and atmospheric chemical reactions). Results may be dependent on model configuration (e.g.,physical and chemical schemes), land surface characterizations (e.g., satellite data from MODIS, or default dataset available in WRF), and emission inventories (e.g., anthropogenic emission inventories from CARB, SCAQMD, or NEI). In addition, since irrigation is not included in the nonurban scenario, simulated meteorology in the nonurban scenario is dependent on assumed initial soil moisture conditions. In this study, we adopt the initial soil moisture conditions from Vahmani et al. (2016) for consistency with our previous work. Soil moisture initial conditions are based on values from 6-month simulations without irrigation

# About further discussion
## limitation of case study
**Comment:** Some additional discussion is needed at the end of the paper to stress that the authors have examined one case and put this study into the proper context. They do mention that this case is for fair weather conditions when one might expect a larger impact of the UHI on the local meteorology. However, it would also be interesting to know how strong synoptic forcing needs to be that would overwhelm the UHI and the effects on air quality presented in this study.

**Response:** Following your comment, we included the point you mentioned and stressed the necessity of further studies at the end of the paper. 

# About grammer erros
**Comment:** While the paper is well organized, there are numerous grammatical errors, some of which are pointed out in the specific comments. I likely did not catch all of them and suggest that the authors find an editor to help them with the final manuscript.

# About references
**Comment:** References: I noticed at least one reference cited in the text that was not included in the reference list. The authors should check all references to make sure they are properly cited.



# 2017-ACP
## An investigation on the origin of regional springtime ozone episodes in the western Mediterranean
**Comment:** 
The paper highlights one of the important factors, i.e. synoptic meteorological system, controlling high ozone concentration episodes over Western Mediterranean (W-MED) and Central Europe (C-EU), during spring. The text is generally well written and clear. The time series plots of the observations clearly confirm there were two episodes in which ozone builds up during late April and early May in 2008 over most of the Mediterranean countries. However, when it comes to the proof of the argument, there are a number of statements and images repeating the same messages. The analysis of various parameters that are generated from different types of observations and models is a great idea, but unfortunately they are not always univocal. Therefore I think this paper needs a major revision. Particularly, I would encourage the authors to avoid misinterpreting the results of multiple sources. 

**Comment:** The major concern I have with this paper, particularly in the result and discussion section, is that there is no clear focus on the two regions which are mentioned in the title (i.e. W-MED and C-EU). Furthermore, the mechanisms leading to ozone enhancement as a consequence of high pressure systems should be explained in more detail. 
(I) One mechanism could be the accumulation of surface ozone which is produced through chemical reactions due to the stagnant air flow. 
(II) Another one could be linked to ozone flux from the upper troposphere to the surface, which the authors have already tried to prove but without sufficient arguments. 


**Comment:** Data and methodology: the description of methodology is insufficient.
(1) Data and methodology: I think it would be nice to add the path (precise address) of the data center or website which the data are taken from.——需要说清楚监测或者再分析数据的来源 
(2) Data and methodology: what is the horizontal and vertical resolution of the CHIMERE model?——模型的水平以及垂直分辨率 

**Comment:** Results and discussion, section 3.2, d): Yes, indeed there is a strong westerly wind toward W-MED a few days before the episode. {It may transfer ozone and its precursors from other places such as eastern US, etc. towards this region (via longrange transport), but there is not enough evidence for that through this maps.} However, on the 26th and 27th of April (in the lowest panel of the left column in Fig. 4), there is a weak wind flow over W-MED due to the existence of a high pressure system.
**含义** 尽管图中呈现了很强劲的西风，可能会将臭氧及前体物从美国东部通过长距离传输输送到盆地，但是仍然没有足够充分的证据可以体现该结论。此外，4月26和27日由于高压系统的存在MED西部风速较弱。

**Comment:** Figure 3: Both omega and omega anomaly have the same messages; I would recommend the authors to keep only one of them. Units are missing. 
**Comment:** Figure 4: Again, adding units would be recommendable. 
**含义** 图表里的单位有缺失。
