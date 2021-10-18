class TasksController < ApplicationController
  before_action :set_task, except: [:create, :index]
  before_action :set_new_item_data_attributes, only: [:show]
  before_action :set_edit_task_data_attributes, only: [:edit]
  before_action :set_new_task_data_attributes, only: [:index]

  def create
    @task = Task.new(task_params)
    if @task.save
      render @task, layout: false
    else
      render partial: "layouts/form_errors", locals: { object: @task }, status: :unprocessable_entity, layout: false
    end
  end
  
  def destroy
    @task.destroy
  end

  def edit
    render partial: "form", locals: { data_attributes: @edit_task_data_attributes }
  end

  def index
    @tasks = Task.all.order(created_at: :desc)
    @task = Task.new
    render layout: !request.xhr?
  end

  def show
    @items = @task.items.order(created_at: :desc)
    render layout: !request.xhr?
  end

  def update
    if @task.update(task_params)
      render @task, layout: false
    else
      render partial: "layouts/form_errors", locals: { object: @task }, status: :unprocessable_entity, layout: false
    end
  end

  private

  def set_new_item_data_attributes
    @new_item_data_attributes = {
      controller: "request",
      request_target: "form",
      request_target_value: "#items",
      request_action_value: "afterbegin"
     }    
  end

  def set_new_task_data_attributes
    @new_task_data_attributes = {
      controller: "request",
      request_target: "form",
      request_target_value: "#tasks",
      request_action_value: "afterbegin"
     }    
  end

  def set_edit_task_data_attributes
    @edit_task_data_attributes = {
      controller: "request",
      request_target: "form",
      request_target_value: "#task_#{@task.id}",
      request_action_value: "replace"
     }    
  end  

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
