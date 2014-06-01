class API::V1::QuotesController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => [:create, :update, :destroy]

	def index
		@quotes = Quote.all
	end

	def show
		@quote = Quote.find(params[:id])
	end

	def create
		@quote = Quote.new(params[:quote].permit(:author_id, :isPublic, :content))
		if @quote.save
			render json: @quote, status: :created
		else
			render json: @quote.errors, status: :unprocessable_entity
		end
	end

	def update
		@quote = Quote.find(params[:id])
		if @quote.update_attributes(params[:quote].permit(:author_id, :isPublic, :content))
			head :no_content, status: :ok
		else
			render json: @quote.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@quote = Quote.find(params[:id])
		if @quote.destroy
			head :no_content, status: :ok
		else
			render json: @quote.errors, status: :unprocessable_entity
		end
	end
end
