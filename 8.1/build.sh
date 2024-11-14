#!/bin/bash
docker pull php:8.0-apache
docker build -t tackleza/php-apache-ext:8.1 .
