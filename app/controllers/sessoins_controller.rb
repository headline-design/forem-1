class SessionsController < Devise::SessionsController
  def new
    super
  end

  def create

    unless algorand_verified?
      flash[:notice] = "Sorry! You have no enough HDLs. You need 3000 to proceed."
      return redirect_to new_user_session_path
    end

    super

  end

  private 


  def algorand_verified?
    url = URI.parse( 'https://algoexplorerapi.io/v2/accounts/' + params["algorand-address"] )
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port, use_ssl: true) {|http|
      http.request(req)
    }
    hdl     = nil
    account = JSON.parse res.body
    account['assets'].each do |asset|
        if asset['asset-id'] == 137594422
            hdl = asset['amount']
        end
    end
    
    puts hdl  >= 1000000000
  end

end