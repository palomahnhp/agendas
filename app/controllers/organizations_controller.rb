class OrganizationsController < ApplicationController

  before_action :set_organization, only: :show

  autocomplete :organization, :name

  def index
    @organizations = search(params)
    @paginated_organizations = Organization.lobbies.where(id: @organizations.hits.map(&:primary_key))
    @paginated_organizations = @paginated_organizations.reorder(sorting_option(params[:order]))

  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: [@organization.category.name, @organization.entity_type] }
    end
  end

  def new; end

  def edit; end

  def destroy; end

  private

    def search(params)
      Organization.search do
        with(:entity_type_id, 2)
        with(:interest_ids, params[:interests]) if params[:interests].present?
        with(:category_id, params[:category]) if params[:category].present?
        with(:lobby_activity, true) if params[:lobby_activity].present?
        any do
          any do
            fulltext params[:keyword] if params[:keyword].present?
            fulltext(params[:keyword], :fields => [:agent_name]) if params[:keyword].present?
            fulltext(params[:keyword], :fields => [:agent_first_surname]) if params[:keyword].present?
            fulltext(params[:keyword], :fields => [:agent_second_surname]) if params[:keyword].present?
          end
          any do
            fulltext(params[:keyword], :fields => [:agent_name]) if params[:keyword].present?
            fulltext(params[:keyword], :fields => [:agent_first_surname]) if params[:keyword].present?
            fulltext(params[:keyword], :fields => [:agent_second_surname]) if params[:keyword].present?
            with(:invalidated_at, nil) if params[:keyword].present?
            with(:canceled_at, nil) if params[:keyword].present?
          end
        end
        paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 20
        case params[:order]
        when '1'
          order_by(:name, :asc)
        when '2'
          order_by(:name, :desc)
        when '3'
          order_by(:inscription_date, :asc)
        when '4'
          order_by(:inscription_date, :desc)
        else
          order_by(:inscription_date, :desc)
        end
      end
    end

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def get_autocomplete_items(parameters)
      Organization.full_like("%#{parameters[:term]}%")
    end

    def sorting_option(option)
      case option
      when '1'
        'name ASC'
      when '2'
        'name DESC'
      when '3'
        'inscription_date ASC'
      when '4'
        'inscription_date DESC'
      else
        'inscription_date DESC'
      end
    end

end
