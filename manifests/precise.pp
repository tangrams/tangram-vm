exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

# Ensure apt-get update has been run before installing any packages
Exec["apt-update"] -> Package <| |>

package {
    "build-essential":
        ensure => installed,
        provider => apt;
    "python":
        ensure => installed,
        provider => apt;
    "python-dev":
        ensure => installed,
        provider => apt;
    "python-setuptools":
        ensure => installed,
        provider => apt;
    "python-software-properties":
        ensure => installed,
        provider => apt;
}

package { "python-pip": 
  ensure => latest,
}

exec { "ppa:ubuntugis":
  command => "/usr/bin/add-apt-repository ppa:ubuntugis && /usr/bin/apt-get update",
  require => Package['python-software-properties'],
}

package {
	"libgdal1":
		ensure => latest,
		provider => apt;
	"postgresql-9.3":
		ensure => latest,
		provider => apt;
	"postgresql-9.3-postgis-2.1":
		ensure => latest,
		provider => apt;
	"postgresql-client-9.3":
		ensure => latest,
		provider => apt;
	"protobuf-compiler":
		ensure => latest,
		provider => apt;
	"libprotobuf-c0-dev":
		ensure => latest,
		provider => apt;
	"protobuf-c-compiler":
		ensure => latest,
		provider => apt;
	"libprotobuf-dev":
		ensure => latest,
		provider => apt;
	"libtokyocabinet-dev":
		ensure => latest,
		provider => apt;
	"python-psycopg2":
		ensure => latest,
		provider => apt;
	"libgeos-c1":
		ensure => latest,
		provider => apt;
	"postgresql-contrib":
		ensure => latest,
		provider => apt;
}

exec { "createuser":
  command => "createuser osm -s -d",
	user => postgres
}
exec { "createdb":
  command => "createdb -O osm osm",
	user => postgres
}
exec { "postgres-extension:hstore":
  command => "psql -d osm -c \"CREATE EXTENSION hstore;\"",
	user => postgres
}
exec { "postgres-extension:adminpack":
  command => "psql -d osm -c \"CREATE EXTENSION adminpack;\"",
	user => postgres
}
exec { "postgres-extension:postgis":
  command => "psql -d osm -c \"CREATE EXTENSION postgis;\"",
	user => postgres
}


package {
	"git-core": 
		ensure => latest,
		provider => apt;
	"dh-autoreconf": 
		ensure => latest,
		provider => apt;
	"libxml2-dev": 
		ensure => latest,
		provider => apt;
	"libbz2-de": 
		ensure => latest,
		provider => apt;
	"libgeos-dev": 
		ensure => latest,
		provider => apt;
	"libproj-dev": 
		ensure => latest,
		provider => apt;
	"libpq-dev": 
		ensure => latest,
		provider => apt;
	"libgeos++-dev": 
		ensure => latest,
		provider => apt;
}

package {
	"shapely": 
		ensure => latest,
		provider => pip,
		require => Package['python-pip'];
	"PIL": 
		ensure => latest,
		provider => pip,
		require => Package['python-pip'];
	"modestmaps": 
		ensure => latest,
		provider => pip,
		require => Package['python-pip'];
	"simplejson": 
		ensure => latest,
		provider => pip,
		require => Package['python-pip'];
	"werkzeug": 
		ensure => latest,
		provider => pip,
		require => Package['python-pip'];
}

