class CreditJournalEntry < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :amount, :app, :source_type, :source_id

  belongs_to :user
  belongs_to :app

  symbolize :source_type, in: [:card_order_debit, :card_order_credit, :credit_order, :signup, :unknown], validate: true

  after_save on: :create do
    CreditJournalEntry.invalidate_cache_for_user_id!(self.user_id, app_id: self.app_id)
  end

  def self.invalidate_cache_for_user_id!(user_id, *args)
    options = args.extract_options!
    app_id = options[:app_id]

    raise ArgumentError.new("required app_id") unless app_id
    Rails.cache.delete(credit_cache_key_for_user_id(user_id, app_id: app_id))
    Rails.cache.delete(credit_journal_size_cache_key_for_user_id(user_id, app_id: app_id))
  end

  def self.credits_for_user_id(user_id, *args)
    options = args.extract_options!

    raise "Missing option app" unless options[:app]

    app_id = options[:app].app_id

    Rails.cache.fetch(credit_cache_key_for_user_id(user_id, app_id: app_id)) do
      CreditJournalEntry.where(user_id: user_id, app_id: app_id).map(&:amount).reduce(&:+) || 0
    end
  end

  def self.credit_journal_size_for_user_id(user_id, *args)
    options = args.extract_options!

    raise "Missing option app" unless options[:app]

    app_id = options[:app].app_id

    Rails.cache.fetch(credit_journal_size_cache_key_for_user_id(user_id, app_id: app_id)) do
      CreditJournalEntry.where(user_id: user_id, app_id: app_id).lock(true).size
    end
  end

  private

  def self.credit_cache_key_for_user_id(user_id, *args)
    options = args.extract_options!
    app_id = options[:app_id]

    raise ArgumentError.new("required app_id") unless app_id

    ["total_credits", user_id, app_id]
  end

  def self.credit_journal_size_cache_key_for_user_id(user_id, *args)
    options = args.extract_options!
    app_id = options[:app_id]

    raise ArgumentError.new("required app_id") unless app_id

    ["total_credit_journal_size", user_id, app_id]
  end
end
