module SimpleMetrics
  begin
    require 'simple_metrics_ext'
    Metric = ::SimpleMetrics::Ext::Metric
  rescue LoadError => le
    require 'simplemetrics/ffi'
    Metric = ::SimpleMetrics::FFI::Metric
  end
end

