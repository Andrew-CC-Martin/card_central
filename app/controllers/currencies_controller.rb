class CurrenciesController < ApplicationController
  require 'net/http'

  def initialize
    @currencies = ["AUD", "BGN", "BRL", "CAD", "CHF", "CNY", "CZK", "DKK", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PLN", "RON", "RUB", "SEK", "SGD", "THB", "TRY", "USD", "ZAR"]
  end

  def index
    # Only get rates if we have amount, from, and to
    @from = params[:from]
    @to = params[:to]
    @amount = params[:amount]

    if (@from && @to && @amount)
      get_rates
    end
  end

  private
    def get_rates
      api_uri = URI.parse("https://api.exchangeratesapi.io/latest?base=#{@from}&symbols=#{@to}")
      result_raw = Net::HTTP.get(api_uri)
      result_parsed = JSON.parse(result_raw)
      rate = result_parsed["rates"][@to]

      @total = @amount.to_i * rate
    end
end
