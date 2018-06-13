module Api::V1::Book
  class Api::V1::Book::RepliesController < ApplicationController
    before_action :set_comment, only: [:create, :destroy, :update, :index]
    before_action :authenticate_request, only: [:create, :destroy, :update]
    before_action :set_reply, only: [:destroy, :update]

    def create
      # check user if authenticate or not  
      if @current_user
        # check reply not empty and it's length larger than two character
        if ((params[:reply]) && (params[:reply].length >= 2))  
            @reply = @comment.replies.new(:comment_id => @comment.id, :user_id => @current_user.id, :reply => params[:reply])
            # save reply and check it saved successfuly
            if @reply.save
              render json: @reply, meta:{ status: 'SUCCESS',message: 'Reply successfully created'},status: :ok    
            else
              render json: {status: 'FAIL', message: 'Couldn\'t create reply', error:@reply.errors},status: :ok   
            end
        else
          render json:{status: 'FAIL', message: 'Reply can\'t be blank or less than two characters', error:{}},status: :ok                           
        end    
      end  
    end    

    def update
      # check user if authenticate or not  
      if @current_user 
        # check if user has permation to update this reply (owner) 
        if @current_user.id == @reply.user_id 
          # check reply not empty and it's length larger than two character
          if ((params[:reply]) && (params[:reply].length >= 2))
            # update reply and check if it is updated or not
            if @reply.update(reply_params)
              render json: @reply, meta:{ status: 'SUCCESS',message: 'Reply successfully updated'},status: :ok
            else
              render json: {status: 'FAIL', message: 'Couldn\'t update reply', error:@reply.errors},status: :ok            
            end  
          else
            render json: {status: 'FAIL', message: 'Reply can\'t be blank or less than two characters', error:{}},status: :ok                           
          end  
        else
          render json: {status: 'FAIL', message: 'you can\'t delete this reply', error:{}},status: :ok               
        end       
      end
    end  
    
    def destroy
      # check user if authenticate or not  
      if @current_user
        # check if user has permation to delete this reply (owner) 
        if @current_user.id == @reply.user_id
          # check if reply deleted or not
          if @reply.destroy
            render json: {status: 'SUCCESS', message: 'Reply successfully deleted', reply: {}},status: :ok    
          else
            render json: {status: 'FAIL', message: 'you can\'t delete this reply', error:@reply.errors},status: :ok               
          end   
        else
          render json: {status: 'FAIL', message: 'you can\'t delete this reply', error:{}},status: :ok               
        end 
      end     
    end   

    private
    #### Authentication of user ####
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
    # find current comment object
    def set_comment
      @comment = Comment.find(params[:comment_id])   
    end
     # find current reply object
     def set_reply
      @reply= Reply.find(params[:id])
    end  
    
    def reply_params
      params.permit(:reply, :comment_id, :user_id)
    end  
  end  
end
