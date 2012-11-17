class OwnerApprovalController < ApplicationController
  before_filter :authorize

  def index
    if params[:approved] == "false"
      @owners = Owner.find_all_by_approved(false)
    else
      @owners = Owner.all
    end
  end

  private

  def authorize
    authorize! :edit, Admin
  end
end
