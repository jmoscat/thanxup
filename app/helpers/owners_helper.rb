module OwnersHelper
  def subscribe_link(subscribed, id)
    unless subscribed
      link_to("Enable Subscription", enable_subscription_owner_path(id: current_owner.id), method: :put)
    else
      link_to("Cancel Subscription", cancel_payment_owner_path(id: current_owner.id), method: :delete)
    end
  end
end
