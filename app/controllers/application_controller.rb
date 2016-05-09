class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # POROS > protected methods for handling secure parameters
  class Params
    # Multi-select checkboxes produce an empty "" element for each field
    # which can become a hastle to deal with
    def self.recursive_reject_blanks(hash_or_array)
      return hash_or_array.reject!(&:blank?) if hash_or_array.is_a? Array
      hash_or_array.each do |k, v|
        case v
        when Array then v.reject!(&:blank?)
        when Hash  then recursive_reject_blanks(v)
        end
      end
    end
  end

end
