#!/bin/bash

# start postgresql
sudo /etc/init.d/postgresql start

# run lightning-server from prebuilt library
cd lightning
npm start &
