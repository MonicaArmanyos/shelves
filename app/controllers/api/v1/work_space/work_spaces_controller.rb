class Api::V1::WorkSpace::WorkSpacesController < ApplicationController
	def index
		@work_spaces=WorkSpace.all
		render json:  @work_spaces,
                meta: {
                    status: 'SUCCESS',
                    message: 'Loaded work_spaces successfully' 
                },status: :ok
	end
end
