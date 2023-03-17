#!/bin/sh

bundle exec yardoc --plugin yard-sinatra app.rb models.rb routes/*
