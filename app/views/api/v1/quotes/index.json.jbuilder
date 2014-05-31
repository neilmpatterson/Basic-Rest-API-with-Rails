json.array!(@quotes) do |quote|
	json.quote quote.id
	json.content quote.content
	json.isPublic quote.isPublic
	json.author quote.author, :id, :full_name, :title, :source
end
