class Image < ActiveRecord::Base
	belongs_to :page
  #attr_accessible :desc, :file, :title
end
