require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra/base'
require 'erb'

class DeRoseMartinezApp < Sinatra::Base
  set :static, true
  set :public, File.dirname(__FILE__) + '/static'

  set :email_username, ENV['SENDGRID_USERNAME']
  set :email_password, ENV['SENDGRID_PASSWORD']
  set :email_port, '587'
  set :email_address, 'luisperichon@gmail.com'
  set :email_service, 'sendgrid.net'
  set :email_domain, ENV['SENDGRID_DOMAIN']

  mime_type :ttf, "application/octet-stream"
  mime_type :woff, "application/octet-stream"

  get '/' do
    erb :index
  end

  get '/contact' do
    erb :contact
  end

  post '/contact' do
    require 'pony'

    @name = params[:name]

    @from = ""
    @from = params[:name] + "<" if @name
    @from << params[:email]
    @from << ">" if @name

    @telephone = params[:telephone]

    @contact_reason = params[:contactReason]

    @message = params[:message]

    Pony.mail :to => settings.email_address,
              :from => params[:email],
              :subject => 'Contacto Web',
              :body =>  erb('email/contact', :layout => false),
              :via => :smtp,
              :via_options => {
                  :address              => 'smtp.' + settings.email_service,
                  :port                 => settings.email_port,
                  :user_name            => settings.email_username,
                  :password             => settings.email_password,
                  :authentication       => :plain,
                  :domain               => settings.email_domain
              }
    redirect '/success'
  end

  get('/success'){"Thanks for your email. We'll be in touch soon."}
end