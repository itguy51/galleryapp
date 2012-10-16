class Page < ActiveRecord::Base
  has_many :images, :dependent => :destroy
  #attr_accessible :name, :summary, :title
end
