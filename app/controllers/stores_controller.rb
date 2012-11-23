class StoresController < ApplicationController
  before_filter :authorize

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
    @store = Store.new(params[:store].merge(owner_id: current_owner.id))
    if @store.save
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
    @store.available_coupons.destroy_all if @store.available_coupons.present?
    @store.destroy
    redirect_to owner_stores_path(owner_id: current_owner.id), notice: 'Successfully removed store.'
  end

  def subregion_options
    render partial: 'subregion_select'
  end

  private

  def authorize
    authorize! :manage, Store
  end
end
