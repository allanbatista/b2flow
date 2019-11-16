class Project < ApplicationRecord
  belongs_to :team

  validates :name, presence: true, uniqueness: { scope: [:team_id] }
  validates :team, presence: true

  def to_api
    as_json(only: [:id, :name, :team_id, :created_at, :updated_at])
  end

  def name=(new_name)
    self['name'] = new_name.downcase.strip if new_name.present?
  end
end
