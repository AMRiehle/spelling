#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

bad = " "

url = "http://spellingbee.com/public/spellers/speller_roster"

results = CSV.open("csv/spellers.csv","w")

begin
  page = agent.get(url)
rescue
  print "  -> error, retrying\n"
  retry
end

path='//*[@id="copyBody"]/table/tr[position()>1]'

spellers = []
page.parser.xpath(path).each_with_index do |tr,i|
  row = [2015]
  tr.xpath("td").each_with_index do |td,j|
    text = td.text.strip rescue nil
    text.gsub!(bad,"") rescue nil
    text.gsub!("  "," ") rescue nil
    row += [text]
  end
  if (row[1]=='')
    row[1] = spellers[i-1][1]
  end
  results << row
  spellers << row
end

results.close
