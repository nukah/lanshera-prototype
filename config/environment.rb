# Load the rails application
require File.expand_path('../application', __FILE__)
APP_VERSION = `git describe --always` unless defined? APP_VERSION
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
# Initialize the rails application
Radibloga::Application.initialize!
