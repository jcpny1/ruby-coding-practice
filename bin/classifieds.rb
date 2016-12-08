#!/usr/bin/env ruby
require_relative '../config/environment'
url = 'http://long-island-cars.newsday.com/motors/results/car?maxYear=2010&radius=0&min_price=1000&view=List_Detail&sort=Price+desc%2C+Priority+desc&rows=50'
CLI.new(Automobile, url, page_size:3).run
