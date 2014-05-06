module ApplicationHelper
  def bootstrap_flash(type)
    'alert-' +
      case type
      when 'alert'  then 'danger'
      when 'notice' then 'info'
      else type.to_s
      end
  end
end
