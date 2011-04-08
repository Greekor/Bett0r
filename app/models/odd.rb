class Odd < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper

  belongs_to :bookie_game
  belongs_to :bettype

  alias_attribute :over, :odd1
  alias_attribute :under, :odd2

  alias_attribute :home, :odd1
  alias_attribute :draw, :oddX
  alias_attribute :away, :odd2

  def betname=(n)
    @betname = n
  end

  def betname
    if self.bettype_id.nil?
      @betname
    else
      Bettype.find(self.bettype_id).to_s
    end
  end

  def odd1=(odd)
    # set precision
    write_attribute(:odd1, number_with_precision(odd, :precision => 3))
  end
  def oddX=(odd)
    #set precision
    write_attribute(:oddX, number_with_precision(odd, :precision => 3))
  end
  def odd2=(odd)
    #set precision
    write_attribute(:odd2, number_with_precision(odd, :precision => 3))
  end

end
