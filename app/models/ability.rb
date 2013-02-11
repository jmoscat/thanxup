class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a? Admin
      can :manage, :all
    elsif user.is_a? Owner
      can :manage, [Owner, Coupon, Store, Campaign]
    end
  end
end
