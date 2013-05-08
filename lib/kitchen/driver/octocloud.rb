require 'fog-octocloud'
require 'kitchen'

module Kitchen
  module Driver

    class Octocloud < Kitchen::Driver::SSHBase

      default_config  :cube_name, 'github-enterprise-test'
      required_config :cube_url
      no_parallel_for :create, :destroy

      def create(state)
        server = create_server
        state[:server_id] = server.id

        info("Octocloud instance <#{state[:server_id]}> created.")
        server.wait_for { print "."; ready? && public_ip_address }
        puts "(server ready)"

        state[:hostname] = server.public_ip_address
        wait_for_sshd(state[:hostname])
        puts "(ssh ready)"
      rescue Fog::Errors::Error, Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      def destroy(state)
        return if state[:server_id].nil?

        server = connection.servers.get(state[:server_id])
        server.destroy unless server.nil?
        info("Octocloud instance <#{state[:server_id]}> destroyed.")
        state.delete(:server_id)
        state.delete(:hostname)
      end

      private

      def compute
        @compute ||= Fog::Compute.new(:provider => 'octocloud')
      end

      def create_server
        unless compute.cubes.get(config[:cube_name])
          compute.cubes.create(:name => config[:cube_name],
                               :source => config[:cube_url])
        end

        compute.servers.create(:id => config[:cube_name], :cube => config[:cube_name])
      end
    end
  end
end
