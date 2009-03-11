module SimpleMetrics
  class Common
    # the list of methods that can be called
    def self.keys
      @keys ||= %w[ count max mean min rate stddev sum ]
    end

    attr_reader :name

    def new( name )

    end

    def initialize( name )
      @name = name
    end

    def to_hash( *args )
      h = {}
      args = [ args ].flatten
      args = self.class.keys if args.empty?
      args.each do |meth|
        h[meth] = self.send( meth )
      end
      return h
    end
  end
end
