#!/usr/bin/env ruby

require 'fog'

fog = Fog::Compute.new(:provider => 'AWS', :region => 'us-east-1', :aws_access_key_id => 'AKIAI5Q3HPJEWA7AMLCQ', :aws_secret_access_key => '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' )

server = fog.servers.create(:image_id=>'ami-fb8e9292', :flavor_id=>'t1.micro' )

server.wait_for { print "."; ready? }

server.dns_name

fog.servers.get(server.id)

server.destroy