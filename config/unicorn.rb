app = "teejay"
root = "/srv/#{app}/current"
# Set the working application directory
# working_directory "/path/to/your/app"
working_directory root

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid root + "/tmp/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path root + "/log/unicorn.log"
stdout_path root + "/log/unicorn.log"

# Unicorn socket
listen root + "/tmp/sockets/unicorn.sock"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
    GC.copy_on_write_friendly = true
# Number of processes
# worker_processes 4
worker_processes 4

# Time-out
timeout 30
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = root + "/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
