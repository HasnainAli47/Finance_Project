class BillNotifierMailer < ApplicationMailer
  default from: 'notifications@example.com'
  # Send mail with subject new bill is added we are using devise so current_user is available
  def notify_user(current_user)
    mail(to: current_user.email, subject: 'New Bill Added')
end
end
