class UsersController < ApplicationController
  # GET /users
  # GET /users.json

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def logout
    session[:user] = nil
  end

  def login
    @attempted = !! params[:password]
    @succeeded = false
    @email = params[:email] or nil
    if @email
      @user = User.where(:email => @email).first rescue nil
      if @user
        if @user.check_password(params[:password])
          @succeeded = true
          session[:user] = @user
          redirect_to @user, :notice => "You have logged in successfully."
        end
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id]) rescue nil
    if @user
      @photos = Photo.where :user_id => @user.id
      @photos = @photos.select do |photo|
        photo.may_view session[:user]
      end

      @friends = @user.friends.map do |id|
        User.find(id) rescue nil
      end
      @friends.delete nil


      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @user }
      end
    else
      redirect_to session[:user]
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = session[:user]
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html {
          session[:user] = @user
          redirect_to @user, :notice => 'Welcome to Photickle! Here is your profile.'
        }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = session[:user]

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = session[:user]
    @user.destroy
    session[:user] = nil

    respond_to do |format|
      format.html { redirect_to users_url, :notice => "Sorry to see you go!" }
      format.json { head :no_content }
    end
  end

  def befriend
    id = params[:id]
    session[:user].friends.delete params[:id]
    session[:user].friends << params[:id]
    session[:user].save
    redirect_to :back, :notice => "You have made a new friend."
  end
end
