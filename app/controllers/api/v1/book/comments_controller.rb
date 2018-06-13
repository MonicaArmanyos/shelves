module Api::V1::Book
  class Api::V1::Book::CommentsController < ApiController
   
    before_action :set_book, only: [:create, :destroy, :update, :index]
    before_action :authenticate_request, only: [:create, :destroy, :update]
    before_action :set_comment, only: [:destroy, :update]

    def create
      # check user if authenticate or not  
      if @current_user
        # check comment not empty and it's length larger than two character
        if ((params[:comment]) && (params[:comment].length >= 2))
          @comment = @book.comments.new(:book_id => @book.id, :user_id => @current_user.id, :comment => params[:comment])
          # save comment and check it saved successfuly
          if @comment.save
            render json: {status: 'SUCCESS', message: 'comment successfully created', comment: {id: @comment.id, comment: @comment.comment, user: {id: @current_user.id, name: @current_user.name, profile_picture: @current_user.profile_picture}, created_at: @comment.created_at.strftime("%B %e, %Y at %I:%M %p") }},status: :ok    
          else
            render json: {status: 'FAIL', message: 'Couldn\'t create comment', error:@comment.errors},status: :ok   
          end
        else
          render json: {status: 'FAIL', message: 'Comment can\'t be blank or less than two characters', error:{}},status: :ok               
        end     
      end  
    end    
 
    def index
      @comments=Comment.where(book_id: @book.id)
      render json: {status: 'SUCCESS', message: 'return', comments: @comments},status: :ok    
    end   

    def update
      # check user if authenticate or not  
      if @current_user 
        # check if user has permation to update this comment (owner) 
        if @current_user.id == @comment.user_id 
          # check comment not empty and it's length larger than two character
          if ((params[:comment]) && (params[:comment].length >= 2))
            # update comment and check if it is updated or not
            if @comment.update(comment_params)
              render json: {status: 'SUCCESS', message: 'Comment successfully updated', comment:{id: @comment.id, comment: @comment.comment, user: @current_user.name, created_at: @comment.created_at.strftime("%B %e, %Y at %I:%M %p") }},status: :ok
            else
              render json: {status: 'FAIL', message: 'Couldn\'t update comment', error:@comment.errors},status: :ok            
            end  
          else
            render json: {status: 'FAIL', message: 'Comment can\'t be blank or less than two characters', error:{}},status: :ok                           
          end  
        else
          render json: {status: 'FAIL', message: 'you can\'t delete this comment', error:{}},status: :ok               
        end  
      end  
    end

    def destroy
      # check user if authenticate or not  
      if @current_user
        # check if user has permation to delete this comment (owner) 
        if @current_user.id == @comment.user_id
          # check if comment deleted or not
          if @comment.destroy
            render json: {status: 'SUCCESS', message: 'comment successfully deleted', comment: {}},status: :ok    
          else
            render json: {status: 'FAIL', message: 'you can\'t delete this comment', error:@comment.errors},status: :ok               
          end   
        else
          render json: {status: 'FAIL', message: 'you can\'t delete this comment', error:{}},status: :ok               
        end 
      end     
    end   

    private
    # find current book object
    def set_book
      @book = Book.find(params[:book_id])   
    end
    #### Authentication of user ####
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
    # find current comment object
    def set_comment
      @comment= Comment.find(params[:id])
    end  
    
    def comment_params
      params.permit(:comment, :book_id, :user_id)
    end  
  end
end  
