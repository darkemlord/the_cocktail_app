class CocktailsController < ApplicationController
  def index
    @cocktails = Cocktail.includes(:user).order(:name)
  end

  def show
    @cocktail = Cocktail.find(params[:id])
  end
end
