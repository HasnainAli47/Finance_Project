class Account < ApplicationRecord
  # has many bills but make them destroy when account is destroyed
  has_many :bills, dependent: :destroy
  belongs_to :user

  validates :CurrentBalance, presence: true 

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
