class Team
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :projects

  field :name, type: String

  validates :name, presence: true, uniqueness: true

  def to_api
    as_json(only: [:_id, :name, :created_at, :updated_at])
  end

  def name=(new_name)
    self['name'] = new_name.downcase.strip if new_name.present?
  end
end
