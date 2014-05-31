# PrettyQuotes concept application

This is the concept application for
[*PrettyQuotes.app*](http://neilmpatterson.com/)
by [Neil Patterson](http://neilmpatterson.com/).

_April 23, 2014_

### Concept for: Quote website
### Short Description: 
	repository for users to create shareable collections of quotes/speeches. 
### Long Description: 
	allow users to upload image, add author and format short or long quote using markdown
	if long quote (or speech) then allow helper tag such as [break] to navigate through text
	user can categorize quotes
	public quotes will include discus commenting
	public quotes are searchable by author or quote author or category or author publication
	users can format text over quote like in most javascript top banner/sliders

### For first deploy:
	use omniauth and doorkeeper for adding users	signin/off ala http://octolabs.com/so-auth

## Models
* Users
	* has_many :quotes
	* firstname:string
	* lastname:string
	* email:string
* Quotes
	* belongs_to :users
	* has_many :categories
	* content:string
	* image:string
	* isPublic:boolean
* Categories
	* belongs_to :quotes
	* name:string
* Authors
	* belongs_to :quotes
	* firstname:string
	* lastname:string
	* middlename:string
	* title:string
	* publication:string
	
	
## API
http://collectiveidea.com/blog/archives/2013/06/13/building-awesome-rails-apis-part-1/
http://quickleft.com/blog/keeping-your-json-response-lean-in-rails
http://stackoverflow.com/questions/4318962/ruby-on-rails-render-json-for-multiple-models