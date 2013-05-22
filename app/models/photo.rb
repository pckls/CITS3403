class Photo < ActiveRecord::Base
  belongs_to :user
  attr_accessible :private, :description, :geo, :image

  has_attached_file :image, :styles => { :large => "600x600>", :medium => "450x450>", :small => "230x230>", :thumb => "100x100>" }

  validates :image, :attachment_presence => true

  def may_view(user)
  	return false unless self.user
    return true unless private
    return false unless user
  	return true if user == self.user
  	return true if self.user.has_befriended user
  	return false
  end
end
