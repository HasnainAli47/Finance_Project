class SendMailJob
  include Sidekiq::Job

  def perform(user_id, bill_id)
    BillNotifierMailer.notify_user(user_id, bill_id).deliver
  end
end
