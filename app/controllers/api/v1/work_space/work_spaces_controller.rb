class Api::V1::WorkSpace::WorkSpacesController < ApplicationController
	def index
                if (params[:page]).eql? nil
                    current_page=1
                else
                    current_page=(params[:page])
                end
                @work_spaces=WorkSpace.all.page(params[:page]).per(8)
               
                  if @work_spaces.count != 0
                    render json: @work_spaces,
                    meta: {
                        pagination: {
                        per_page: 8,
                        current_page: current_page.to_i,
                        total_pages: (WorkSpace.all.count.to_f/8).ceil,
                        total_objects: WorkSpace.all.count
                  }
                  }
                  else
                    render json: {status: 'FAIL', message: 'No work_spaces found'},status: :ok
                  end
	end
end
