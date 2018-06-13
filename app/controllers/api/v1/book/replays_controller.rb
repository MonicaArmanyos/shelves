module Api::V1::Book
  class Api::V1::Book::ReplaysController < ApplicationController
    before_action :set_comment, only: [:create, :destroy, :update, :index]
    before_action :authenticate_request, only: [:create, :destroy, :update]
    before_action :set_replay, only: [:destroy, :update]

    def create
      # check user if authenticate or not  
      if @current_user
        # check replay not empty and it's length larger than two character
        if ((params[:replay]) && (params[:replay].length >= 2))  
            @replay = @comment.replays.new(:comment_id => @comment.id, :user_id => @current_user.id, :replay => params[:replay])
            # save replay and check it saved successfuly
            if @replay.save
              render json: @replay, meta:{ status: 'SUCCESS',message: 'Replay successfully created'},status: :ok    
            else
              render json: {status: 'FAIL', message: 'Couldn\'t create replay', error:@replay.errors},status: :ok   
            end
        else
          render json:{status: 'FAIL', message: 'Replay can\'t be blank or less than two characters', error:{}},status: :ok                           
        end    
      end  
    end    

    def update
      # check user if authenticate or not  
      if @current_user 
        # check if user has permation to update this replay (owner) 
        if @current_user.id == @replay.user_id 
          # check replay not empty and it's length larger than two character
          if ((params[:replay]) && (params[:replay].length >= 2))
            # update replay and check if it is updated or not
            if @replay.update(replay_params)
              render json: @replay, meta:{ status: 'SUCCESS',message: 'Replay successfully updated'},status: :ok
            else
              render json: {status: 'FAIL', message: 'Couldn\'t update replay', error:@replay.errors},status: :ok            
            end  
          else
            render json: {status: 'FAIL', message: 'Replay can\'t be blank or less than two characters', error:{}},status: :ok                           
          end  
        else
          render json: {status: 'FAIL', message: 'you can\'t delete this replay', error:{}},status: :ok               
        end       
      end
    end  
    
    def destroy
      # check user if authenticate or not  
      if @current_user
        # check if user has permation to delete this replay (owner) 
        if @current_user.id == @replay.user_id
          # check if replay deleted or not
          if @replay.destroy
            render json: {status: 'SUCCESS', message: 'Replay successfully deleted', replay: {}},status: :ok    
          else
            render json: {status: 'FAIL', message: 'you can\'t delete this replay', error:@replay.errors},status: :ok               
          end   
        else
          render json: {status: 'FAIL', message: 'you can\'t delete this replay', error:{}},status: :ok               
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
     # find current replay object
     def set_replay
      @replay= Replay.find(params[:id])
    end  
    
    def replay_params
      params.permit(:replay, :comment_id, :user_id)
    end  
  end  
end
