require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'simplemetrics/ffi'

describe SimpleMetrics::FFI::Metric  do
  before( :each ) do
    @full_metric = SimpleMetrics::FFI::Metric.new( "test" )
    
    [ 1, 2, 3].each { |i| @full_metric.update( i ) }
  end

  it "is initialized with 0 values" do
    metric = SimpleMetrics::FFI::Metric.new( "bare" )
    metric.count.should == 0
    metric.min.should == 0.0
    metric.max.should == 0.0
    metric.sum.should == 0.0
    metric.rate.should == 0.0
    metric.stddev.should == 0.0
  end

  it "calculates the mean correctly" do
    @full_metric.mean.should == 2.0
  end

  it "calculates the rate correctly" do
    @full_metric.rate.should == 0.5
  end

  it "tracks the maximum value" do
    @full_metric.max.should == 3.0
  end

  it "tracks the minimum value" do
    @full_metric.min.should == 1.0
  end

  it "tracks the count" do
    @full_metric.count.should == 3
  end
  
  it "tracks the sum" do
    @full_metric.sum.should == 6.0
  end

  it "calculates the standard deviation" do
    @full_metric.stddev.should == 1.0
  end 

  describe "#to_hash " do
    it "converts to a Hash" do
      h = @full_metric.to_hash
      h.size.should == ::SimpleMetrics::Metric.keys.size
      h.keys.sort.should == ::SimpleMetrics::Metric.keys
    end

    it "converts to a limited Hash if given arguments" do
      h = @full_metric.to_hash( "min", "max", "mean" )
      h.size.should == 3
      h.keys.sort.should == %w[ max mean min  ]

      h = @full_metric.to_hash( %w[ count rate ] )
      h.size.should == 2
      h.keys.sort.should == %w[ count rate ]
    end

    it "raises NoMethodError if an invalid key is used" do
      lambda { @full_metric.to_hash( "wibble" ) }.should raise_error( NoMethodError )
    end

  end

end
