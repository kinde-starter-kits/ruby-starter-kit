module ApplicationHelper
  def logged_in?
    session[:kinde_auth].present? && !KindeApi.token_expired?(session[:kinde_auth])
  end

  def kinde_account_full_name
    [session[:kinde_user]["first_name"], session[:kinde_user]["last_name"]].join(" ")
  end
end
