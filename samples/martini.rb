class Martini

  class BadBartender < Exception; end

  attr_accessor :ice, :vermouth, :olive_brine
  attr_reader :liquor, :garnish

  def initialize(*args)
    @ice          = false
    @vermouth     = false
    @olive_brine  = true
    @garnish      = 'olives'
    @liquor       = 'vodka'
  end

  def dirty?
    olive_brine && ! (garnish =~ /olive/).nil?
  end

  def straight_up?
    ! ice
  end

  def garnish=(g)
    raise BadBartender unless g =~ /lemon|olive/
    @garnish = g
  end

  def liquor=(l)
    raise BadBartender unless l =~ /vodka|gin/
    @liquor = l
  end

end