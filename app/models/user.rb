class User < ActiveRecord::Base
  attr_accessible :username, :password, :status


  def self.login(parameter)
    return false if parameter.blank?
    # User.find_by_username_and_password(parameter[:username], Digest::MD5.hexdigest(parameter[:password]))
    where(username: parameter[:username], password: Digest::MD5.hexdigest(parameter[:password])).first
  end

end
