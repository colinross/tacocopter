ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
class ActionController::TestCase
  # Rails 4 changed from providiogn a null session to throwing an Exception with
  # the CSRF token isn't present, including in test env.
  def set_form_authenticity_token
    session[:_csrf_token] = SecureRandom.base64(32)
  end

  alias_method :post_without_token, :post
  def post_with_token(symbol, args_hash)
    args_hash.merge!(authenticity_token: set_form_authenticity_token)
    post_without_token(symbol, args_hash)
  end
  alias_method :post, :post_with_token
end
