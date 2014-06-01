class API::V1::AuthorsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create, :update, :destroy]

	def index
		@authors = Author.all
	end

	def show
		@author = Author.find(params[:id])
	end

	def create
		@author = Author.new(params[:author].permit(:firstname, :lastname, :middlename, :title, :source))
		if @author.save
			render json: @author, status: :created
		else
			render json: @author.errors, status: :unprocessable_entity
		end
	end

	def update
		@author = Author.find(params[:id])
		if @author.update_attributes(params[:author].permit(:firstname, :lastname, :middlename, :title, :source))
			head :no_content, status: :ok
		else
			render json: @author.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@author = Author.find(params[:id])
		if @author.destroy
			head :no_content, status: :ok
		else
			render json: @author.errors, status: :unprocessable_entity
		end
	end
end
