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
	
- Authors
  - has_many :quotes
  - first_name:string
  - last_name:string
  - middle_name:string
  - title:string
  - source:string
	
Pretty straight-forward we will have authors which are person who is delivering the quotes and the quotes themselves. An Author can have many quotes, but a quote can only belong to one author. 

Now we code:
