class Environment
  include Mongoid::Document

  field :name, type: String
  field :value, type: String
  field :secret, type: Boolean, default: false

  index({dag_id: 1, name: 1}, {unique: true, name: "environment_dag_name_unique", background: true})

  validates_presence_of :name, :value, :secret

  def to_api
    {
        name: name,
        value: value_formated,
        secret: secret
    }
  end

  def value_formated
    if secret
      return "*" * value.size if value.size <= 4
      return value.slice(0, 2) + ("*" * (value.size - 2)) if value.size <= 15
      return value.slice(0, 5) + ("*" * (value.size - 5))
    else
      value
    end
  end
end