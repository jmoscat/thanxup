class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a? Admin
      can :manage, :all
    elsif user.is_a? Owner
      can :manage, [Store, Coupon]
    end
  end
end
