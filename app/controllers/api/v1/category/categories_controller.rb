module Api::V1::Category
    

            class Api::V1::Category::CategoriesController < ApplicationController
                def index
                    @categories = Category.all

                    render json: {status: 'SUCCESS', message: 'Loaded categories', data:@categories},status: :ok
                end
            end
     


end
