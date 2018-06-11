module Api::V1::Book
  class Api::V1::Book::CommentsController < ApplicationController
   
    before_action :set_book
    before_action :authenticate_request


    private
    def set_book
      @book = Book.find(params[:book_id])
    end
    #### Authentication of user ####
    def authenticate_request
      @current_user = AuthorizeApiRequest.call(request.headers).result
    end
  end
end  
