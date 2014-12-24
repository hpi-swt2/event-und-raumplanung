class Permission < ActiveRecord::Base
  has_many :permission_manifests
  belongs_to :permitted_entity, :polymorphic => true
  belongs_to :room

  enum type: [
    :manage_rooms,
    :edit_rooms,
    :approve_events,
    :manage_equipment,
    :edit_equipment,
    :manage_properties,
    :edit_properties,
    :assign_to_rooms ]

end
