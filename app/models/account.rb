class Account < ApplicationRecord
  has_many :bills

  validates :CurrentBalance, presence: true # Updated to use snake_case naming convention

  after_initialize :initialize_balance

  def initialize_balance
    self.CurrentBalance ||= 0
  end

  # after_create :initialize_balance

  # def update_account_balance(amount)
  #   update(CurrentBalance: CurrentBalance + amount)
  # end

  # private

  # def initialize_balance
  #   update(CurrentBalance: 0) if CurrentBalance.nil?
  # end
end