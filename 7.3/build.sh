#!/bin/bash
docker pull php:7.3-apache
docker build -t tackleza/php-apache-ext:7.3 .
