#!/usr/bin/env bash

# Abort on error
set -e

pub build

deploymentDir=deployment

git clone git@github.com:enyo/vocal-coach.git $deploymentDir

cd $deploymentDir

git config --global user.email "m@tias.me"
git config --global user.name "Matias Meno"

git checkout gh-pages

rm -r ./*

mv ../build/* .

git add --all .

git commit -m 'New release'

git push origin gh-pages
