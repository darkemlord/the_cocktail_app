class CocktailsController < ApplicationController
  def index
    @cocktails = Cocktail.includes(:user).order(:name)
  end

  def show
    @cocktail = Cocktail.find(params[:id])
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Current.user.cocktails.new(cocktail_params)

    if @cocktail.save
      redirect_to @cocktail, notice: "Cocktail was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def cocktail_params
      params.expect(cocktail: [ :name, :ingredients, :instructions, :difficulty ])
    end
end
