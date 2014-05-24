!#/usr/bin/env ruby

require 'fog'

connection = Fog::AWS::ELB.new(:aws_access_key_id => ENV['AWS_ACCESS_KEY'], :aws_secret_access_key => ENV['AWS_SECRET_KEY'], :region => "us-east-1")

#Build the Load Balancer
availability_zones = ["us-east-1d"]
listeners = [ { "Protocol" => "HTTP", "LoadBalancerPort" => 80, "InstancePort" => 8080, "InstanceProtocol" => "HTTP" } ]
result = connection.create_load_balancer(availability_zones, "mynewlb", listeners)

if result.status != 200
  puts "ELB creation failed!"
end

#Let's get the new load balancer's object
elb = connection.load_balancers.get("mynewlb")

#Let's configure a faster health check
health_check_config = { "HealthyThreshold" => 2, "Interval" => 30, "Target" => "TCP:80", "Timeout" => 5, "UnhealthyThreshold" => 3 }
health_check_result = connection.configure_health_check("mynewlb", health_check_config)

if health_check_result.status != 200
  puts "Failed health check configuration request"
end