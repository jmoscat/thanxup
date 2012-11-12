class AdminsController < ApplicationController
  before_filter :setup

  def approve_owner
    if @owner.update_attribute(:approved, !@owner.approved)
      if @owner.approved?
        #Need to send an email to the owner saying they have been approved,
        #and give them documentation on getting started. Need to throw the
        #email in a sidekiq queue
        redirect_to owner_approval_index_path, notice: 'Owner has been approved'
      else
        #Need to send an email to the owner saying why they have had
        #their approval revoked
        redirect_to owner_approval_index_path, notice: 'Revoked approval'
      end
    end
  end

  private

  def setup
    @owner = Owner.find(params[:owner_id])
  end
end
