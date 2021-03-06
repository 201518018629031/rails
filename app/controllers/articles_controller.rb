class ArticlesController < ApplicationController
 
  def index
    res = Article
    order = 'updated_at desc'
    if params[:sort].present?
      order = case params[:sort]
                when 'star'
                  'star_count desc'
                when 'comments'
                  'comments_count desc'
                else
                  'updated_at desc'
              end
    end
    if params[:c].present?
      category = Category.find params[:c]
      res = res.where("category_id=#{category.id}") if category
    end
    res = res.where("title like ?", "%#{params[:keyword]}%") if params[:keyword].present?
    @articles = res.order(order).page(params[:page]).per(Settings.blog.aritcle_page_size)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new params.require(:article).permit(:title, :tags, :source, :content)
    @article.user_id = @current_user.id
    if params[:article].present? && params[:article][:category_id].present?
      @article.category_id = params[:article][:category_id]
    elsif params[:article].present? && params[:article][:category_name].present?
      category = Category.find_or_create params[:article][:category_name]
      @article.category_id = category.id
    end
    if @article.save
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def show
    @article.add_view request.remote_ip, @current_user, params.inspect
    @comment = @article.comments.new
    @comments = @article.comments.order('updated_at asc').page(params[:page]).per(Settings.blog.comments_page_size)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit

  end

  def update
    attributes = params.require(:article).permit(:title, :tags, :source, :content)
    if params[:article].present? && params[:article][:category_id].present?
      attributes[:category_id] = params[:article][:category_id]
    elsif params[:article].present? && params[:article][:category_name].present?
      category = Category.find_or_create params[:article][:category_name]
      attributes[:category_id] = category.id
    end
    if @article.update_attributes attributes
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    if @article.destroy
      redirect_to articles_path
    else
      flash[:error] = '删除失败'
      redirect_to article_path(@article)
    end
  end

  def star
    
  end

  protected

  def check_current_user_is_admin
   
  end

  def article
    
  end
end
