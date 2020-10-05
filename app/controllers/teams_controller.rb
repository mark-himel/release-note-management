class TeamsController < ApplicationController
  load_and_authorize_resource

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path(@team),
                  notice: I18n.t('shared.created', resource: Team.model_name.human)
    else
      flash[:error]= I18n.t('shared.not_created', resource: Team.model_name.human)
      render :new
    end
  end

  def update
    @team.update(team_params)
    if @team.save
      redirect_to team_path(@team),
                  notice: I18n.t('shared.updated', resource: Team.model_name.human)
    else
      flash[:error]= I18n.t('shared.not_updated', resource: Team.model_name.human)
      render :edit
    end
  end

  def destroy
    if @team.destroy
      redirect_to teams_path,
                  notice: I18n.t('shared.deleted', resource: Team.model_name.human)
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :github_organization)
  end
end
