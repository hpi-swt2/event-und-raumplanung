[![Code Climate](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung/badges/gpa.svg)](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung)
[![Test Coverage](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung/badges/coverage.svg)](https://codeclimate.com/github/hpi-swt2/event-und-raumplanung)
[![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=master)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
[![Dependency Status](https://gemnasium.com/hpi-swt2/event-und-raumplanung.svg)](https://gemnasium.com/hpi-swt2/event-und-raumplanung)
[![Heroku](https://heroku-badge.herokuapp.com/?app=event-und-raumplanung)](http://event-und-raumplanung.herokuapp.com/)
[![Open Issues](http://img.shields.io/github/issues/hpi-swt2/event-und-raumplanung.svg)](https://github.com/hpi-swt2/event-und-raumplanung/issues?q=is%3Aopen+is%3Aissue)
[![License](http://img.shields.io/badge/license-AGPL-blue.svg)](https://github.com/hpi-swt2/event-und-raumplanung/blob/master/LICENSE)

# Building
Branch      | Status
----------- | ----------
master  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=master)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
dev  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=dev)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
Axolotl  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=Axolotl)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
Biber  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=Biber)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
Clownfish  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=Clownfish)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
Dolphins  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=Dolphins)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)
Elch  | [![Build Status](https://travis-ci.org/hpi-swt2/event-und-raumplanung.svg?branch=Elch)](https://travis-ci.org/hpi-swt2/event-und-raumplanung)

event-und-raumplanung
=====================

Ein Tool das die interne Planung von Events verbessern soll und dabei besonderen Fokus auf die Zuteilung von Räumen und Ausstattung legt.

Live-System
-----
http://event-und-raumplanung.herokuapp.com/

http://event-und-raumplanung-dev.herokuapp.com/ (dev branch)

Fehleranalyse:
http://swt2-2014-errbit.herokuapp.com

Setup
-----
Es gibt zwei Möglichkeiten das Projekt aufzusetzen. Einmal mit einer virtuellen Maschine und Vagrant
(langsamer, geht dafür auch unter Windows) oder direkt auf deinem System.

Wenn du Vagrant (mit postgresql) benutzen willst (Vagrant muss installiert sein):

    vagrant up
    vagrant ssh
    cd hpi-swt2
    # Lokale docs machen die Gem-Installation langsamer
    # und brauchen Speicherplatz
    echo “gem: --no-document” >> ~/.gemrc
    bundle install
    gem install pg
    cp config/database.psql.yml config/database.yml
    # Die Session muss neu gestartet werden
    exit

Ihr könnt das System auch mit sqlite nutzen (nicht empfohlen):

    bundle install --without=production
    cp config/database.sqlite.yml config/database.yml

Um den `rails dev server` zu starten:

    vagrant ssh # mit der VM verbinden
    cd hpi-swt2
    rails s # kurz für rails server

Pull request
------------

Wir benutzen [review.ninja](http://app.review.ninja/hpi-swt2/event-und-raumplanung) für Pull Requests.

Deployment
----------

Travis CI deployed den Master-Branch (nach erfolgreichem Build) auf Heroku.
Die Badges enthalten die Links zu den verschiedenen Diensten.

FAQ
----------
In case of strange errors around Capybara-Webkit, please keep in mind to install QT windowing framework

sudo apt-get install libqt4-dev
