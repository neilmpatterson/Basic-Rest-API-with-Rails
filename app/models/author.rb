class Author < ActiveRecord::Base
	has_many :quotes

	def full_name
		"#{firstname} #{middlename} #{lastname}"
	end
end
