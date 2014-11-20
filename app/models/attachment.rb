class Attachment < ActiveRecord::Base
  belongs_to :task, inverse_of: :attachments

  validates_presence_of :title, :url, :task
  validates :url, :format => URI::regexp(%w(http https))
end
