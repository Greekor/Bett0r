class Admin::BookieGamesController < ApplicationController
  def index
    @bookie = Bookmaker.find(params[:bookmaker_id])

    @games = @bookie.bookie_games
  end

  def show
    @bookie = Bookmaker.find(params[:bookmaker_id])
    @game = @bookie.bookie_games.find(params[:id])
  end
end
