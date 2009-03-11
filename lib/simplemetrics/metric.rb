module SimpleMetrics
  class Metric
    def self.implementations
      @implementations ||= %w[ ffi ext ]
    end

    def self.default_implementation
      @default_implementation ||= SimpleMetrics::FFI::Metric
    end
  
    def self.default_implementation=( i )
      s = i.to_s
      case s
      when 'ffi'
        @default_implementation = ::SimpleMetrics::FFI::Metric
      when 'ext'
        @default_implementation = ::SimpleMetrics::Ext::Metric
      else
        raise "Unknown implementation of '#{i}'.  Known implementations are #{Metric.implementations.join(', ')}"
      end
      return @default_implementation
    end

    # the list of methods that can be called
    def self.keys
      @keys ||= %w[ count max mean min rate stddev sum ]
    end

    attr_reader :name

    def initialize( name )
      @name = name
    end

    def to_hash( *args )
      h = {}
      args = [ args ].flatten
      args = Metric.keys if args.empty?
      args.each do |meth|
        h[meth] = self.send( meth )
      end
      return h
    end
  end
end
