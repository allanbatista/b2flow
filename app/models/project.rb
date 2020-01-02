class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :team
  has_many :dags

  field :name, type: String
  field :config, type: Hash, default: {}

  validates :name, presence: true, uniqueness: { scope: [:team_id] }
  validates :team, presence: true

  def to_api
    as_json(only: [:_id, :name, :team_id, :created_at, :updated_at])
  end

  def name=(new_name)
    self['name'] = new_name.downcase.strip if new_name.present?
  end
end
