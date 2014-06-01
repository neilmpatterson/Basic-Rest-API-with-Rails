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
    
    group :production do
      gem 'pg', '0.15.1'
      gem 'rails_12factor', '0.0.2'
    end
    
Next we can modify the routes.rb file so that we can tell the app to only respond with JSON and create the namespace and the version
 
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

    $ rails generate controller api/v1/Authors index show create update destroy --no-test-framework

This will generate the controller in /app/controllers/api/v1/authors_controller.rb with the core methods to handle our RESTful api calls


