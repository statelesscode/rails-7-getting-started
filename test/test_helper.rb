ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require_relative "./support/visible_test_helpers"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def run_model_fixture_tests(klass_name)
    klass_name.all.each do |model_record|
      assert(
        model_record.valid?,
        "Invalid #{klass_name} Fixture: #{model_record.inspect}\n\nErrors: #{model_record.errors.messages}")
    end
  end

  def generate_auth_headers
    {'Authorization' => "Basic #{Base64.strict_encode64('stateless:code')}"}
  end
end
