class DatasourcesController < ApplicationController


	def auto_complete_for_project_company
    search = params[:term]
    @companieses = Company.where("name LIKE ?", "%#{search}%").order("name ASC").pluck(:name)
    respond_to do |format|
      format.json { render json: @companieses }
    end
  end

end
