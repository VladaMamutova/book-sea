#require 'sneakers'
require 'sneakers/handlers/maxretry'

module Connection
  def self.sneakers
    @sneakers ||= begin
      Bunny.new(
        host: 'rabbitmq',
        addresses: 'rabbitmq',
        username: 'guest',
        password: 'guest',
        port: 5672,
        vhost: '/',
        automatically_recover: true,
        connection_timeout: 2,
        continuation_timeout: 4000,
        logger: Rails.logger
      )
    end
  end
end
Sneakers.configure  connection: Connection.sneakers,
                    exchange: '',
                    exchange_type: :direct,
                    runner_config_file: nil,                # A configuration file (see below)
                    metric: nil,                            # A metrics provider implementation
                    daemonize: false,                       # Send to background
                    workers: 2,                             # Number of per-cpu processes to run
                    log: STDOUT,                            # Log file
                    pid_path: 'sneakers.pid',               # Pid file
                    timeout_job_after: 5.minutes,           # Maximal seconds to wait for job
                    prefetch: 2,                            # Grab 10 jobs together. Better speed.
                    threads: 2,                             # Threadpool size (good to match prefetch)
                    env: Rails.env,                         # Environment
                    durable: true,                          # Is queue durable?
                    ack: true,                              # Must we acknowledge?
                    heartbeat: 5,                           # Keep a good connection with broker
                    handler: Sneakers::Handlers::Maxretry,
                    retry_max_times: 10, # how many times to retry the failed worker process
                    retry_timeout: 3 * 60 * 1000 # how long between each worker retry duration

Sneakers.logger = Rails.logger
Sneakers.logger.level = Logger::INFO
