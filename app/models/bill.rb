class Bill < ApplicationRecord
  validates :status, presence: true, inclusion: { in: %w(in out), message: ' can have only in or out values' }
  validates :amount, presence: true
  validates :bill_reference, presence: true
  has_one_attached :image

  belongs_to :account, optional: true

  after_save :update_account_balance

  private

  def update_account_balance
    if account.present?
      
      if status == 'in'
        account.update(CurrentBalance: account.CurrentBalance + amount)
      elsif status == 'out'
        account.update(CurrentBalance: account.CurrentBalance - amount)
      end
    end
  end


  after_destroy :update_account_balance_on_destroy
  # before_update :update_account_balance

  # private
  
  # def update_account_balance
  #   if account.present?
  #     debugger
  #   end
  # end


  private

  def update_account_balance_on_destroy
    if account.present?
      if status == 'out'
        account.update(CurrentBalance: account.CurrentBalance + amount)
      elsif status == 'in'
        account.update(CurrentBalance: account.CurrentBalance - amount)
      end
    end
  end

end
