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

Then load a small subset of real contract data, which will automatically create a number of public authorities and bidders:

    $ rake data:import_awards

Load CPV codes (not needed for now):

    $ rake data:import_cpv
