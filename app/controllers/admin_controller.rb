class AdminController < ApplicationController
  def index
    @bookies = Bookmaker.all
  end

end
