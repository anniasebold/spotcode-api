class Api::V1::DashboardController < ApplicationController
  def index
    load_recent_heard
    load_recommendations
  end
 
  private
 
  def load_recent_heard
  	#utilizando o devise podemos descobrir quem esta chamando e com qual tabalea atraves de cookies com o current_user
    @recent_albums = current_user.recently_heards.order("created_at DESC").limit(4).map(&:album)
    #mapeamento do que você quer pegar em recently_heards
  end
 
  def load_recommendations
  	#mapeando uma lista de álbuns do recently_heards
    heard_categories = @recent_albums.map(&:category)
    if heard_categories.present?
    	#usando o joins pra encontrar onde tenha categorias semelhantes ao heard_categories
      @recommended_albums = Album.joins(:category, :songs).where(category: heard_categories).order("songs.played_count")
                                .select("distinct albums.*").limit(12)
    else
      @recommended_albums = Album.all.limit(12)
    end
  end
end