class PagesController < ApplicationController
  def root
    @n_apn_tokens = ApnToken.count
    @n_devices = Device.active.count
  end
end
