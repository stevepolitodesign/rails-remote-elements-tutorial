class ItemsController < ApplicationController
  before_action :set_item, only: [:destroy, :edit, :update]
  before_action :set_task
  before_action :set_edit_item_data_attributes, only: [:edit]

  def create
    @item = @task.items.build(item_params)
    if @item.save
      render @item, layout: false
    else
      render partial: "layouts/form_errors", locals: { object: @item }, status: :unprocessable_entity, layout: false
    end    
  end

  def destroy
    @item.destroy
  end

  def edit
    render partial: "form", locals: { object: [@task, @item] , data_attributes: @edit_item_data_attributes }
  end

  def mark_all_as_complete
    @items = @task.items.order(created_at: :desc)
    @items.update_all(complete: true)
    render partial: "items"
  end

  def mark_all_as_incomplete
    @items = @task.items.order(created_at: :desc)
    @items.update_all(complete: false)
    render partial: "items"
  end  

  def update
    if @item.update(item_params)
      render @item, layout: false
    else
      render partial: "layouts/form_errors", locals: { object: @item }, status: :unprocessable_entity, layout: false
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :complete)
  end

  def set_edit_item_data_attributes
    @edit_item_data_attributes = {
      controller: "request",
      request_target: "form",
      request_target_value: "#item_#{@item.id}",
      request_action_value: "replace"
    }
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_task
    @task = Task.find(params[:task_id])
  end
end
