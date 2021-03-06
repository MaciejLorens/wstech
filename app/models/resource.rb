class Resource < ActiveRecord::Base
  belongs_to :order

  has_attached_file :image, styles: { medium: '300x300>', thumb: '50x50>' }, default_url: '/images/:style/missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
