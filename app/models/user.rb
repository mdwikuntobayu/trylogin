class User < ActiveRecord::Base
  before_save :encrypt_password
  after_save :clear_password
  
  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password
    
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  
  validates :username, :presence => true,
  																			:length => {:in => 3..25},
  																			:uniqueness => true
	
	validates :email, :presence => true,
																:format => EMAIL_REGEX,
																:uniqueness => true
																
	validates :password, :presence => true,
																			:confirmation => true,
																			:length => {:in => 6..20},
																			:on => :create
																			
  #encrypt password with BCrypt
  def encrypt_password
  	if password.present?
  		self.salt = BCrypt::Engine.generate_salt
  		self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
  	end
  end
  
  def clear_password
  	self.password = nil
  end
  
  #authenticate user, take username/email and matched with database
  def self.authenticate(username_or_email = "", login_password="")
  	if EMAIL_REGEX.match(username_or_email)
  		user = User.find_by_email(username_or_email)
  	else
  		user = User.find_by_username(username_or_email)
  	end
  	
  	if user && user.match_password(login_password)
  		return user
  	else
  		return false
  	end
  end
  
  def match_password(login_password = "")
  	encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end
  
end
