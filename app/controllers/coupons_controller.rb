class CouponsController < ApplicationController
  before_filter :setup
  rescue_from Ripple::DocumentInvalid, :with => :invalid_coupon

  def index
    @coupons = @store.available_coupons
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(params[:coupon].merge(store_id: @store.key))
    if @coupon.save
      redirect_to owner_store_coupons_path(owner_id: current_owner.id, store_id: @store.key), notice: 'Successfully created a coupon.'
    else
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update_attributes(params[:coupon])
      redirect_to owner_store_coupons_path(owner_id: current_owner.id, store_id: @store.key), notice: 'Successfully updated coupon.'
    else
      render :edit
    end
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy
    redirect_to owner_store_coupons_path(owner_id: current_owner.id, store_id: @store.key), notice: 'Successfully removed coupon.'
  end

  protected

  def invalid_coupon
    @coupon ||= Coupon.new
    if params[:action] == 'create'
      render :new
    else
      render :edit
    end
  end

  private

  def setup
    authorize! :manage, Coupon
    @store = Store.find(params[:store_id])
  end
end
