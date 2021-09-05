class TareasController < ApplicationController
  # Authentication to generate the compilated tasks json file
  http_basic_authenticate_with name: 'admin', password: 'admin', only: :export_api

  def index
    @tareas = Tarea.all
  end

  def show
    @tarea = Tarea.find(params[:id])
  end

  def edit
    @tarea =  Tarea.find(params[:id])
  end

  def update
    @tarea =  Tarea.find(params[:id])

    if @tarea.update(tarea_params)
      redirect_to @tarea
    else
      render :edit
    end
  end

  def new
    @tarea = Tarea.new
  end

  def create
    @tarea = Tarea.new(tarea_params)

    if @tarea.save
      redirect_to @tarea

      # Checks if the task has an associated email
      unless @tarea.email.nil?  || @tarea.email.blank?
        # if so, sends an email when the task starts
        UserMailer.task_started(@tarea).deliver_later(wait_until: @tarea.inicio)
      end
    else
      render :new
    end
  end

  def destroy
    @tarea = Tarea.find(params[:id])
    @tarea.destroy

    redirect_to root_path
  end

  # Exports the task list as a json file, which is downloaded from the web browser
  def export_api
    file = File.open(Rails.root.join('tmp/export_tasks.json'), 'w')

    Tarea.order(:id).find_each do |tarea|
      file.write(serialize_task(tarea).to_json)
      file.write("\n")
    end

    send_file(file, filename: 'tareas.json', type: 'application/json')

    file.close
  end

  private

  def tarea_params
    params.require(:tarea).permit(:titulo, :inicio, :fin, :email)
  end

  def serialize_task(tarea)
    {
      id: tarea.id,
      titulo: tarea.titulo,
      inicio: tarea.inicio,
      fin: tarea.fin,
      email: tarea.email,
    }
  end
end
