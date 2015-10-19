require 'test_helper'

class ClientRequestTest < ActiveSupport::TestCase
  fixtures :client_requests, :users

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  def test_create_ae_job_id
    last_ae_job_id = substract_last_digits(client_requests(:two).ae_job_id)
    @client_request = ClientRequest.new
    new_ae_job_id = substract_last_digits(@client_request.create_ae_job_id)
    assert_equal 1, new_ae_job_id - last_ae_job_id
  end

  def test_search
    # any part of field
    result = ClientRequest.search({:find_what => client_requests(:one).ae_job_id.split("")[-1], :look_in => "AE Job ID", :match => "Any Part of Field"})
    assert_equal 1, result.size
    assert_equal client_requests(:one).ae_job_id, result[0].ae_job_id

    # whole field
    result = ClientRequest.search({:find_what => client_requests(:one).ae_job_id, :look_in => "AE Job ID", :match => "Whole Field"})
    assert_equal 1, result.size
    assert_equal client_requests(:one).ae_job_id, result[0].ae_job_id

    # start of field
    result = ClientRequest.search({:find_what => client_requests(:one).ae_job_id.split("-")[0], :look_in => "AE Job ID", :match => "Start of Field"})
    assert_equal 2, result.size
  end

  private
  def substract_last_digits(ae_job_id)
    ae_job_id.split("-")[-1].to_i
  end
end