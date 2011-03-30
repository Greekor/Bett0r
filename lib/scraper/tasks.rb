def delete_old
  Game.where("starttime < :starttime", { :starttime => Time.now }).destroy_all
end

delete_old
