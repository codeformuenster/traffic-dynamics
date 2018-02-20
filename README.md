# traffic-dynamics

In this project, the automatic countings of bicycles and cars in Münster (Westf.), Germany are analyzed.
This repository contains a Docker image in which the data are downloaded, preprocessed, and subsequently put in a database.
The data come originally from the Stadt Münster and [are available in this repository](https://github.com/codeformuenster/open-data/tree/master/verkehrsdaten).
The docker image from this repository is at [the docker hub](https://hub.docker.com/r/codeformuenster/traffic-dynamics/).
The source code can be best understood by following the pipeline in [src/000_run_pipeline.R](https://github.com/codeformuenster/traffic-dynamics/blob/master/src/000_run_pipeline.R).

There exists a front-end web-app visualizing the data using Shiny. The [shiny-web-app is here](https://traffics.codeformuenster.org), the code for the front-end can be found in [this repository](https://github.com/codeformuenster/traffic-dynamics-shiny).

We are in the process of adding analyses of these data with machine learning and statistical tools.

# Ideas for future development

* use machine learning tools to predict the number of traffic participants:
	The idea is to predict number of cyclists based on date, hour, weather, etc. 
	There is already some work done using Bayesian and non-Bayesian regression models (see files `src/06_Bayesian_glms.R` and `src/06_glm_regression.R`). 
* add model benchmarking (e.g. RMSE score, based on cross-validation)
* migrate 'negative-binomial regression' to 'linear regression', due to normal distribution of target variable during day hours
* grab live data from EcoCounter counting machines via https://github.com/derhuerst/eco-counter-client
* interactive visualization of statistical model
* compute ratio of space needed by bikes vs cars and the actual numbers of bikes/cars passing by
* impute missing weather observations (assuming similar weather as e.g. 30 minutes earlier)

## Ideas from talking to bike stakeholders

* Pendler quantifizieren
  * Tagesverlauf (Pendlerpulse) visualisieren -> Pendler identifizieren
  * Daten zu stadtein- und auswärts nutzen
  * Wo / wann wird gependelt?
* Ausweichen auf andere verkehrsmittel
  * Umstieg der Pendler aufs Auto im Winter / bei Schlechtwetter?
  * "Regeneffekt"
  * Vergleich mit Autozählstellen
  * Ausweichen auf ÖPNV oder auf Auto?
* Auto & Luftqualität -> mehr Autos, schlechtere Luft?

## Notizen / Ideen seitens der Stadt:

- Daten sind nicht "kontrolliert" -> es kann gut sein, dass manche Zählschleifen nicht funktionieren oder manche Zählschleifen vertauscht sind. 
- Gibt es mehr Verkehr auf dem Albersloher Weg wegen Autobahnanschluss Hiltrup?
- Radverkehr verhält sich sehr ähnlich zum Kfz-Verkehr (vom Muster her)
- Münster ist Kfz-verkehrsmäßig am Limit, 3-4 % mehr Autos und es gibt Stau (z.B. bei schlechtem Wetter)
- Radverkehrsplanung ist Schönwetterplanung

## Contributors

* [silberzwiebel](https://github.com/silberzwiebel)
* [ThorbenJensen](https://github.com/ThorbenJensen)

## Rechtliches

### Quelltext

Copyright © 2017-2018 Thorben Jensen, Thomas Kluth

#### Deutsch 

Dieses Programm ist Freie Software: Sie können es unter den Bedingungen
der GNU General Public License, wie von der Free Software Foundation,
Version 3 der Lizenz oder (nach Ihrer Wahl) jeder neueren
veröffentlichten Version, weiterverbreiten und/oder modifizieren.

Dieses Programm wird in der Hoffnung, dass es nützlich sein wird, aber
OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
Siehe die GNU General Public License für weitere Details.

Sie sollten [eine Kopie der GNU General Public License zusammen mit diesem
Programm erhalten haben](COPYING). Wenn nicht, siehe <http://www.gnu.org/licenses/>.

#### Englisch

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have [received a copy of the GNU General Public License
along with this program](COPYING). If not, see <http://www.gnu.org/licenses/>.

### Daten

Datenquelle: Stadt Münster

[Datenlizenz Deutschland – Namensnennung – Version 2.0](http://www.govdata.de/dl-de/by-2-0) (oder [diese pdf-Datei](doc/Stadt_MS_OpenData_Datenlizenz_Deutschland.pdf))


The following text is not up-to-date due to repository restructuring (but it's still here to not get lost) -- we are working on it, stay tuned!

## Computing all Bayesian regression models using Docker

In the file `src/03_Bayesian_glms.R` there are some Bayesian regression models specified. Those can be computed with the help of the R package [brms](https://cran.r-project.org/package=brms). Since the computation takes some time and you might also not like to fiddle around with installing all the prerequisites, we created a docker image that you could run on any docker capable computer. After you've run the image you should have some models files saved to your disk in the `results` directory.

This is how to start the docker image.
First, build it and give it a name (here `predictcyclists`):

sudo docker run --rm --privileged -v $PWD/test:/home/rstudio/results -ti codeformuenster/predict-cyclists:master 

```
sudo docker build -t predictcyclists .
```

Then run the docker image and tell it to run the `src/03_Bayesian_glms.R` file:

```
sudo docker run --rm --user rstudio -v $(pwd):/home/rstudio -w /home/rstudio predictcyclists Rscript src/03_Bayesian_glms.R
```

If you are running a linux distribution with enabled SELinux support (like Fedora) and get a permission error, you could try to add the `--privileged` flag to the docker command. Otherwise, you might disable SELinux temporarily with `sudo setenforce 0` (check with `getenforce`). Don't forget to enable it back again afterwards with `sudo setenforce 1`.

If all went fine, you should have some `.RData` files (that contain `brms` model fits) after the docker run in the `results` folder. It will take some time, though!

