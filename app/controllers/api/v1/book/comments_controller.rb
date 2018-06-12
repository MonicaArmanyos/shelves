module Api::V1::Book
  class Api::V1::Book::CommentsController < ApplicationController
   
    before_action :set_book, only: [:create, :destroy]
    before_action :authenticate_request, only: [:create, :destroy]
    before_action :set_comment, only: [:destroy]

    def create
      # check user if authenticate or not  
      if @current_user
        # check comment not empty and it's length larger than two character
        if ((params[:comment]) && (params[:comment].length >= 2))
          @comment = @book.comments.new(:book_id => @book.id, :user_id => @current_user.id, :comment => params[:comment])
          # save comment and check it saved successfuly
          if @comment.save
            render json: {status: 'SUCCESS', message: 'comment successfully created', comment: {id: @comment.id, comment: @comment.comment, user: @current_user.name, created_at: @comment.created_at.strftime("%B %e, %Y at %I:%M %p") }},status: :ok    
          else
            render json: {status: 'FAIL', message: 'Couldn\'t create comment', error:@comment.errors},status: :ok   
          end
        else
          render json: {status: 'FAIL', message: 'Comment can\'t be blank or less than two characters', error:{}},status: :ok               
        end     
      end  
    end    
 
    #def index
      #@comments=Comment.where(book_id: params[:id])
      #render json: {status: 'SUCCESS', message: 'return', comments: {id: @comment.id, comment: @comment.comment, user: @current_user.name, created_at: @comment.created_at.strftime("%B %e, %Y at %I:%M %p") }},status: :ok    
    #end    
    def destroy
      if @current_user.id == @comment.user_id

      else
        
      end    
    end   

    private
    def set_book
      @book = Book.find(params[:book_id])   
    end
    #### Authentication of user ####
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
    end
    def set_comment
      @comment= Comment.find(params[:id])
    end    
  end
end  
