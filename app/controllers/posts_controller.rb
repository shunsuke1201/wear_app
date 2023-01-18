class PostsController < ApplicationController
  before_action :post_find, { only:[:show, :edit, :update, :destroy]}
  before_action :authenticate_user!, except: [:index]
  
  def index
    @posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = Post.create(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "投稿しました"
    else
      render "new"
    end
  end

  def edit
    if @post.user != current_user
      redirect_to posts_path, alert: "不正なアクセスです"
    end
  end
  
  def update
    if @post.update(post_params)
    redirect_to post_path(@post), notice: "更新しました"
    else
      render "edit"
    end
  
  end
  
  def destroy
    @post.destroy
    redirect_to posts_path
  end
  
  private
  
  def post_find
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:item, :body, post_images_images: [])
  end
end
