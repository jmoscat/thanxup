class ThanxupMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_owner_waiting_for_approval(owner)
    @owner = owner
    mail(to: "thanxup@gmail.com", subject: "New owner signup: #{@owner.name}")
  end
end
