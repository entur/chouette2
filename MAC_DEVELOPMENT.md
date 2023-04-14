Notes on developing on a Mac
------------

* Install a ruby version manager (e.g. rvm or chruby).
* Install and switch to ruby v2.7.8

Run the following commands:

```sh
gem update --system 3.3.8
gem install bundler -v 2.3.22
```

Install some prerequisites:

```sh
brew install libffi geos proj
```

Configure libffi:

```sh
export LDFLAGS="-L/usr/local/opt/libffi/lib"
export CPPFLAGS="-I/usr/local/opt/libffi/include"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
```

Chouette depends on an older version of libProj. Newer versions that are pre-installed on Linux/MacOS exposes a
different API. The last version of libProj that exposes both the old and new API is 7.2

Download https://download.osgeo.org/proj/proj-7.2.1.tar.gz and
then follow instructions from https://proj.org/install.html#compilation-and-installation-from-source-code.

The first 3 build steps are sufficient.

Then export the PROJ4_LIBRARY_PATH env variable:

```ssh
export PROJ4_LIBRARY_PATH=/<path>/proj-7.2.1/build/lib
```

Install gem dependencies:

```sh
bundle install
```

Start a postgres database with Docker:

```sh
docker run --name=chouette -d \
  -e POSTGRES_USER=chouette -e POSTGRES_PASSWORD=chouette -e POSTGRES_DBNAME=chouette -e ALLOW_IP_RANGE=0.0.0.0/0 \
  -p 5432:5432 --restart=always postgis/postgis:13-3.1
```

If you want to run a database with test data from dev, you may need to run Postgres directly on the OS. 
Use the official Postgres app: https://postgresapp.com/ (don't use Homebrew, it won't work). Download version 13 or 14 and follow the installation guide.

After installation, you have to create a chouette and grant it superuser privileges:

```sh
psql
```

In the sql prompt:

```sql
CREATE USER chouette with password 'chouette';
ALTER USER chouette WITH SUPERUSER;
```

Create development and test databases:

```sh
# Create databases
bundle exec rake db:create
```

If running Postgres.app you have to install postgis extension manually. Also, if you want to import data from dev,
make sure to install it in the correct place, since Google Cloud SQL stores it in shared_extension schema instead
of the public/postgres (?) schema

```sh
psql -d chouette -u chouette
```

In the sql prompt:

```sql
CREATE SCHEMA shared_extensions;
CREATE EXTENSION postgis SCHEMA shared_extensions;
```


# Add some configuration files

Before you can run tests or start the application locally, you must have two configuration files in the config folder:
`application.yml` and `database.yml`. The example files in the config file give some hints but these are better:


`database.yml` (no modifications needed, just copy and paste this):

```yml
default: &default
  adapter: postgis
  encoding: unicode
  port: 5432
  host: localhost
  schema_search_path: 'public,shared_extensions'
  username: chouette
  password: chouette
  postgis_schema: 'shared_extensions'

development:
  <<: *default
  database: chouette

test:
  <<: *default
  database: chouette-test
```

`application.yml` (modifications needed, get secret_key_base and devise_secret_key from a friend):

```yml
secret_key_base: XXX # get this from a friend
devise_secret_key: XXX # get this from a friend
domain_name: 'localhost:3001'
api_endpoint: 'http://localhost:8080/chouette_iev/'
google_analytic_tracker:
geoportail_api_key:
newrelic_licence_key:
osrm_endpoint: 'http://osrm-bus:5000'
osrm_endpoint_list: '{"coach": "http://osrm-bus:5000", "bus": "http://osrm-bus:5000", "water": "http://osrm-water:5000", "rail": "http://osrm-rail:5000"}'
deactivate_formats_referential: hub,sig
deactivate_formats_import: hub,sig
deactivate_formats_export: hub,sig
smtp_delivery_method: sendmail
smtp_host: localhost
smtp_port: "25"
smtp_domain: rutebanken.org
smtp_user_name:
smtp_password:
smtp_authentication:
mailer_sender: 'no-reply@rutebanken.org'
capistrano_deploy_user:
IEV_VERSION: '1.0'
IEV_HOST: 'http://localhost'
IEV_PORT: '8080'
IEV_PATH: 'chouette_iev'
SPEC_VALIDATION_URL_PROD: 'http://www.chouette.mobi/validation/V2_3'
SPEC_VALIDATION_URL: 'http://preview.chouette.cityway.fr/validation/v24'
PROGRESS_BAR_TIMEOUT: '60000'
openlayers_default_map: osm
restriction_format:
REDIS_URL: redis://localhost:6379/chouette
PASSENGER_COMPILE_NATIVE_SUPPORT_BINARY: "0"
PASSENGER_DOWNLOAD_NATIVE_SUPPORT_BINARY: "0"
```

# Running tests

First migrate test database:

```sh
bin/rails db:migrate RAILS_ENV=test
```

And run the test suite:

```sh
bundle exec rake spec
```

If you want to import data from dev into local database for development, 
get your hands on an SQL dump and run the following command:

```sh
psql -h localhost -p 5432 -U chouette -d chouette < /path/to/dump.sql
```

Before starting the application you must run database migrations:

```sh
bundle exec rake db:migrate
```

If you are not running [chouette](https://github.com/entur/chouette) locally, you must create a port-forward to a
dev instance:

```sh
kubectl port-forward chouette-XXX-yyy -n chouette  8080
```

Finally, start a redis server, if you want to test validation reports:

```sh
docker run -p 127.0.0.1:6379:6379 -d redis redis-server
```

Now you are finally ready to run the application:

```sh
RAILS_ENV=development bundle exec rails server
```

# Set up in IntelliJ

Running Chouette2 in IntelliJ should be straight forward (given the above steps have been completed and are working).

First, make sure the Ruby plugin is installed. If you opened Chouette2 in IntelliJ before you installed the Ruby plugin,
things may not work correctly. Close IntelliJ, delete the .idea folder and open it again (after you installed the plugin).

Now, IntelliJ should have correctly identifed Chouette2 as a Ruby on Rails project, but you must still set the correct
SDK version.

Go to File -> Project Structure:
* Under Project -> Project Settings -> SDK, select 2.7.8 (there may be more than one option).
* Under Module -> Chouette2 -> Ruby SDK and gems, select 2.7.8 (there may be more than one option).
* Under Platform setttings -> SDKs, select 2.7.8 (there may be more than one option).

Double check run configurations for RSpec and Rails, but they should be configured correctly out of the box.

You can run tests either in individual spec files or the entire spec folder.

To run the application choose run Rails -> Development.
