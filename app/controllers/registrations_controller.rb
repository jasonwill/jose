class RegistrationsController < Devise::RegistrationsController
  
  def new
    resource = build_resource({})
    respond_with resource
  end

  def create
    logger.debug(" *** 1 ***")
    build_resource
    logger.debug(" *** 2 ***")

    if resource.save
      logger.debug(" *** 3 ***")
      if resource.active_for_authentication?
        logger.debug(" *** 4 ***")
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        logger.debug(" *** 5 ***")
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      logger.debug(" *** 6 ***")
      clean_up_passwords resource
      respond_with resource
    end
  end

end