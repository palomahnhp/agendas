class Attachment < ActiveRecord::Base

  belongs_to :event

  has_attached_file :file,
      :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_file_name",
      :url => "/system/:attachment/:id/:style/:normalized_file_name"

  validates :title, :file, presence: true
  validates :public, inclusion: [true, false]
  validates_attachment_content_type :file, content_type:
    ['application/pdf','image/jpeg', 'image/png','application/txt',
     'text/plain', 'application/msword', 'application/msexcel',
     'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.oasis.opendocument.text',
     'application/x-vnd.oasis.opendocument.text','application/rtf', 'application/x-rtf', 'text/rtf', 'text/richtext',
     'application/doc', 'application/docx', 'application/xls', 'application/xlsx', 'application/x-soffice', 'application/octet-stream'],
    message: I18n.t('backend.allowed_file_content_types')

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.file_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

end
