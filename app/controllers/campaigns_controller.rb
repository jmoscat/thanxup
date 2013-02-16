class CampaignsController < ApplicationController
  before_filter :validate_stripe, :authorize, :setup
  rescue_from Ripple::DocumentInvalid, with: :invalid_campaign

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
        campaign.campaign_stores << CampaignStore.new(store_id: store) unless store.empty? || Store.find(store).blank?
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
    stores = params[:campaign].delete(:campaign_stores)
    @campaign = Campaign.find(params[:id])
    stores.try(:each) do |store|
      @campaign.campaign_stores << CampaignStore.new(store_id: store) unless store.empty? || @campaign.has_store?(store) || Store.find(store).blank?
    end
    if @campaign.update_attributes(params[:campaign])
      redirect_to owner_campaigns_path(owner_id: current_owner.id), notice: 'Successfully updated campaign.'
    else
      render :edit
    end
  end

  def deactivate
    Campaign.find(params[:id]).deactivate!
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
    redirect_to new_owner_store_path(owner_id: current_owner.id), notice: 'You need to have a store with coupons before you start a campaign.' if @stores.blank? || !@stores.has_coupons?
  end
end
