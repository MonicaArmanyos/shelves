module Api::V1::Book
  class Api::V1::Book::ReplaysController < ApplicationController
    before_action :set_comment, only: [:create, :destroy, :update, :index]
    before_action :authenticate_request, only: [:create, :destroy, :update]

    def create
      # check user if authenticate or not  
      if @current_user
        # check replay not empty and it's length larger than two character
        if ((params[:replay]) && (params[:replay].length >= 2))  
            @replay = @comment.replays.new(:comment_id => @comment.id, :user_id => @current_user.id, :replay => params[:replay])
            # save replay and check it saved successfuly
            if @replay.save
              render json: {status: 'SUCCESS', message: 'Replay successfully created', replay: {id: @replay.id, replay: @replay.replay, user: {id: @current_user.id, name: @current_user.name, profile_picture: @current_user.profile_picture},comment: {id: @comment.id}, created_at: @replay.created_at.strftime("%B %e, %Y at %I:%M %p") }},status: :ok    
            else
              render json: {status: 'FAIL', message: 'Couldn\'t create replay', error:@replay.errors},status: :ok   
            end
        else
          render json: {status: 'FAIL', message: 'Replay can\'t be blank or less than two characters', error:{}},status: :ok                           
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
  end  
end
