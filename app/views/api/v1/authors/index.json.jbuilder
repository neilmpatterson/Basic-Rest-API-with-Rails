json.array!(@authors) do |author|
	json.id author.id
	json.full_name author.full_name
	json.title author.title
	json.source author.source
end


