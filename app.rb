#!/usr/bin/env ruby
require 'json'
require 'date'
require 'erb'

erb = ERB.new(File.read("index.html.erb"))

@keywords = File.open('keywords.json') {|j| JSON.load(j)}
@content_data = File.open('app.json') {|j| JSON.load(j)}
@terms = File.open('terms.json') {|j| JSON.load(j)}

today = Date.today
@year = today.strftime("%Y")

File.write('index.markdown', erb.result(binding))
