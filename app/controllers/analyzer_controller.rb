class AnalyzerController < ApplicationController
  def index
    @bets = Game.best_bets
    @bets.sort_by! { |b| b[:per] }.reverse!
    @bets.delete_if { |b| b[:per] < 98.5 }
    Time.zone = "CET"
  end
end
