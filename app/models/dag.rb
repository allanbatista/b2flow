class Dag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  belongs_to :team
  belongs_to :project

  field :name, type: String
  field :cron, type: String
  field :config, type: Hash, default: {}
  field :enable, type: Boolean, default: false

  has_mongoid_attached_file :source

  validates_attachment :source, content_type: { content_type: 'application/zip' }
  validates :name, presence: true, uniqueness: { scope: [:team_id, :project_id] }
  validates :enable, presence: true
  validates :cron, allow_blank: true, format: { with: /\A((\*|\d+((\/|\-){0,1}(\d+))*)\s*){5}\z/ }

  def to_api
    as_json(only: [:_id, :name, :enable, :cron, :config, :team_id, :project_id, :source_url])
  end

  def source_url
    source.url
  end
end
