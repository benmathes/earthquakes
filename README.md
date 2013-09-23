### TLDR;

Check it out on Heroku:

### To set up:

* Install Postgres. Postgres.app is a great way to do this on mac: http://postgresapp.com/
* Install postGIS: http://postgis.net/install
  * I followed the heroku setup instructions since I wanted to get this running live: https://devcenter.heroku.com/articles/postgis
  * You may have some issues, this worked for me: https://github.com/PostgresApp/PostgresApp/issues/111
  * may need to run this on the database initially to give the db user read access to the GIS tables:
    # GRANT SELECT ON geometry_columns TO earthquakes;
    # GRANT SELECT ON geography_columns TO earthquakes;
    # GRANT SELECT ON spatial_ref_sys TO earthquakes;



### Some ambiguities/explanations/commentary/etc.

* As is expected with most side web projects, 90% of my time was spent gluing rails/postgres/postGIS/heroku/googlemaps together (read "get error message, google for stack overflow, figure out and fiddle with configurations), and 10% on "real" programming (e.g. writing models)
* Grouping by region: since a region is defined as "within 25 miles of a place" and *every* earthquake is at a place, grouping by region is taken to mean including ALL quakes within a region for ALL quakes. E.g. if there are 10 quakes total, all within 2 miles of each other, there are 10 regions, each one containing the 9 other quakes.
*







