class OwnersController < ApplicationController
  load_and_authorize_resource except: [:index, :new, :create, :destroy]
  before_filter :authorize

  def show
  end

  def edit_payment
  end

  def update_payment
    owner = current_owner
    if owner.update_attribute(:stripe_token, params[:owner][:stripe_token])
      redirect_to root_path, notice: 'Updated card, begin adding coupons!'
    else
      flash.alert = 'Unable to update card.'
      render :edit_payment
    end
  end

  private

  def authorize
    redirect_to unauthorized_path unless current_owner.id == params[:id].to_i || current_admin.present?
  end
end
