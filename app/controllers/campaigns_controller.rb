class CampaignsController < ApplicationController
  before_filter :authorize, :setup
  rescue_from Ripple::DocumentInvalid, :with => :invalid_campaign

  def index
    @campaigns = current_owner.campaigns
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = Campaign.new
  end

  def create
    stores = params[:campaign].delete(:campaign_stores)
    @campaign = Campaign.new(params[:campaign]) do |campaign|
      campaign.owner_id = current_owner.id
      stores.try(:each) do |store|
        campaign.campaign_stores << CampaignStore.new(store_id: store) unless store.empty?
      end
    end
    if @campaign.save!
      redirect_to owner_campaigns_path(owner_id: current_owner.id), notice: 'Successfully added a new campaign.'
    else
      render :new
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def update
    @campaign = Campaign.find(params[:id])
    if @campaign.update_attributes(params[:store])
      redirect_to owner_campaigns_path(owner_id: current_owner.id), notice: 'Successfully updated campaign.'
    else
      render :edit
    end
  end

  def deactivate
    @campaign.deactivate!
    redirect_to owner_campaigns_path(owner_id: current_owner.id), notice: 'Successfully deactivated campaign.'
  end

  protected

  def invalid_campaign
    @campaign ||= Campaign.new
    if params[:action] == 'create'
      render :new
    else
      render :edit
    end
  end

  private

  def authorize
    authorize! :manage, Campaign
  end

  def setup
    @stores = current_owner.stores
  end
end
