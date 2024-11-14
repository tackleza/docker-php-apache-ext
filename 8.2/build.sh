#!/bin/bash
docker pull php:8.2-apache
docker build -t tackleza/php-apache-ext:8.2 .
