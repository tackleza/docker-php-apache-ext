#!/bin/bash
docker pull php:7.1-apache
docker build -t tackleza/php-apache-ext:7.1 .
