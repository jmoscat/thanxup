class OwnersController < ApplicationController
  load_and_authorize_resource except: [:index, :new, :create, :destroy]
  before_filter :authorize

  def show
  end

  def edit
  end

  def update
  end

  private

  def authorize
    redirect_to unauthorized_path unless current_owner.id == params[:id].to_i || current_admin.present?
  end
end
