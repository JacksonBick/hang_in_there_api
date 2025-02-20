class PosterSerializer
    include JSONAPI::Serializer
    attributes :name, :description, :year, :vintage, :img_url, :price
end