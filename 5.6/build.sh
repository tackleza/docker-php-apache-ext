#!/bin/bash
docker pull php:5.6-apache
docker build -t tackleza/php-apache-ext:5.6 .
