class Gallery::Gallery < ActiveRecord::Base
  self.table_name = :gallery_galleries
  
  cms_is_categorized if defined?(ComfortableMexicanSofa)
  cms_has_revisions_for :title, :description, :full_width, :full_height, :force_ratio_full, :thumb_width, :thumb_height, :force_ratio_thumb

  
  # -- Relationships --------------------------------------------------------
  has_many :photos, :dependent => :destroy
  
  # -- Validations ----------------------------------------------------------
  validates :title,
    :presence => true
    
  validates :identifier,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with =>  /\A\w[a-z0-9_-]*\z/i }
    
end