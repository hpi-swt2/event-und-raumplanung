class Permission < ActiveRecord::Base
  belongs_to :permitted_entity, :polymorphic => true
  belongs_to :room

  enum category: [
    :manage_rooms,
    :edit_rooms,
    :approve_events,
    :manage_equipment,
    :edit_equipment,
    :manage_properties,
    :edit_properties,
    :assign_to_rooms ]

  validates_uniqueness_of :permitted_entity_id, scope: [:permitted_entity_type, :category, :room]

  scope :for_category, lambda { |category|
    where(category: categories[category])
  }

end
