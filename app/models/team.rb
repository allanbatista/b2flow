class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def to_api
    as_json(only: [:id, :name, :created_at, :updated_at])
  end

  def name=(new_name)
    self['name'] = new_name.downcase.strip if new_name.present?
  end
end
