#!/usr/bin/env bash

pub build

deploymentDir=deployment

git clone git@github.com:enyo/vocal-coach.git $deploymentDir

cd $deploymentDir

git checkout gh-pages

rm -r ./*

mv ../build/* .

git add .
git add -u

git commit -m 'New release'

git push
