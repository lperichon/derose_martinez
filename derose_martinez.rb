require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra/base'
require 'erb'

class DeRoseMartinezApp < Sinatra::Base
  set :static, true
  set :public, File.dirname(__FILE__) + '/static'

  set :email_username, ENV['SENDGRID_USERNAME']
  set :email_password, ENV['SENDGRID_PASSWORD']
  set :email_port, '587'
  set :email_address, 'info@yogaenmartinez.com.ar'
  set :email_service, 'sendgrid.net'
  set :email_domain, ENV['SENDGRID_DOMAIN']

  mime_type :ttf, "application/octet-stream"
  mime_type :woff, "application/octet-stream"

  get '/' do
    flash_message(params[:m])

    @description = "¿Qué hiciste por vos hoy? Clases de Swásthya en Martinez, calidad de vida, administración del stress, fuerza, flexibilidad y cultura."
    @keywords = "swásthya, martinez, swásthya en martinez, swasthya, clases de swásthya"

    erb :index, :layout => :'page-layout'
  end

  get '/contacto' do
    flash_message(params[:m])

    @page_title = "Contacto"
    @description = "Contactános para recibir más información."

    erb(:contacto, :layout => :'page-layout')
  end

  post '/contacto' do
    require 'pony'

    redirect request.referer + (request.referer.include?('?') ? '&' : '?') + "m=email_blank" if params[:email].blank?
    @fb = params[:fb]
    @name = params[:name]

    @from = ""
    @from = "#{params[:name]} <" if @name
    @from << params[:email]
    @from << ">" if @name

    @email = params[:email]

    @phone = params[:phone]

    @contact_reason = params[:contactReason]

    @message = params[:message]

    unless Sinatra::Application.development?
      begin
        Pony.mail :to => settings.email_address,
                :from => params[:email],
                :subject => 'Contacto Web',
                :body =>  erb(:'email/contacto', :layout => false),
                :via => :smtp,
                :via_options => {
                    :address              => 'smtp.' + settings.email_service,
                    :port                 => settings.email_port,
                    :user_name            => settings.email_username,
                    :password             => settings.email_password,
                    :authentication       => :plain,
                    :domain               => settings.email_domain
                }

        Pony.mail :to => params[:email],
                :from => settings.email_address,
                :subject => 'Gracias por visitar YôgaenMartinez.com.ar',
                :headers => { 'Content-Type' => 'text/html' },
                :body =>  erb(:'email/infomail', :layout => false),
                :via => :smtp,
                :via_options => {
                    :address              => 'smtp.' + settings.email_service,
                    :port                 => settings.email_port,
                    :user_name            => settings.email_username,
                    :password             => settings.email_password,
                    :authentication       => :plain,
                    :domain               => settings.email_domain
                }
      rescue
        @pony_error = true
      end
    end

    if @pony_error
      redirect request.referer + (request.referer.include?('?') ? '&' : '?') + "m=email_invalid"
    else
      redirect request.referer + (request.referer.include?('?') ? '&' : '?') + "m=success"
    end
  end

  get('/swasthya') do
    @page_title = "SwáSthya"
    @description = "SwáSthya es el nombre de la sistematización del Yôga Antiguo, Preclásico."

    erb :'swasthya', :layout => :'page-layout'
  end

  get('/clases-particulares') do
    @page_title = "Clases particulares"
    @description = "Ofrecemos clases particulares."

    erb :'clases-particulares', :layout => :'page-layout'
  end

  get('/empresas') do
    @page_title = "Empresas"
    @description = "Nuestro servicio para empresas y gimnasios."

    erb :'empresas', :layout => :'page-layout'
  end

  get('/nosotros') do
    @page_title = "Nosotros"
    @description = "Conocenos un poco más."

    erb :'nosotros', :layout => :'page-layout'
  end

  get('/facebook') do
    #require 'sinatra-facebook-signed-request'
    #ensure_facebook_request!('183431315036552', '4c7869fb2bcd85f159bacf1dc78d3034')
    #@fan = @facebook_params[:page][:liked]

    flash_message(params[:m])
    erb :'facebook', :layout => :'fb-layout'
  end

  post('/facebook') do
    #require 'sinatra-facebook-signed-request'
    #ensure_facebook_request!('183431315036552', '4c7869fb2bcd85f159bacf1dc78d3034')
    #@fan = @facebook_params[:page][:liked]
    erb :'facebook', :layout => :'fb-layout'
  end

  helpers do
    def flash_message(message)
      case message
      when "email_blank"
        @notice = "Por favor, ingresá un email."
      when "email_invalid"
        @notice = "El formato del email es incorrecto"
      when "success"
        @success = "Gracias! Pronto estaremos en contacto con vos."
      else ""
      end
    end

  end
end