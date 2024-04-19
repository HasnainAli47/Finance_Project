class BillNotifierMailer < ApplicationMailer
  default from: 'notification@xyz.com'
  # Send mail with subject new bill is added we are using devise so current_user is available
  def notify_user(user_id, bill_id)
    @user = User.find(user_id)
    @bill = Bill.find(bill_id)
    mail(to: @user.email, subject: 'New Bill Added')
end
end
