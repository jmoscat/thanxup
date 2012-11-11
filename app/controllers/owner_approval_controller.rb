class OwnerApprovalController < ApplicationController
  def index
    if params[:approved] == "false"
      @owners = Owner.find_all_by_approved(false)
    else
      @owners = Owner.all
    end
  end
end
