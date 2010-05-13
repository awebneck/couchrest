require 'rubygems'
require 'spork'
require "rspec"

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require File.join(File.dirname(__FILE__), '..','lib','couchrest')
  # check the following file to see how to use the spec'd features.

  unless defined?(FIXTURE_PATH)
    FIXTURE_PATH = File.join(File.dirname(__FILE__), '/fixtures')
    SCRATCH_PATH = File.join(File.dirname(__FILE__), '/tmp')

    COUCHHOST = "http://127.0.0.1:5984"
    TESTDB    = 'couchrest-test'
    TEST_SERVER    = CouchRest.new
    TEST_SERVER.default_database = TESTDB
    DB = TEST_SERVER.database(TESTDB)
  end

  class Basic < CouchRest::ExtendedDocument
    use_database TEST_SERVER.default_database
  end

  def reset_test_db!
    DB.recreate! rescue nil 
    DB
  end

  Rspec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    config.before(:all) { reset_test_db! }
    config.mock_with :rspec

    config.after(:all) do
      cr = TEST_SERVER
      test_dbs = cr.databases.select { |db| db =~ /^#{TESTDB}/ }
      test_dbs.each do |db|
        cr.database(db).delete! rescue nil
      end
    end

    # If you'd prefer not to run each of your examples within a transaction,
    # uncomment the following line.
    # config.use_transactional_examples = false
  end
  
end

Spork.each_run do
  # This code will be run each time you run your specs.
  
end

# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading 
#   code that you don't normally modify during development in the 
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.
#

