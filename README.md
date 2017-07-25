# predictCyclists

At the moment all the stuff in this repo is a work-in-progress and pretty messy. There will be a better documentation very soon.

Data (`.xlsx` files) come from the [Stadt Münster](http://www.stadt-muenster.de/verkehrsplanung/verkehr-in-zahlen/radverkehrszaehlungen/neutor.html), `.csv` files were converted by me.
The files contain the number of cyclists that passed every hour at the counting location Neutor which is [roughly located here](http://www.openstreetmap.org/#map=19/51.96683/7.61577). In addition, the temperature and the wind speed is given. For 2016, also the general weather conditions are provided.

The idea is to predict number of cyclists based on date, hour, weather, etc. For now, this is done using a Bayesian regression model in `R` (see `predictNoOfBikes.R` file). One could potentially also compare the number of cars at the same location, for which the [data are here](http://www.stadt-muenster.de/verkehrsplanung/verkehr-in-zahlen/kfz-verkehrszaehlungen/neutor.html). The vision is to calculate this online using the live data from different counting stations throught Münster.

