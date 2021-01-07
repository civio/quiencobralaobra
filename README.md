###System dependencies

* Ruby 2.5.1
* Rails 4.2.10
* Postgres 9.3+

###Installing the app

Install required gems:

    $ bundle install

In OS X, if using Postgres.app as the database, the 'pg' gem may throw an error. If so, install it [manually](http://edgar.tumblr.com/post/113599678239/install-pg-gem-in-mac-os-x-with-postgresapp) specifying the path to Postgres.app.

Install JS dependencies (a working installation of Node needed):

    $ npm install

Create the database:

    $ rake db:create

Create the first user (admin@quiencobralaobra.es / password) using the DB seeds:

    $ rake db:seed

Then load a small subset of real contract data, which will automatically create a number of public authorities and bidders:

    $ rake data:import_awards[db/awards.csv]

Load UTE-companies mapping:

    $ rake data:import_utes
