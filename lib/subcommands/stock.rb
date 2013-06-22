require 'escort'
require 'highline/import'
require_relative '../fh_quotes_communicator'

class AddStockCommand < ::Escort::ActionCommand::Base
  def execute
    symbol   = command_options[:symbol]
    name     = command_options[:name]
    currency = command_options[:currency]

    symbol   ||= ask('Symbol? ')
    name     ||= ask('Name? ')
    currency ||= ask('Currency? ')

    FhQuotesCommunicator.new.add_new_stock symbol, name, currency
    puts 'Successfully created new stock.'
  end
end

class ListStockSymbolsCommand < ::Escort::ActionCommand::Base
  def execute
    FhQuotesCommunicator.new.fetch_all_stock_symbols.each do |symbol|
      puts symbol
    end
  end
end

class ShowStockDetailsCommand < ::Escort::ActionCommand::Base
  def execute
    symbol = arguments[0]
    currency_only = command_options[:currency_only]
    name_only = command_options[:name_only]

    if symbol.nil?
      puts 'Please provide the symbol of the stock for which you would like to see details as argument to the command.'
    else
      FhQuotesCommunicator.new.fetch_stock_details(symbol).each do |attribute_name, attribute_value|
        if currency_only
          if attribute_name == 'Currency'
            puts attribute_value
          end
        elsif name_only
          if attribute_name == 'Name'
            puts attribute_value
          end
        else
          puts "#{attribute_name}: #{attribute_value}"
        end
      end
    end
  end
end

def create_show_stock_subcommand(stock)
  stock.command :show do |show|
    show.summary 'Show details for a stock.'

    show.options do |options|
      options.opt :currency_only, "Show only the currency of the stock.", :short => '-c', :long => '--currency-only', :type => :boolean, :default => false
      options.opt :name_only, "Show only the name of the stock.", :short => '-n', :long => '--name-only', :type => :boolean, :default => false

      options.conflict :currency_only, :name_only
    end

    show.action do |options, arguments|
      ShowStockDetailsCommand.new(options, arguments).execute
    end
  end
end

def create_list_stock_symbols_subcommand(stock)
  stock.command :list do |list|
    list.summary 'List all stock symbols.'
    list.action do |options, arguments|
      ListStockSymbolsCommand.new(options, arguments).execute
    end
  end
end

def create_add_stock_subcommand(stock)
  stock.command :add do |add|
    add.summary 'Add a new stock.'

    add.options do |options|
      options.opt :symbol, "Symbol", :short => '-s', :long => '--symbol', :type => :string
      options.opt :name, "Name", :short => '-n', :long => '--name', :type => :string
      options.opt :currency, "Currency", :short => '-c', :long => '--currency', :type => :string
    end

    add.action do |options, arguments|
      AddStockCommand.new(options, arguments).execute
    end
  end
end