class SessionsController < Devise::SessionsController
  
  #layout 'mini'
  
  def new
    logger.debug("*******************************3333**********************")
    super
  end

  def create
    logger.debug("*****************************************************")
    super
  end

  def update
    super
  end
  
  protected

    #def after_sign_in_path_for(resource)
    #  if current_user.try(:admin?)
    #    logger.debug("!!!!!!!!!!!!!!!! ADMIN !!!!!!!!!!!!!!!!!!!!!!") 
    #  end
    #end

end