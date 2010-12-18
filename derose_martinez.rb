require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra/base'
require 'erb'

class DeRoseMartinezApp < Sinatra::Base
  set :static, true
  set :public, File.dirname(__FILE__) + '/static'

  set :email_username, ENV['SENDGRID_USERNAME']
  set :email_password, ENV['SENDGRID_PASSWORD']
  set :email_port, '587'
  set :email_address, 'natalia.sanmartin@gmail.com'
  set :email_service, 'sendgrid.net'
  set :email_domain, ENV['SENDGRID_DOMAIN']

  mime_type :ttf, "application/octet-stream"
  mime_type :woff, "application/octet-stream"

  get '/' do
    flash_message(params[:m])

    erb :index, :layout => :'page-layout'
  end

  get '/contact' do
    flash_message(params[:m])

    erb(:contact, :layout => :'page-layout')
  end

  post '/contact' do
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
                :body =>  erb(:'email/contact', :layout => false),
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
                                                            error
  get('/success') do
    erb :success
  end

  get('/swasthya-yoga') do
    erb :'swasthya-yoga', :layout => :'page-layout'
  end

  get('/clases-particulares') do
    erb :'clases-particulares', :layout => :'page-layout'
  end

  get('/empresas') do
    erb :'empresas', :layout => :'page-layout'
  end

  get('/nosotros') do
    erb :'nosotros', :layout => :'page-layout'
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