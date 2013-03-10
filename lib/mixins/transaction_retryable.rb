module TransactionRetryable
  extend ActiveSupport::Concern

  module ClassMethods
    def transaction_with_retry(max_retries = 3)
      attempts = 0

      loop do
        begin
          return yield
        rescue ActiveRecord::StatementInvalid => e
          raise e unless e.message =~ /Deadlock found when trying to get lock/
          raise e if (attempts += 1) >= max_retries
        end
      end
    end
  end
end
