### Sadly, no Heroku live version.

After investin time installing/learning/configuring postGIS, I discovered Heroku's fine print on using postGIS: you must have a *production tier* databse, the cheapest of which appears to be $50 a month. For a one-off, that's sadly not worth it. Read more: https://devcenter.heroku.com/articles/postgis


### To set up:

* (I'm assuming you have some kind of ruby and ruby version manager installed)
* Install Postgres. Postgres.app is a great way to do this on mac: http://postgresapp.com/
* PostGIS should come installed with postgresapp.com, but if you aren't using that, install instructions: http://postgis.net/install
* clone this repo
* `cd` into the repo
* `bundle install`
* `bundle exec rake db:create && bundle exec rake db:migrate` to create the development and test databses
* `bundle exec rake earthquakes:import`
* `whenever --update-crontab` to install the cron jobs (or don't if you don't want to poll for them every 15 minutes on your own machine)
* in postgres: `CREATE EXTENSION postgis;`
* If you get this issue: `Library not loaded: /usr/local/lib/libtiff.5.dylib`, then `brew install libtiff`. Read more: https://github.com/PostgresApp/PostgresApp/issues/111
* in postgres: `ALTER ROLE earthquakes SUPERUSER`, (or the GIS postgres extension won't work. Not ideal security, but again, a one-off project.
* `bundle exec rails server`
* have a look at http://http://localhost:3000/quakes
* Or run some tests: `bundle exec rake test`


### Some ambiguities/explanations/commentary/etc.

* As is expected with most side web projects, 90% of my time was spent gluing rails/postgres/postGIS/heroku/googlemaps together (read "get error message, google for stack overflow, figure out and fiddle with configurations), and 10% on "real" programming (e.g. writing models)
* Grouping by region: since a region is defined as "within 25 miles of a place" and *every* earthquake is at a place, grouping by region is taken to mean including ALL quakes within a region for ALL quakes. E.g. if there are 10 quakes total, all within 2 miles of each other, there are 10 regions, each one containing the 9 other quakes.
* 