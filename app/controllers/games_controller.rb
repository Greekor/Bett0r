class GamesController < ApplicationController
  def index
    @games = Game.includes(:odds => [{:bookie_game => :bookmaker}, :bettype]).all
    Time.zone = "CET"
  end
end
