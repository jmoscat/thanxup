class OwnersController < ApplicationController
  load_and_authorize_resource except: [:index, :new, :create, :destroy]
  before_filter :authorize

  def show
  end

  def edit_payment
    @subscribed = current_owner.subscribed?
  end

  def update_payment
    if current_owner.update_attribute(:stripe_token, params[:owner][:stripe_token])
      redirect_to root_path, notice: 'Updated card, begin thanxuping!'
    else
      flash.alert = 'Unable to update card.'
      render :edit_payment
    end
  end

  def cancel_payment
    current_owner.cancel_subscription
    redirect_to root_path, notice: 'Removed card, you will lose access in a month.'
  end

  def remove_stripe_info
    current_owner.remove_stripe_info
    redirect_to root_path, notice: 'Removed all information from stripe.'
  end

  def enable_subscription
    current_owner.enable_subscription!
    redirect_to root_path, notice: 'Enabled your subscription for $29.99 a month. Thanks!'
  end

  private

  def authorize
    redirect_to unauthorized_path unless current_owner.id == params[:id].to_i || current_admin.present?
  end
end
