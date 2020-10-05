class ProjectsController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource

  def index
    @projects = @team.projects
  end

  def new
    @project = @team.projects.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = t('shared.created', resource: Project.model_name.human)
      redirect_to team_project_path(@team, @project)
    else
      flash[:error] = t('shared.not_created', resource: Project.model_name.human)
      render :new
    end
  end

  def update
    @project.update(project_params)
    if @project.save
      flash[:notice] = t('shared.updated', resource: Project.model_name.human)
      redirect_to team_project_path(@team, @project)
    else
      flash[:error] = t('shared.not_updated', resource: Project.model_name.human)
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = t('shared.deleted', resource: Project.model_name.human)
      redirect_to team_projects_path(@team)
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :team_id)
  end

end
