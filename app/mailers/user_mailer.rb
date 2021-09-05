class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def task_started
    @tarea = params[:tarea]
    mail(
      to: @tarea.email,
      subject: "New task started",
      body: "Task with title #{@tarea.titulo} has started at #{@tarea.inicio}"
    )
  end
end
