class StoresController < ApplicationController
  before_filter :authorize
  rescue_from Ripple::DocumentInvalid, :with => :already_exists

  def index
    @stores = current_owner.stores
  end

  def show
    @store = Store.find(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = current_owner.stores.build(params[:store])
    if @store.save!
      redirect_to owner_stores_path(owner_id: current_owner.id), notice: 'Successfully added a new store.'
    else
      render :new
    end
  end

  def edit
    @store = Store.find(params[:id])
  end

  def update
    @store = Store.find(params[:id])
    if @store.update_attributes(params[:store])
      redirect_to owner_stores_path(owner_id: current_owner.id), notice: 'Successfully updated store.'
    else
      render :edit
    end
  end

  def destroy
    @store = Store.find(params[:id])
    @store.available_coupons.each { |coupon| coupon.destroy } if @store.available_coupons.present?
    @store.destroy
    redirect_to owner_stores_path(owner_id: current_owner.id), notice: 'Successfully removed store.'
  end

  protected

  def already_exists
    @store ||= Store.new
    if params[:action] == 'create'
      render :new
    else
      render :edit
    end
  end

  private

  def authorize
    authorize! :manage, Store
  end
end
