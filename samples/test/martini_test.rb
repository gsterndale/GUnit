require File.join(File.dirname(__FILE__), 'test_helper')

class MartiniTest < GUnit::TestCase

  setup do
    @martini = Martini.new
  end

  verify "ice attribute" do
    ice = false
    @martini.ice = ice
    assert ice === @martini.ice
  end

  verify "vermouth attribute" do
    vermouth = false
    @martini.vermouth = vermouth
    assert vermouth === @martini.vermouth
  end

  verify "olive_brine attribute" do
    olive_brine = false
    @martini.olive_brine = olive_brine
    assert olive_brine === @martini.olive_brine
  end

  verify "liquor attribute" do
    liquor = 'gin'
    @martini.liquor = liquor
    assert liquor === @martini.liquor
  end

  verify "garnish attribute" do
    garnish = 'lemon'
    @martini.garnish = garnish
    assert garnish === @martini.garnish
  end

  verify "dirty by default" do
    assert @martini.dirty?
  end

  verify "straight up by default" do
    assert @martini.straight_up?
  end

  context "with ice" do
    setup do
      @martini.ice = true
    end

    verify "not straight up" do
      assert ! @martini.straight_up?
    end
  end

end