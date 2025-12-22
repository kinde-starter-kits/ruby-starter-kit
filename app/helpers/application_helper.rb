module ApplicationHelper
  include AuthHelper

  def mgmt_token_alive?
    $redis.get("kinde_m2m_token").present?
  end

  def print_organization(org)
    str = "#{org.name} (#{org.code})"
    str = "#{str} DEFAULT" if org.is_default
    str
  end

  def print_user(user)
    "#{user.email.presence || "---"} (#{user.first_name} #{user.last_name})"
  end

  def kinde_account_full_name
    Rails.logger.info("Getting full name from session : #{session[:kinde_user]}")
    [session[:kinde_user]["first_name"], session[:kinde_user]["last_name"]].join(" ")
  end

  def notification_class(key)
    return "is-warning" if key == "notice"
    "is-danger" if key == "alert"
  end
end
