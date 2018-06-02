module Api
    class Api::CategoriesController < ApplicationController
        def index
            @categories = Category.all

            render json: {status: 'SUCCESS', message: 'Loaded categories', data:@categories},status: :ok
        end
    end

end
