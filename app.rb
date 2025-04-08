require 'sinatra'
require 'pg'
require 'json'
require 'logger'
require 'securerandom'
require 'dotenv'

# Load environment variables
Dotenv.load

# Configure logger
logger = Logger.new(STDOUT)

# Database connection
def db_connection
  @db ||= PG.connect(
    host: ENV['DB_HOST'],
    port: ENV['DB_PORT'],
    user: ENV['DB_USER'],
    password: ENV['DB_PASS'],
    dbname: ENV['DB_NAME']
  )
rescue PG::Error => e
  logger.fatal "Failed to connect to database: #{e.message}"
  exit(1)
end

# Ensure table exists
begin
  db_connection.exec("CREATE TABLE IF NOT EXISTS entries (id SERIAL PRIMARY KEY, data TEXT NOT NULL);")
rescue PG::Error => e
  logger.fatal "Failed to ensure table exists: #{e.message}"
  exit(1)
end

# Configure Sinatra
set :port, ENV['PORT'] || 8080
set :bind, '0.0.0.0'
set :protection, false

# Routes
get '/' do
  halt 404 unless request.path_info == '/'
  
  random_data = SecureRandom.uuid
  
  begin
    db_connection.exec_params('INSERT INTO entries(data) VALUES ($1)', [random_data])
    
    result = db_connection.exec('SELECT COUNT(*) FROM entries')
    count = result[0]['count'].to_i
    
    # Logging
    logger.info "log - entry added: #{random_data}."
    logger.info "slog.Info - entry added data=#{random_data} total=#{count}"
    logger.warn "slog.Warn - entry added data=#{random_data} total=#{count}"
    logger.error "slog.Error - entry added data=#{random_data} total=#{count}"
    
    response = {
      message: 'This is a simple, basic Ruby application with Sinatra, each request adds an entry to the PostgreSQL database and returns a count.',
      newEntry: random_data,
      count: count
    }
    
    status 201
    content_type :json
    response.to_json
  rescue PG::Error => e
    logger.error e.message
    status 500
    { error: 'Failed to process request' }.to_json
  end
end

get '/status' do
  content_type :json
  { status: 'UP' }.to_json
end