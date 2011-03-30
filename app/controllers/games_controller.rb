class GamesController < ApplicationController
  def index
    @games = Game.all
    Time.zone = "CET"
  end
end
