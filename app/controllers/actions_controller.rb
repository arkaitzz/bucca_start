class ActionsController < ApplicationController

  def sys_start
    
    yubikey = params[:yubikey].gsub(/^(.{12,}?).*$/m,'\1')
    pass = params[:pass]

    crypt = ActiveSupport::MessageEncryptor.new(ActiveSupport::KeyGenerator.new(yubikey).generate_key(pass))
    # Mounting the FS
    command_1 = `#{crypt.decrypt_and_verify(COMMAND1)}`
    # Reload de apache without cutting the service
    command_2 = '$ /etc/init.d/httpd reload'
    # Evaluate the received lines
    command_1 != '' ? message = command_1 : message = 'TUTTO BENNE';

    flash[:notice] = message
    redirect_to '/'
    # When the commands cannot be decrypter because its a wrong pass or yubikey an exception is launched. Must be captured.
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      flash[:error] = 'Contraseñas inválidas'
      redirect_to '/'
      return
  end
end
