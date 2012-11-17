class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_a? Admin
      can :manage, :all
      can :approve, :owner
    elsif user.is_a? Owner
      can :manage, [Owner]
    end
  end
end
