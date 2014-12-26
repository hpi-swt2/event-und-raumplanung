class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
       #user.id = 0
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    can [:update, :destroy, :edit, ], Event, :user_id => user.id
    can [:sugguest, :create_suggestion], Event, {:user_id => user.id, :status => "In Bearbeitung"}
    can [:update, :destroy, :edit], EventTemplate, :user_id => user.id
    if user.username == load_admin
        can :manage, Group
        can :manage, Room
        can :manage, Equipment
        can :manage, Event
    else
        can :read, Group
    end

    can [:create, :destroy], Room do |room|
        user.has_permission("manage_rooms")        
    end

    can :update, Room do |room|
        user.has_permission("edit_rooms", room)
    end

    can [:create, :destroy], Equipment do |equipment|
        user.has_permission("manage_equipment")        
    end
    
    can :update, Equipment do |equipment|
        user.has_permission("edit_equipment")        
    end

    can [:create, :destroy], RoomProperty do |property|
        user.has_permission("manage_properties")        
    end
    
    can :update, RoomProperty do |property|
        user.has_permission("edit_properties")        
    end

    can :assign_to, Room do |room|
        user.has_permission("assign_to_rooms", room)
    end

    can :approve, Event do |event|
        event.rooms.any? {|room| user.has_permission("approve_events", room)}
    end
  end

  def load_admin
    config = YAML.load_file(Rails.root.join('config', 'config.yml'))
    admin_identity = config['admin']['username']
  end
end
