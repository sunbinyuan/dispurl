json.array!(@urls) do |url|
  json.extract! url, :id, :name, :redirect_to, :alias
  json.url url_url(url, format: :json)
end
