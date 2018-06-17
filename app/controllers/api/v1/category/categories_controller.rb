module Api::V1::Category
    

            class Api::V1::Category::CategoriesController < ApplicationController
                def index
                    @categories = Category.all

                    render json: {status: 'SUCCESS', message: 'Loaded categories', data:@categories},status: :ok
                end

                def get_books_for_category
                    @books_category=Book.where(:Category_id => params[:id])
                    if @books_category.count != 0
                        render :json => @books_category, each_serializer: BookSerializer 
                    else
                        render json: {status: 'FAil', message: 'Books Not Foud For this category'},status: :ok
                    end
                end
            end
     


end
