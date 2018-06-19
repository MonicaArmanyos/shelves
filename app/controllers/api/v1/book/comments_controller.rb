module Api::V1::Book
  class Api::V1::Book::CommentsController < ApplicationController
   
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
            render json: @comment,meta:{status: 'SUCCESS', message: 'comment successfully created'},status: :ok    
          else
            render json: {status: 'FAIL', message: 'Couldn\'t create comment', error:@comment.errors},status: :ok   
          end
        else
          render json: {status: 'FAIL', message: 'Comment can\'t be blank or less than two characters', error:{}},status: :ok               
        end     
      end  
    end    
 
    def index
      @comments=Comment.where(book_id: @book.id).all.order('created_at DESC')
      render :json => @comments, meta:{ status: 'SUCCESS',message: 'comments loaded'},status: :ok 
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
              render json: @comment,meta: {status: 'SUCCESS', message: 'Comment successfully updated'},status: :ok
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
          @replies = @comment.replies
          @replies.each do |reply|
            reply.destroy
          end  
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
