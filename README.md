[![Code Climate](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung/badges/gpa.svg)](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung)
[![Test Coverage](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung/badges/coverage.svg)](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung)
[![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=master)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
[![Dependency Status](https://gemnasium.com/hpi-swt2/event-und-raumplanung.svg)](https://gemnasium.com/hpi-swt2/event-und-raumplanung)
event-und-raumplanung
=====================

Ein Tool das die interne Planung von Events verbessern soll und dabei besonderen Fokus auf die Zuteilung von Räumen und Ausstattung legt.


Setup
-----
Es gibt zwei Möglichkeiten das Projekt aufzusetzen. Einmal mit einer virtuellen Maschine und Vagrant
(langsamer, geht dafür auch unter Windows) oder direkt auf deinem System.

Wenn du Vagrant (mit psql) benutzen willst:

    vagrant up
    vagrant ssh
    cd hpi-swt2
    # Lokale docs machen die Gem-Installation langsamer und brauchen
    # Speicherplatz
    echo “gem: --no-document” >> ~/.gemrc
    bundle install
    gem install pg
    cp config/database.psql.yml config/database.yml
    exit

Ihr könnt das System auch mit sqlite nutzen (nicht empfohlen):

    bundle install --without=production
    cp config/database.sqlite.yml config/database.yml

Um `rails` zu starten müsst ihr folgendes ausführen:

    vagrant ssh
    cd hpi-swt2
    rails s





