class ErrorSerializer < ActiveModel::Serializer
  attributes :status, :title, :detail, :source

  def self.format_error(status, message)
    {
      errors: [
        {
          status: status.to_s,
          message: message
        }
      ]
    }
  end
end
