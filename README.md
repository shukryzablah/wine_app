Wine App
========

Live Version
------------

The production version of the application is deployed at:  
<a href="https://szablah.shinyapps.io/wine/" class="uri">https://szablah.shinyapps.io/wine/</a>

You can run the repository's HEAD app with the following command:  

    shiny::runGitHub("wine_app", "shukryzablah", subdir = "app/")

Or you can follow our progress at:
<a href="https://github.com/shukryzablah/wine_app" class="uri">https://github.com/shukryzablah/wine_app</a>

A full report is available in /index/_book/finalreport.pdf.

Screenshots
-----------

The wine reviews used in this application are taken from
[kaggle](https://www.kaggle.com/zynicide/wine-reviews). We geocoded the
wineries using the Google Maps Static API and used `leaflet` to create
an interactive visualization in our `shiny` app.

![screenshot of clustered wineries in a map](./assets/map1.png) *Fig. 1:
Screenshot of clustered wineries in interactive leaflet map in web app.*

![screenshot of catalog of wines with links to locate entry to
map](./assets/table1.png) *Fig. 2: Screenshot of wine reviews catalog.
Note each entry has link to locate itself in map.*

Future Work
-----------

- [ ]  Include summary statistics related to view in draggable panel.
- [X]  Tweak user experience with map
- [X]  Extraction of features from description text.
- [X]  Creation of model to allow prediction of wine quality.
