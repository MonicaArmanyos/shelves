module Api::V1::User
    class Api::V1::User::BooksController < ApplicationController
         
        def show
            user = User.find(params[:id])
            @books = user.books
            if(@books)
                render json: {status: 'SUCCESS', books:@books, each_serializer: BookSerializer},status: :ok
            else
                render json: {status: 'FAil', message: 'Can\'t get user\'s books!'},status: :ok
            end
        end
      
    end
  end
  
