require 'rest_client'
require 'json'

class FhQuotesCommunicator
  FH_QUOTES_BASE_URL = 'http://localhost:9000/sve2/'
  FH_QUOTES_REST = 'FhQuotesRest'
  FH_QUOTES_ADMIN_REST = 'FhQuotesAdminRest'

  def fetch_all_stock_symbols
    json_as_string = RestClient.get "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_REST}/stocks", { :accept => :json}
    JSON.parse json_as_string
  end

  def fetch_stock_details symbol
    begin
      json_as_string = RestClient.get "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_REST}/stocks/#{symbol}", { :accept => :json}
      JSON.parse json_as_string
    rescue RestClient::ResourceNotFound => e
      puts "Could not find stock with symbol '#{symbol}'"
      raise e
    end
  end

  def add_new_stock symbol, name, currency
    RestClient.post "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_ADMIN_REST}/stocks/new", {
        'Currency' => currency,
        'Name' => name,
        'Symbol' => symbol
    }.to_json, :content_type => :json, :accept => :json
  end

  def fetch_current_quote symbol
    begin
      json_as_string = RestClient.get "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_REST}/quotes/current/#{symbol}", { :accept => :json}
      JSON.parse json_as_string
    rescue RestClient::ResourceNotFound => e
      puts "Could not find stock with symbol '#{symbol}'"
      raise e
    end
  end

  def fetch_current_price symbol
    begin
      RestClient.get "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_REST}/quotes/current/#{symbol}/price", { :accept => :json}
    rescue RestClient::ResourceNotFound => e
      puts "Could not find stock with symbol '#{symbol}'"
      raise e
    end
  end

  def add_new_quote symbol, ask, bid, price
    RestClient.post "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_ADMIN_REST}/quotes/new", {
        'stockSymbol' => symbol,
        'ask' => ask,
        'bid' => bid,
        'price' => price
    }.to_json, :content_type => :json, :accept => :json
  end

  def fetch_quotes_in_period symbol, from, to
    begin
      json_as_string = RestClient.get "#{FH_QUOTES_BASE_URL}#{FH_QUOTES_REST}/quotes/#{symbol}/#{from}/#{to}", { :accept => :json}
      JSON.parse json_as_string
    rescue RestClient::ResourceNotFound => e
      puts "Could not find stock with symbol '#{symbol}'"
      raise e
    end
  end
end