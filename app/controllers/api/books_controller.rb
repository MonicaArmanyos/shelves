module Api
    class Api::BooksController < ApplicationController
         #### Latest Books in Home Page ####
         def latest_books
            @latest_books = Book.order('created_at Desc').limit(20);
            render json: {status: 'SUCCESS', message: 'Loaded latest_books', data:@latest_books},status: :ok
        end 

        #### Recommended Books in Home Page ####
        def recommended_books
            if current_user
                @user = current_user
                @recommended_books ||= []
                user_interests = @user.categories
                for interest in user_interests
                    @recommended_books << interest.books.order('created_at Desc').limit(5)
                end
                render json: {status: 'SUCCESS', message: 'Loaded recommended_books', data:@recommended_books},status: :ok
            end 
        end 

        private
        #### Permitted book params 
        def book_params
            params.require(:book).permit(:name, :description, :transcation, :quantity, 
                                        :bid_user, :user_id, :category_id, :price)
        end
    end
end
