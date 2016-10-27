###System dependencies

* Ruby 2.2
* Rails 4.2.4
* Postgres 9.3? 9.4?

###Installing the app

Install required gems:

    $ bundle install

In OS X, if using Postgres.app as the database the 'pg' gem will throw an error. Install it [manually](http://edgar.tumblr.com/post/113599678239/install-pg-gem-in-mac-os-x-with-postgresapp) specifying the path to Postgres.app.

Create the database:

    $ rake db:create

Create the first user (admin@quiencobralaobra.es / password) using the DB seeds:

    $ rake db:seed

Load UTE-companies mapping:

    $ rake data:import_utes

Then load a small subset of real contract data, which will automatically create a number of public authorities and bidders:

    $ rake data:import_awards[db/awards.csv]

Or, if you're feeling brave:

    $ rake data:import_awards[/Users/David/Box\ Sync/Civio/Proyectos/07\ Quién\ cobra\ la\ obra/02\ Data/Limpieza\ y\ análisis/\!2009-2015/2009-2015.csv]

Load CPV codes (not needed for now):

    $ rake data:import_cpv

