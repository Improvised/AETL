require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :projects

  test "the truth" do
    assert true
  end

  def test_create_ae_job_id
    last_ae_job_id = substract_last_digits(projects(:two).ae_job_id)
    @project = Project.new
    new_ae_job_id = substract_last_digits(@project.create_ae_job_id)
    assert_equal 1, new_ae_job_id - last_ae_job_id
  end

  def test_search
    # any part of field
    # - name
    result = Project.search({:find_what => projects(:one).name.split(" ")[0], :field => "name", :match => "Any Part of Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).name, result[0].name

    # - company
    result = Project.search({:find_what => projects(:one).company.name.split(" ")[0], :field => "company", :match => "Any Part of Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).company.name, result[0].company.name

    # - address_line_1
    result = Project.search({:find_what => projects(:one).address_line_1.split(" ")[0], :field => "address_line_1", :match => "Any Part of Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).address_line_1, result[0].address_line_1

    # - number
    result = Project.search({:find_what => projects(:one).number.split("")[-1], :field => "number", :match => "Any Part of Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).number, result[0].number

    # - contact
    result = Project.search({:find_what => projects(:one).company.contacts[0].name.split(" ")[0], :field => "contact", :match => "Any Part of Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).company.contacts[0].name, result[0].company.contacts[0].name

    # whole field
    # - name
    result = Project.search({:find_what => projects(:one).name, :field => "name", :match => "Whole Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).name, result[0].name

    # - company
    result = Project.search({:find_what => projects(:one).company.name, :field => "company", :match => "Whole Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).company.name, result[0].company.name

    # - address_line_1
    result = Project.search({:find_what => projects(:one).address_line_1, :field => "address_line_1", :match => "Whole Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).address_line_1, result[0].address_line_1

    # - number
    result = Project.search({:find_what => projects(:one).number, :field => "number", :match => "Whole Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).number, result[0].number

    # - contact
    result = Project.search({:find_what => projects(:one).company.contacts[0].name, :field => "contact", :match => "Whole Field"})
    assert_equal 1, result.size
    assert_equal projects(:one).company.contacts[0].name, result[0].company.contacts[0].name
  end

  private
  def substract_last_digits(ae_job_id)
    ae_job_id.split("-")[-1].to_i
  end
end