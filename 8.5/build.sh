#!/bin/bash
docker pull php:8.5-apache
docker build -t tackleza/php-apache-ext:8.5 .
