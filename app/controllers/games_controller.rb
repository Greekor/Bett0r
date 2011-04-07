class GamesController < ApplicationController
  def index
    @games = Game.order(:starttime).includes(:odds => [{:bookie_game => :bookmaker}, :bettype]).all
    Time.zone = "CET"
  end
end
