def delete_old
  Game.where("starttime < :starttime", { :starttime => Time.now }).destroy_all
  Odd.where("updated_at < :updated_at", { :updated_at => Time.now-2.hours }).destroy_all
end

delete_old
