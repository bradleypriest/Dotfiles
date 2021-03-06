require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8

def unbundled_require(gem)

  loaded = false

  if defined?(::Bundler)

    Gem.path.each do |gems_path|
      gem_path = Dir.glob("#{gems_path}/gems/#{gem}*").last
      unless gem_path.nil?
        $LOAD_PATH << "#{gem_path}/lib"
        require gem
        loaded = true
      end
    end

  else
    require gem
    loaded = true
  end

  raise(LoadError, "couldn't find #{gem}") unless loaded

  loaded

end

def load_gem(gem, &block)

  begin

    if unbundled_require gem
      yield if block_given?
    end

  rescue Exception => err
    warn "Couldn't load #{gem}: #{err}"
  end

end

# Highlighting and other features
# load_gem 'wirble' do
#   Wirble.init
#   Wirble.colorize
# end

# Improved formatting for objects
# load_gem 'awesome_print'

# Improved formatting for collections
load_gem 'hirb' do
  Hirb.enable
end

if defined?(::Rails)
  if Rails.env.test?
    require './spec/support/factories.rb'
  end
end

# Show log in Rails console
def enable_logging!
  if defined? Rails
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end

def gitx
 `gitx`
end

# # Enable route helpers in Rails console
# if defined? Rails
#   include Rails.application.routes.url_helpers
#   default_url_options[:host] = 'localhost'
#   default_url_options[:port] = 3000
# end
#
# # Benchmarking helper (http://ozmm.org/posts/time_in_irb.html)
# if defined? Benchmark
#   def time(times = 1)
#     ret = nil
#     Benchmark.bm { |x| x.report { times.times { ret = yield } } }
#     ret
#   end
# end
#
# # Random time method
# class Time
#   def self.random(from=Time.at(0), to=Time.now)
#     Time.at rand(to.to_f - from.to_f) + from.to_f
#   end
# end