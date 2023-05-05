class PostsController < ApplicationController
  before_action :post_find, { only:[:show, :edit, :update, :destroy]}
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user, :post_images).order(created_at: :desc).page(params[:page]).per(8)
  end


  def show
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.build(post_params)
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
    params.require(:post).permit(:item, :body, :category, post_images_images: [])
  end
end
