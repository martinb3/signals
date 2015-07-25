require 'pp'
require 'nokogiri'
require 'open-uri'
require_relative 'speedtest'

doc = Nokogiri::HTML(open("http://192.168.100.1/Docsis_system.asp"))

#downstream channels
(1..8).to_a.each do |i|
  ch1_snr = doc.xpath("//table[@summary='Downstream Channels']/tr/td[contains(@headers, 'channel_#{i}') and contains(@headers, 'ch_snr')]")
  ch1_pwr = doc.xpath("//table[@summary='Downstream Channels']/tr/td[contains(@headers, 'channel_#{i}') and contains(@headers, 'ch_pwr')]")

  puts "Downstream Channel #{i}, SNR: #{ch1_snr.children.first.text.strip} dB, PWR: #{ch1_pwr.children.first.text.strip} dBmV"
end

(1..4).to_a.each do |i|
  ch1_pwr = doc.xpath("//table[@summary='Upstream Channels']/tr/td[contains(@headers, 'up_channel_#{i}') and contains(@headers, 'up_pwr')]")

  puts "Upstream Channel #{i}, PWR: #{ch1_pwr.children.first.text.strip} dBmV"
end

tester = Speedtest::SpeedTest.new(ARGV)
tester.run.each do |x, y|
  if x == :server
    puts "#{x}: #{y}"
  elsif x == :latency
    puts "#{x}: #{y} ms"
  else
    puts "#{x}: #{tester.pretty_speed(y.to_f)}"
  end
end
