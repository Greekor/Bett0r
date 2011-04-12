module Admin::TeamnamesHelper
  def name_suggestions(name)
    mainnames = @mainnames.map { |mainname| { :name => mainname.name, :id => mainname.id, :points => 0 } }

    name_tokens = name[:name].split(/\s+/)

    mainnames.each do |mainname|
      mainname_tokens = mainname[:name].split(/\s+/)
      mainname_tokens.each do |mnt|
        if name_tokens.include? mnt
          mainname[:points] += 1.0/@token_occurences[mnt]
        end
      end
    end

    mainnames.delete_if { |n| n[:points] == 0 }.sort_by { |n| n[:points] }.reverse
  end
end
