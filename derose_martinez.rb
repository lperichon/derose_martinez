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

    @description = "¿Ya invertiste en vos mismo hoy? Clases de Yôga en Martinez, calidad de vida, administración del stress, fuerza, flexibilidad y cultura."
    @keywords = "yoga, martinez, yoga en martinez, swasthya, clases de yoga"

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

    redirect request.url + "?m=email_blank" if params[:email].blank?

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
      rescue
        @pony_error = true
      end
    end

    if @pony_error
      redirect request.url + "?m=email_invalid"
    else
      redirect request.url + "?m=success"
    end
  end

  get('/swasthya-yoga') do
    @page_title = "SwáSthya Yôga"
    @description = "SwáSthya Yôga es el nombre de la sistematización del Yôga Antiguo, Preclásico."

    erb :'swasthya-yoga', :layout => :'page-layout'
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

  post('/facebook') do
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