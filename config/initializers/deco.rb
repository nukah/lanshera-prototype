require File.expand_path('config/application')

Radibloga::Application.initializer "decorators" do |app|
    Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        puts File.dirname(__FILE__)
        Rails.env.production? ? require(c) : load(c)
    end
end


