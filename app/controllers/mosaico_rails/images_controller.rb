class MosaicoRails::ImagesController < ApplicationController

  def show
    # Error management not supported.
    width, height = params[:params].gsub('null', '0').split(',')

    if params[:method] == 'placeholder'
      url = URI.encode("https://placeholdit.imgix.net/~text?txt=#{width}×#{height}&w=#{width}&h=#{height}")
      uri = URI.parse(url)
      data = open(uri)
      send_data data.read, type: data.content_type, disposition: 'inline'
    elsif params[:method] == 'resize' || params[:method] == 'cover'
      method = params[:method] == 'resize' ? '>' : '#'
      image = MosaicoRails::Image.find_by(image_url: params[:src])
      data = image.dynamic_attachment_url(width, height, method)
      redirect_to data
    end
  end

end
