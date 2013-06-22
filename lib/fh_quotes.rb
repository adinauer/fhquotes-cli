require 'escort'
require 'highline/import'
require_relative 'subcommands/stock'
require_relative 'subcommands/quote'
require_relative 'fh_quotes/version'

Escort::App.create do |app|
  app.summary 'FhQuotes Command Line Interface'
  app.version FhQuotes::VERSION
  app.description 'Manage stock and quotes.'

  app.command :stock do |stock|
    stock.summary 'List existing stocks, show details and add new ones.'

    create_add_stock_subcommand(stock)
    create_list_stock_symbols_subcommand(stock)
    create_show_stock_subcommand(stock)
  end

  app.command :quote do |quote|
    quote.summary 'List the current quote, current price or all quotes in a certain time period for a certain stock.'

    create_current_quote_subcommand(quote)
    create_current_price_subcommand(quote)
    create_add_quote_subcommand(quote)
    create_period_subcommand(quote)
  end
end