class AbilityDecorator
  include CanCan::Ability 
  def initialize(user)
    can :finish, Questionnaire if user.id
  end

end

Spree::Ability.register_ability AbilityDecorator