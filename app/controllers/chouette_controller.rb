class ChouetteController < BreadcrumbController

  include ApplicationHelper
  include BreadcrumbHelper

  before_action :check_organisation
  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= current_organisation.referentials.find_by_id(params[:referential_id])
    @referential ||= current_organisation.referentials.find_by_slug(params[:referential_id])
    @referential ||= current_organisation.referentials.find_by_name(params[:referential_id])
  end

  protected

  def check_organisation
    redirect_to additionnal_fields_path unless current_organisation.present?
  end

end
