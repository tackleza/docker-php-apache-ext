#!/bin/bash
docker pull php:7.0-apache
docker build -t tackleza/php-apache-ext:7.0 .
