class Test::Unit::TestCase
  
  def run_with_test_timing(*args, &block)
    result = args[0] # Test::Unit::TestResult      
    # extend the class to do what we want
    # Note this does not work with the regular class_eval
    # I was unable to successfully oepn up Test::Unit::TestResult
    result.class.class_eval do
      
      def add_error_with_log_error(error)
        puts error.to_s
        add_error_without_log_error(error)
      end
    
      def add_failure_with_log_failure(failure)          
        puts failure.to_s
        add_failure_without_log_failure(failure)
      end
    
      alias_method_chain :add_error, :log_error unless method_defined?(:add_error_without_log_error)
      alias_method_chain :add_failure, :log_failure unless method_defined?(:add_failure_without_log_failure)
    end
    
    #time the test
    begin_time = Time.now
    run_without_test_timing(*args, &block)
    end_time = Time.now

    duration = (end_time - begin_time) 
    long_test = duration > '.00025'.to_f
    puts "\nSLOW TEST: #{duration} - #{self.name}" if long_test
  end
  
  # Since we require the test helper in all tests we need to check this out.
  alias_method_chain :run, :test_timing unless method_defined?(:run_without_test_timing)
  
end