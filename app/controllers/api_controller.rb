class ApiController < ApplicationController
  require 'digest/md5'
  #Digest::MD5.hexdigest("Hello from Dmitry")

  def self.version
    return '0.1c ALPHA'
  end

  def register

    #render text: '1'
  end
end
