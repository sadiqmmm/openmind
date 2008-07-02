class CommentsController < ApplicationController
  
  before_filter :login_required
  access_control [:edit, :update, :destroy] => 'prodmgr | voter'
 
  def index
    @comment_pages, @comments = paginate :comments, :per_page => 10
  end

  def preview
    render :layout => false
  end
  
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)c/whenToUseGet.html)
  verify :method => :post, :only => [:create ],
    :redirect_to =>{ :controller => 'ideas', :action => :index }
  verify :method => :put, :only => [ :update ],
    :redirect_to => { :controller => 'ideas', :action => :index }
  verify :method => :delete, :only => [ :destroy ],
    :redirect_to => { :controller => 'ideas', :action => :index }

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @idea = Idea.find(params[:id])
    @comment ||= Comment.new
  end

  def create
    @idea = Idea.find(params[:id])
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.idea_id = @idea.id
    if @comment.save
      flash[:notice] = "Comment for idea number #{@comment.idea.id} was successfully created."
      redirect_to :controller => 'ideas', :action => 'show', :id => @idea, :selected_tab => "COMMENTS"
    else
      new
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = 'Comment was successfully updated.'
      redirect_to :controller => :ideas, :action => :show, :id => @comment.idea.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to comments_path
  end
end