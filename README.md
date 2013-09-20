### TLDR;

Check it out on Heroku:

### To set up:

* Install Postgres. Postgres.app is a great way to do this on mac: http://postgresapp.com/
* Install postGIS: http://postgis.net/install
  * I followed the heroku setup instructions since I wanted to get this running live: https://devcenter.heroku.com/articles/postgis
  * You may have some issues, this worked for me: https://github.com/PostgresApp/PostgresApp/issues/111
  * need to run this on the database initially to give the db user read access to the GIS tables:
    # GRANT SELECT ON geometry_columns TO earthquakes;
    # GRANT SELECT ON geography_columns TO earthquakes;
    # GRANT SELECT ON spatial_ref_sys TO earthquakes;


###







