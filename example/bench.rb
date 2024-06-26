#!/usr/bin/env ruby

require 'rubygems'
require 'benchmark'
%w[ ext lib ].each do |sub|
  subdir = File.expand_path( File.join( File.dirname( __FILE__ ), "..", sub ) )
  $: << subdir
end

include Benchmark

iterations = (ARGV.shift || 100_000).to_i

puts "generating #{iterations} random numbers between 0 and 10,000"
numbers = []
iterations.times do |x|
  numbers << rand( 10_000 )
end

require 'simplemetrics/metric'

metrics = []
begin
  require 'simple_metrics_ext'
  metrics << SimpleMetrics::Ext::Metric.new( "ext" )
rescue LoadError => le
  puts "Skipping Ext"
end

begin 
  require 'simplemetrics/ffi'
  metrics << ::SimpleMetrics::FFI::Metric.new( "ffi" )
rescue LoadError => le
  puts "Skipping FFI"
end

bmbm( 12 ) do |x|
  metrics.each do |m|
    x.report( m.name ) do
      numbers.each { |n| m.update( n ) }
    end
  end
end

SimpleMetrics::Metric.keys.each do |k|
  puts "For #{k}:"
  metrics.each do |m|
    puts "  #{m.name} : #{m.send( k ) }"
  end
end


