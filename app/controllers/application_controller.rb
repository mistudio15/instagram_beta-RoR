class ApplicationController < ActionController::Base

	# before_action :set_locale

	before_action :authenticate, :except => [:signup, :signin, :new, :create, :about]

	around_action :switch_locale

	# def set_locale
	# 	I18n.locale = :ru
	# end
	
	def current_user
		@current_user ||= User.find_by_id(session[:current_user_id]) if session[:current_user_id]
	end
	
	helper_method :current_user 

	private
	
	def authenticate
		unless current_user
			redirect_to signin_path
		end
	end

	def switch_locale(&action)
		locale = locale_from_url || I18n.default_locale #if there are not :locale in url, take locale from config
		I18n.with_locale locale, &action #set locale
	end 

	def locale_from_url
		locale = params[:locale]

		return locale if I18n.available_locales.map(&:to_s).include?(locale) #available_locales has symbols, params[] is type of String
		nil
	end

	def default_url_options #save :local for each url
		{ locale: I18n.locale }
	end

end
