# The FFI interface to simple_metrics
#
require 'rbconfig'
require 'ffi'
require 'simplemetrics/metric'

module SimpleMetrics
  module FFI
    class Struct < ::FFI::Struct
      layout :min, :double,
             :max, :double,
             :sum, :double,
             :sumsq, :double,
             :count, :long

      def self.release( ptr )
        SimpleMetrics::FFI.simple_metrics_free( ptr )
      end
    end

    extend ::FFI::Library
    ffi_lib "ext/simple_metrics_ext.#{Config::CONFIG['DLEXT']}"

    attach_function :simple_metrics_new,   [          ], :pointer
    attach_function :simple_metrics_free,  [ :pointer ], :void
    attach_function :simple_metrics_update,[ :pointer, :double  ], :void
    attach_function :simple_metrics_min,   [ :pointer ], :double
    attach_function :simple_metrics_max,   [ :pointer ], :double
    attach_function :simple_metrics_mean,  [ :pointer ], :double
    attach_function :simple_metrics_sum,   [ :pointer ], :double
    attach_function :simple_metrics_count, [ :pointer ], :long
    attach_function :simple_metrics_stddev,[ :pointer ], :double
    attach_function :simple_metrics_rate,  [ :pointer ], :double

    class Metric < ::SimpleMetrics::Common
      include ::SimpleMetrics::FFI
      def initialize( name )
        super
        @impl = FFI.simple_metrics_new
      end

      def update( v )
        simple_metrics_update( @impl, v )
      end

      self.keys.each do |f|
        module_eval <<-code
        def #{f}
          simple_metrics_#{f}( @impl )
        end
        code
      end
    end
  end
end
