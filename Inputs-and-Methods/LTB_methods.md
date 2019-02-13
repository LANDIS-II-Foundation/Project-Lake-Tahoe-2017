This document is a running methods doc for the LANDIS-II portion of the
Lake Tahoe west project. It describes data collection/analysis,
calibration, and results organized by model extension. Note that all
parameters used, as well as the version of extension used are all
available on github at:
https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017

Contents
========

[Net Ecosystem Carbon Nitrogen (NECN)](#necn)

[NECN input maps](#necn-h-input-maps)

[Soil physical property/quality maps](#soil-physical-propertyquality-maps)

[Soil carbon maps](#soil-carbon-maps)

[Dead wood maps](#dead-wood-maps)

[Initial Communities](#initial-communities)

[Soil Decay rates](#soil-decay-rates)

[Species Parameters](#species-parameters)

[SCRAPPLE](#scrapple)

[Methods](#methods)

[Ignition](#ignition)

[Fire Spread (Growth)](#fire-spread)

[Fire Intensity](#fire-intensity)

[Fire Severity](#fire-severity)

[Harvest ](#harvest)

[SCENARIO 1 ](#scenario-1)

[SCENARIO 2: WUI Focused](#scenario-2-wui-focused)

[SCENARIO 3: WUI Extended](#scenario-3-wui-extended)

[SCENARIO 4: WUI Extended Rx Focus](#scenario-4-wui-extended-rx-focus)

[Base BDA](#base-bda)

[Climate Change](#climate-change)


Net Ecosystem Carbon Nitrogen (NECN) 
==========

This section records the translation process from Century Succession
inputs to NECN inputs. For each new input, I will attempt to create a
method for translating existing Century inputs into NECN inputs. If no
method can be found for translation, new inputs will be mode with data
source suggestions. The big change here is the elimination of
ecoregions, which are replaced by a series of maps containing soils
data.

This will be specific for the PSW Lake Tahoe West project, but will
probably be pertinent for similar input translation for other projects.
There is a companion spreadsheet for this called
'Input\_Translator.xlsx' in the same directory as this.

NECN input maps
-----------------

### Soil physical property/quality maps

SSURGO is incomplete for the basin, so some of these are just constants
at the climate region scale that I adapted from Louise's work
(Loudermilk et al. 2013, Loudermilk et al. 2014). Source is denoted next
to name.  Full list of files is available here: <https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/tree/master/LTW_LANDIS_Scenarios/NECN_input_maps/>

SoilDepthMapName - SSURGO
SoilDrainMapName- SSURGO
SoilBaseFlowMapName
SoilStormFlowMapName
SoilFieldCapacityMapName
SoilWiltingPointMapName
SoilPercentSandMapName
SoilPercentClayMapName
###Soil carbon maps 
InitialSOM1CsurfMapName - ORNL
InitialSOM1NsurfMapName - ratio
InitialSOM1CsoilMapName - ORNL
InitialSOM1NsoilMapName- ratio
InitialSOM2CMapName - ORNL
InitialSOM2NMapName- ratio
InitialSOM3CMapName - ORNL

InitialSOM3NMapName- ratio

For the soil carbon maps, data was downloaded from the Oak Ridge
National Laboratory distributed active archive
<https://daac.ornl.gov/SOILS/guides/West_Soil_Carbon.html>

To partition total soil carbon into the various pools, I found the ratio
of pools from Louise's work and applied them to the new ORNL spatially
dynamic values. Her previous total soil carbon value was 3475 g C m^-2^:
SOM1surf (75 g C m^-2^; 2.16% of total), SOM1soil (100 g C m^-2^;
2.88%), SOM2 (3000 g C m^-2^; 86.33%), SOM3 (300 g C m^-2^; 8.63%). I
then used raster calculator to create individual SOM pool maps.

The new total soil carbon values are:
![Carbon inputs](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/tree/master/Inputs-and-Methods/Images%20for%20methods/LTW_SOC.png)


So if anything, we were slightly over predicting soil carbon, especially
on the east shore, but not by a ton landscape-wide

For the Soil N maps, I am basing values on the default Century C:N
ratios of the pools, described as

*One of the most difficult parts of initializing the model is estimating
the C, N, P, and S levels for the different soil fractions. In most
soils the **active soil fraction is approximately 2 to 4% of the total
soil C.** The **slow SOM fraction makes up approximately 55%** of the
total SOM. Unfortunately there is not a good technique for estimating
the size of the stabilized **microbial products pool; however, it is
estimated that it is approximately 10 to 20% of the soil**. The
**passive SOM generally makes up 30 to 40% of the total SOM** and will
have a higher value for high clay content soils. **The best estimate of
the N content of these fractions are that the slow fraction has a C:N
ratio of 15 to 20, the active SOM has a C:N ratio of 8 to 12, while the
passive SOM has a C:N ratio of 7 to 10.** These approximations seem to
work well for a large number of different soils.*

I used the guidelines above to develop these parameters

  Pool | Century name  | \% of total C |  C/N ratio
  ----------| -------------- |--------------- |-----------
  SOM1surf |  Microbial  |    1         |      10
  SOM1soil |  Active     |    2         |      10
  SOM2     |  Slow       |    59        |      17.5
  SOM3     |  Passive    |    38         |     8.5

### Dead wood maps

Source of C\_deadwood information was from:
<https://www.fs.usda.gov/rds/archive/Product/RDS-2013-0004>. Raster
calculator was used to convert between units. Per cell ratio of dead
woody debris to AGB was calculated as a check for consistency.

Wilson, Barry Tyler; Woodall, Christopher W.; Griffith, Douglas M. 2013.
Forest carbon stocks of the contiguous United States (2000-2009).
Newtown Square, PA: U.S. Department of Agriculture, Forest Service,
Northern Research Station. <https://doi.org/10.2737/RDS-2013-0004>

InitialDeadWoodSurfaceMapName -- SurfDead.tif

Belowground carbon in FIA is defined as Carbon in the belowground
portion of the tree.

*The carbon (pounds) of coarse roots *

*\>0.1 inch in root diameter. Calculated for live trees with a diameter
&gt;1 inch, and dead trees with a diameter &gt;5 inches, for both timber and
woodland species. This is a per tree value and must be multiplied by
TPA\_UNADJ to obtain per acre information. Carbon is assumed to be
one-half the value of belowground biomass as follows: CARBON\_BG = 0.5
\* DRYBIO\_BG*

*The average proportion of coarse roots to total aboveground biomass is
calculated using this equation: *

*root\_ratio = Exp(JENKINS\_ROOT\_RATIO\_B1 + JENKINS\_ROOT\_RATIO\_B2 /
(DIA\*2.54))*

*partially defined by:*
*Species category*
*JENKINS\_ROOT\_RATIO\_B1*
*Softwood (S)*
*-1.5619*
*Hardwood (H)*
*-1.6911*
*Species category*
*JENKINS\_ROOT\_RATIO\_B2*
*Softwood (S)*
*0.6614*
*Hardwood (H)*
*0.8160*

I just used the FIA equation from above and applied it to our initial
communities AGB info to get coarse live roots and then use Melissa's .4
conversion factor to get dead roots. This will require getting diameter
info from FIA info that Louise compiled, called
'forest\_age\_estimates.csv', which acts as a crosswalk for initial
communities information.

### Initial Communities 

Forest\_age\_estimates.xlsx in
"K:\\Loudermilk\\Loudermilk\\SNPLMA\\LTBdata\\FIA\\SAS\_FIA" contains
all data needed to retrace FIA -\> IC process. Need to extract biomass
of each cohort from this spreadsheet and assign it to the appropriate
cohort in the IC text file. However, there are multiple trees per age
cohort, so we need to figure out how to convert tons/acre from multiple
cohorts into Mg/ha.

*Biomass expansion factor*

FIA uses a 'biomass expansion factor' (BEF) to convert individual tree
biomass to tons/acre. The expansion factor is based on a trees per acre
(TPA) calculation, which is:

TPA = 1/(N\*A), where N = \# of subplots, A = area of subplot

So, for standard plot design

TPA (trees per acre) = 6.018046.

The TPA used can be found in the TPA\_UNADJ column

### Soil Decay rates

Soil decay rates were formerly within the Ecoregion parameters, but now
they are landscape wide. Louise has decay rates the same across
ecoregions so I just used those.

Species Parameters
------------------

Original species parameters were carried over from Loudermilk et al.
2013 for the LTB area, see Table 1 and Table 2. However, certain species
were not behaving as expected. Some of this issue was related to climate
inputs (changes from CMIP3 to CMIP5). Adjustments were proposed for
shade tolerance and GDD minimum and maximum.

Known issues:

1.  Red fir (AbieMagn) was experiencing substantial decline from year 1

2.  PinuCont, PinuMont, TsugMert, PinuAlbi, have minimal regeneration.
    Limitations were related to GDD/temperature parameters.

3.  Substantial increases in Sugar Pine biomass.

Potential solutions:

1.  Adjusting GDD parameters to match 10 and 90^th^ percentiles for
    those species based on USGS climate atlas.

2.  Adjusting impacts of fir engraver on red fir (by lowering
    susceptibility).

3.  Increasing maximum biomass cap on red fir.

4.  Increase sugar pine susceptibility to mountain pine beetle.

5.  Introduce white pine blister rust as mortality agent.

Table 1.Species parameters

 Species	|	Longevity	|	Sexual Maturity	|	Shade Tol.	|	Shade source	|	Changes?	|	Fire Tolerance	|	Seed DispersalEffective Distance	|	Seed Dispersal Maximum Distance	|	Veg Reproduction	|	Veg Sprout Age Min	|	Veg Sprout Age Max	|	Post-Fire Regen	|
 -----|-----|------|-------|-------|-------|------|------|-------|-------|--------|------|------|
 PinuJeff	|	500	|	25	|	2	|	Jenkinsen, Silvics Manual. "The species is intolerant of shade"	|	Change to 1	|	5	|	50	|	300	|	0	|	0	|	0	|	none	|
 PinuLamb	|	550	|	20	|	3	|	Kinlock and Scheuner, Silvics Manual. " Sugar pine tolerates shade better than ponderosa pine but is slightly less tolerant  than incense-cedar and Douglas-fir and much less so than white fir (14)."	|	Change to 2?	|	5	|	30	|	400	|	0	|	0	|	0	|	none	|
 CaloDecu	|	500	|	30	|	3	|	Powers and Oliver, Silvics Manual, "Incense-cedar has been rated as more shade tolerant (22) than the associated pines and Douglas-fir (16), and perhaps less tolerant than white fir and grand fir."	|	Hold?	|	5	|	30	|	1000	|	0	|	0	|	0	|	none	|
 AbieConc	|	450	|	35	|	4	|	Laacke, Silvics Manual. "In general, white fir becomes established best in partial shade, but once established grows best in full sunlight. It is less tolerant of shade than associated true firs (except red fir), is slightly more tolerant than Douglas-fir, and is much more tolerant than pines or oaks (37,41,56). Because white fir can survive and grow beneath heavy brush cover and eventually overtop the brush and dominate the site, many pure stands exist in otherwise mixed conifer areas (36)."	|	Hold?	|	3	|	30	|	500	|	0	|	0	|	0	|	none	|
 AbieMagn	|	500	|	40	|	3	|	Laacke, Silvics Manual. "Although red fir grows best in full sunlight, it can survive and grow for long periods in relatively dense shade. Red fir's tolerance of shade appears to be less than that of mountain hemlock, slightly less than that of white fir and Brewer spruce, but greater than that of all of its other associates. Red fir's capacity to maintain significantly more foliage under shade than white fir suggests that the tolerance difference between them is marginal (1). It is most accurately classed as tolerant of shade. Red fir seedlings are slightly more hardy in full sun than white fir seedlings but become established most easily in partial shade (14,26). "	|	Increase to 4?	|	4	|	30	|	500	|	0	|	0	|	0	|	none	|
 PinuCont	|	250	|	7	|	1	|	Lotan and Critchfield, Silvics Manual. "Lodgepole pine is very intolerant of shade and competition from other plant species."	|	Hold	|	2	|	30	|	300	|	0	|	0	|	0	|	none	|
 PinuMont	|	550	|	18	|	3	|	Graham, Silvics Manual. "It is classed as intermediate in shade tolerance when compared to other northwestern tree species."	|	Change to 2?	|	4	|	30	|	800	|	0	|	0	|	0	|	none	|
 TsugMert	|	800	|	20	|	5	|	Means, Silvics Manual. "Mountain hemlock is classed as tolerant of shade and other forms of competition (10,48,55)"	|	Hold	|	1	|	30	|	800	|	0.0005	|	100	|	800	|	none	|
 PinuAlbi	|	900	|	30	|	3	|	Arno and Hoff, Silvics Manual. "Although whitebark pine has been tentatively rated very intolerant of competition or shade (12), recent observers (8,25,60,66,71) believe that it is intermediate or intolerant, about equivalent to western white pine or interior Douglas-fir. Whitebark pine is less tolerant than subalpine fir, spruce, and mountain hemlock; however, it is more tolerant than lodgepole pine and alpine larch."	|	Change to 2?	|	2	|	30	|	2500	|	0.0001	|	100	|	900	|	none	|
 PopuTrem	|	175	|	15	|	1	|	Perala, Silvics Manual. "In both the eastern and western parts of its range, quaking aspen is classed as very intolerant of  shade, a characteristic it retains throughout its life."	|	Hold	|	2	|	30	|	1000	|	0.9	|	1	|	175	|	resprout	|
 NonnResp	|	80	|	5	|	2	|		|		|	1	|	30	|	550	|	0.85	|	5	|	70	|	resprout	|
 NonnSeed	|	80	|	5	|	2	|		|		|	1	|	30	|	1000	|	0	|	0	|	0	|	none	|
 FixnResp	|	80	|	5	|	1	|		|		|	1	|	30	|	500	|	0.75	|	5	|	70	|	resprout	|
 FixnSeed	|	80	|	5	|	1	|		|		|	1	|	30	|	800	|	0	|	0	|	0	|	none	|



Table 2. Species Climate Parameters

  Species  |  Species Functional Type    |  N-fix | GDD Min | GDD 10% value from Atlas | GDD Max| GDD 90% value | Min Temp.| Drought | Leaf Longevity | Epicormic resprout  | 
  ---------| --------------------| --------| -----| ----------------------| ------| ----------------------| --------- |---------| ----------------| ---------------------|
  PinuJeff |  1                 |   N      |  555 |  1200   |                2149  | 2800         |          -5    |    0.94    |  6         |       N
  PinuLamb |   1                |    N    |    815 |  1300  |                 2866 |   2800       |            -5 |       0.9   |    2.5    |          N
  CaloDecu |  1                 |   N     |   837 |  1400   |                2938 |  3100         |          -18  |     0.99    |  4        |        N
  AbieConc |   1                |    N    |    540 |   700  |                  2670 |   2500      |             -10 |      0.93 |     8      |          N
  AbieMagn |   1                |    N    |    483 |   1100 |                  1257 |  1700       |            -10  |     0.87  |    8        |        N
  PinuCont |   1                |    N    |    276 |   500  |                  1230 |  1300       |            -18  |     0.87  |    3.5       |       N
  PinuMont |   1                |    N    |    155 |   500  |                  1220 |  1800       |            -18  |     0.82  |    7        |        N
  TsugMert |   1                |    N    |    235 |   500  |                  1200 |  1400       |            -18  |     0.8   |    4.5       |       Y
  PinuAlbi |   1                |    N    |    230 |   300  |                  1205 |  1200       |            -18  |     0.9   |    5.5        |      Y
  PopuTrem |   2                |    N    |    600 |   600  |                  3000 |  3000       |            -10  |     0.82  |    1           |     Y
  NonnResp |   3                |    N    |    400 |   400  |                  4000 |  4000       |            -10  |     0.99  |    1.5          |    Y
  NonnSeed |   3                |    N    |    400 |   400  |                  4000 |  4000       |            -10  |     0.97  |    1.5        |      N
  FixnResp |   3                |    Y    |    400 |  400   |                 4000  | 4000        |           -10   |    0.97   |   1.5          |    Y
  FixnSeed |   3                |    Y    |    400 |   400  |                  4000 |  4000       |            -10  |     0.99  |    1.5          |    N

References:

Loudermilk et al. 2013 and 2014

USFS Silvics Manual

USGS Climate Atlas

SCRPPLE
========

Methods
-------

We included three types of fires in the model: Lightning, Human
Unintentional ('Accidental'), and Prescribed Fire ('RxFire'). Each has
its own ignition and suppression and intensity patterns. All fires
behave similarly in regards to spread and mortality. Our model consists
of four primary algorithms: Ignition, Spread, Fire Intensity, and Fire
Severity, described below.

### 1. Ignition

Our ignitions follow a "supply and allocation" model whereby the supply
of ignitions are generated from a zero-inflated Poisson model and then
ignitions are allocated across the landscape with an ignition surface.

For Accidental and Lightning fires, the number of ignitions per day is
determined from empirical data relating the number of ignitions (by each
of three types) to FWI. The following equation was fit to available
ignition and climatic data (Zuur et al 2009).

Number of fires = e^b0\ +\ b1\*FWI^ (Equation 1)

This is a zero-inflated Poisson distribution, which requires fitting two
parameters, which vary by ignition type. Fire Weather Index (FWI)
follows the calculations from the Canadian Fire Prediction System (1992)
and is a smoothed averaged that integrates long- and short-term
variation in precipitation and temperature. FWI was calculated for each
day-of-the-year and the appropriate number of ignitions were generated
for each day. For fractional ignitions (i.e. number of ignitions = 1.6),
simple rounding will determine the number of ignitions. The location of
each ignition is determined below.

In order to parameterize ignitions, historical fire data from 1992-2013
for the LTB (Short 2013) was used to establish a relationship between
daily number of ignitions and FWI. Ignition within the historical data
set were separated by ignition type into lightning (coded as 'lightning'
within the Short data) and human accidental (many codes, including
'campfire', 'arson', and 'child', were combined). Daily historical FWI
was calculated from daily temperature and precipitation data (PRISM) as
implemented within the Climate Library of LANDIS-II (Lucash et al.
2017), which produced daily FWI values for our period of record. A zero
inflated Poisson distribution was then fitted using the 'zeroinfl'
function within the 'pscl' package in R, producing estimates for b0 and
b1 in equation 1. This was done for both lightning ignitions and human
accidental ignitions. The analysis was conducted using the likelihood
package in R (R Core Team 2014).

We tested these parameters by providing our fitted equation with daily
FWI values to observe how many ignitions values were produced. The
procedure was verified using random FWI values produced by a random
number generator within R. Below are the results of feeding daily FWI
values from 1992-2013 back into our fitted equation for lightning
ignitions, to attempt to mimic the historical ignitions data used to fit
the equation.

![Lightning](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/tree/master/Inputs-and-Methods/Images%20for%20methods/PLI_LTB.png)

*Figure 1: Example of predicted lightning ignitions per day for 16 years
of historical FWI data using SCRAPPLE method.*

For RxFire, a set number of fires are generated per year, based on
expert input and/or scenario design. For each day of the year, a single
RxFire is attempted, given that FWI is within a specified range and that
the wind speed is below an allowable maximum. RxFires are attempted
sequentially (by day of year) until the expected number of fires is
successfully ignited. Conditions are placed on RxFire ignitions based on
a minimum FWI (necessary to maintain fire spread, below), a maximum FWI
(conditions under which prescribed fire would be avoided), and a maximum
wind speed (again, conditions under which prescribed fire would be
avoided).

#### 1.1 Ignition Locations

A continuous weighted surface of historic ignitions occurrences is
generated for each of the three ignition types from the fire record data
and used to allocate ignitions. For regions where ignitions have no
spatial pattern, this surface would be a constant value or a smoothed
average of ignition rates (see some of Finney's national-scale modeling
work). For other regions, the spatial pattern of ignitions could be
predicted (Yang et al. 2015). For this study we used historical fire
data from 1992-2013 for the LTB (Short 2013). All available sites are
then randomly shuffled, with an algorithm that biases selection by the
weights provided; ignition locations begin at the top of the shuffled
list. The list of ignitions sites is re-shuffled at the beginning of
each year.

In combination, the three ignition sources generate the total number of
fires per year per fire type and is highly dependent upon FWI.

Our model produces an output map of fire ignitions, coded by type (e.g.
Lightning = 1, Accidental = 2, Rx = 3). To calibrate fire ignitions, we
ran simulations in R to validate that fire ignition parameters recreate
the appropriate number of fires given a particular FWI value. We also
calibrated each ignition type such that the spatial patterns of fire
ignitions provided by the input maps match the spatial patterns of fire
ignitions by type in the output maps.

2. Fire Spread (Growth)
From the point of ignition, fire spreads. Fire can spread to each
adjacent cell dependent upon a probability of spread (Pspread) to
adjacent neighbor (out of four nearest neighbors). Fire spread is from
cell-to-cell and determines fire size. A fire will continue burning
until no more cells are selected for spread.

Fire spread was built from a general equation relating event probability
to FWI (Beverly and Wotton 2007):

Probability of Fire Spread = 1 / 1 + e^β0^ Equation 2

Where β0 is the probability of spread into a site given condition on
that site:\
β0 = β0' + β1 \* FWI + β2\*EffectiveWindSpeed + β3\*FineFuels Equation 3

Where EffectiveWindSpeed is an adjusted wind speed whereby reported wind
speed and direction for the region (from meteorological stations) is
downscaled to individual sites by accounting for slope angle and the
slope azimuth relative to the wind direction (see Nelson 2002 for
complete information). EffectiveWindSpeed also incorporates the
intensity of the source fire. A high severity fire burning upslope
generates a greater EffectiveWindSpeed than a moderate or light fire.
This in turn feeds back into the estimate of fire intensity (see below),
creating self-sustaining high-intensity fires under certain conditions.

For our model fit from empirical data, we used fine fuel load (mass)
estimates from LANDFIRE fuel types (Table 1). During model execution,
fire fuels are estimated from endogenous (internal to the model
framework) litter estimates. Notably, during model execution, fine fuels
are dynamic over time to reflect reductions from fuel treatments or
prescribed fire and additions from overstory mortality, e.g., from
insect outbreaks (e.g., Sturtevant et al. 2009).

A fire will spread until it has reached a maximum area for the day.
Spread area was drawn from the GEOMAC fire perimeter data (Table X) and
is defined as the increase in day-to-day area of total fire perimeter.
Maximum area is determined empirically:

Maximum daily spread area = β0 + β1 \* FWI + β2\*EffectiveWindSpeed
Equation 4

![Climate fire spread](ttps://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/tree/master/Inputs-and-Methods/Images%20for%20methods/v_area_spread.png)

*Figure 2: Daily fire spread area (ha) and daily wind speed velocity.
Daily fire spread within SCRAPPLE is a function of both daily wind speed
velocity and FWI.*

Maximum area spread parameters were derived using a fitted generalized
linear model, function 'glm' in the R statistical software. It is
important to note that the FWI and Effective wind speed parameters used
to determine maximum daily spread area entirely separate from, and
derived differently from the parameters fit to determine successful
cell-to-cell fire spread (described below). In simulations, cell-to-cell
and maximum daily fire spread are updated with daily FWI estimates until
the fire can no longer spread (e.g. disconnected fuels), FWI levels
reduces spread rates, or suppression is applied.

To estimate the fire spread parameters, spatial data are needed for
daily FWI, daily wind speed, daily wind direction, and fine fuel loading
for a set of reference fires. Daily fire perimeters are then overlain on
each of the datasets to extract successful and unsuccessful spread
areas. For the purposes of the Lake Tahoe West project, fire perimeters
were polyline layers and each of the fire spread variables were raster
datasets. Unsuccessful/successful spread areas could then be identified
as unsuccessful/successful spread cells and tracked throughout the
period of record.

Our approach allows unburned islands within perimeters which are
important ecologically and may cover 20% of the area within a perimeter.

*Data and parameterization*

We used the Sierra Nevada boundary defined by the Sierra Nevada
Conservancy to derive the data below (see Figure 3). Because fire
suppression is modeled as a separate process, we chose this area as
being broadly representative of the conditions found in the LTB, there
are many more fires (larger sample size), and fires in the area are
typically not extensively suppressed due to the rugged terrain.

![Greater Sierra](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/tree/master/Inputs-and-Methods/Images%20for%20methods/GS_AnalysisArea.png)

*Figure 3: Sierra Nevada analysis area for generating fire extension
parameters for the Lake Tahoe West project, outlined in black. Green
areas represent Forest Service administrative boundaries.*

Table 1. The following data sources were used to parameterize Lake Tahoe
West.

Data | Source
-----------|-------------
 Daily fire perimeters | GEOMAC from all available years (2000-2016). Data required preprocessing, which included year-to-year attribute name standardization, date convention standardization, geographic coordinate standardization, removal of blank or missing records, elimination of duplicate record days, elimination of days with 'negative' fire spread, etc <(https://rmgsc.cr.usgs.gov/outgoing/GeoMAC/historic_fire_data/>
  Fire Weather Index (FWI), Daily | Daily FWI was calculated using equations internal to the Climate Library (Lucash et al. 2017). Climate data used was Mauer daily gridded historical climate data available through the USGS GeoDataPortal. [<https://cida.usgs.gov/gdp/>.]{.underline} The climate data was produced for EPA level II ecoregions, which was then resampled into 30mx30m pixels to make it consistent with all other input maps.
  Fine fuel loads  | Fine fuel load maps were developed using LANDFIRE cover types and the associated fuel loading information (Reeves etal 2006) [[https://www.landfire.gov/documents/FuelProceedings.pdf]{.underline}](https://www.landfire.gov/documents/FuelProceedings.pdf)
  Daily wind speed  | Daily wind speed data used were summarized by the USGS GeoDataPortal, using the same EPA region mapping approach and resolution resampling as the FWI data.
  Daily wind direction | Because a continuous surface of historical daily wind direction is not available, we estimated wind direction as the direction of fire spread; daily fire polygon centroid-to-centroid azimuth was used as daily wind direction. Wind direction is not a direct input to fire spread, but rather is included in the effective wind speed calculation.

After the raster data were processed for extent and resolution,
successful and unsuccessful spread cells were extracted based on daily
fire progression. 'Unsuccessful' cells were defined as those that fell
on a fire perimeter that did not burn on the following day. Parameter
values were then estimated using a modified zero inflated Poisson
distribution. This modified form creates a 0-1 probability function
which is then applied at a daily time step to determine the success of
cell-to-cell fire transmission.

*2.1 Suppression*
Suppression accounts for the capacity to reduce the rare, or probability
of fire spread and is unique for each fire type. Suppression is
implemented as four zones per fire type: none, minimal, moderate,
maximal suppression. Each zone is assigned an integer reflecting
suppression effectiveness that reduce P~spread~ as a fraction
(effectiveness / 100). Zones are inputs as unique maps for each fire
type. The unique maps allow for different kinds of suppression dependent
upon circumstances. For example, lightning generated fires may be
allowed to naturally spread in more remote areas. Accidentally started
fires may be heavily suppressed in all areas.

Our suppression algorithms account for changes in suppression as
function of FWI whereby resources for suppression are typically
allocated more during more extreme fire weather (higher FWI). Two FWI
breakpoints determine when suppression efforts are increased. In
addition, a maximum wind speed limit limits suppression to days when
resources can be safely deployed.

Suppression zones were based on the 2014 multi-jurisdictional Tahoe Fire
and Fuels plan (data provided by Mason Bindl at Tahoe Regional Planning
Agency). We used the Threat and Defense Zone to identify three levels of
suppression ranging from highly (\~95%), moderately (\~65%), and very
low suppression (\~5%).

![Suppression_zones](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/tree/master/Inputs-and-Methods/Images%20for%20methods/SUPPRESSION_TFFP.png/)

One known issue was that the scenario designers wanted a \"paint the
corners\" approach to fire management. However, the same level of
suppression effort was used across all scenarios, instead of allowing
lightning fires to burn in wilderness areas under Scenario 4.

### 3. Fire Intensity 

We developed three classes of fire intensity, Low: \< 4' flame lengths;
Moderate: 4-8'; and High: \>8'. These intensity classes correspond to
metrics of intensity commonly used by fire managers. Corresponding
mortality severity classes were also defined (see below).

Unlike fire ignition and spread, empirical data of fire intensity are
not available at the regional scale. Although dNBR data exist, they do
not readily translate into intensity classes that can be related to
expert opinion and mortality. Therefore, we used a multi-condition risk
approach to determine whether a site burned at low (\< 4'), moderate
(4-8'), or high intensity. We defined three risk conditions:

1.  Does the mass (g m-2) of fine fuels exceed a pre-determined risk
    level?

2.  Does the mass (g m-2) of ladder fuels exceed a pre-determined risk
    level? Ladder fuels are assigned via a list of species with maximum
    ages that can be regarded as 'ladder fuels'. For example, white
    spruce aged 0-25 might be regarded as ladder fuels.

3.  Is the fire intensity of the source site (the neighboring site from
    where a fire spread) high intensity? A high severity fire will
    promote high severity fire as it spreads.

The default is low intensity. If one of these three conditions is true,
the intensity become moderate. If two or more conditions are true, the
fire is high intensity. Relationships between these three conditions and
historical fire intensity were created by assigning historical fires one
of the three fire intensity classes described above and extracting the
fuel loading data that corresponded to that fire (data from Forest
Service Region 5 GeoSpatial Information Center
<https://www.fs.usda.gov/detail/r5/landmanagement/gis/?cid=STELPRDB5327833>.
Fire intensity data is drawn from the same broad Sierra Nevada geography
as spread parameters, avoiding potential sampling bias towards small
high intensity fires which are most prominent in the Basin.

###  4. Fire Severity

Fire severity is the mortality caused by fire at each site and varies
depending on the tree species and ages present. A low severity fire, for
example, may cause extensive mortality if the forest is dominated by
fire-intolerant tree species. For each fire intensity class, a fire
severity table is defined that includes the age ranges and associated
probability of mortality for each tree species. A single random number
is drawn for each burned site (ensuring a consistent effect on all
trees). If Pmortality (from the corresponding fire severity table)
exceeds the random number, the cohort is killed. Biomass loss is
determined by cohort mortality. These data were collected using an
expert opinion approach whereby five fire experts for the LTB provided
estimates of mortality for varying species and age combinations. These
data were collected independently and collated and areas of disagreement
(indicated by high variance among experts) discussed and refined. See
the following link for the table of mortality values by species-age class: <https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/SCRAPPLE_LTW.txt>.

 
Harvest
=======

Scenarios are based solely on west shore for acres

-   While scenario acreage targets are based on LTW only, percent of
    acres within LTW compared to the entire Lake Tahoe Basin are very
    similar. The only difference is that LTW has a higher percentage of
    wilderness compared to the LTB, while the LTB has a higher
    percentage of general forest -- especially in steep slopes compared
    to LTW (see appendix A).

**Stand Delineation**

-   Everything over 116 ha (\~7062 total ha) were split into smaller
    polygons at maximum of 116 -- keeping larger end

-   Evaluated TPA, Seral Class, Slope, LMU, Vegetation type: CWHR,
    Channel, drainages, ridge top roads

-   Final stand delineation based on CWHR types and slope classes (0-30,
    30-50, 50-70, \>70%)

**Management Zones**

-   Management zones were developed using the stand delineation and
    treatment available (treatment available was based on distance from
    road, and slope with the assumption that the following priority took
    place: ground mechanical, aerial mechanical, hand thinning)

-   The underlying layers do not change between scenarios; however, the
    treatment zones do because they incorporate treatment type.

-   Each stand was assigned a management zone based on management zone
    that had its centroid in the stand

-   Each stand was assigned road distance of \<1000 feet or between 1000
    feet and 0.5 miles if the polygon was completely within that
    distance of the road.

*KNOWN ISSUES:*

These were issues found in the original parameterization. Fixes were
either incorporated into existing model runs or left for the next model
round.

1.  *SALVAGE LOGGING*
      a.  GOAL: Salvage is a priority over live thinning and occurs in both WUI
        Defense and WUI Threat. 90% of the area that experienced a high
        mortality event (from either fire or insects) would be salvaged
        prior to new live thinning occurring. 40% of the salvaged area
        would be replanted with: 80% Jeffrey pine, 10% cedar, 5% red
        fir, 5% sugar pine.
      b.  WHAT HAPPENED: Salvage logging was NOT implemented as expected. However, it
        could be added in the next round. Replanting did NOT occur. Note
        that the materials harvested do not appear within the harvest
        log file. Instead, they show as a reduction in the deadwood pool
        maps from the NECN extension.

2.  *STAND RE-ENTRY*
      c.  GOAL: Re-entry after harvest or disturbance was to be set at the
        dominant mean FRI types for each management zone.
      d.  WHAT HAPPENED: Stands were re-entered more than expected. MinTimeSinceDamage
        was the only restriction used when MinTimeSinceHarvest should
        also have been used. Additional replicates were run with the
        fixes:
          i.  Scenario 2: stand re-entry occurs at 20 years after
            disaster/harvest.
          ii. Scenario 3 & 4: stand re-entry occurs at 11 years.
      e.  The result of the changes was increased stand carbon since fewer
        young cohorts were wiped out. There were also fewer harvest
        events that resulted in nothing coming off the landscape.

3.  *HARVEST RESIDUES*
      f.  GOAL: 60% of hand thinning and 80% of mechanical thinning woody
        residue to be harvested.
      g.  WHAT HAPPENED: Only 5% of woody harvest residues were removed. Additional
        replicates were run with the corrected harvest targets.

SCENARIO 1
----------

The suppression only scenario does not have any separate management
zones as all zones receive 100% suppression. No other management
activities occur in this scenario.

SCENARIO 2: WUI Focused
-----------------------

Scenario 2 is focused on business as usual. This scenario focuses on
hand and mechanical treatments in the WUI, with 75% of the treatments
occurring in the defense zone (750 acres/year) and the other 25%
occurring in the threat zone (250 acres/year). During May 1^st^ to
November 1^st^, 80% of the treatments are hand thin treatments, while
20% of the treatments are mechanical treatments. Eighty percent of the
stand is thinned each time it is treated with 26% of the total biomass
removed using ground based mechanical and 8% of the total biomass
removed using hand thinning. There is no prescribed fire in this
scenario and all wildfires have 100% suppression. Salvage is a priority
over green forest treatments and can occur on 90% of the land within the
WUI up to the allocated annual acres. Reforestation occurs on 40% of the
salvaged acres. Stands can be re-entered after 20 years post disturbance
(post-disturbance includes thinning treatments, wildfire, and salvage).

(\*note 80% of the stand being treated during each entry is based on
data from South Shore Fuels).

*Management Zones *

There are five management zones in this scenario.

-   Defense Mechanical: This is the zone within the defense zone that
    can be treated with mechanical ground based equipment that can treat
    on less than 30% slopes and up to 1000 feet from any existing road.

-   Defense Hand: This is the zone within the defense that cannot be
    treated with mechanical equipment and has a slope less than 70%.

-   Threat Mechanical: This is the zone within the threat zone that can
    be treated with mechanical ground based equipment that can treat on
    less than 30% slopes and up to 1000 feet from any existing road.

-   Threat Hand: This is the zone within the threat zone that cannot be
    treated with mechanical equipment and has a slope less than 70%.

-   No Treatment: This is the area that does not receive any treatment
    as part of scenario 2. It is land found in the general forest and
    wilderness.

-   N/A: This is the area within the defense and threat zones that
    cannot be treated because the slope is greater than 70%.
    

![Management Zones](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/HarvestMaps/WUI_focused/Mgmt_zone_WUI_focus.tif)

![Stands](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/HarvestMaps/WUI_focused/mgmt_areas_scen2_2ha.tif)

Table 1: Management zones for scenario 2 based on management area plus
treatment type, with annual acres and percentage treated and total
available acres to treat in the zone.

  **Management Area** |  **Treatment**  | **Treatment Allocation By Zone**  | **Annual Treatment Acres**  | **Total Annual Acres**  | **Total Acres Available**
  ---------------------|---------------|----------------------------------|----------------------------|------------------------|----------------------------
  WUI Defense Zone |  Mechanical | 20% |  150 | 750 | 6545
                   | Hand | 80% | 600 | 10189
  WUI Threat Zone | Mechanical | 20% | 50 | 250 | 2512
                  | Hand  |  80%  | 200 | 12217
  General Forest | No treatment | 0 | 0 | 0 | 27025
  Wilderness | NA | NA | 0 | 0 | 0 | 89

*Acre targets*

-   Acres targets for year were based on the average for entire basin:
    2000 hand thin, 500 mechanical, 100 prescribed, 800 pile burning

    -   Based on ratio of hand to mechanical thinning we allocated 80%
        hand and 20% to mechanical

-   Based on the average acres treated across the LTB, we selected 1,000
    acre per year thinning/ salvage target; note: planting does not
    influence this treatment based on Salvage acres

-   In order to set treatment area targets within the Harvest extension,
    the average area treated by mechanical and hand prescriptions per
    year by management area was compiled (below).

-   The average treatment in the defense zone was 73.5% compared to
    22.9% threat zone -- we therefore selected a ratio of 75:25%
    defense:threat.

Table 2: Historic LTB data identifying hectares treated per year defined
by target area (Lake Tahoe West, CA, and NV broken out between defense
and threat zones).

 **Zone** | LTW-Defense | LTW-Threat | LTW-General | CA-Defense | CA-Threat | CA-General | NV-Defense | NV-Threat | NV-General
 ---------|-------------|------------|-------------|------------|-----------|------------|------------|-----------|------------
 Code\*    | 8          | 7          | 9           | 5          | 4        | 6           | 2          | 1         | 3
 Hectares | 6865 | 6117  | 10846 | 14335 | 7634 | 17437 | 7652 |  6001 |  7748
 Mean treated area /yr (ha) | 216.3 | 101.96 | 0 | 283.05 | 34.1 |  0 | 193.7 | 112.3 | 0
 Percentage of each zone treated | 68.0  | 32.0 |  0.0  | 89.2 | 0.1 | 0.0 |  63.3 | 36.7 |  0.0

*Biomass Targets*

Mechanical thinning is ground based only and can occur on
up to 30% slope and up to 1000 ft from existing road. 80% of dead
biomass is removed during thinning operations.

Table 3: Percent of live species removed by size classes using
mechanical thinning for scenario 2.

  **Mechanical**  | IC    | JP   | LP    | SP   | WF/RF | Total % Size Class
  ----------------|-------|------|-------|------|-------|--------------------
  \<10            | 10.71 | 9.54  | 39.37 |  4.20 |  29.17 |   93.00
  10-12           | 8.07  | 7.19  | 29.67 |  3.16 |  21.98 |   70.07
  12-14           | 7.54  | 6.71  | 27.70 |  2.95 |  20.52 |  65.43
  14-16           | 6.58  | 5.86  | 24.19 |  2.58 |  17.92 |   57.14
  16-18           | 5.18  | 4.62  | 19.05 |  2.03 |  14.12 |  45.00
  18-20           | 3.70  | 3.30  | 13.61 |  1.45 |  10.08 |   32.14
  20-22           | 2.63  | 2.35  | 9.68  |  1.03 |  7.17 |   22.86
  22-24           | 2.01  | 1.79  | 7.38  |  0.79 |  5.47 |   17.43
  24-26           | 1.48  | 1.32  | 5.44  |  0.58 |  4.03 |   12.86
  26-28           | 0.89  | 0.79  | 3.27  |  0.35 |  2.42 |   7.71
  28-30           | 0.49  | 0.44  | 1.81  |  0.19 |  1.34 |   4.29

DBH was cross-walked to age using methods developed by Angela White
(USFS). Biomass reductions were set equal to the 'Total % Size class'
reductions above, assuming that species differences would be determined
by the community at a given treated site. \*\*IC: incense cedar, JP:
Jeffrey pine, SP: sugar pine, WF/RF: white fir and red fir combined

Hand thinning can occur on slopes up to 70% slopes. 60% of
dead biomass removed during thinning operations

Table 4: Percent of live species removed by size classes using hand
thinning for scenario 2 and 3.

  **Hand Thin**  | IC   |  JP |    LP   |   SP  |   WF/RF |  Total % Size Class
  ---------------|------|------|-------|------|-------|--------------------
  \<10        |   7.60 | 6.77 | 27.94 | 2.98 | 20.70 | 66.00
  10-12       |   4.44 | 3.96 | 16.33 | 1.74 | 12.10 | 38.57
  12-14       |   4.44 | 3.96 | 16.33 | 1.74 | 12.10 | 38.57

\*\*IC: incense cedar, JP: Jeffrey pine, SP: sugar pine, WF/RF: white
fir and red fir combined

Suppression occurs at 100% in all areas regardless of
management zone.

SCENARIO 3: WUI Extended
------------------------

Scenario 3 is focused on using increased pace and scale with vegetation
thinning treatments driving the structure of the forest. This scenario
focuses on hand and mechanical treatments in the WUI, and general forest
with hand treatments occurring in the wilderness as well. Increased pace
of 4000 acres of treatment annual with 45% of the treatments occurring
in the defense zone (1800 acres/year), 25% occurring in the threat zone
(1000 acres/year), 25% occurring in the general forest (1000 acres), and
5% occurring in the wilderness (200 acres/year). During May 1^st^ to
November 1^st^, the proportion of treatments that are allocated to
ground based mechanical, aerial based mechanical, and hand thinning are
proportional to the total acres within each zone (see Table 5 for
specific allocations). Eighty percent of the stand is thinned each time
it is treated with 55% of the total biomass removed using ground based
mechanical and 8% of the total biomass removed using hand thinning. In
order to increase the pace and scale several factors have been pushed
including increased biomass removal compared to scenario 2, increased
slope accessibility for treatments using ground based equipment (up to
50% slope) and aerial based equipment (up to 70% slope and within 0.5
miles from a road), and increased DBH limits for removal (38"). There is
no prescribed fire in this scenario and all wildfires have 100%
suppression. Salvage is a priority over green forest treatments and can
occur on 90% of the land within the WUI defense and up to 60% of the
land within the WUI treat and general forest up to the allocated annual
acres. Reforestation occurs on 40% of the salvaged acres. Stands can be
re-entered after 11 years post disturbance (post-disturbance includes
thinning treatments, wildfire, and salvage) which is based on the
dominant mean fire return interval for the landscape (see Appendix D).

*Management Zones*

There are 11 management zones in this scenario.

-   Defense Ground Mechanical: This is the zone within the defense zone
    that can be treated with mechanical ground based equipment that can
    treat on less than 50% slopes and up to 1000 feet from any existing
    road.

-   Defense Aerial Mechanical: This is the zone within the defense zone
    that can be treated with aerial based equipment that can treat on
    less than 70% slopes and up to 0.5 miles from any existing road. The
    zones were defined so that if ground based mechanical could be used
    it would be.

-   Defense Hand: This is the zone within the defense that cannot be
    treated with mechanical equipment and has a slope less than 70%.

-   Threat Ground Mechanical: This is the zone within the threat zone
    that can be treated with mechanical ground based equipment that can
    treat on less than 50% slopes and up to 1000 feet from any existing
    road.

-   Defense Aerial Mechanical: This is the zone within the threat zone
    that can be treated with aerial based equipment that can treat on
    less than 70% slopes and up to 0.5 miles from any existing road. The
    zones were defined so that if ground based mechanical could be used
    it would be.

-   Threat Hand: This is the zone within the threat zone that cannot be
    treated with mechanical equipment and has a slope less than 70%.

-   General Forest Ground Mechanical: This is the zone within the
    general forest that can be treated with mechanical ground based
    equipment that can treat on less than 50% slopes and up to 1000 feet
    from any existing road.

-   General Forest Aerial Mechanical: This is the zone within the
    general forest that can be treated with aerial based equipment that
    can treat on less than 70% slopes and up to 0.5 miles from any
    existing road. The zones were defined so that if ground based
    mechanical could be used it would be.

-   General Forest: This is the zone within the general forest that
    cannot be treated with mechanical equipment and has a slope less
    than 70%.

-   Wilderness: This is the area within Wilderness with less than 70%
    slope that can be treated with hand thinning.

-   N/A: This is the area within the broader area with a slope greater
    than 70% than cannot be treated.
    
![Management Zones](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/HarvestMaps/WUI_extended/MgmtZone_Scen3.tif)

![Stands](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/HarvestMaps/WUI_extended/scen3_mgmt_areas_3ha.tif)
    

Table 5: Management zones for scenario 3 based on management area plus
treatment type, with annual acres and percentage treated and total
available acres to treat in the zone.

  **Management Area** | **Treatment\*** | **Treatment Allocation By Zone** | **Annual Treatment Acres** | **Total Annual Acres** | **Total Acres Available**
  ---------------------|-----------------|----------------------------------|----------------------------|------------------------|----------------------------
  WUI Defense     |     G Mechanical  |   44    |                             794             |            1800         |              7386
   |     A Mechanical  |    3    |                              59             |                         |              544
   |     Hand          |    53   |                              947            |                         |              8804
  WUI Threat      |     G Mechanical  |    23   |                              226            |              1000       |              3326
   |     A Mechanical  |    3    |                              25             |                         |              369
   |     Hand          |    75   |                              749            |                         |              11034
  General Forest  |     G Mechanical  |    8    |                              83             |              1000       |              1130
   |     A Mechanical  |    11   |                              113            |                         |              1551
   |     Hand          |    80   |                              804            |                         |              10983
  Wilderness      |     Hand          |    100  |                              200            |              200        |              12773
  NA              |     NA            |    100  |                              0              |              0          |              677

\*G stands for ground based mechanical and A stands for aerial based
mechanical

\*\*If these management zones need to be further collapsed, aerial and
ground based could be merged because they have the same biomass
removals. If this occurred the acres and allocation would just be
summed. However, they were kept separate at this point for potential
need from water quality modeling and for tracking nuance, which
theoretically could be tracked post model runs. This would reduce the
total model runs from 10 to 7.

*Acre targets*

-   Acres targets for year were developed based on Landscape Resilience
    Assessment (LRA). There are 38,284 acres of non-resilient Trees Per
    Acre based on LRA, which was rounded up to 40,000

-   It was then determined that if we wanted to treat all these acres
    over 10 years 4,000 acres would need to be treated annually year

*Biomass Targets*

Mechanical thinning

Ground based treatments can occur on up to 50% slope and up to 1000 ft
from existing road. 80% of dead biomass is removed during thinning
operations. This treatment does not occur in the wilderness. An increase
to 50% slope was selected because a self-levelling cab excavator can go
up to 50% slope and this pushes the slope limits to maximum that LTW
would consider.

Aerial based treatments (yarding-cable/helicopter) can occur on up to
70% slope and within 0.5 miles of a road. Distance to road was
determined based on average distance helicopter can thin, which varies
based on elevation, slope, etc. Ground based treatments occur as
priority over aerial treatments.

Biomass removal is the same regardless of method. 55% of the biomass is
removed (see appendix B and C for methodology). 80% of dead biomass
removed during thinning operations.

Table 6: Total acres by slope class for each management area within 1000
feet of a road.

  **Within a 1000ft of a Road** | **Acres**
  -------------------------------|------------
  **General Forest**        |     **3,894**
  \>70%                     |     175
  0-30%                     |     2,023
  30-40%                    |     591
  40-45%                    |     193
  45-50%                    |     206
  50-70%                    |     704
  N/A                       |      2
  **WUI - Defense**         |      **14,521**
  \>70%                     |      295
  0-30%                     |      10,535
  30-40%                    |      1,356
  40-45%                    |      446
  45-50%                    |      454
  50-70%                    |      1,365
  N/A                       |      71
  **WUI - Threat**          |      **10,647**
  \>70%                     |      159
  0-30%                     |      7,415
  30-40%                    |      1,431
  40-45%                    |      390
  45-50%                    |      375
  50-70%                    |      854
  N/A                       |      23
  **Grand Total**           |      **29,062**

Table 7: Percent of live species removed by size classes using
mechanical thinning for scenario 3 with no tree greater than 38" DBH
being removed (Appendix B).

  **Populated Species/Size Class** | IC   |  JP  |  LP   |  SP  |  WF/RF | Total % Size Class
  ----------------------------------|-------|------|-------|------|-------|--------------------
  \<10                            |  10.95|  9.75 | 40.22 | 4.29 | 29.80 | 95.00
  10-12                           |  10.95|  9.75 | 40.22 | 4.29 | 29.80 | 95.00
  12-14                           |  9.79 |  8.72 | 35.99 | 3.83 | 26.66 | 85.00
  14-16                           |  9.79 |  8.72 | 35.99 | 3.83 | 26.66 | 85.00
  16-18                           |  9.79 |  8.72 | 35.99 | 3.83 | 26.66 | 85.00
  18-20                           |  8.64 |  7.70 | 31.75 | 3.38 | 23.53 | 75.00
  20-22                           |  8.06 |  7.18 | 29.64 | 3.16 | 21.96 | 70.00
  22-24                           |  6.91 |  6.16 | 25.40 | 2.71 | 18.82 | 60.00
  24-26                           |  4.03 |  3.59 | 14.82 | 1.58 | 10.98 | 35.00
  26-28                           |  2.30 |  2.05 | 8.47  | 0.90 | 6.27 |  20.00
  28-30                           |  1.15 |  1.03 | 4.23  | 0.45 | 3.14 |  10.00
  30-32                           |  1.15 |  1.03 | 4.23  | 0.45 | 3.14 |  10.00
  32-34                           |  1.15 |  1.03 | 4.23  | 0.45 | 3.14 |  10.00
  34-36                           |  1.15 |  1.03 | 4.23  | 0.45 | 3.14 |  10.00
  36-38                           |  0.58 |  0.51 | 2.12  | 0.23 | 1.57 |  5.00

\*IC: incense cedar, JP: Jeffrey pine, SP: sugar pine, WF/RF: white fir
and red fir combined

Hand thinning occurs in all management zones on slopes up
to 70%. Total biomass removal will stay at 8% and be same species
removal ratios as scenario 2 (Table 4) because it is not feasible to
remove more material by hand across the landscape.

Suppression occurs at 100% in all areas regardless of
management zone.

SCENARIO 4: WUI Extended Rx Focus
---------------------------------

Scenario 4 is focused on using increased pace and scale with fire
driving the structure of the forest. Thinning treatments only occur in
the defense zone and follow the same prescription as under scenario 2.
Hand and mechanical treatments occur only in the WUI defense (750
acres/year). During May 1^st^ to November 1^st^, 80% of the treatments
are hand thin treatments, while 20% of the treatments are mechanical
treatments. Eighty percent of the stand is thinned each time it is
treated with 26% of the total biomass removed using ground based
mechanical and 8% of the total biomass removed using hand thinning.
Salvage only occurs in the WUI defense and is a priority over green
forest treatments; this activity can occur on 90% of the land within the
WUI defense up to the allocated annual acres. Reforestation occurs on
40% of the salvaged acres. Stands can be re-entered after 11 years post
disturbance (post-disturbance includes thinning treatments, wildfire,
and salvage), which is based on the dominant mean fire return interval
for the landscape (see Appendix D). Suppression continues at 100% in the
WUI defense. However, managed wildfire is allowed to burn in all other
zones. Prescribed fire is used in all zones. The target acres of fire
(weather prescribed or managed) will guide number of ignitions and
percent suppression for scenario 4 inputs based on model iterations to
test this. The goal is to burn 3250 acres of prescribed fire up to
moderate severity in all zones annually.

![Management Zones](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/HarvestMaps/WUI_extended/MgmtZone_Scen3.tif)

![Stands](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/LTW_LANDIS_Scenarios/HarvestMaps/WUI_extended/scen3_mgmt_areas_3ha.tif)


*Management Zones *

There are six management zones in this scenario.

-   Defense Mechanical: This is the zone within the defense zone that
    can be treated with mechanical ground based equipment that can treat
    on less than 30% slopes and up to 1000 feet from any existing road.

-   Defense Hand: This is the zone within the defense that cannot be
    treated with mechanical equipment and has a slope less than 70%.

-   Threat Burn: Threat zone where there will be no thinning and only
    burning will be allowed.

-   General Forest Burn: General Forest where there will be no thinning
    and only burning will be allowed.

-   Wilderness Burn: General Forest where there will be no thinning and
    only burning will be allowed.

-   N/A: This is the area within the defense and threat zones that
    cannot be treated because the slope is greater than 70%.

Table 8: Scenario 4 management zones based on management area plus
treatment type, with annual acres and percentage treated and total
available acres to treat in the zone.

  **Management Area** | **Treatment**  |  **Treatment Allocation By Zone** | **Annual Treatment Acres** | **Total Annual Acres** | **Total Acres Available ** | **Target Acres Fire**
  ---------------------|----------------|----------------------------------|----------------------------|------------------------|----------------------------|-----------------------
  WUI Defense Zone | Mechanical/Burn | 20% | 150 | 750 | 6545 | 410
   |  Hand/Burn | 80% | 600  | 10189 | 640
  WUI Threat       |    Burn Only | 0  |  0 |  0 |  14751 | 1000
  General Forest   |    Burn Only | 0 | 0 | 0 | 13729 | 1000
  Wilderness       |    Burn Only | 0 | 0 | 0 | 13296 | 200
  NA               |    NA |  NA  | 0 |  0 | 67 | 0

*Acre targets*

-   Acres targets for year were developed based on Landscape Resilience
    Assessment (LRA). There are 38,284 acres of non-resilient Trees Per
    Acre based on LRA, which was rounded up to 40,000

-   It was then determined that if we wanted to treat all these acres
    over 10 years 4,000 acres would need to be treated annually year

-   We determined that thinning would still occur within the defense
    zone due to structures and so that remained at 750 acres based on
    scenario 2. The remaining acres were then allocated among the
    remaining zones with a heavier emphasis on the defense zone
    treatments and a lighter emphasis on wilderness (similar to scenario
    3 allocations).

*Biomass Targets*

Mechanical thinning is ground based only and can occur in
the WUI defense on up to 30% slope and up to 1000 ft from existing road.
80% of dead biomass is removed during thinning operations. See table 3
for the percent of live species removed by size classes using mechanical
thinning.

Hand thinning can occur on slopes up to 70% slopes in the
WUI defense. 60% of dead biomass removed during thinning operations. See
table 4 for percent of live species removed by size classes using hand
thinning.

Suppression occurs at 100% only in WUI defense. The other
zones have managed wildfire during specific fire weather windows to meet
total acreage targets of fire in other zones.

*Prescribed Fire*

Fire treatments are implemented differently in LANDIS compared to
thinning treatments. Fire treatments are not confined to the stand map
and therefore and not held to acreage. Inputs into LANDIS focus on
number of ignitions, rather than acres. Alec will determine how many
prescribed fires combined with how much suppression under certain
conditions equal the target acreage and use this number as the number of
ignitions and percent suppression in each zone. These values will not be
the exact target acreage during time step. The ignition probability map
(raster cell scale) for prescribed fire starts will be weighted by
management zone so that more ignitions would start in defense zone to
reach the higher acreage targets in this zone. In general, fires in the
defense zone will be smaller than outside of the defense zone because of
the level of effectiveness parameters that were set in LANDIS. In the
WUI suppression is 90% effectives, in WUI buffer -- 60% effective, and
in general forest -- 5% effective. While these numbers may seem
intuitively low since the LTB on average is 90% effective at suppressing
fire, regardless of zone -- the values represent the size of fires that
have occurred in the LTB and therefore are assumed to be a good
representation of what has occurred as far as suppression.

The input parameters in respect to prescribed burning are provided
below. The burn window is set through allowable wind speed and min and
max fire weather index (FWI). Based on historical prescribed fire data,
max wind speed was this at 24.79 mph and max FWI was approximately 13.
In addition to wind speed and FWI, a cap on prescription intensity can
be provided based on maximum prescription fire intensity which are tied
to mortality values by age and species. Theoretically it is possible to
have an escaped fire, however Alec has not been able to make it happen.

*Prescribed Fire Parameters*

-   MaximumRxWindSpeed 8.0

-   MaximumRxFireWeatherIndex 10.0

-   MinimumRxFireWeatherIndex 8.0

-   MaximumRxFireIntensity 2

    -   This is based on allowable flame lengths: 1) \<4ft, 2) 4-8
        ft, 3) \>8ft (note in the LRA we said that \> 6 foot flame
        length was considered high severity and was undesirable if
        patches were above 40 acres). We selected intensity class 2
        because a) it depends on stand conditions what effect of flame
        length is, b) it is more representative of pinning a corner, c)
        we recognize that fires may need to burn hotter to reach
        objectives, and d) small patches of higher severity are okay it
        is the large contiguous patches that indicate lower resilience.
        This may be a factor that we want to adjust in scenario 5.

-   NumberRxAnnualFires 5 -- this will be adjusted through iterations of
    model to reach target acres

*Additional Considerations Evaluated but not included*

Fire break zones were evaluated based on where fire breaks would be
naturally established on the landscape. We evaluated two zones: Fire
break outside defense: determined using a 100 m buffer from existing
roads (everything on impervious roads and forest service maintenance) +
LMU ridge top stands defined in EcObject + 100 m buffer on powerlines
and Fire break inside defense: determined using a 100 m buffer from
existing roads (everything on impervious roads and forest service
maintenance) + LMU ridge top stands defined in EcObject + 100 m buffer
on powerlines + structures with 100 m buffer. However, we decided not to
use fire breaks in order to more completely "pin corners" of this
scenario really focusing on using fire, and possibility that fire can be
used as fuel break rather than thinning.

Base BDA
========

We simulated three bark beetle species (JPB, MPB, and FEB) that cause
the majority of insect mortality in the LTB. For many bark beetle
species, climate influences outbreaks in three ways: low winter
temperatures cause beetle mortality; year-round temperatures influence
development and mass attack; and drought stress reduces host resistance.
Here, we model climate influences as a function of drought and host
density alone, recognizing that the full suite of climatic influences is
necessary for a fully mechanistic model. For this project, outbreaks
occur randomly between a set of minimum and maximum intervals (Table 1).

Bark beetle outbreaks (mortality that exceeds background mortality,
which was captured in the NECN-H extension) were modeled using the
Biological Disturbance Agent (BDA) extension. This extension simulates
tree mortality from insect outbreaks and can represent multiple insects
simultaneously. The BDA assigns insect-specific resource requirements
and tree species-specific vulnerability that varies by cohort age.
Within BDA, sites are probabilistically selected for disturbance based
upon the host density at a given site; non-hosts reduce site disturbance
probability. Disturbance probability therefore is an emergent property
of host density that can be altered by other mortality agents, including
wildfire and fuels management. Cohort mortality at an outbreak site is
subsequently determined by species' age and host susceptibility
probabilities (Table 2). The susceptibility of each cohort to insect
mortality was derived from empirical field studies and expert opinion.
Following mortality, dead biomass remains on site and was either added
to the downed woody debris C pool or the fine woody debris C pool.

Trees under 10 years old were immune/ignored by Fir engraver and JPB,
with increasing vulnerability as the trees aged.

Table 1


  Dispersal Parameters | Fir Engraver | Jeffrey Pine Beetle | Mountain Pine Beetle
  ---------------------|----------------|---------------------|----------------------
  Pattern           |   Cyclic Uniform | Cyclic Uniform   |    Cyclic Uniform
  Min interval      |   10             | 10               |    10
  Max interval      |   25             | 25               |    25
  Min time since    |   5              | 5                |    5
  NeighborhoodFlag  |   No             | No               |    Yes
  NeighborhoodSpeedUp | None           | None             |    2x
  Radius             |  10,000m        | 10,000m          |    2,000m
  Shape              |  Uniform        | Uniform          |    Uniform
  Weight             |  20             | 20               |    20
  Dispersal Rate     |  1000m/yr       | 400m/yr          |    600m/yr
  Epidemic Threshold |  0.01           | 0.01             |    0.01
  Seed Epicenter     |  Yes            | Yes              |    Yes
  Seed Epicenter Coef | 0.01           | 0.01             |    0.01
  Dispersal Template  | MaxRadius      | MaxRadius        |    MaxRadius

Table 2

Agent | Species Name | Minor Host Age | SRDProb | 2nd Host Age | SRDProb | Major Host Age | SRDProb | Susceptibility Class3 | MortProb | Susceptibility Class2 | MortProb | Susceptibility Class1 | MortProb | CFS
-|-|-|-|-|-|-|-|-|-|-|-|-|-|-|
Fir Engraver | AbieConc | 0 |	0 |	10 |	0.99 |	60 |	0.99 |	0 |	0 |	10	| 0.15 |	60 |	0.35	| yes
Fir Engraver | AbieMagn |	0 |	0 |	10 |	0.9 |	60 |	0.8 |	0 |	0 |	10 |	0.05 |	60	| 0.15 |	yes
JPB |	PinuJeff |	0 |	0.1 |	20 |	1 |	25 |	1 |	0 |	0.1 |	40 |	0.5 |	120 |	0.1 |	yes
MPB |	PinuAlbi |	20 |	0.33 |	60 |	0.66 |	80 |	0.9 |	20 |	0.05 |	60 |	0.1 |	80 |	0.2 |	yes
MPB |	PinuLamb |	20 |	0.33 |	60 |	0.66 |	80 |	1 |	20 |	0.05 |	60 |	0.2 |	80 |	0.5 |	yes
MPB |	PinuCont |	20 |	0.33 |	60 |	0.66 |	80 |	0.9	| 20 |	0.05 |	60 |	0.1 |	80 |	0.2	| yes
MPB |	PinuMont |	20 |	0.33 |	60 |	0.66 |	80 |	0.9	| 20 |	0.05	| 60 |	0.1 |	80 |	0.2 |	yes

White pine blister rust was not incorporated into this model at this
time. There is limited information related to the rate of spread and
impacts on overall mortality. It is expected to respond to increasing
temperature and precipitation. However, there is not enough information
to parameterize the extension at this time. One potential workaround
would be to just raise the background mortality rate through adjusting
the monthly wood mortality parameter in NECN.

References:

Jactel 1991
USFS Fir Engraver Facts
Schwilk 2006
Ferrel 1994
Joel Egan (USFS) conversation
MPB CFS Synthesis
Safranyik 2006
Cole and Amman
Bradley and Tueller 2001

Climate Change
==============

![climate comparison](https://github.com/LANDIS-II-Foundation/Project-Lake-Tahoe-2017/blob/master/Inputs-and-Methods/Images%20for%20methods/avg_annual_temp.png)

**Notes:**

-   The Maurer (historical gridded) data set is not particularly good in
    its representation of the historical trends that you will find in
    actual (pre-gridded) site observations.

-   The Maurer data set does not do well capturing extreme events.

-   The Maurer data set was used as a calibration source for the CMIP 3
    projections (which explains the continuity with the climate data
    used by Louise).

-   Maurer is also 2°C colder minimum temps than other comparable
    historical datasets.

-   PRISM is likely the most "accurate" (per Mike Dettinger) at
    representing broadscale historical trends.

-   PRISM and UIdaho are in line with CMIP5 projections.

-   All climate projections are designed to represent trends at the
    sub-continental scale, not basin scale.

I do not know why the CanESM rcp 4.5 and GFDL rcp 8.5 were the
projections selected---other than those were the same GCMs used by
Loudermilk. Gridded climate data from 30 GCMs and rcps were provided by
Mike Dettinger but were not analyzed. Ideally more than one GCM and rcp
would be used.
