class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  
  def create
    following = current_user.relationships.build(follower_id: params[:user_id])
    following.save
    
  end
  
  def destroy
    following = current_user.relationships.find_by(follower_id: params[:user_id])
    following.destroy
    
  end
  
  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
