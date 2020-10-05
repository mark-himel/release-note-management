class ProjectSettingsController < ApplicationController
  load_and_authorize_resource :team
  load_and_authorize_resource :project
  before_action :find_setting
  authorize_resource

  def edit; end

  def update
    if @project_setting.update(settings_params)
      redirect_to edit_team_project_project_settings_path(@team, @project),
                  notice: t('shared.updated', resource: ProjectSetting.model_name.human)
    else
      render :edit
    end
  end

  private

  def find_setting
    @project_setting = @project&.settings
    unless @project_setting
      flash[:error] = t('shared.not_found', resource: Project.model_name.human)
      redirect_to team_projects_path(@team)
    end
  end

  def settings_params
    params.
      require(:project_setting).
      permit(:project_id, :git_repo_url, :git_repo_identifier, :git_release_branch,
             :git_webhook_url, :jira_username, :jira_api_token,
             :jira_site, :jira_project_slug)
  end
end
