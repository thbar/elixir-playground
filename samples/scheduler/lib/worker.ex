defmodule Worker do
  require Logger
  
  def run do
    Logger.info "I'm running"
  end
  
  def once do
    Logger.info "This should be called only once, at startup"
  end
end