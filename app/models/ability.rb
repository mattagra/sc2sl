class Ability
  include CanCan::Ability


  def initialize(user)
    can :read, :all
    if user

      if user.role? :superadmin
        can :manage, :all
      else
        can :manage, Vote
        can :show_current, VoteEvent
        can :update, User do |user|
          user.try(:id) == user.id
        end
        can :rate, Game
        can :create, Comment
        can :replay, Game
        can :update, Comment do |comment|
          comment.try(:user) == user || user.role?(:moderator)
        end
        can :create, Topic
        if user.role?(:admin)
          can :create, Article
          can :update, Article do |article|
            article.try(:user) == user
          end
        end
      end

    else
      can :create, User
    end

  end
end