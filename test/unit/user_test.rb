require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  def test_login
    # succes
    assert_not_nil User.login({:username => users(:one).username, :password => "Aepm_admin"})

    # failed
    assert_nil User.login({:username => users(:one).username, :password => "admin"})
  end
end