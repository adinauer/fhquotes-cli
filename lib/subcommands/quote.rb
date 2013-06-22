require 'escort'
require 'highline/import'
require 'terminal-table'
require 'date'

require_relative '../fh_quotes_communicator'

class QuotePrinter
  def print_quotes quotes
    table = Terminal::Table.new
    table.headings = ['Stock', 'Ask', 'Bid', 'Price', 'Time']

    quotes.each do |quote|
      stock = quote['Stock']['Symbol']
      time = convert_csharp_timestamp(quote)

      table.add_row [stock, quote['Ask'], quote['Bid'], quote['Price'], time]
    end

    puts table
  end

  def convert_csharp_timestamp(quote)
    csharp_time                = quote['Time']                     # /Date(1371286800000+0200)/
    time_with_timezone         = csharp_time.match(/\((.*?)\)/)[1] # 1371286800000+0200
    relevant_part_of_timestamp = time_with_timezone[0..9]          # 1371286800

    time = Time.at(relevant_part_of_timestamp.to_i)
  end
end

class ShowCurrentQuoteCommand < ::Escort::ActionCommand::Base
  def execute
    symbol = arguments[0]

    if symbol.nil?
      puts 'Please provide the symbol of the stock for which you would like to see the current quote as argument to the command.'
    else
      quote = FhQuotesCommunicator.new.fetch_current_quote(symbol)
      QuotePrinter.new.print_quotes [quote]
    end
  end
end

class ShowCurrentPriceCommand < ::Escort::ActionCommand::Base
  def execute
    symbol = arguments[0]

    if symbol.nil?
      puts 'Please provide the symbol of the stock for which you would like to see the current price as argument to the command.'
    else
      puts FhQuotesCommunicator.new.fetch_current_price symbol
    end
  end
end

class AddQuoteCommand < ::Escort::ActionCommand::Base
  def execute
    symbol = command_options[:symbol]
    ask    = command_options[:ask]
    bid    = command_options[:bid]
    price  = command_options[:price]

    symbol ||= ask('Symbol? ')
    ask    ||= ask('Ask? ')
    bid    ||= ask('Bid? ')
    price  ||= ask('Price? ')

    FhQuotesCommunicator.new.add_new_quote symbol, ask, bid, price
    puts 'Successfully added new quote.'
  end
end

class ShowPeriodCommand < ::Escort::ActionCommand::Base
  def execute
    symbol = command_options[:symbol]
    from   = command_options[:from]
    to     = command_options[:to]

    symbol ||= ask('Symbol? ')
    from   ||= ask('From? ')
    to     ||= ask('To? ')

    quotes = FhQuotesCommunicator.new.fetch_quotes_in_period(symbol, from, to)
    QuotePrinter.new.print_quotes quotes
  end
end

def create_current_price_subcommand quote
  quote.command :price do |price|
    price.summary 'Show the current price for a certain stock.'
    price.action do |options, arguments|
      ShowCurrentPriceCommand.new(options, arguments).execute
    end
  end
end

def create_current_quote_subcommand quote
  quote.command :current do |current|
    current.summary 'Show the current quote for a certain stock.'
    current.action do |options, arguments|
      ShowCurrentQuoteCommand.new(options, arguments).execute
    end
  end
end

def create_add_quote_subcommand quote
  quote.command :add do |add|
    add.summary 'Add a new quote for a certain stock.'

    add.options do |options|
      options.opt :symbol, "Symbol", :short => '-s', :long => '--symbol', :type => :string
      options.opt :ask, "Ask", :short => '-a', :long => '--ask', :type => :string
      options.opt :bid, "Bid", :short => '-b', :long => '--bid', :type => :string
      options.opt :price, "Price", :short => '-p', :long => '--price', :type => :string
    end

    add.action do |options, arguments|
      AddQuoteCommand.new(options, arguments).execute
    end
  end
end

def create_period_subcommand quote
  quote.command :period do |period|
    period.summary 'Show all quotes for a certain stock in a certain time period.'

    period.options do |options|
      options.opt :symbol, "Symbol", :short => '-s', :long => '--symbol', :type => :string
      options.opt :from, "From", :short => '-f', :long => '--from', :type => :string
      options.opt :to, "To", :short => '-t', :long => '--to', :type => :string
    end

    period.action do |options, arguments|
      ShowPeriodCommand.new(options, arguments).execute
    end
  end
end