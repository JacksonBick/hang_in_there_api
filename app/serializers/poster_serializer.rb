class PosterSerializer
  def self.format_posters(posters, option)
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
    end,
    meta: option[:meta]
  }
  end

  def self.format_single_poster(poster, option)
    {
      data: format_single_poster_data(poster, option)
    }
  end

  private
  
  def self.format_single_poster_data(poster, option)
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