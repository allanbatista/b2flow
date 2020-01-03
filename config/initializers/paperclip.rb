Paperclip::Attachment.default_options[:use_timestamp] = false

if AppConfig.B2FLOW__STORAGE__TYPE == 'GCS'
  Paperclip::Attachment.default_options[:path] = "__core__/:class/:attachment/:id/:style/:filename"
  Paperclip::Attachment.default_options[:url] = ':gcs_domain_url'
  Paperclip::Attachment.default_options[:fog_directory] = AppConfig.B2FLOW__STORAGE__BUCKET
end