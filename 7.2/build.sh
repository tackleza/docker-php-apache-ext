#!/bin/bash
docker pull php:7.2-apache
docker build -t tackleza/php-apache-ext:7.2 .
