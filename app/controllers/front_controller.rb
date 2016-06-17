class FrontController < ApplicationController

  hobo_controller

  def index
    encfs_status = `mount | grep encfs`
    encfs_status != '' ? @enc_color = 'green':@enc_color = 'red';
    sg_status = `pgrep passenger`
    sg_status != '' ? @sg_color = 'green':@sg_color = 'red';

    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def summary
    if !current_user.administrator?
      redirect_to user_login_path
    end
  end

  def search
    if params[:query]
      site_search(params[:query])
    end
  end

end
