# Quote Locker Basic REST API with Rails

This is the concept application for
[*QuoteLocker*](http://neilmpatterson.ghost.io/)
by [Neil Patterson](http://neilmpatterson.ghost.io/).

_April 23, 2014_

## Basic Objective
I started this project as a stepping stone to learn and share my experience in building a Rails app for the first time. The larger project will include  a backbone driven single page app using Backbone.js, Marionette and Rails API.

The first step is to build a useable API for the Backbone.JS models to consume data. I am fairly new to Rails and extremely new to Backbone. I am sure the contents in this project will be modified, refactored and change for the better over time. 

The idea is to build a library of Quotations that users can save to collections, categorized and shared to various social media outlets. To accomplish this, we will need to model Quotes and Authors first. Eventually we will also need Users, Categories, Lists. For the purpose of starting a basic API, let's just start with Quotes and Authors. 

Let's have a look at our proposed models:

### Models
- Quotes
  - belongs_to :authors
  - author_id:integer FK	
  - content:string
  - public:boolean
  
---
	
- Authors
  - has_many :quotes
  - first_name:string
  - last_name:string
  - middle_name:string
  - title:string
  - source:string

---

Pretty straight-forward we will have authors which are person who is delivering the quotes and the quotes themselves. An Author can have many quotes, but a quote can only belong to one author. 

First things first:

    $ rails new quotelocker
    $ cd quotelocker

With our Rails application created, let's modify the Gemfile. The default Gemfile will work fine, but I don't need coffeescript and I would like Redcarpet in order to render markdown to html. 

__Gemfile__
    source 'https://rubygems.org'
    ruby '2.1.1'
    
    gem 'rails', '4.0.4'
    gem 'sass-rails', '4.0.1'
    gem 'uglifier', '2.1.1'
    gem 'jquery-rails', '3.0.4'
    gem 'turbolinks', '1.1.1'
    gem 'jbuilder', '1.0.2'
    gem 'redcarpet', '3.1.2'
    
    group :development, :test do
      gem 'sqlite3', '1.3.8'
    end
    
    group :doc do
      gem 'sdoc', '0.3.20', require: false
    end
    
After running a bundle update, we can modify the routes.rb file so that we can tell the app to only respond with JSON and create the namespace and the version
 
 __config/routes.rb__
 
    QuoteLocker::Application.routes.draw do
	    namespace :api, :defaults => {:format => :json} do
	        namespace :v1 do
	            resources :quotes, :authors
	        end
	    end
    end

One other file we need to modify is the inflections.rb which will aid in making our controllers (which will be created in /app/controllers/api/v1/) use a nicely formatted `API::AuthorsController < ApplicationController` as opposed to `Api::AuthorsController < ApplicationController`
Simply uncomment the block and add the API acronym:

__config/initializers/inflections.rb__ 

    ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym 'API'
    end

With that in place our API will be available in a URL structured like `http://127.0.0.1:3000/api/v1/authors` however, first, we need to create our controllers and models. 

Let's start with our Authors controller since we cannot have a quote without an author. In the terminal we can generate the controller

    $ rails g controller api/v1/Authors index show create update destroy --no-test-framework  --skip-assets  --skip-helper

This will generate the controller in /app/controllers/api/v1/authors_controller.rb with the core methods to handle our RESTful api calls without the tests, css or javascript or helper files which wont be necessary. We wont need the views either aside from some jbuilder templates. We'll come back to that shortly. 

First let's generate the model:

    $ rails g model Author first_name:string last_name:string middle_name:string title:string source:string --no-test-framework
     
The model is not available until we migrate the db:
    
    $ rake db:migrate
    
The model is now available and you can test by adding an author via the rails console:

    $ rails c
    >> author = Author.new(first_name: "Lex", last_name: "Luthor", source: "Superman (1978)")
    >> author.save

The author is in the db but it will not be returned by the api until we add logic to the controller and add the json template. To modify the controller, lets add logic to the index method
    
__app/controllers/api/v1/authors_controller.rb__

    class API::V1::AuthorsController < ApplicationController
      def index
        @authors = Author.all
      end
    
      def show
      end
    
      def create
      end
    
      def update
      end
    
      def destroy
      end
    end
    
Now we can return something to our json view template. We will use jbuilder so lets cd into our views directory and rename the index template. Since we're in there we can also rename the show template and remove the create, destroy and update templates. 

    $ cd app/views/api/v1/authors/
    $ mv index.html.erb index.json.jbuilder -i
    $ mv show.html.erb show.json.jbuilder -i
    $ rm create.html.erb
    $ rm destroy.html.erb
    $ rm update.html.erb
    $ cd -
    
__/app/views/api/v1/authors/index.json.jbuilder__

    json.array!(@authors) do |author|
    	json.id author.id
    	json.first_name author.first_name
    	json.middle_name author.middle_name
    	json.last_name author.last_name
    	json.title author.title
    	json.source author.source
    end
    
Now if we start the rails server `$ rails s` and then navigate to the authors api call `http://127.0.0.1:3000/api/v1/authors` we will see our json response with Lex Luthor that we added in rails console:

But we are returning first, last and middle names. Would be nice to only return full name, right? Lets just add a full_name method to the model and update the json:

__/app/models/author.rb__

    class Author < ActiveRecord::Base
    	def full_name
			"#{first_name} #{middle_name} #{last_name}"
    	end
    end
    
 __/app/views/api/v1/authors/index.json.jbuilder__
 
     json.array!(@authors) do |author|
     	json.id author.id
     	json.name author.full_name
     	json.title author.title
     	json.source author.source
     end

Awesome! Now we can add the show method so we can get to `http://127.0.0.1:3000/api/v1/authors/1` to show only one author. 

__app/controllers/api/v1/authors_controller.rb__

    class API::V1::AuthorsController < ApplicationController
      def index
        @authors = Author.all
      end
    
      def show
    	@author = Author.find(params[:id])
      end
    
      def create
      end
    
      def update
      end
    
      def destroy
      end
    end
    
  __/app/views/api/v1/authors/show.json.jbuilder__
  
      json.(@author, :id, :full_name, :title, :source) 

Perfect! now we can return a single author when requested. In order to get the create, destroy and update to work with have to tell the controller to skip authentication. Adding some form of authentication will be added in later.

__app/controllers/api/v1/authors_controller.rb__

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


Now we can use an API client to post a create author request, put an update author request, or delete a destroy author request

    => creating author
       url: http://127.0.0.1:3000/api/v1/authors
       method: Post
       Body : {"author": {"first_name": "Louis", "last_name": "Lane", "source": "Superman (1978)"}}
    
    => Updating User
      url: http://127.0.0.1:3000/api/v1/authors/:id 
      method: PUT
      Body : {"author": {"first_name": "Lois"}}
      
    => Deleting User 
      url: http://127.0.0.1:3000/api/v1/authors/:id 
      method: DELETE
      body : not needed
      
That's it, but let's add our actual Quotes to the mix. Start with the controller or most people prefer to start with the model but we're making minimal modifications so it makes little difference for us

    $ rails g controller api/v1/Quotes index show create update destroy --no-test-framework  --skip-assets  --skip-helper

Now the model

    $ rails g model Quote content:string public:boolean author_id:integer --no-test-framework
     
The model is not available until we migrate the db:
    
    $ rake db:migrate
    
The Quotes will belong to Authors so we need to tell our models:

__/app/models/quote.rb__

    class Quote < ActiveRecord::Base
    	belongs_to :author
    end

__/app/models/author.rb__

    class Author < ActiveRecord::Base
    	has_many :quotes
    
    	def full_name
    		"#{first_name} #{middle_name} #{last_name}"
    	end
    end

Let's fill in the controller the same as our author controller

__app/controllers/api/v1/quotes_controller.rb__

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

Update the templates:
    
     $ cd app/views/api/v1/authors/
        $ mv index.html.erb index.json.jbuilder -i
        $ mv show.html.erb show.json.jbuilder -i
        $ rm create.html.erb
        $ rm destroy.html.erb
        $ rm update.html.erb
        $ cd -
        
__/app/views/api/v1/quotes/index.json.jbuilder__

    json.array!(@quotes) do |quote|
    	json.id quote.id
    	json.content quote.content
    	json.isPublic quote.public
    	json.author quote.author, :id, :full_name, :title, :source
    end
    
Notice the json.author line above? It will pull in the author details to show when we list out all quotes! Associative data, no joins required!!

 __/app/views/api/v1/quotes/show.json.jbuilder__
  
      json.(@quote, :id, :content, :public)
      json.author @quote.author, :id, :full_name, :title, :source
      
We can return author data in our show response as well. Everything's in place so we can add, list, create, update and delete quotes using the API

    => creating quote
       url: http://127.0.0.1:3000/api/v1/quotes
       method: Post
       Body : {"quote": {"author_id": "1", "content": "It's amazing that brain can generate enough power to keep those legs moving.", "public": "true"}}
    
    => listing quotes
       url: http://127.0.0.1:3000/api/quotes
       method: GET
       body : not needed
    
    => Retrieving Quote detail
      url: http://127.0.0.1:3000/api/quotes/:id 
      method: GET
      body : not needed
    
    => Updating User
      url: http://127.0.0.1:3000/api/v1/quotes/:id 
      method: PUT
      Body : {"quote": {"public": "false"}}
      
    => Deleting User 
      url: http://127.0.0.1:3000/api/v1/quotes/:id 
      method: DELETE
      body : not needed