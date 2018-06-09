module Api::V1::Book
    class Api::V1::Book::RatesController < ApiController
        before_action :set_book

        def create
            @rate = @book.rates.new(:book_id => params[:book_id], :rate => params[:rate].to_i)
            @rate.user_id = current_user.id 
            if @rate.save
                #@rate = Rate.where(book_id: params[:book_id]).average("rate")
                @rate =@book.rates.average("rate")
                puts @rate
                @book.update(:rate => @rate)
                #puts @rate
                #@book.update(rate: @rate)
                render json: {status: 'SUCCESS', message: 'Rate successfully added to book'},status: :ok
            else
                render json: {status: 'FAIL', message: 'Couldn\'t add rate to book'},status: :ok
            end
        end

        private

        def set_book
            @book = Book.find(params[:book_id])
        end

    end
end
