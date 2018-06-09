module Api::V1::User
    class Api::V1::User::BooksController < ApiController 
  
        def show
            user = User.find(params[:id])
            @books = user.books
            if(@books)
                render json: {status: 'SUCCESS', books:@books},status: :ok
            else
                render json: {status: 'FAil', message: 'Can\'t get user\'s books!'},status: :ok
            end
        end
      
    end
  end
  