class Role < ActiveRecord::Base
  def student?
    name == "Alumnos" ? true : false
  end
  
  def admin?
    (name  ==  "Administrativos" || name  == "Cuentas Especiales") ? true  : false
  end
end
