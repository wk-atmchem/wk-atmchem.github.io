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

# About model simulation
## data assimilation and nudging applied
Comment:Was data assimilation or nudging of large scale meteorological field (NCEP final analysis data) applied? 72 hour is long for plume simulations without any of these adjustments of large-scale forcing.

Response#1:In the present study, we did not apply data assimilation or nudging for the 72h simulations. Nonetheless, both the meteorological variables and pollutant concentrations simulated by the models showed good agreements with the observations.

## model results validation
Comment:It is not known how well the model represents key factors, such as the magnitude of the UHI, differences in boundary layer height between the city and outside of the city, and winds in the city core that will affect the conclusions drawn in this study. The authors need to include key results from that study that demonstrate the model performs reasonably well in representing observed temperature and winds in the urban area. Readers need to know if there are sufficient observations to verify the meteorological model predictions, otherwise, the present study is simply more of a modeling exercise that may or may not represent the true impact of the UHI on air quality predictions.

Response: In Ryu and Baik (2012), the simulated meteorological variables are evaluated against observation dataset. The WRF-SNUUCM coupled model showed satisfactory performances in reproducing the diurnal variations of observed wind and temperature both in the city core and outside the core. The PBL height is reasonably well simulated by the model as compared with that observed in an urban site and that observed in a rural site (~50 km away from the urban core) although the validation result is not given in Ryu and Baik (2012). Note that the YSU PBL scheme showed a better performance in simulating PBL height in the urban site than the MYJ PBL scheme.

## emission inventory adjustment
Comment: Is base year of emission inventory 2007 and does it need to be adjusted (projected) to 2008 level? I thought the episode in 2010 was simulated in this study.

Response:We chose an ozone episode occurred in 2010, but an emission inventory in 2010 is not available at present. Under the present circumstances, the gridded and speciated hourly anthropogenic emission data are derived from the emission inventory in 2007. The emission data based on the emission inventory in 2008 are not yet established, but the total annual emissions of pollutants in 2008 are available. To update the emission data with the up-to-date information, the amounts of NOx (VOC) emitted are adjusted according to the ratio of the total annual emissions of NOx (VOC) in 2008 to those in 2007. We conclude that this is the best way we can do at present. Following your comment, this part is clarified in the revised manuscript.

## model uncertainty from parameterization selection
Comment:It is not clear how this effect compares to other uncertainties in air quality predictions. For example, choice of PBL parameterization could also introduce differences in ozone concentrations and uncertainties in emission inventories will impact predictions of ozone. How does the impact of the UHI compare to other commonly known uncertainties in air quality predictions? Some context is needed.

Response:Following your comment, we examined changes in ozone concentration owing to the choice of PBL parameterization scheme and changes in ozone precursor emissions. In the present study, the YSU PBL scheme is used and this is mentioned in the revised manuscript. To examine an uncertainty owing to the choice of PBL parameterization scheme, the MYJ PBL scheme is chosen and the results are presented in Table B1. The difference in area-averaged O3 concentration between the baseline simulation with the YSU PBL scheme and the simulation with the MYJ PBL scheme is small in the daytime (3 ppb) but large in the nighttime (11 ppb).
To examine possible uncertainties in O3 prediction associated with emission uncertainties, simulations in which anthropogenic NOx and anthropogenic VOC emissions are altered by 20% are performed. We considered four types of scenarios with 20% decrease in NOx emission (denoted by NOx0.8), 20% increase in NOx emission (denoted by NOx1.2), 20% decrease in VOC emission (denoted by VOC0.8), and 20% increase in VOC emission (denoted by VOC1.2). When either NOx emission or VOC emission is altered, the other precursor emission is set to be the same as the emission in the baseline simulation. In Table B1, it is found that the change in O3 concentration owing to the change in the precursor emissions is larger in the daytime than in the nighttime and that O3 concentration is more
sensitive to the change in the NOx emission than to the change in the VOC emission. Four additional simulations in which the urban areas are replaced with cropland areas are performed with the same emission scenarios (Table B1). Even though the precursor emissionsare altered, the impact of urban land-surface forcing is substantial for each emission scenario. So, the changes in precursor emissions do not change the conclusions drawn in this study.
So, the changes in precursor emissions do not change the conclusions drawn in this study. In summary, the changes in O3 concentration owing to urban land-surface forcing are significant as compared with those owing to the choice of different PBL parameterization schemes and those owing to the changes in O3 precursor emissions.

# About further discussion
## limitation of case study
Comment:Some additional discussion is needed at the end of the paper to stress that the authors have examined one case and put this study into the proper context. They do mention that this case is for fair weather conditions when one might expect a larger impact of the UHI on the local meteorology. However, it would also be interesting to know how strong synoptic forcing needs to be that would overwhelm the UHI and the effects on air quality presented in this study.

Response: Following your comment, we included the point you mentioned and stressed the necessity of
further studies at the end of the paper. 

# About grammer erros
Comment:While the paper is well organized, there are numerous grammatical errors, some of which are pointed out in the specific comments. I likely did not catch all of them and suggest that the authors find an editor to help them with the final manuscript.

# About references
Comment:References: I noticed at least one reference cited in the text that was not included in the reference list. The authors should check all references to make sure they are properly cited.