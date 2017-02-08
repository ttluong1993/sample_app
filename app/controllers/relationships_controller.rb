class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @user = User.find_by id: params[:user_id]
    redirect_to users_path unless @user
    @title = params[:relationship]
    if @user.respond_to? @title
      @users = @user.send(@title).paginate page: params[:page],
        per_page: 10
    else
      flash[:danger] = "Unexpected value for relationship!"
      redirect_to root_url
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      @relationship = current_user.active_relationships
        .find_by followed_id: @user.id
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = "Can't find user!"
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user
      current_user.unfollow @user
      respond_to do |format|
        format.html {redirect_to @user}
        format.js
      end
    else
      flash[:danger] = "Relationship does not exist!"
    end
  end
end
