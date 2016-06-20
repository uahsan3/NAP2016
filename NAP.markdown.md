
---
title: New American Pathways Houusing Locator
author: Data Science for Social Good
output: html_document
runtime: shiny
---
New American Pathways Housing Scout
========================================================
The goal of our project is to create an online tool for scouting locations to resettle refugees in Fulton and Dekalb counties GA.

Primary Selection Criteria 

1. Price 

2. Proximity to Public Transit 

3. Public Safety 


Secondary Selection Criteria 

1. Proximity to schools, grocery stores, faith centers, and other community facilities 

2. Distance to New American Pathways HQ

3. Access to jobs & retail


Data We've Collected 

* All Apartment Buildings in Fulton and Dekalb Counties 
* Index data on affordability, job access, and retail access 
* Crime data 
* Faith Centers 
* Grocery stores and markets 
* Schools
* ESL resources 
* MARTA transit stops 



```r
library(rgdal)
library(raster)
library(magrittr)
library(leaflet)
library(shiny)
library(knitr)

setwd("C:/Users/Jack/Dropbox/MVP/data")

Units <- read.csv("units.csv", header = T, sep = ",")

leaflet() %>% addTiles("http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>% 
    setView(-84.3851808, 33.785859, zoom = 10) %>% addCircles(lat = ~Latitude, 
    lng = ~Longitude, data = Units, popup = Units$Apartment_name, opacity = 0.5)
```

<!--html_preserve--><div id="htmlwidget-618" style="width:504px;height:504px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-618">{"x":{"calls":[{"method":"addTiles","args":["http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false}]},{"method":"addCircles","args":[[33.860196,33.918275,33.781227,33.782327,33.783092,33.871128,33.785346,33.919488,33.91946,33.789779,33.784953,33.771828,33.783139,33.822298,33.797441,33.792165,33.792301,33.703437,33.702903,33.77025,33.812238,33.843827,33.696244,33.857136,33.799589,33.938476,34.042682,33.770558,33.784345,33.840581,33.777675,33.864071,33.750373,33.778353,33.769708,34.063367,33.842775,33.769105,33.787016,34.044536,33.777423,33.846885,33.756172,33.768635,33.801491,33.773041,33.618212,33.753953,33.772362,33.811073,33.837519,34.104342,33.682096,33.786709,34.063359,33.820052,33.760525,34.036344,33.76898,33.765663,33.770698,33.851539,33.660603,33.799269,33.738055,33.789738,33.703688,33.747433,33.711277,33.747641,33.915168,34.017375,34.054735,34.00733,33.853564,33.746806,33.789368,33.762271,33.819116,33.724667,33.715281,33.863423,33.92775,33.785799,33.895535,33.78883,33.8213,33.757295,33.751038,33.718441,33.745048,34.004415,33.708272,33.73502,33.681114,33.70996,34.030523,33.702767,33.851729,33.926502,33.771541,33.773136,33.85029,33.75294,33.838281,33.707141,33.58719,33.81525,33.776395,33.672105,33.67181,33.826302,33.788675,33.853249,33.770799,33.647414,33.774829,34.014558,33.926723,34.04879,33.763859,33.992734,33.890535,33.929482,33.764172,33.809163,33.867467,34.028723,33.813326,33.654695,33.848071,34.062995,33.748697,33.807957,33.807957,33.845775,33.846656,33.756223,33.777921,33.819172,33.609377,33.766297,33.773491,33.835994,33.673919,33.785,33.700815,33.81732,33.830303,33.826112,33.81583,33.839768,33.670977,33.892075,33.701008,33.809986,33.803508,33.631996,33.666648,33.907127,33.815289,33.83778,33.707895,33.910914,33.802936,33.919341,34.104254,33.922633,33.772233,33.843735,33.837947,33.758383,33.83434,33.915116,33.802469,33.7192,33.745352,33.728826,33.722367,33.699914,33.813179,33.815248,33.798086,33.734797,33.693617,33.723245,33.751521,33.82108,33.946228,33.769061,33.768731,33.779811,33.707999,33.650315,33.865821,33.764897,33.759747,33.89297,33.579916,34.001014,33.711649,33.903599,33.721511,33.628032,33.887014,33.758269,33.856376,33.883397,33.717531,33.684373,33.981725,33.74882,33.761323,33.850352,33.75532,33.808519,33.80086,33.798707,33.815126,33.810086,33.794938,33.797726,33.652226,33.815213,33.764942,33.813956,34.04931,33.937758,33.815173,33.68332,33.653992,33.737563,33.64899,33.659807,33.700395,33.711511,33.727087,33.757916,33.751497,33.794019,33.720184,33.790285,33.739351,33.744133,33.75768,33.734152,33.927665,33.764024,33.811516,33.694295,33.692822,33.768142,33.920718,33.770775,33.73674,33.745708,33.726811,33.893655,33.696858,33.696234,33.713516,33.701357,33.715433,33.72535,33.821099,33.693446,34.072657,33.789796,33.780052,33.699284,34.098158,33.812493,33.92759,33.690605,33.771882,33.700304,33.890543,33.650366,33.666798,33.750331,33.733574,33.734087,34.043264,33.943634,33.993915,33.916841,33.923384,33.930097,33.973235,33.953049,33.922702,33.799476,33.799539,33.809923,33.705481,33.698436,33.741774,33.711655,33.964401,33.700364,33.755615,33.786112,33.836375,33.809377,33.62314,33.801336,33.791567,33.842567,33.815314,33.740861,33.822679,34.054129,33.887247,33.681228,33.886776,33.849959,33.763275,33.757965,33.819999,33.92554,33.772925,33.714818,33.708232,33.705255,33.904288,33.663353,33.712183,33.753557,33.780253,33.78119,33.848295,33.80195,33.807736,33.792979,33.837491,34.02005,33.794736,33.792645,33.825548,33.646204,33.748644,33.777042,33.796309,33.737829,33.943907,33.743757,34.038452,33.843747,33.626298,33.735084,33.707796,33.807817,33.818406,33.998817,33.972851,33.665286,33.692434,33.703874,33.705753,34.071565,33.798818,33.856534,33.951794,33.890898,33.927106,33.757889,33.753894,33.676565,33.709868,33.733552,33.621472,33.888362,33.696133,33.668534,33.742877,33.569089,33.674257,33.708035,33.734021,33.909469,33.711902,33.809717,33.765864,33.700546,33.802145,33.985181,33.797814,33.910408,33.792925,33.775732,33.80441,33.761219,33.723801,33.993997,33.86482,33.878891,34.100915,33.796823,33.907992,33.907791,33.761965,33.75981,33.750047,33.918429,33.826155,33.771607,33.745708,33.789869,33.921811,33.840562,34.056847,33.782139,33.819425,33.765899,33.849883,33.752013,33.901616,33.812672,33.743065,33.799634,33.796038,33.928128,33.763783,33.647038,33.894354,33.664362,33.818289,33.710827,33.649057,33.970927,33.841026,33.776573,33.964911,33.857156,33.816393,33.705506,33.80151,34.008035,33.776951,33.917636,33.921731,33.764124,34.039754,33.713893,33.71669,33.760781,33.826507,33.760258,33.831944,33.796865,33.811807,34.016892,33.764389,33.76384,33.74818,33.786243,33.741059,33.740582,33.660284,33.849359,33.78895,33.754668,33.813728,33.763895,33.892286,33.794336,33.810694,33.809322,33.882245,33.820569,33.826347,33.564897,33.969459,33.910035,33.810516,33.82105,33.783949,33.67016,33.936551,33.755238,33.762556,33.76285,33.79623,34.001882,33.904193,33.887094,33.675612,33.655736,33.770102,33.788422,34.051241,33.771306,33.761912,33.798895,33.84247,33.84063,34.102731,33.752648,33.767603,34.072713,33.780115,33.784578,33.767675,33.768929,33.720166,33.720794,33.584634,33.584776,34.026495,33.742981,33.887881,33.757348,33.812729,33.69696,33.795196,33.708016,33.713398,34.05056,33.924411,34.013424,33.941967,33.684194,33.750141,33.874747,33.793542,33.915837,33.917576,33.77177,33.844879,33.883031,33.939068,33.844161,33.903153,33.679799,33.739046,33.929025,33.813665,33.931565,33.783699,33.789697,33.904864,33.749726,33.758809,33.863401,33.906487,33.906716,33.837839,33.772746,33.850581,33.853135,33.702776,33.785657,33.89573,33.794249,33.868158,33.761193,33.815287,33.869927,33.866431,33.808958,33.934536,33.850029,33.862756,33.819591,33.782038,33.818517,33.869342,33.84163,33.594101,33.837821,33.733191,33.656241,33.933638,33.849474,33.707983,33.702144,33.706982,33.843984,33.760177,33.760811,33.702548,33.652738,33.875839,33.920107,33.815221,33.750126,33.661118,33.752646,33.75173,33.999966,34.023678,33.790663,33.740075,34.058265,33.860188,34.026391,33.848831,34.026578,34.02005,33.762702,33.85027,33.664576,33.90178,34.080957,33.820166,33.719368,33.925278,33.770304,33.696677,33.992951,33.858124,33.791535,33.891246,33.807024,33.893159,33.706414,33.81519,33.568682,33.862849,33.911473,33.754904,33.820386,33.784687,33.777499,33.813791,33.709401,33.774154,33.840871,33.900406,33.820331,33.615225,33.650365,33.806214,33.900898,33.696463,33.960863,33.958726,33.789259,33.757053,33.718347,33.822374,33.800829,33.844491,33.757197,33.788214,33.795334,33.883227,33.838017,33.748234,33.668068,33.748197,34.101888,33.728756,33.66619,33.679626,33.735026,33.673151,33.767776,33.768098,33.781698,33.813208,33.712613,33.671595,33.922903,33.971314,33.923388,33.788439,33.86579,33.789527,34.095567,33.8934,33.790782,33.790757,33.809435,33.844335,33.780176,33.930376,33.930376,33.731132,33.860925,33.848068,33.973208,33.710443,33.784937,34.026288,34.026288,33.809701,33.926408,33.78754,33.907373,33.908382,33.886257,33.788458,33.870299,33.849153,33.793166,33.697851,33.813333,34.008051,34.006612,33.798468,34.082404,33.585194,33.659062,33.647678,33.746612,34.078576,33.671664,33.927079,33.928967,33.835736,33.810222,33.961358,33.813823,33.704912,33.761562,33.795909,33.687206,33.821008,33.692733,33.714004,33.824901,33.776073,33.765275,33.822892,33.984325,33.83632,34.069107,33.7656,33.700145,33.781868,33.991075,34.052658,33.704042,34.050405,33.847517,33.950676,33.753494,33.812785,33.838956,33.864116,33.756012,34.016407,33.703945,33.894007,33.842775,33.918888,33.730987,33.705963,33.903432,33.849419,33.708928,33.712846,33.746732,33.769038,33.711728,33.671781,33.694379,33.747247,33.765649,33.796078,33.786905,33.853065,33.728569,33.818243,33.79343,33.923943,33.585194,33.856195,33.823066,33.755084,33.736767,33.800983,33.859894,33.807425,33.729653,33.710813,33.751815,33.743887,33.98145,33.631038,33.850271,33.668718,33.825957,33.82225,33.725802,33.702628,34.100007,34.099984,33.68475,33.743687,33.676668,33.708122,33.70957,33.835804,33.707938,33.721979,33.679567,33.780863,33.702751,34.011612,33.661796,33.667889,33.786602,33.755159,33.993829,33.785861,33.818674,34.075126,33.69803,33.993535,33.709889,33.68003,33.694646,33.967101,33.682951,33.813661,33.723519,33.807672,33.793129,33.753166,33.723816,33.778137,33.834644,33.720526,33.755125,33.717914,33.818402,33.801956,34.005611,33.773363,33.80847,33.810092,33.808273,33.783778,33.768112,33.908545,33.787019,33.787016,33.854262,34.090272,33.708193,33.926673,34.065184,34.025506,33.901436,33.71987,33.890986,33.809046,33.798073,33.897063,33.734215,33.810315],[-84.333582,-84.294549,-84.390101,-84.411841,-84.379409,-84.338175,-84.384571,-84.348967,-84.348353,-84.387948,-84.385701,-84.38265,-84.344223,-84.231156,-84.391599,-84.396859,-84.396856,-84.462633,-84.312314,-84.378153,-84.304499,-84.358936,-84.157344,-84.34626,-84.402466,-84.368508,-84.33911,-84.362926,-84.384946,-84.382925,-84.408647,-84.286215,-84.489284,-84.384779,-84.307315,-84.20881,-84.426199,-84.382279,-84.380719,-84.285738,-84.298077,-84.35617,-84.364782,-84.079056,-84.411638,-84.382952,-84.459824,-84.488788,-84.299004,-84.389475,-84.375764,-84.265651,-84.50137,-84.300568,-84.285294,-84.365281,-84.387581,-84.309469,-84.366363,-84.365526,-84.365735,-84.302054,-84.508234,-84.369418,-84.196243,-84.425386,-84.464287,-84.542352,-84.135239,-84.328691,-84.3003,-84.195845,-84.323636,-84.353628,-84.205797,-84.404873,-84.388181,-84.416774,-84.445392,-84.570546,-84.327289,-84.299001,-84.331725,-84.244001,-84.230311,-84.212265,-84.194113,-84.196145,-84.377912,-84.52339,-84.417841,-84.278574,-84.145822,-84.41492,-84.367513,-84.444329,-84.320422,-84.276323,-84.349218,-84.335027,-84.381343,-84.288837,-84.249631,-84.371815,-84.309303,-84.137999,-84.534515,-84.245419,-84.477687,-84.387608,-84.387554,-84.357142,-84.421786,-84.296701,-84.290784,-84.474609,-84.275467,-84.181902,-84.334716,-84.181449,-84.423574,-84.346439,-84.229309,-84.299089,-84.352048,-84.266175,-84.288335,-84.313852,-84.354543,-84.410599,-84.34779,-84.244059,-84.43377,-84.413099,-84.413099,-84.37128,-84.343941,-84.38083,-84.386706,-84.237869,-84.474774,-84.362501,-84.356939,-84.209918,-84.391402,-84.38727,-84.450652,-84.33573,-84.325313,-84.339423,-84.451945,-84.371467,-84.459062,-84.323909,-84.406268,-84.38936,-84.401927,-84.491218,-84.465679,-84.383218,-84.31689,-84.371796,-84.140433,-84.262426,-84.397144,-84.307741,-84.266008,-84.305013,-84.378778,-84.382324,-84.314917,-84.374713,-84.384828,-84.376261,-84.337145,-84.276354,-84.384106,-84.387048,-84.408232,-84.419658,-84.424659,-84.236243,-84.277238,-84.437453,-84.515017,-84.511253,-84.411692,-84.352261,-84.373019,-84.392185,-84.392383,-84.401754,-84.456074,-84.484404,-84.286006,-84.382617,-84.321122,-84.29153,-84.532475,-84.280404,-84.205861,-84.374368,-84.324306,-84.474867,-84.378883,-84.418024,-84.298049,-84.379332,-84.112315,-84.401547,-84.345592,-84.391806,-84.373587,-84.248006,-84.38128,-84.308894,-84.308225,-84.247186,-84.242679,-84.245118,-84.214227,-84.322201,-84.469467,-84.397263,-84.457744,-84.425831,-84.261791,-84.350349,-84.39656,-84.396162,-84.494293,-84.242057,-84.360855,-84.355103,-84.426262,-84.383133,-84.281501,-84.344924,-84.470531,-84.450333,-84.314602,-84.449452,-84.254639,-84.383576,-84.340971,-84.310349,-84.307535,-84.385498,-84.291296,-84.357109,-84.351796,-84.359443,-84.269533,-84.375096,-84.533043,-84.31864,-84.179385,-84.233829,-84.171619,-84.17465,-84.264612,-84.261764,-84.19119,-84.395851,-84.426129,-84.256285,-84.255824,-84.288395,-84.27759,-84.484696,-84.256204,-84.425871,-84.313933,-84.457073,-84.280462,-84.159458,-84.379301,-84.478772,-84.472547,-84.469156,-84.428439,-84.428478,-84.221513,-84.351882,-84.343036,-84.30186,-84.305027,-84.271339,-84.353305,-84.35311,-84.296,-84.470961,-84.470983,-84.187502,-84.48326,-84.323683,-84.31446,-84.187954,-84.37544,-84.261004,-84.336654,-84.411007,-84.37977,-84.435127,-84.460995,-84.328238,-84.304186,-84.317444,-84.234652,-84.358907,-84.371555,-84.325337,-84.3172,-84.372398,-84.316725,-84.358332,-84.45443,-84.419744,-84.249528,-84.310335,-84.364151,-84.254429,-84.359755,-84.356363,-84.267168,-84.405552,-84.204592,-84.403193,-84.415898,-84.416149,-84.310995,-84.327805,-84.375296,-84.306053,-84.37425,-84.331501,-84.305622,-84.340816,-84.338077,-84.488466,-84.335958,-84.387038,-84.265325,-84.403841,-84.36378,-84.354086,-84.335968,-84.250713,-84.475789,-84.531535,-84.138599,-84.191597,-84.333982,-84.353106,-84.370096,-84.467635,-84.624826,-84.45325,-84.135514,-84.27873,-84.203457,-84.292692,-84.355799,-84.319872,-84.331612,-84.370495,-84.412995,-84.41675,-84.190933,-84.402763,-84.512983,-84.269133,-84.45015,-84.494481,-84.510717,-84.517629,-84.415302,-84.487465,-84.226792,-84.380875,-84.291653,-84.198031,-84.354377,-84.160405,-84.309283,-84.342998,-84.405419,-84.385698,-84.337772,-84.364024,-84.249197,-84.364637,-84.322051,-84.280531,-84.297613,-84.291532,-84.256342,-84.244409,-84.360145,-84.359539,-84.358633,-84.36203,-84.403265,-84.375574,-84.363956,-84.381321,-84.31864,-84.275128,-84.266985,-84.428546,-84.174928,-84.382166,-84.31168,-84.236791,-84.357564,-84.324871,-84.266864,-84.191596,-84.221324,-84.242548,-84.236948,-84.274468,-84.193452,-84.485662,-84.231661,-84.5001,-84.181575,-84.29108,-84.493526,-84.373049,-84.260606,-84.384809,-84.353024,-84.347034,-84.351793,-84.151376,-84.21755,-84.339291,-84.40847,-84.360119,-84.312454,-84.449484,-84.325905,-84.398239,-84.342194,-84.255576,-84.362753,-84.361632,-84.321437,-84.208146,-84.373802,-84.32386,-84.38223,-84.510324,-84.377859,-84.380708,-84.403037,-84.404784,-84.504143,-84.370444,-84.400435,-84.390634,-84.391946,-84.253521,-84.307068,-84.25563,-84.260254,-84.370236,-84.248089,-84.448374,-84.344988,-84.520258,-84.359112,-84.37824,-84.191968,-84.191352,-84.159834,-84.461088,-84.35059,-84.389281,-84.391469,-84.359629,-84.243753,-84.278152,-84.368519,-84.300024,-84.417047,-84.438334,-84.391359,-84.289249,-84.226058,-84.351672,-84.36021,-84.247989,-84.230609,-84.24271,-84.26469,-84.402274,-84.253052,-84.260299,-84.248174,-84.251742,-84.341441,-84.247133,-84.426129,-84.427262,-84.532562,-84.531204,-84.325438,-84.43767,-84.381042,-84.384554,-84.366645,-84.26175,-84.276514,-84.591186,-84.327551,-84.302784,-84.35313,-84.302731,-84.368276,-84.492206,-84.473374,-84.255535,-84.279623,-84.376482,-84.360552,-84.30261,-84.332702,-84.379985,-84.270831,-84.329961,-84.236712,-84.406119,-84.250435,-84.351216,-84.389933,-84.271402,-84.386201,-84.477225,-84.275491,-84.37801,-84.355559,-84.303759,-84.368655,-84.37182,-84.385469,-84.294328,-84.358067,-84.380717,-84.271293,-84.302538,-84.236855,-84.210049,-84.449094,-84.373785,-84.331908,-84.330656,-84.383466,-84.416049,-84.335778,-84.349656,-84.340401,-84.371615,-84.379541,-84.375276,-84.448363,-84.317415,-84.551665,-84.371931,-84.510331,-84.438581,-84.380415,-84.251384,-84.448158,-84.475087,-84.26423,-84.427463,-84.236952,-84.233249,-84.474784,-84.495491,-84.256076,-84.378295,-84.248254,-84.229642,-84.523466,-84.350162,-84.360882,-84.334316,-84.333241,-84.472584,-84.3641,-84.326749,-84.33618,-84.356198,-84.381478,-84.33304,-84.331501,-84.258737,-84.319876,-84.459398,-84.24002,-84.318386,-84.227254,-84.569557,-84.332428,-84.38016,-84.267125,-84.277293,-84.293063,-84.400572,-84.227959,-84.193189,-84.287767,-84.453365,-84.27094,-84.51242,-84.296229,-84.384766,-84.486491,-84.230769,-84.388245,-84.383199,-84.337529,-84.204467,-84.385172,-84.426422,-84.237179,-84.364667,-84.48165,-84.484237,-84.178036,-84.38157,-84.51927,-84.360969,-84.353809,-84.226749,-84.305607,-84.27215,-84.232413,-84.394597,-84.211824,-84.352146,-84.400891,-84.208813,-84.257143,-84.327803,-84.333724,-84.501318,-84.33445,-84.249069,-84.187354,-84.468279,-84.394756,-84.530327,-84.385256,-84.391668,-84.360302,-84.408345,-84.188225,-84.110925,-84.389389,-84.312591,-84.356416,-84.334332,-84.305036,-84.185409,-84.400568,-84.232877,-84.332449,-84.39758,-84.397686,-84.333717,-84.426252,-84.411487,-84.335745,-84.335742,-84.323883,-84.287261,-84.375175,-84.361407,-84.18969,-84.277654,-84.328897,-84.328897,-84.391496,-84.330347,-84.405043,-84.377283,-84.377231,-84.24546,-84.403338,-84.336865,-84.357203,-84.404841,-84.145042,-84.395088,-84.316546,-84.315799,-84.233315,-84.279557,-84.527189,-84.508373,-84.488682,-84.377524,-84.315252,-84.460482,-84.328968,-84.333555,-84.337919,-84.427934,-84.35902,-84.395875,-84.117158,-84.382435,-84.27964,-84.31288,-84.179595,-84.62514,-84.277724,-84.366746,-84.300055,-84.40508,-84.211388,-84.353937,-84.342288,-84.256565,-84.378064,-84.465594,-84.494406,-84.334949,-84.175631,-84.158861,-84.177788,-84.341734,-84.371709,-84.191324,-84.423196,-84.378433,-84.379549,-84.404939,-84.181108,-84.110756,-84.229068,-84.426199,-84.305567,-84.388812,-84.37441,-84.372288,-84.326135,-84.21189,-84.390294,-84.408348,-84.382238,-84.292135,-84.38943,-84.293752,-84.496806,-84.382315,-84.398273,-84.381582,-84.382188,-84.362279,-84.368928,-84.246929,-84.31361,-84.527189,-84.38093,-84.370734,-84.391157,-84.256948,-84.264127,-84.298387,-84.265947,-84.193534,-84.448446,-84.376946,-84.41898,-84.352546,-84.491075,-84.382418,-84.462399,-84.316399,-84.316397,-84.358454,-84.446084,-84.264817,-84.264804,-84.494957,-84.31477,-84.405457,-84.399416,-84.202256,-84.31537,-84.111535,-84.319471,-84.369521,-84.366495,-84.159661,-84.300119,-84.537962,-84.543231,-84.4139,-84.238959,-84.336022,-84.412216,-84.195682,-84.278533,-84.262171,-84.352919,-84.21984,-84.09935,-84.105819,-84.360688,-84.096304,-84.394346,-84.577326,-84.183199,-84.447793,-84.366855,-84.579122,-84.412344,-84.386728,-84.509712,-84.375137,-84.276599,-84.237639,-84.190078,-84.394646,-84.35035,-84.3029,-84.306958,-84.180956,-84.247377,-84.237286,-84.363758,-84.380721,-84.380719,-84.352534,-84.23777,-84.136499,-84.266708,-84.239718,-84.326921,-84.235908,-84.144819,-84.290671,-84.292149,-84.230504,-84.283617,-84.232548,-84.185589],10,null,null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2,"dashArray":null},null]}],"setView":[[33.785859,-84.3851808],10,[]],"limits":{"lat":[33.564897,34.104342],"lng":[-84.62514,-84.079056]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

