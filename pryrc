# My pry is polite
Pry.config.hooks.add_hook(:after_session, :say_bye) do
  puts "bye-bye"
end

# Prompt with ruby version
Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

%w{hirb}.each { |gem| require gem }

# # Toys methods
# # Stealed from https://gist.github.com/807492
# class Array
#   def self.toy(n=10, &block)
#     block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
#   end
# end

# class Hash
#   def self.toy(n=10)
#     Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
#   end
# end

# loading rails configuration if it is running as a rails console
# load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails) && Rails.env


# https://github.com/pry/pry/wiki/FAQ#wiki-hirb
begin
  require 'hirb'
rescue LoadError
  # Missing goodies, bummer
end

if defined? Hirb
  # Slightly dirty hack to fully support in-session Hirb.disable/enable toggling
  Hirb::View.instance_eval do
    def enable_output_method
      @output_method = true
      @old_print = Pry.config.print
      Pry.config.print = proc do |output, value|
        Hirb::View.view_or_page_output(value) || @old_print.call(output, value)
      end
    end

    def disable_output_method
      Pry.config.print = @old_print
      @output_method = nil
    end
  end

  Hirb.enable
end