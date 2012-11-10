class SessionsController < ApplicationController
	before_filter :authenticate_user, :only => [:home, :profile, :setting]
	before_filter :save_login_state, :only => [:login, :login_attemt]
	
  def login
  end
  
  def login_attempt
  	authorized_user = User.authenticate(params[:username_or_email], params[:login_password])
  	if authorized_user
  		#create user_id session key, storing authorized user id
  		session[:user_id] = authorized_user.id
  		flash[:notice] = "wow welcome again, you logged in as #{authorized_user.username}"
  		redirect_to(home_path)
  	else
  		flash[:notice] = "invalid username or password"
  		flash[:color]="invalid"
  		render "login"
  	end
  end
  
  def logout
  	session[:user_id] = nil
  	redirect_to(login_path)
  end

  def home
  end

  def profile
  end

  def setting
  end
end
