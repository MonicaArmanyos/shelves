module Api::V1::Book
    class Api::V1::Book::RatesController < ApiController
        before_action :set_book

        def create
            #### check if user give a rate on this book before or not ###
            if @book.rates.where(:user_id => current_user.id).first
                #### update old rate
                @old_rate = @book.rates.where(:user_id => current_user.id)
                @old_rate.update(:rate => params[:rate].to_i)
                render json: {status: 'SUCCESS', message: 'Rate successfully updated to book'},status: :ok
            else
                #### add new rate
                @rate = @book.rates.new(:book_id => params[:book_id], :rate => params[:rate].to_i)
                @rate.user_id = current_user.id 
                if @rate.save
                    @rate =@book.rates.average("rate")
                    @book.update(:rate => @rate)

                    render json: {status: 'SUCCESS', message: 'Rate successfully added to book'},status: :ok
                else
                    render json: {status: 'FAIL', message: 'Couldn\'t add rate to book'},status: :ok
                end
            end
                
            
        end

        private

        def set_book
            #### check if book exist
            if Book.exists?(params[:book_id])
            @book = Book.find(params[:book_id])
            else
                 render json: {status: 'FAIL', message: 'Couldn\'t find this book'},status: :ok
            end
        end

    end
end
