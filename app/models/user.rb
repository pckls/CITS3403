require 'digest/sha2'

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not formatted realistically")
    end
  end
end

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :confirm, :saltdata, :digest, :password_confirmation, :friendlist
  validates :email, :uniqueness => true, :length => {:minimum => 6}, :email => true
  validates :name, :uniqueness => true, :length => {:minimum => 4}
  validates :password, :confirmation => true

  serialize :friendlist

  # 'friends' is a pseudoproperty, backed by the friendlist column. It will create an empty array
  # the first time it is accessed.
  def friends
    self.friendlist ||= []
    self.friendlist
  end

  def friends=(val)
    self.friendlist = val
  end


  def make_digest(password)
  	self.saltdata ||= SecureRandom.hex()
    input = self.saltdata + (password or "") + self.saltdata
    (Digest::SHA2.new << input).to_s
  end

  def password=(new_password)
      @_password = new_password
      self.digest = make_digest(new_password) unless new_password == ""
  end
  def password
    @_password
  end
  
  def check_password(candidate)
    make_digest(candidate) == self.digest rescue false
  end
  public
  def has_befriended(other)
    friends.include? other.id or friends.include? "#{other.id}"
  end

end
