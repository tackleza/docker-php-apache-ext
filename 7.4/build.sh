#!/bin/bash
docker pull php:7.4-apache
docker build -t tackleza/php-apache-ext:7.4 .
