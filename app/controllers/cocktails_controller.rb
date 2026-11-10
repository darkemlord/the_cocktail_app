class CocktailsController < ApplicationController
  before_action :set_own_cocktail, only: %i[ edit update destroy ]

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
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @cocktail.update(cocktail_params)
      redirect_to @cocktail, notice: "Cocktail was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @cocktail.destroy
    redirect_to cocktails_path, notice: "Cocktail was successfully deleted.", status: :see_other
  end

  private
    # Only the owner can find their cocktail; anyone else gets a 404
    def set_own_cocktail
      @cocktail = Current.user.cocktails.find(params[:id])
    end

    def cocktail_params
      params.expect(cocktail: [ :name, :ingredients, :instructions, :difficulty ])
    end
end
