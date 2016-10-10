class SessionsController < ApplicationController
  def new
  
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
	  log_in user
      redirect_to user
    else
      # Create an error message.
      render 'new'
	end  
  end

  def destroy
	log_out
    redirect_to root_url
  end
  
  def root
	if logged_in?
      redirect_to current_user
    else
      render 'new'
	end  
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
