module SimpleMetrics
  module Ext
  end
  module FFI
  end

  begin
    require 'libsimple_metrics'
    Metric = ::SimpleMetrics::Ext::Metric
  rescue LoadError => le
    require 'simplemetrics/ffi'
    Metric = ::SimpleMetrics::FFI::Metric
  end
end

