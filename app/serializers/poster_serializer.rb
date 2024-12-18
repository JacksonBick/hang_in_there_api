class PosterSerializer
  def self.format_posters(posters)
    {
      data: posters.map do |poster|
      {
        id: poster.id,
        type: poster.class,
        attributes: {
          name: poster.name,
          description: poster.description,
          price: poster.price,
          year: poster.year,
          vintage: poster.vintage,
          img_url: poster.img_url
        }
      }
    end
  }
  end

  def self.format_single_poster(poster)
    {
      data: format_single_poster_data(poster)
    }
  end

  def self.create_poster(poster)
    {
      name: poster.name
    }
  end

  private
  
  def self.format_single_poster_data(poster)
    {
      id: poster.id,
      type: poster.class.to_s,
      attributes: {
        name: poster.name,
        description: poster.description,
        price: poster.price,
        year: poster.year,
        vintage: poster.vintage,
        img_url: poster.img_url
      }
    }
  end
end