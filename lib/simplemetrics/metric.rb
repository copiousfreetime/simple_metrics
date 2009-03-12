module SimpleMetrics
  begin
    require 'libsimple_metrics'
    Metric = ::SimpleMetrics::Ext::Metric
  rescue LoadError => le
    require 'simplemetrics/ffi'
    Metric = ::SimpleMetrics::FFI::Metric
  end
end

