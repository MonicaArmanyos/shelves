class Api::RatesController < ApplicationController
    before_action :set_book



    private

    def set_book
        @book = Book.find(params[:book_id])
    end

    def rate_params
         params.require(:rate).permit(:book_id, :rate)
    end
end
