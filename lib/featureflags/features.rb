module FeatureFlags
  module Features
    attr_accessor :flags

    def self.init!(flags=nil)
      @flags = load_flags!(flags)
    end

    def self.enabled?(name)
      !!flag(name)
    end

    # Could be useful to use this directly for variants /
    # AB testing, etc
    # e.g. FeatureFlags::Features.flag('homepage.splash_form')
    def self.flag(name)
      ENV[env_ize(name)] || @flags[name.to_sym]
    end

    def self.all_defaults
      @flags || {}
    end

    # return all features which are enabled by default 
    # i.e. not-false, regardless of environment variables
    def self.enabled_by_default
      @flags.select{|k,v| v}.map{|k,v| k}
    end

    def self.any_enabled?(*names)
      names.flatten.any?{ |name| enabled?(name) }
    end

    def self.all_enabled?(*names)
      names.flatten.all?{ |name| enabled?(name) }
    end

    def self.env_ize(name)
      name.to_s.upcase.gsub(/[^A-Z0-9_]+/, '_')
    end

    protected

      # NOTE: thread-safety??
      def self.load_flags!(defaults={})
        @flags = {}
        if defaults
          defaults.each do |key, value|
            @flags[key] = value
          end
        end
      end

  end
end