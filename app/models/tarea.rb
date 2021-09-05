class Tarea < ApplicationRecord
  validates_presence_of :titulo, :inicio, :fin
  validate :valid_date, :date_not_used

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { email.blank? }

  def valid_date
    errors.add(:fin, 'date must be after start date') if fin <= inicio
  end

  def date_not_used
    Tarea.find_each do |t|
      if inicio >= t.inicio  && inicio <= t.fin
        errors.add(:inicio, 'date is already ocuppied by another task')
      end

      if fin >= t.inicio  && fin <= t.fin
        errors.add(:fin, 'date is already ocuppied by another task')
      end
    end
  end
end
